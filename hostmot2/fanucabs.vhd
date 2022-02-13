library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;
--
-- Copyright (C) 2009, Peter C. Wallace, Mesa Electronics
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

entity FanucAbs is
	generic (
			Clock : integer
			);    
	Port (clk : in std_logic;
	 		ibus : in std_logic_vector(31 downto 0);
			obus : out std_logic_vector(31 downto 0);
			loadcontrol0 : in std_logic;
			loadcontrol1 : in std_logic;
			loadcontrol2 : in std_logic;
			lstart : in std_logic;
			pstart : in std_logic;
			timers : in std_logic_vector(4 downto 0);
			readdata0 : in std_logic;
			readdata1 : in std_logic;
			readdata2 : in std_logic;
			readcontrol0 : in std_logic;
			readcontrol1 : in std_logic;
			busyout : out std_logic;
			davout: out std_logic; 
			requestout : out std_logic;
			driveEn : out std_logic;
			rxdata : in std_logic;
			testclk : out std_logic
          );
end FanucABS;

architecture Behavioral of FanucABS is

constant DDSSize : integer := 20;
constant DefaultBRDDS : real  := 
         round((2**real(DDSSize))*(1024000.0/real(Clock)));		-- add second register for dual speed use
signal BitrateDDSReg : std_logic_vector(DDSSize-1 downto 0) := 
       std_logic_vector(to_unsigned(integer(DefaultBRDDS),DDSSize));
signal BitrateDDSAccum : std_logic_vector(DDSSize-1 downto 0);
alias  DDSMSB : std_logic is BitrateDDSAccum(DDSSize-1);
signal OldDDSMSB: std_logic;  
signal BitCountReg : std_logic_vector(6 downto 0) := 
       std_logic_vector(to_unsigned(76,7));
signal BitCount : std_logic_vector(6 downto 0);
constant DefaultReqWidthReg : real := round(real(Clock)*8.0e-6);
signal RequestWidthReg : std_logic_vector(9 downto 0) := 
       std_logic_vector(to_unsigned(integer(DefaultReqWidthReg),10));
signal RequestWidth : std_logic_vector(9 downto 0);
signal FAbsSreg: std_logic_vector(75 downto 0);
signal FAbsLatch: std_logic_vector(75 downto 0);
signal TimerSelect: std_logic_vector(2 downto 0);
signal Timer: std_logic; 
signal OldTimer: std_logic; 
signal TStart: std_logic;
signal RXGo: std_logic; 
signal Start: std_logic;
signal Busy: std_logic;
signal Request: std_logic;
signal RXDone: std_logic;
signal OldRXDone: std_logic;
signal InvertMask: std_logic;
signal PStartmask: std_logic; 
signal TStartmask: std_logic; 
signal SampleTime: std_logic; 
signal FilterTime: std_logic_vector(3 downto 0);
signal FilterTimeReg: std_logic_vector(3 downto 0) := "1111";
signal FilteredRXData: std_logic; 
signal RXDataD: std_logic; 
signal RXPipe : std_logic_vector(1 downto 0);
signal EnableSetupLoad: std_logic := '0';
signal CableErr: std_logic := '0'; 
signal DAV : std_logic := '0';
--added stuff below for rs485 support
signal ReqData : std_logic_vector(9 downto 0) := "0001110000";	--request character with start/stop bits
signal SReqData : std_logic_vector(9 downto 0);
signal RequestSinglePairMode : std_logic := '0';	--request rs485 mode
signal SinglePairMode : std_logic := '0';	--rs485 mode
signal OldSinglePairMode : std_logic := '0';
signal ReqGo : std_logic := '0';	--go send req data
signal ReqBitCountReg : std_logic_vector(4 downto 0) := 
       std_logic_vector(to_unsigned(9,5));
signal ReqBitCount : std_logic_vector(4 downto 0);
--signal PulseCountReg : std_logic_vector(9 downto 0) := 
--       std_logic_vector(to_unsigned(75,10));
--signal PulseCount : std_logic_vector(9 downto 0);
signal ReqDrvDlyReg : std_logic_vector(9 downto 0) := 
       std_logic_vector(to_unsigned(16,10));
signal StartingReqDrvDlyReg : std_logic_vector(9 downto 0) := 
       std_logic_vector(to_unsigned(1000,10));	--3767?
signal ReqDrvDly : std_logic_vector(9 downto 0);
signal PulseDrvOffDlyReg : std_logic_vector(12 downto 0) := 
       std_logic_vector(to_unsigned(2100,13));
signal PulseDrvOffDly : std_logic_vector(12 downto 0);
signal RXDlyReg : std_logic_vector(9 downto 0) := 
       std_logic_vector(to_unsigned(40,10));
signal RXDly : std_logic_vector(9 downto 0);
signal ReqDrvEn : std_logic := '0';
--signal InitPulsesStarted : std_logic := '0';
signal ReqPulseDone : std_logic := '0';
--signal StartupInit : std_logic := '0';
signal RXReady : std_logic := '0';
signal RXDlyReady : std_logic := '0';
signal waitCountReg : std_logic_vector(3 downto 0) := 
       std_logic_vector(to_unsigned(0,4));
signal waitCount : std_logic_vector(3 downto 0);

begin

	afabsinterface: process (clk, lstart, tstart, TStartmask , pstart, PStartmask, 
									BitrateDDSAccum, OldDDSMSB, readdata0, FAbsLatch, 
									readdata1, readdata2, readcontrol0, BitCountReg, RXGo, 
									Busy, RequestWidthReg, readcontrol1, BitrateDDSReg, Request,
									Timer,OldTimer,TimerSelect,Timers,CableErr,DAv,FilterTimeReg)
	begin
		

		if clk'event and clk = '1' then
			RXDataD <= rxdata;		-- first stage sync
			
			if FilterTime > FilterTimeReg then
				FilterTime <= FilterTimeReg;
			end if;

			if RXdataD = '0' then
				if FilterTime /=0 then
					FilterTime <= FilterTime -1;
				end if;
			else
				if FilterTime /= FilterTimeReg then
					FilterTIme <= FilterTime +1;
				end if;
			end if;
			if FilterTime = 0 then
				FilteredRXData <= '0';
			end if;				
			if FilterTime = FilterTimeReg then
				FilteredRXData <= '1';
			end if;	
			
			RXPipe <= RXPipe(0) & FilteredRXData; 	-- Two stage rx data pipeline to compensate for
																	-- start bit --> dds startup time
																
			if Start = '1' then
				--if StartupInit = '1' then
				--	InitPulsesStarted <= '0';
				--	SinglePairMode <= '0';
				--	StartupInit <= '0';
				--end if;
				ReqDrvDly <= (Others => '0');
				PulseDrvOffDly <= (Others => '0');
				RequestWidth <= (Others => '0');
				BitCount <= BitCountReg;
				BitRateDDSAccum <= (others => '0');
				FAbsSReg <= (Others => '0');
				PulseDrvOffDly <= (Others => '0');
				Busy <= '1';
				RXDone <= '0';
				RXGo <= '0';									-- reset Go if it was running/waiting
				RXDlyReady <= '0';
				RXDly <= (Others => '0');
				
				--if (RequestSinglePairMode = '1') and (SinglePairMode = '0') then
				--	if (InitPulsesStarted = '0') then
				--		InitPulsesStarted <= '1';
				--		PulseCount <= PulseCountReg;
				--	else
				--		PulseCount <= PulseCount -1;
				--	end if;

				--	if PulseCount = 1 then
				--		SinglePairMode <= '1';
				--		ReqPulseDone <= '0';
				--		ReqGo <= '0';
				--		--Request <= '1';
				--		--ReqDrvEn <= '1';
				--		ReqBitCount <= ReqBitCountReg;
				--		SReqData <= ReqData;
				--		ReqDrvDly <= ReqDrvDlyReg;									-- start send req data
				--	end if;	
				--end if;
				ReqPulseDone <= '0';
				if SinglePairMode = '1' then
					--if RequestSinglePairMode = '0' then
					--	SinglePairMode <= '0';
					--end if;
					ReqGo <= '0';
					--Request <= '1';
					--ReqDrvEn <= '1';
					ReqBitCount <= ReqBitCountReg;
					SReqData <= ReqData;
					if OldSinglePairMode = '0' then
						ReqDrvDly <= StartingReqDrvDlyReg;
					else
						ReqDrvDly <= ReqDrvDlyReg;
					end if;
				else
						ReqDrvEn <= '1';
						Request <= '1';
						RequestWidth <= RequestWidthReg;  --change registers to constants
						CableErr <= FilteredRXData;				-- if we have a start bit here we have a cable/polarity error
					
				end if;
				OldSinglePairMode <= SinglePairMode;
			end if;

			if RequestWidth /= 0 then						-- request pulse one shot
				--if (RequestWidth = 1) and (PulseCount = 1) and (RequestSinglePairMode = '1') then
				--	PulseDrvOffDly <= PulseDrvOffDlyReg;
				--	Request <= '0';
				--end if;
				RequestWidth <= RequestWidth -1;
				if (RequestWidth = 1) and (SinglePairMode = '0') then
					Request <= '0';
				end if;
			end if;
			
			--if PulseDrvOffDly /= 0 then						-- disable driveEn after final init pulse after a delay
			--	if (PulseDrvOffDly = 1) then
			--		ReqDrvEn <= '0';
			--	end if;
			--	PulseDrvOffDly <= PulseDrvOffDly -1;
			--end if;

			if (ReqDrvDly /= 0) and (ReqGo = '0') and (SinglePairMode = '1')then
				Request <= '1';
				ReqDrvEn <= '1';
				if (ReqDrvDly = 1) then
					if ReqBitCount /= 0 then
						ReqGo <= '1';
					else 
						ReqPulseDone <= '1';
						RXDly <= RXDlyReg;
					end if;
				end if;
				ReqDrvDly <= ReqDrvDly -1;
			end if;

			if RXDly /= 0 then
				RXDly <= RXDly - 1;
				if RXDly = 1 then
					RXDlyReady <= '1';
					--FilterTime <= "0000";
					FilteredRXData <= '0';
				end if;
			end if;

			--if (RXDlyReady = '1') and (RXDataD = '1') then
			--	FilterTime <= "0100";
			--	RXDlyReady <= '0';
			--	RXReady <= '1';
			--end if;

			-- based on pktuartx with added driveEn
			if ReqGo = '1' then
				BitRateDDSAccum <= BitRateDDSAccum - BitRateDDSReg;
				if SampleTime = '1' then
					SReqData <= '1' & SReqData(9 downto 1);		-- right shift = LSb first
					Request <= SReqData(0);
					if ReqBitCount /= 0 then
						ReqBitCount <= ReqBitCount -1;
					else
						ReqGo <= '0';
						ReqDrvDly <= ReqDrvDlyReg;
					end if;	
				end if;
			end if;

			if ReqPulseDone = '1' then
				Request <= '1';
				ReqDrvEn <= '0';
			end if;

			if SinglePairMode = '0' then
				if (Busy = '1') and (RXDone = '0') and (FilteredRXData = '1') then
					RXGo <= '1';	-- start bit detection
				end if;
			else
				if (Busy = '1') and (RXDone = '0') and (RXDataD = '1') and (RXDlyReady = '1') then
					RXGo <= '1';	-- start bit detection
					Request <= '0';
					ReqDrvEn <= '1';
					RXReady <= '0';
					RXDlyReady <= '0';
				end if;
			end if;
				
			if RXGo = '1' then 					-- Receive go
				BitRateDDSAccum <= BitRateDDSAccum + BitRateDDSReg;
				if SampleTime = '1' then
					FAbsSReg <= (not RXPipe(1)) & FAbsSReg(75 downto 1) ; -- shiftright
					if BitCount /= 0 then
						BitCount <= BitCount -1;
					else
						RXDone <= '1';					-- minor buglet: we are actually done 1/2 bit 
					end if;								-- time later, but probably not worth fixing
				end if;
			end if;
			
			if (RXDone = '1') and (OldRXDone = '0') then	-- on rxdone becoming true we
				RXGo <= '0';									  	-- stop receiving		
				if SinglePairMode = '1' then
					FAbsLatch <= '1' & FabsSreg(75 downto 1);		-- shift data transfer to fix offset
				else
					FAbsLatch <= FAbsSReg;						  	-- normal transfer data
				end if;
				Busy <= '0';
				DAV <= not CableErr;							-- dont set DAV if theres a cable error
			end if;
			
			OldDDSMSB <= DDSMSB;
			OldRXDone <= RXDone;

			if loadcontrol0 =  '1' then
				--waitCount <= (Others => '0');
				--SinglePairMode <= '0';
				SinglePairMode <= ibus(6);
				EnableSetupLoad <= ibus(7);
				PStartMask <= ibus(8);
				TStartMask <= ibus(9);
				TimerSelect <= ibus(14 downto 12);
				ReqData <= ibus(24 downto 15);
			end if;

			--if EnableSetupLoad = '1' then
				--waitCount <= (Others => '0');
				--SinglePairMode <= '0';
			--end if;

			if loadcontrol1 =  '1' and EnableSetupLoad = '1'then 
				BitRateDDSReg <= ibus(19 downto 0);
				FilterTimeReg <= ibus(31 downto 28);
			end if;

			if loadcontrol2 =  '1' and EnableSetupLoad = '1' then 
				RequestWidthReg <= ibus(23 downto 14);
				BitCountReg <= ibus(30 downto 24);
			end if;

			if readdata0 =  '1' then
				DAV <= '0';
			end if;
      			
			OldTimer <= Timer;
		end if; -- clk
		
		SampleTime <= DDSMSB and (not OldDDSMSB);

		if Timer = '1' and OldTimer = '0' then			-- rising edge of selected timer
			TStart <= '1';
		else
			TStart <= '0';
		end if;
		
		case TimerSelect is
			when "000" => Timer <= timers(0);
			when "001" => Timer <= timers(1);
			when "010" => Timer <= timers(2);
			when "011" => Timer <= timers(3);
			when "100" => Timer <= timers(4);	
			when others => Timer <= Timers(0);
		end case;	

		if lstart = '1' or (TStart = '1' and TStartMask = '1') or (pstart = '1' and PStartMask = '1')then
			Start <= '1';
		else
			Start <= '0';
		end if;		
				
		obus <= (others => 'Z');
      if readdata0 =  '1' then
			obus <= FAbsLatch(31 downto 0);
		end if;
      if readdata1 =  '1' then
			obus <= FAbsLatch(63 downto 32);
		end if;
      if readdata2 =  '1' then
			obus(11 downto 0) <= FAbsLatch(75 downto 64);
			obus(13 downto 12) <= (others =>'0');
			obus(23 downto 14) <= RequestWidthReg;	
			obus(30 downto 24) <= BitCountReg;
			obus(31) <= CableErr; 
		end if;
		if	readcontrol0 = '1' then
			obus(5 downto 0) <= (others =>'0');
			obus(6) <= RequestSinglePairMode;
			obus(7) <= '0';
			obus(8) <= PStartMask;	
			obus(9) <= TStartMask;			
			obus(10) <= RXGo;
			obus(11) <= Busy;
			obus(14 downto 12) <= TimerSelect;
			obus(15) <= DAV;
			obus(24 downto 15) <= ReqData;
			obus(31 downto 25) <= (others =>'0');
		end if;
		if	readcontrol1 = '1' then
			obus(19 downto 0) <= BitRateDDSReg;
			obus(31 downto 28) <= FilterTimeReg;
			obus(27 downto 20) <= (others => '0');
		end if;
		testclk <= DDSMSB;
		requestout <= not Request;
		busyout <= Busy or (not DAV);
		davout <= DAV;
		driveEn <= not ReqDrvEn;
	end process afabsinterface;
	
end Behavioral;
