library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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

entity pktuartx16 is
	generic (MaxFrameSize: integer ); -- in bytes (-1) maximum is 2K bytes
	Port (clk : in std_logic;
			ibus : in std_logic_vector(15 downto 0);
         obus : out std_logic_vector(15 downto 0);
			pushdata : in std_logic;
			pushsc: in std_logic;
			readsc: in std_logic;
			loadbitratel : in std_logic;
         readbitratel : in std_logic;          
			loadbitrateh : in std_logic;
         readbitrateh : in std_logic;          
			loadmodel : in std_logic;
			readmodel : in std_logic;
			loadmodeh : in std_logic;
			readmodeh : in std_logic;
			drven : out std_logic;
         txdata : out std_logic
			);
end pktuartx16;

architecture Behavioral of pktuartx16 is

-- buffer related signals
signal InAdd: std_logic_vector(log2(MaxFrameSize) -2 downto 0);
signal OutAdd: std_logic_vector(log2(MaxFrameSize) -2  downto 0);
signal OutData: std_logic_vector(15 downto 0);
signal ReadData: std_logic;
signal FrameBufferEmpty: std_logic;
	
-- frame FIFO related signals
signal PopSC: std_logic;
signal SFrameCount: std_logic_vector(4 downto 0);
signal SCPopAdd: std_logic_vector(3 downto 0);
signal SCFIFOError: std_logic;
signal SCFIFOEmpty : std_logic;
signal SCPopData: std_logic_vector(log2(maxFrameSize)-1 downto 0);
-- uart interface related signals

constant DDSWidth : integer := 20;

signal BitrateDDSReg : std_logic_vector(DDSWidth-1 downto 0);
signal BitrateDDSAccum : std_logic_vector(DDSWidth-1 downto 0);
alias  DDSMSB : std_logic is BitrateDDSAccum(DDSWidth-1);
signal OldDDSMSB: std_logic;  
signal SampleTime: std_logic; 
signal DelayTime: std_logic; 
signal BitCount : std_logic_vector(3 downto 0);
signal BytePointer : std_logic := '0';
signal SReg: std_logic_vector(10 downto 0);
signal SendData: std_logic_vector(7 downto 0);
signal SendCount: std_logic_vector(log2(MaxFrameSize)-1 downto 0);
signal Clear: std_logic; 
alias SregData: std_logic_vector(7 downto 0)is SReg(9 downto 2);
alias StartBit: std_logic is Sreg(1);
alias StopBit: std_logic is Sreg(10);
alias IdleBit: std_logic is Sreg(0);
signal Go: std_logic := '0'; 
signal FDGo: std_logic := '0'; 
signal SCNZ: std_logic := '0'; 
signal ModeReg: std_logic_vector(15 downto 0);
alias FrameDelay: std_logic_vector(7 downto 0) is ModeReg(15 downto 8);
signal FrameDelayCount: std_logic_vector(7 downto 0);
alias DriveEnDelay: std_logic_vector(3 downto 0) is ModeReg(3 downto 0);
signal DriveDelayCount: std_logic_vector(3 downto 0);
alias DriveEnAuto: std_logic is ModeReg(5);
alias DriveEnBit: std_logic is ModeReg(6);
signal DriveEnable: std_logic;
signal DriveEnHold: std_logic;
signal WaitingForDrive: std_logic;
signal Busy: std_logic;

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
		dina  => ibus,
--		douta => 
		doutb => OutData,
		wea	=> pushdata
	);	 
	
	

	abuf: process (clk,InAdd,OutAdd)
	begin
		if rising_edge(clk) then			
			if pushdata = '1' then
				InAdd <= InAdd+1;
			end if;		 								   
			if ReadData = '1' then
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
				

	fifosrl: for i in 0 to log2(MaxFrameSize)-1 generate
		asr16e: SRL16E generic map (x"0000") port map(
 			 D	  => ibus(i),
          CE  => pushsc,
          CLK => clk,
          A0  => SCPopAdd(0),
          A1  => SCPopAdd(1),
          A2  => SCPopAdd(2),
          A3  => SCPopAdd(3),
          Q   => SCPopData(i)
			);	
  	end generate;

	

	ascfifo: process (clk,SCPopData,SFrameCount) -- send counter fifo
	begin
		if rising_edge(clk) then
			if pushsc = '1'  and PopSC = '0'  then
				if SFrameCount /= 16 then	-- a push
					-- always increment the data counter if not full
					SFrameCount <= SFrameCount +1;
					SCPopAdd <= SCPopAdd +1;						-- popadd must follow data down shiftreg
				else
					SCFIFOError <= '1';
				end if;	
			end if;		 		
						   
			if  (PopSC = '1') and (pushsc = '0') and (SCFIFOEmpty = '0') then	-- a pop
				-- always decrement the data counter if not empty
				SFrameCount <= SFrameCount -1;
				SCPopAdd <= SCPopAdd -1;
			end if;

-- if both push and pop are asserted we dont change either counter
	  
			if Clear = '1' then -- a Clear fifo
				SCPopadd  <= (others => '1');
				SFrameCount <= (others => '0');
				SCFIFOError <= '0';
			end if;	
	

		end if; -- clk rise
		if SFrameCount = 0 then
			SCFIFOEmpty <= '1';
		else
			SCFIFOEmpty <= '0';
		end if;
	end process ascfifo;


	asimplepktuarttx: process (clk,loadmodel,loadmodeh,OldDDSMSB,BitRateDDSAccum,DriveDelayCount,
	                            DriveEnable,ModeReg,Go,BytePointer,OutData,readbitratel, readbitrateh,
										 readmodel,readmodeh,ibus,BitRateDDSReg,FDGo,WaitingForDrive,SReg,Busy,
										 SCNZ,SFrameCount,SendCount,SCFIFOError,SCFIFOEmpty,ReadSC,FrameBufferEmpty)
	begin
		if rising_edge(clk) then
			if Go = '1' or FDGo = '1' then 	
				BitRateDDSAccum <= BitRateDDSAccum - BitRateDDSReg;
				if FDGo = '0' then	
					if SampleTime = '1' then
						SReg <= '1' & SReg(10 downto 1);		-- right shift = LSb first
						BitCount <= BitCount -1;
						if BitCount = 0 then
							Go <= '0';
						end if;	
					end if;	
				end if;	
				if FDGO = '1' then							-- frame delay
					if DelayTime = '1' then
						FrameDelayCount <= FrameDelayCount -1;
						if FrameDelayCount = x"01" then
							FDGo <= '0';	
						end if;
					end if;
				end if;	
			else
			
				BitRateDDSAccum <= (others => '0');
			end if;
			
			if Go = '0' and FDGo = '0' then	-- prepare to send
				StartBit <= '0';
				StopBit <= '1';
				IdleBit <= '1';				
				BitCount <= "1010";
				if SendCount /= 0 and DriveEnHold = '0' then  -- start byte send 		                                                                                                                                 -- UART SReg not busy and we have data
					SRegData <= SendData;
					Go <= '1';						
					BytePointer <= not BytePointer;
					SendCount <= SendCount -1;
					if BytePointer = '1' then
						ReadData <= '1';					-- advance read data pointer 
					end if;	
					SCNZ <= '1';						 
				else											-- SendCount = 0 
					if SCFIFOEmpty = '0' then			-- more frames to send
						SendCount <= SCPopData;
						PopSC <= '1';
					end if;
					if SCNZ = '1' then 					-- just at end of frame
						if BytePointer /= '0' then 	-- discard partial data
							BytePointer <= '0';
							ReadData <= '1';
						end if;	
						FDGo <= '1';
						FrameDelayCount <= FrameDelay;							
						SCNZ <= '0';	
					end if;	
				end if;				
			end if;
			
			if Clear = '1' then 
				SendCount <= (others => '0');
				BytePointer <= '0';
				Go <= '0';
				FDGo <='0';
				SCNZ <='0';
			end if;
			
			if ReadData = '1' then 
				ReadData <= '0';
			end if;	
			
			if PopSC = '1' then 
				PopSC <= '0';
			end if;	
		
			if DriveEnable = '0' then
				DriveDelayCount <= DriveEnDelay;
			else
				if WaitingForDrive = '1' then
					DriveDelayCount <= DriveDelayCount -1;
				end if;	
			end if;
					
			OldDDSMSB <= DDSMSB;

			if loadbitratel =  '1' then 
				BitRateDDSReg(15 downto 0) <= ibus;							 
			end if;
	
			if loadbitrateh =  '1' then 
				BitRateDDSReg(DDSWidth-1 downto 16) <= ibus(DDSWidth-17 downto 0);	
			end if;
			
			if loadmodel = '1'  then 
				ModeReg <= ibus(15 downto 0);
			end if;

		end if; -- clk
		
		if loadmodeh = '1' and ibus(0) = '1' then
			Clear <= '1';
		else
			Clear <= '0';
		end if;	

		SampleTime <= (not OldDDSMSB) and DDSMSB;
		DelayTime <= OldDDSMSB and (not DDSMSB);
		if DriveDelayCount /= 0 then 
			WaitingForDrive <= '1';
		else
			WaitingForDrive <= '0';
		end if;	
		
		DriveEnHold <= (not DriveEnable) or WaitingForDrive;
		
		if DriveEnAuto = '1' then 
			DriveEnable <= (Go or FDGo or SCNZ or (not SCFIFOEmpty)); 																						-- when there is data to xmit
		else																		
			DriveEnable <= DriveEnBit;
		end if;	
		
		case BytePointer is 
			when '0' => SendData <= OutData(7 downto 0);
			when '1' => SendData <= OutData(15 downto 8);
			when others => null;
		end case;
		
		Busy <= Go or FDGo or (not SCFIFOEmpty) or SCNZ;
		
		obus <= (others => 'Z');

      if readsc =  '1' then
			obus(log2(MaxFrameSize)-1 downto 0) <=SendCount;
			obus(15 downto log2(MaxFrameSize)) <= (others => '0');
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
			obus(4) <= SCFIFOError;
			obus(6 downto 5) <= ModeReg(6 downto 5);
			obus(7) <= Busy;
			obus(15 downto 8) <= ModeReg(15 downto 8);
		end if;

		if readmodeh =  '1' then
			obus(4 downto 0) <= SFrameCount;
			obus(5) <= (not FrameBufferEmpty) and (not Busy);
			obus(15 downto 6) <= (others => '0');
		end if;
		
		txdata<= SReg(0);
		drven <= DriveEnable;
		
	end process asimplepktuarttx;
	
end Behavioral;
