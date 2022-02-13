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
use work.oneofndecode.all;	

entity biss is
	port (
		clk : in std_logic;
		hclk : in std_logic;
	 	ibus : in std_logic_vector(31 downto 0);
      obus : out std_logic_vector(31 downto 0);
      poplifo : in std_logic;
		lstart : in  std_logic;
		pstart : in  std_logic;
		timers : in std_logic_vector(4 downto 0);
		loadcontrol0 : in std_logic;
		loadcontrol1 : in std_logic;
		readcontrol0 : in std_logic;
		readcontrol1 : in std_logic;
		lifohasdata : out std_logic;
		busyout: out std_logic;
		davout: out std_logic; 
		testdata: out std_logic;
		sampletime: out std_logic;
		bissclk : out std_logic;
      bissdata : in std_logic
		);
end biss;

architecture Behavioral of biss is


-- BISS interface related signals

constant DDSWidth : integer := 16; -- 16 max
constant BitLength : integer := 10; -- limited by SLR16 x 32 bits wide so 512 bits 
constant TestDataConst : std_logic_vector(31 downto 0) := x"AABCD123";
signal BitLengthReg : std_logic_vector(BitLength-1 downto 0);
signal BitCount : std_logic_vector(BitLength-1 downto 0);
signal BitrateDDSReg : std_logic_vector(DDSWidth-1 downto 0);
signal BitPointer : std_logic_vector(4 downto 0);
alias  BitPointerMSB : std_logic is BitPointer(4);
signal OldBitPointerMSB : std_logic;
signal FilterTime : std_logic_vector(32-Bitlength-DDSWidth-1 downto 0);
signal FilterTimeReg : std_logic_vector(32-Bitlength-DDSWidth-1 downto 0);
signal FilteredBISSData : std_logic;
signal XmitDDSAccum : std_logic_vector(DDSWidth-1 downto 0);
alias  XmitDDSMSB : std_logic is XmitDDSAccum(DDSWidth-1);
signal OldXmitDDSMSB: std_logic;  
signal RecvDDSAccum : std_logic_vector(DDSWidth-1 downto 0);
alias  RecvDDSMSB : std_logic is RecvDDSAccum(DDSWidth-1);
signal OldRecvDDSMSB : std_logic;  
signal RXSampleTime: std_logic; 
signal XmitClockRE : std_logic; 
signal BISSDataD : std_logic; 
signal BISSDataPipe: std_logic_vector(2 downto 0); 

signal XGo: std_logic := '0'; 
signal RGo: std_logic := '0'; 
signal DGo: std_logic := '0'; 
signal DAV: std_logic := '0';
signal SyncDAV: std_logic := '0';
signal TimerSelect: std_logic_vector(2 downto 0);
signal Timer: std_logic; 
signal OldTimer: std_logic;
signal TStart: std_logic := '0'; 
signal TStartMask: std_logic := '0';
signal PStartMask: std_logic := '0';
signal StartReq: std_logic := '0';
signal StartReq1: std_logic := '0';
signal StartReq2: std_logic := '0';
signal PopReq: std_logic := '0';
signal PopReq1: std_logic := '0';
signal PopReq2: std_logic := '0';

-- test signals
signal SampleToggle: std_logic;
signal TestDataSR: std_logic_vector(31 downto 0);

-- LIFO related signals
	signal PushData: std_logic_vector(31 downto 0);
	signal PopAdd: std_logic_vector(3 downto 0) := x"f";	
	signal PopData: std_logic_vector(31 downto 0);
	signal DataCounter: std_logic_vector(4 downto 0);
	signal PushBit: std_logic_vector(31 downto 0);  
	signal Push: std_logic;  
	signal Pop: std_logic;  
	signal ClearLIFO: std_logic;
	signal llifoempty: std_logic; 
	signal llifohasdata: std_logic; 

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

	lifosrl: for i in 0 to 31 generate
		asr16e: SRL16E generic map (x"0000") port map(
 			 D	  => BissDataPipe(2),
          CE  => PushBit(i),
          CLK => hclk,
          A0  => PopAdd(0),
          A1  => PopAdd(1),
          A2  => PopAdd(2),
          A3  => PopAdd(3),
          Q   => PopData(i)
			);	
  	end generate;

	alifo: process (hclk,Popdata,DataCounter,llifoempty)
	begin
		if rising_edge(hclk) then
			if (Push = '1')  and (Pop = '0') then
				if DataCounter /= 16 then	-- a Push
					-- always increment the data counter if not full
					DataCounter <= DataCounter +1;
				end if;	
			end if;		 		
			if  (Pop = '1') and (Push = '0') then		-- a Pop
				if DataCounter > 0  then  
					DataCounter <= DataCounter - 1;
					PopAdd <= PopAdd + 1;
				end if;	
			end if;
			if ClearLIFO = '1' then -- a clear lifo
				PopAdd  <= (others => '0');
				DataCounter <= (others => '0');
			end if;	
		end if; -- clk rise		
		if DataCounter = 0 then
			llifoempty <= '1';
		else
			llifoempty <= '0';
		end if;		 
	end process alifo;

		
	asimplebiss: process (clk, StartReq2, StartReq1, PopReq2, PopReq1, OldRecvDDSMSB, BISSDataPipe,
                      	RecvDDSAccum, OldXmitDDSMSB, XmitDDSAccum, DGo, BitPointer, RXSampleTime,
								DataCounter, SyncDAV, poplifo, PopData, llifoempty,hclk, readcontrol0,Readcontrol1,
								Timer,Timers,TimerSelect,BitLengthReg,FilterTimeReg,BitRateDDSReg,PstartMask,
								TStartMask,RGo,XGo)
	begin
		if rising_edge(hclk) then
			
			-- fi
			BISSDataD <= bissdata;
			if BissDataD = '0' then
				if FilterTime /=0 then
					FilterTime <= FilterTime -1;
				end if;
			else
				if FilterTime /= FilterTimeReg then
					FilterTIme <= FilterTime +1;
				end if;
			end if;
			if FilterTime = 0 then
				FilteredBISSData <= '0';
			end if;				
			if FilterTime = FilterTimeReg then
				FilteredBISSData <= '1';
			end if;	
			
 			BISSDataPipe <= BISSDataPipe(1 downto 0) & FilteredBISSData;  		-- Two stage rx data pipeline to compensate for
																									-- two clock delay from start bit detection to acquire loop startup
--			OldBitPointerMSB <= BitPointerMSB;
			if XGo = '1' then 
				if XmitClockRE = '1' then
					TestDataSR <= TestDataSR(30 downto 0) & TestDataSR(31);
				end if;		
				XmitDDSAccum <= XmitDDSAccum + BitRateDDSReg;	-- start clock
				if RGo = '1' then							-- RGo means we detected start bit
					RecvDDSAccum <= RecvDDSAccum + BitRateDDSReg;
					if RXSampleTime = '1' then					
						if BitCount = 0 then
							RGo <= '0';						-- done with receive
							DAV <= '1';
						else
							if DGo = '1' and RGo = '1' then
								BitCount <= BitCount -1;
								BitPointer <= BitPointer -1;
								SampleToggle <= not SampleToggle;
							end if;	
						end if;	
						DGo <= '1';							-- data starts 1 bit after start bit			
					end if;	
				end if;	
			else
				XmitDDSAccum <= (others => '0'); 
				RecvDDSAccum <= (others => '0'); 			
				SampleToggle <= '0';
				TestDataSR <= TestDataConst;
			end if;
			
			if (RGo = '0') and (DGo = '0') and (BISSDataPipe(0) = '1') and (BISSDataPipe(1)= '0') then	-- start bit detection
				RGo <= '1';
			end if;	

			if (RGo = '0') and (BitCount = 0) and (XmitClockRE = '1') then	--stop xmit clock synchronously
				DGo <= '0';
				XGo <= '0';
			end if;	
					
			OldXmitDDSMSB <= XmitDDSMSB;							-- for Phase accumulator MSB edge detection
			OldRecvDDSMSB <= RecvDDSMSB;							-- for Phase accumulator MSB edge detection

			-- clock domain crossing control signals
			StartReq2 <= StartReq1;
			
			if StartReq = '1' then
				StartReq1 <= '1';
			end if;
			
			PopReq2 <= PopReq1;
			
			if PopReq = '1' then
				PopReq1 <= '1';
				DAV <= '0';					-- DAV cleared on any reads	
			end if;	
	
			if PopReq2 = '1' then
				PopReq1 <= '0';
			end if;	
	
			if (StartReq2 and StartReq1) = '1' then
				BitCount <= BitLengthReg;
				BitPointer <= BitLengthReg(4 downto 0); --5 bit remainder
				XGo <= '1';
				RGo <= '0';
				DGo <= '0';
				StartReq1 <= '0';
			end if;
			
		end if; -- hclk
		
		PushBit <= OneOfNDecode(32,DGo,RXSampleTime,BitPointer);

		if (BitPointer = "00001") and (DGo = '1') and (RXSampleTime = '1') then
			Push <= '1';
		else
			Push <= '0';
		end if;	
			
		if (StartReq2 and StartReq1) = '1' then
			ClearLIFO <= '1';							-- always clear data LIFO when starting cycle
		else		
			CLearLIFO <= '0';
		end if;	
		
		if (PopReq2 and PopReq1) = '1' then
			Pop <= '1';
		else		
			Pop <= '0';
		end if;		
			
		if rising_edge(clk) then
			if loadControl0=  '1' then 
				BitRateDDSReg <= ibus(31 downto 32-DDSWidth);
				FilterTimeReg <= ibus(32-DDSWidth-1 downto bitlength);
				BitLengthReg <= ibus(BitLength-1 downto 0);	
			end if;

			if loadControl1=  '1' then 
				TimerSelect <= ibus(14 downto 12);
				PstartMask <= ibus(8);
				TstartMask <= ibus(9);
			end if;
		
			if (lstart = '1') or ((pstart = '1') and (PstartMask = '1')) or ((TStart = '1') and (TStartMask = '1')) then
				StartReq <= '1';
			end if;	
	
			if (Poplifo = '1') then
				PopReq <= '1';
			end if;	
			
			SyncDAV <= DAV;
			OldTimer <= Timer;
			
		end if; -- clk rising edge

		if Timer = '1' and OldTimer = '0' then 		-- rising edge of selected timer
			TStart <= '1';
		else
			TStart <= '0';
		end if;

		case TimerSelect(2 downto 0) is
			when "000" => Timer <= timers(0);
			when "001" => Timer <= timers(1);
			when "010" => Timer <= timers(2);
			when "011" => Timer <= timers(3);
			when "100" => Timer <= timers(4);	
			when others => Timer <= Timers(0);
		end case;	
		
		if StartReq2 = '1' then 
			StartReq <= '0';				-- async clear request
		end if;		

		if PopReq2 = '1' then 
			PopReq <= '0';					-- async clear request
		end if;		
		
		
		RXSampleTime <= (not OldRecvDDSMSB) and RecvDDSMSB;			-- sample on rising edge of DDS MSB, that is 1/2 cycle from edge
		XmitClockRE  <= OldXmitDDSMSB and (not XmitDDSMSB); 			-- stop xmit clock in idle state

		obus <= (others => 'Z');
		if	readcontrol0 =  '1' then
			obus(9 downto 0) <= BitLengthReg;
			obus(15 downto 10) <= FilterTimeReg;
			obus(31 downto 32-DDSWidth) <= BitRateDDSReg;
		end if;

		if	readcontrol1 =  '1' then
			obus(4 downto 0) <= DataCounter;
			obus(7 downto 5) <= (others => '0');
			obus(8)	<= PstartMask;
			obus(9)	<= TstartMask;
			obus(10) <= RGo;
			obus(11) <= '0';
			obus(14 downto 12) <= TimerSelect;
			obus(15) <= SyncDAV;
			obus(31 downto 16) <= (others => '0');
		end if;

		if poplifo =  '1' then
			obus <= PopData;
		end if;

		lifohasdata <= not llifoempty;
		bissclk <= 	not XmitDDSMSB;
		busyout <= XGo or not SyncDAV;
		davout <= SyncDAV;
		sampletime <= SampleToggle;
		testdata <= TestDataSR(31);
	end process asimplebiss;
	
end Behavioral;
