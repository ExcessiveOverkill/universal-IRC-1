library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;
--
-- Copyright (C) 2007, Peter C. Wallace, Mesa Electronics
-- http://www.mesanet.com
--
-- This program is is licensed under a disjunctive dual license giving you
-- the choice of one of the two following sets of free software/open source
-- licensing terms:
--
--    * GNU General Public License (GPL), version 2.0 or later
--    * 3-clause BSD License
-- 
--
-- The GNU GPL License:
-- 
--     This program is free software; you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation; either version 2 of the License, or
--     (at your option) any later version.
-- 
--     This program is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
-- 
--     You should have received a copy of the GNU General Public License
--     along with this program; if not, write to the Free Software
--     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
-- 
-- 
-- The 3-clause BSD License:
-- 
--     Redistribution and use in source and binary forms, with or without
--     modification, are permitted provided that the following conditions
--     are met:
-- 
--         * Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
-- 
--         * Redistributions in binary form must reproduce the above
--           copyright notice, this list of conditions and the following
--           disclaimer in the documentation and/or other materials
--           provided with the distribution.
-- 
--         * Neither the name of Mesa Electronics nor the names of its
--           contributors may be used to endorse or promote products
--           derived from this software without specific prior written
--           permission.
-- 
-- 
-- Disclaimer:
-- 
--     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--     "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--     LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
--     FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
--     COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
--     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
--     BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
--     LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
--     ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--     POSSIBILITY OF SUCH DAMAGE.
-- 



use work.log2.all;

entity pktuartr16 is
	generic (
	          MaxFrameSize: integer;	-- in bytes (-1) maximum is 2K bytes
	          Clock: integer 			-- for default input filter time constant     
				); 
	Port (clk : in std_logic;
			ibus : in std_logic_vector(15 downto 0);
         obus : out std_logic_vector(15 downto 0);
			popdata : in std_logic;
			poprc: in std_logic;
			loadbitratel : in std_logic;
         readbitratel : in std_logic;          
			loadbitrateh : in std_logic;
         readbitrateh : in std_logic;          
			loadmodel : in std_logic;
			readmodel : in std_logic;
			loadmodeh : in std_logic;
			readmodeh : in std_logic;
			rxmask : in std_logic;
			rxdata : in std_logic
			);
end pktuartr16;

-- digital input filter added 5/16 V1

architecture Behavioral of pktuartr16 is

-- buffer related signals
signal InAdd: std_logic_vector(log2(MaxFrameSize) -2 downto 0);
signal OutAdd: std_logic_vector(log2(MaxFrameSize) -2  downto 0);
signal OutData: std_logic_vector(15 downto 0);
signal PushData: std_logic;
signal FrameBufferEmpty: std_logic;

-- frame FIFO related signals
signal PushRC: std_logic;
signal RFrameCount: std_logic_vector(4 downto 0) := "00000";
signal RCPopAdd: std_logic_vector(3 downto 0) := "1111";
signal RCFIFOEmpty : std_logic;
signal RCFIFOError: std_logic;
signal RCPopData: std_logic_vector(log2(maxFrameSize)-1 downto 0);
signal ErrPopData: std_logic_vector(1 downto 0);
-- uart interface related signals

constant DDSWidth : integer := 20;
constant defaultfilter : real := round((real(Clock)/5000000.0)); --default filter TC is 200 ns

signal BitrateDDSReg : std_logic_vector(DDSWidth-1 downto 0);
signal BitrateDDSAccum : std_logic_vector(DDSWidth-1 downto 0);
alias  DDSMSB : std_logic is BitrateDDSAccum(DDSWidth-1);
signal OldDDSMSB: std_logic;  
signal SampleTime: std_logic; 
signal DelayTime: std_logic; 
signal BitCount : std_logic_vector(3 downto 0);
signal BytePointer : std_logic := '0';
signal RDataLatch :  std_logic_vector(15 downto 0);
signal SReg: std_logic_vector(9 downto 0);
alias  SRegData: std_logic_vector(7 downto 0)is SReg(9 downto 2);
alias  StartBit: std_logic is Sreg(0);
alias  StopBit: std_logic is Sreg(9);
signal RXPipe : std_logic_vector(1 downto 0);
signal RecvCount: std_logic_vector(log2(MaxFrameSize)-1 downto 0);
signal Go: std_logic; 
signal FDGo: std_logic; 
signal Clear: std_logic; 
signal ModeReg: std_logic_vector(15 downto 0);
alias FrameDelay: std_logic_vector(7 downto 0) is ModeReg(15 downto 8);
signal FrameDelayCount: std_logic_vector(7 downto 0);
alias FalseStart: std_logic is ModeReg(0);-- started recieve but middle of start bit is '1' 
alias OverRun: std_logic is ModeReg(1);	-- '0' where stop bit should be
alias RXMaskEn: std_logic is ModeReg(2); 	-- enable TXEN of transmit side to disable receive
alias RXEnable: std_logic is ModeReg(3); 	-- RX enable
signal RXErrs: std_logic_vector(1 downto 0);
signal ClrRXErrs: std_logic; 
signal ClrRXErrsD: std_logic; 
signal Busy: std_logic;
signal FilterReg: std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(integer(defaultfilter),8)); 
signal FilterCount: std_logic_vector(7 downto 0);
signal RXDataD: std_logic;
signal RXDataFilt: std_logic;

  component SRL16E
--
    generic (INIT : bit_vector);


--
    port (D   : in  std_logic;
          CE  : in  std_logic;
          CLK : in  std_logic;
          A0  : in  std_logic;
          A1  : in  std_logic;
          A2  : in  std_logic;
          A3  : in  std_logic;
          Q   : out std_logic); 
  end component;
	
			
begin

	buffram : entity work.dpram 
	generic map (
		width => 16,
		depth => MaxFrameSize/2
				)
	port map(
		addra => InAdd,
		addrb => OutAdd,
		clk  => clk,
		dina  => RDataLatch,
--		douta => 
		doutb => OutData,
		wea	=> PushData
	);	 

	abuf: process (clk,InAdd,OutAdd)
	begin
		if rising_edge(clk) then			
			if PushData = '1' then
				InAdd <= InAdd+1;
			end if;		 								   
			if popdata = '1' then
				OutAdd <= OutAdd +1;
			end if; 		
			if Clear = '1' then
				InAdd <= (others => '0');
				OutAdd <= (others => '0');
			end if;	
		end if; -- clk
		if InAdd = OutAdd then 
			FrameBufferEmpty <= '1';
		else
			FrameBufferEmpty <= '0';
		end if;	
	end process abuf;
	
	fiforc: for i in 0 to log2(MaxFrameSize)-1 generate
		asr16e: SRL16E generic map (x"0000") port map(
 			 D	  => RecvCount(i),
          CE  => PushRC,
          CLK => clk,
          A0  => RCPopAdd(0),
          A1  => RCPopAdd(1),
          A2  => RCPopAdd(2),
          A3  => RCPopAdd(3),
          Q   => RCPopData(i)
			);	
  	end generate;

	fifoerrs: for i in 0 to 1 generate
		asr16e: SRL16E generic map (x"0000") port map(
 			 D	  => RXErrs(i),
          CE  => PushRC,
          CLK => clk,
          A0  => RCPopAdd(0),
          A1  => RCPopAdd(1),
          A2  => RCPopAdd(2),
          A3  => RCPopAdd(3),
          Q   => ErrPopData(i)
			);	
  	end generate;
	
	
	arcfifo: process (clk,RCPopData,RFrameCount) -- send counter fifo
	begin
		if rising_edge(clk) then
			if PushRC = '1'  and poprc = '0'  then
				if RFrameCount /= 16 then	-- a push
					-- always increment the data counter if not full
					RFrameCount <= RFrameCount +1;
					RCPopAdd <= RCPopAdd +1;						-- popadd must follow data down shiftreg
				else
					RCFIFOError <= '1';
				end if;	
			end if;		 		
						   
			if  (poprc = '1') and (PushRC = '0') then
				if RCFIFOEmpty = '0' then	-- a pop
					RFrameCount <= RFrameCount -1;
					RCPopAdd <= RCPopAdd -1;
				else
					RCFIFOError <= '1';	-- pop with no data
				end if;	
			end if;

-- if both push and pop are asserted we dont change either counter
	  
			if Clear = '1' then -- a Clear fifo
				RCPopadd  <= (others => '1');
				RFrameCount <= (others => '0');
				RCFIFOError <= '0';
			end if;	

		end if; -- clk rise
		if RFrameCount = 0 then
			RCFIFOEmpty <= '1';
		else
			RCFIFOEmpty <= '0';
		end if;
	end process arcfifo;


	asimpleuartrx: process (clk, loadmodel,loadmodeh,OldDDSMSB,BitRateDDSAccum,
	                        OldDDSMSB,FrameDelayCount,poprc,RCPopData,popdata,
									OutData,ErrPopData,readbitratel,readbitrateh,
									BitRateDDSReg,readmodel,readmodeh,ModeReg,FrameBufferEmpty,
									RCFIFOError,rxmask,Go,FDGo,ibus,RCFIFOEmpty,RFrameCount)
	begin
		report "Default FilterReg = " & integer'image(integer(defaultfilter));
		if rising_edge(clk) then
			RXDataD <= rxdata;
			RXPipe <= RXPipe(0) & RXDataFilt;  		-- Two stage rx data pipeline to compensate for
																-- two clock delay from start bit detection to acquire loop startup

			if (RXDataD = '1') and (FilterCount < FilterReg) then		-- simple digital filter on rxdata
				FilterCount <= FilterCount + 1;
			end if;
			if (RXDataD = '0') and (FilterCount /= 0) then 
				FilterCount <= FilterCount -1;
			end if;
			if FilterCount >= FilterReg then
				RXDataFilt<= '1';
			end if;
			if FilterCount = 0 then
				RXDataFilt<= '0';
			end if;
																				
			if Go = '1' or FDGo = '1' then 
				BitRateDDSAccum <= BitRateDDSAccum + BitRateDDSReg;
				if Go = '1' then	
					if SampleTime = '1' then
						if BitCount = 0 then		-- received a char							
							Go <= '0';
							if FDGo = '0' then 	-- first character of a frame	
								RecvCount <= conv_std_logic_vector(1,log2(MaxFrameSize));
							else
								RecvCount <= RecvCount + 1;
							end if;	
							FDGo <= '1';						
							FrameDelayCount <= FrameDelay;
							if RXPipe(1) = '0' then
								OverRun <= '1';
								RXErrs(1) <= '1';
							end if;	
							case BytePointer is
								when '0' => RDataLatch(7 downto 0)   <= SRegData;
								when '1' => RDataLatch(15 downto 8)  <= SRegData;
								when others => null;
							end case;							
							if BytePointer = '1' then
								PushData <= '1';					-- write and advance write data pointer every  word 
							end if;	
							BytePointer <= not BytePointer;
						end if;					
						if BitCount = "1001" then	-- false start bit check
							if RXPipe(1) = '1' then
								Go <= '0';				-- abort receive
								FalseStart <= '1';
								RXErrs(0) <= '1';
							end if;
						end if;	
						SReg <= RXPipe(1) & SReg(9 downto 1);		-- right shift = LSb first
						BitCount <= BitCount -1;	
					end if;	-- sampletime
				end if;
				if FDGo = '1' then							-- framing timeout
					if DelayTime = '1' then
						FrameDelayCount <= FrameDelayCount -1;
						if FrameDelayCount = x"01" then
							FDGo <= '0';	
							PushRC <= '1';
							ClrRXErrs <= '1';
							if BytePointer /= '0' then	-- push rest of data if any remaining
								PushData <= '1';
								BytePointer <= '0';
							end if;	
						end if;
					end if;
				end if;						
			end if;

			if PushData = '1' then
				PushData <= '0';
			end if;
			
			if PushRC = '1' then
				PushRC <= '0';
			end if;
			
			if ClrRXErrs = '1' then
				ClrRXErrs <= '0';
			end if;

			ClrRXErrsD <= ClrRXErrs;
			if ClrRXErrsD = '1' then
				RXErrs <= "00";
			end if;
			
			if Go = '0' then
				BitCount <= "1001";
				if RXDataFilt = '0' and (rxmask and RXMaskEn) = '0' and RXEnable = '1' then		
					Go <= '1';			-- start bit detection
					BitRateDDSAccum <= (others => '0'); 				
				end if;
			end if;	
			
			if Clear = '1' then
				Go <= '0';
				FDGo <= '0';
				FrameDelayCount <= x"01";
				BytePointer <= '0';
			end if;	
			
			OldDDSMSB <= DDSMSB;							-- for Phase accumulator MSB edge detection

			if loadbitratel =  '1' then 
				BitRateDDSReg(15 downto 0) <= ibus;							 
			end if;
	
			if loadbitrateh =  '1' then 
				BitRateDDSReg(DDSWidth-1 downto 16) <= ibus(DDSWidth-17 downto 0);	
			end if;
			
			if loadmodel=  '1' then 
				ModeReg <= ibus(15 downto 0);
			end if;
			
			if loadmodeh = '1' then
				FilterReg <= ibus(13 downto 6);
			end if;

		end if; -- clk

		if loadmodeh = '1' and ibus(0) = '1' then
			Clear <= '1';
		else
			Clear <= '0';
		end if;	
		
		SampleTime <= (not OldDDSMSB) and DDSMSB;		-- sample on rising edge of DDS MSB
		DelayTime <= OldDDSMSB and (not DDSMSB);
		
		Busy <= Go or FDGo or PushRC or (not RCFIFOEmpty);
		
		obus <= (others => 'Z');
		
		if	poprc =  '1' then
			obus(log2(maxFrameSize)-1 downto 0) <= RCPopData;
			obus(13 downto log2(MaxFrameSize)) <= (others => '0');
			obus(15 downto 14) <= ErrPopData;
		end if;

		if popdata =  '1' then
			obus <= OutData;
		end if;
		
      if readbitratel =  '1' then
			obus <= BitRateDDSReg(15 downto 0);
		end if;

      if readbitrateh =  '1' then
			obus(DDSWidth-17 downto 0) <= BitRateDDSReg(DDSWidth-1 downto 16);
			obus(15 downto DDSWidth-16) <= (others => '0');
		end if;

		if readmodel =  '1' then
			obus(3 downto 0) <= ModeReg(3 downto 0);
			obus(4) <= RCFIFOError;
			obus(6) <= rxmask;
			obus(7) <= Busy;
			obus(15 downto 8) <= ModeReg(15 downto 8); -- frame delay
		end if;
		
		if readmodeh =  '1' then
			obus(4 downto 0) <= RFrameCount;
			obus(5) <= (not FrameBufferEmpty) and (not Busy); --  buffer error
			obus(13 downto 6) <= FilterReg;
			obus(15 downto 14) <= (others => '0');
		end if;	
	
	end process asimpleuartrx;
	
end Behavioral;
