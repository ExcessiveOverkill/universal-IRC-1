library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
--   * Redistributions of source code must retain the above copyright
--     notice, this list of conditions and the following disclaimer.
-- 
--   * Redistributions in binary form must reproduce the above
--     copyright notice, this list of conditions and the following
--     disclaimer in the documentation and/or other materials
--     provided with the distribution.
-- 
--   * Neither the name of Mesa Electronics nor the names of its
--     contributors may be used to endorse or promote products
--     derived from this software without specific prior written
--     permission.
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

use work.IDROMConst.all;

package PIN_SVST10_6_7I49_7I33_7I47_96 is 
	constant ModuleID : ModuleIDType :=( 
		(WatchDogTag,			x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,				x"00",	ClockLowTag,	x"04",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
      (ResModTag,          x"00",	ClockLowTag,    x"01",  ResModCommandAddr&PadT,                    ResModNumRegs,                  x"00",  ResModMPBitMask),
      (PWMTag,             x"00",	ClockHighTag,   x"0A",  PWMValAddr&PadT,                                PWMNumRegs,                             x"00",  PWMMPBitMask),
		(QcountTag,				x"02",	ClockLowTag,	x"08",	QcounterAddr&PadT,			QcounterNumRegs,		x"00",	QCounterMPBitMask),
		(StepGentag,			x"02",	ClockLowTag,	x"06",	StepGenRateAddr&PadT,		StepGenNumRegs,		x"00",	StepgenMPBitMask),
		(LEDTag,					x"00",	ClockLowTag,	x"01",	LEDAddr&PadT,					LEDNumRegs,				x"00",	LEDMPBitMask),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000")
		);
			
	constant PinDesc : PinDescType :=(
-- 	Base func  sec unit sec func 	 		 sec pin		
		IOPortTag & x"00" & PWMTag & PWMCEnaPin,       					-- I/O 00
		IOPortTag & x"00" & ResModTag & ResModPwrEnPin,					-- I/O 01
		IOPortTag & x"00" & ResModTag & ResModSPIDI0Pin,				-- I/O 02	
		IOPortTag & x"00" & ResModTag & ResModSPIDI1Pin,				-- I/O 03		
		IOPortTag & x"00" & ResModTag & ResModChan2Pin,					-- I/O 04		
		IOPortTag & x"00" & ResModTag & ResModChan1Pin,					-- I/O 05		
		IOPortTag & x"00" & ResModTag & ResModChan0Pin,					-- I/O 06		
		IOPortTag & x"00" & ResModTag & ResModSPIClkPin,				-- I/O 07			
		IOPortTag & x"00" & ResModTag & ResModSPICSPin,					-- I/O 08		
		IOPortTag & x"00" & ResModTag & ResModPDMMPin,					-- I/O 09		
		IOPortTag & x"00" & ResModTag & ResModPDMPPin,					-- I/O 10
		IOPortTag & x"04" & PWMTag & PWMAOutPin,            			-- I/O 11
		IOPortTag & x"04" & PWMTag & PWMBDirPin,            			-- I/O 12
		IOPortTag & x"05" & PWMTag & PWMAOutPin,            			-- I/O 13
		IOPortTag & x"05" & PWMTag & PWMBDirPin,            			-- I/O 14
		IOPortTag & x"06" & PWMTag & PWMAOutPin,            			-- I/O 15
		IOPortTag & x"06" & PWMTag & PWMBDirPin,            			-- I/O 16
		IOPortTag & x"07" & PWMTag & PWMAOutPin,            			-- I/O 17
		IOPortTag & x"07" & PWMTag & PWMBDirPin,            			-- I/O 18
		IOPortTag & x"08" & PWMTag & PWMAOutPin,            			-- I/O 19
		IOPortTag & x"08" & PWMTag & PWMBDirPin,            			-- I/O 20
		IOPortTag & x"09" & PWMTag & PWMAOutPin,            			-- I/O 21
		IOPortTag & x"09" & PWMTag & PWMBDirPin,            			-- I/O 22
		IOPortTag & x"00" & PWMTag & PWMCEnaPin,        				-- I/O 23
					                                   
		IOPortTag & x"01" & QCountTag & x"02",								-- I/O 24 0 
		IOPortTag & x"01" & QCountTag & x"01",    						-- I/O 25 1	
		IOPortTag & x"00" & QCountTag & x"02",    						-- I/O 26 2
		IOPortTag & x"00" & QCountTag & x"01",    						-- I/O 27 3	
		IOPortTag & x"01" & QCountTag & x"03",    						-- I/O 28 4 
		IOPortTag & x"00" & QCountTag & x"03",    						-- I/O 29 5 
		IOPortTag & x"01" & PWMTag & x"81",       						-- I/O 30 6
		IOPortTag & x"00" & PWMTag & x"81",       						-- I/O 31 7
		IOPortTag & x"01" & PWMTag & x"82",       						-- I/O 32 8
		IOPortTag & x"00" & PWMTag & x"82",       						-- I/O 33 9 
		IOPortTag & x"01" & PWMTag & x"83",       						-- I/O 34 10
		IOPortTag & x"00" & PWMTag & x"83",       						-- I/O 35 11
		IOPortTag & x"03" & QCountTag & x"02",    						-- I/O 36 12
		IOPortTag & x"03" & QCountTag & x"01",    						-- I/O 37 13	
		IOPortTag & x"02" & QCountTag & x"02",    						-- I/O 38 14	
		IOPortTag & x"02" & QCountTag & x"01",    						-- I/O 39 15	
		IOPortTag & x"03" & QCountTag & x"03",    						-- I/O 40 16 
		IOPortTag & x"02" & QCountTag & x"03",    						-- I/O 41 17 
		IOPortTag & x"03" & PWMTag & x"81",       						-- I/O 42 18
		IOPortTag & x"02" & PWMTag & x"81",       						-- I/O 43 19
		IOPortTag & x"03" & PWMTag & x"82",       						-- I/O 44 20
		IOPortTag & x"02" & PWMTag & x"82",       						-- I/O 45 21
		IOPortTag & x"03" & PWMTag & x"83",       						-- I/O 46 22
		IOPortTag & x"02" & PWMTag & x"83",       						-- I/O 47 23	
																					
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 48  0 
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 49  1	
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 50  2		
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 51  3		
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 52  4		
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 53  5		
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 54  6			
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 55  7		
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 56  8		
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 57  9 
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 58  10
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 59  11
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 60  12
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 61  13
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 62  14	
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 63  15
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 64  16		
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 65  17
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 66  18		
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 67  19
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 68  20			
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 69  21
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 70  22			
		IOPortTag & x"00" & NullTag & x"00",								-- I/O 71  23

		IOPortTag & x"02" & StepGenTag & StepGenStepPin,				-- I/O 72  0 
		IOPortTag & x"02" & StepGenTag & StepGenDirPin,					-- I/O 73  1	
		IOPortTag & x"03" & StepGenTag & StepGenStepPin,				-- I/O 74  2		
		IOPortTag & x"03" & StepGenTag & StepGenDirPin,					-- I/O 75  3		
		IOPortTag & x"04" & QCountTag & QCountQAPin,						-- I/O 76  4		
		IOPortTag & x"06" & QCountTag & QCountQAPin,						-- I/O 77  5		
		IOPortTag & x"04" & QCountTag & QCountQBPin,						-- I/O 78  6			
		IOPortTag & x"06" & QCountTag & QCountQBPin,						-- I/O 79  7		
		IOPortTag & x"04" & QCountTag & QCountIDXPin,					-- I/O 80  8		
		IOPortTag & x"06" & QCountTag & QCountIDXPin,					-- I/O 81  9 
		IOPortTag & x"05" & QCountTag & QCountQAPin,						-- I/O 82  10
		IOPortTag & x"07" & QCountTag & QCountQAPin,						-- I/O 83  11
		IOPortTag & x"05" & QCountTag & QCountQBPin,						-- I/O 84  12
		IOPortTag & x"07" & QCountTag & QCountQBPin,						-- I/O 85  13
		IOPortTag & x"05" & QCountTag & QCountIDXPin,					-- I/O 86  14	
		IOPortTag & x"07" & QCountTag & QCountIDXPin,					-- I/O 87  15
		IOPortTag & x"04" & StepGenTag & StepGenStepPin,				-- I/O 88  16		
		IOPortTag & x"04" & StepGenTag & StepGenDirPin,					-- I/O 89  17
		IOPortTag & x"05" & StepGenTag & StepGenStepPin,				-- I/O 90  18		
		IOPortTag & x"05" & StepGenTag & StepGenDirPin,					-- I/O 91  19
		IOPortTag & x"00" & StepGenTag & StepGenStepPin,				-- I/O 92  20			
		IOPortTag & x"00" & StepGenTag & StepGenDirPin,					-- I/O 93  21
		IOPortTag & x"01" & StepGenTag & StepGenStepPin,				-- I/O 94  22			
		IOPortTag & x"01" & StepGenTag & StepGenDirPin,					-- I/O 95  23

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_SVST10_6_7I49_7I33_7I47_96;
