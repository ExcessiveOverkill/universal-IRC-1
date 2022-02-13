library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- MODIFIED FOR REFPRINTER 3D PRINTER TESTING
-- RLS 2015-01-30

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

package PIN_REFPRINTER_72 is
	constant ModuleID : ModuleIDType :=( 
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	x"03",	PortAddr&PadT,				IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(QcountTag,		x"02",	ClockLowTag,	x"04",	QcounterAddr&PadT,			QCounterNumRegs,		x"00",	QCounterMPBitMask),
		(PWMTag,		x"00",	ClockHighTag,	x"04",	PWMValAddr&PadT,			PWMNumRegs,				x"00",	PWMMPBitMask),
		(StepGenTag,	x"02",	ClockLowTag,	x"06",	StepGenRateAddr&PadT,		StepGenNumRegs,		    x"00",	StepGenMPBitMask),
		(AddrXTag,		x"00",	ClockLowTag,	x"01",	TranslateRAMAddr&PadT,		TranslateNumRegs,		x"00",	TranslateMPBitMask),
		(SPITag,		x"00",	ClockLowTag,    x"06",	SPIDataAddr&PadT,			SPINumRegs,			    x"00",	SPIMPBitMask),
--		(BSPITag,		x"00",	ClockLowTag,    x"02",	BSPIDataAddr&PadT,			BSPINumRegs,			x"00",	BSPIMPBitMask),
		(LEDTag,		x"00",	ClockLowTag,	x"01",	LEDAddr&PadT,				LEDNumRegs,				x"00",	LEDMPBitMask),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000")
		);
	
	constant PinDesc : PinDescType :=(
-- 	Base func  sec unit sec func 	 sec pin		

		IOPortTag & x"03" & StepGenTag & StepGenStepPin,-- I/O 00 TB1-1
		IOPortTag & x"00" & StepGenTag & StepGenStepPin,-- I/O 01 TB2-1
		IOPortTag & x"03" & StepGenTag & StepGenDirPin, -- I/O 02 TB1-3
		IOPortTag & x"00" & StepGenTag & StepGenDirPin, -- I/O 03 TB2-3
        IOPortTag & x"00" & NullTag & x"00",            -- I/O 04 TB1-5
        IOPortTag & x"00" & NullTag & x"00",            -- I/O 05 TB2-5
		IOPortTag & x"04" & StepGenTag & StepGenStepPin,-- I/O 06 TB1-7
		IOPortTag & x"01" & StepGenTag & StepGenStepPin,-- I/O 07 TB2-7
		IOPortTag & x"04" & StepGenTag & StepGenDirPin, -- I/O 08 TB1-9
		IOPortTag & x"01" & StepGenTag & StepGenDirPin, -- I/O 09 TB2-9
        IOPortTag & x"00" & NullTag & x"00",            -- I/O 10 TB1-11
        IOPortTag & x"00" & NullTag & x"00",            -- I/O 11 TB2-11
		IOPortTag & x"05" & StepGenTag & StepGenStepPin,-- I/O 12 TB1-13
		IOPortTag & x"02" & StepGenTag & StepGenStepPin,-- I/O 13 TB2-13
		IOPortTag & x"05" & StepGenTag & StepGenDirPin, -- I/O 14 TB1-15
		IOPortTag & x"02" & StepGenTag & StepGenDirPin, -- I/O 15 TB2-15
        IOPortTag & x"00" & NullTag & x"00",            -- I/O 16 TB1-17
        IOPortTag & x"00" & NullTag & x"00",            -- I/O 17 TB2-17
		IOPortTag & x"06" & StepGenTag & StepGenStepPin,-- I/O 18 TB1-19
		IOPortTag & x"03" & StepGenTag & StepGenStepPin,-- I/O 19 TB2-19
		IOPortTag & x"06" & StepGenTag & StepGenDirPin, -- I/O 20 TB1-21
		IOPortTag & x"03" & StepGenTag & StepGenDirPin, -- I/O 21 TB2-21
        IOPortTag & x"00" & NullTag & x"00",            -- I/O 22 TB1-23
        IOPortTag & x"00" & NullTag & x"00",            -- I/O 23 TB2-23

--		IOPortTag & x"00" & StepGenTag & x"81",	  -- I/O 00	
--		IOPortTag & x"00" & StepGenTag & x"82",   -- I/O 01
--		IOPortTag & x"00" & StepGenTag & x"83",   -- I/O 02
--		IOPortTag & x"00" & StepGenTag & x"84",   -- I/O 03
--		IOPortTag & x"01" & StepGenTag & x"81",   -- I/O 04
--		IOPortTag & x"01" & StepGenTag & x"82",   -- I/O 05
--		IOPortTag & x"01" & StepGenTag & x"83",   -- I/O 06
--		IOPortTag & x"01" & StepGenTag & x"84",   -- I/O 07
--		IOPortTag & x"02" & StepGenTag & x"81",   -- I/O 08
--		IOPortTag & x"02" & StepGenTag & x"82",   -- I/O 09
--		IOPortTag & x"02" & StepGenTag & x"83",   -- I/O 10
--		IOPortTag & x"02" & StepGenTag & x"84",   -- I/O 11
--		IOPortTag & x"03" & StepGenTag & x"81",   -- I/O 12
--		IOPortTag & x"03" & StepGenTag & x"82",   -- I/O 13
--		IOPortTag & x"03" & StepGenTag & x"83",   -- I/O 14
--		IOPortTag & x"03" & StepGenTag & x"84",   -- I/O 15
--		IOPortTag & x"04" & StepGenTag & x"81",   -- I/O 16
--		IOPortTag & x"04" & StepGenTag & x"82",   -- I/O 17
--		IOPortTag & x"04" & StepGenTag & x"83",   -- I/O 18
--		IOPortTag & x"04" & StepGenTag & x"84",   -- I/O 19
--		IOPortTag & x"05" & StepGenTag & x"81",   -- I/O 20
--		IOPortTag & x"05" & StepGenTag & x"82",   -- I/O 21
--		IOPortTag & x"05" & StepGenTag & x"83",   -- I/O 22
--		IOPortTag & x"05" & StepGenTag & x"84",   -- I/O 23

        IOPortTag & x"00" & NullTag & x"00",        -- I/O 24
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 25
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 26
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 27
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 28
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 29
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 30
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 31
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 32
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 33
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 34
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 35
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 36
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 37
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 38
        IOPortTag & x"00" & NullTag & x"00",        -- I/O 39
        IOPortTag & x"00" & SPITag & SPIFramePin,   -- I/O 40
        IOPortTag & x"00" & SPITag & SPIClkPin,     -- I/O 41
        IOPortTag & x"00" & SPITag & SPIInPin,      -- I/O 42
        IOPortTag & x"00" & SPITag & SPIOutPin,     -- I/O 43
        IOPortTag & x"01" & SPITag & SPIFramePin,   -- I/O 44
        IOPortTag & x"01" & SPITag & SPIClkPin,     -- I/O 45
        IOPortTag & x"01" & SPITag & SPIInPin,      -- I/O 46
        IOPortTag & x"01" & SPITag & SPIOutPin,     -- I/O 47

        IOPortTag & x"01" & QCountTag & QCountQBPin, -- I/O 48
        IOPortTag & x"01" & QCountTag & QCountQAPin, -- I/O 49
        IOPortTag & x"00" & QCountTag & QCountQBPin, -- I/O 50
        IOPortTag & x"00" & QCountTag & QCountQAPin, -- I/O 51
        IOPortTag & x"01" & QCountTag & QCountIdxPin,-- I/O 52
        IOPortTag & x"00" & QCountTag & QCountIdxPin,-- I/O 53
        IOPortTag & x"01" & PWMTag & PWMAOutPin,     -- I/O 54
        IOPortTag & x"00" & PWMTag & PWMAOutPin,     -- I/O 55
        IOPortTag & x"01" & PWMTag & PWMBDirPin,     -- I/O 56
        IOPortTag & x"00" & PWMTag & PWMBDirPin,     -- I/O 57
        IOPortTag & x"01" & PWMTag & PWMCEnaPin,     -- I/O 58
        IOPortTag & x"00" & PWMTag & PWMCEnaPin,     -- I/O 59
        IOPortTag & x"03" & QCountTag & QCountQBPin, -- I/O 60
        IOPortTag & x"03" & QCountTag & QCountQAPin, -- I/O 61
        IOPortTag & x"02" & QCountTag & QCountQBPin, -- I/O 62
        IOPortTag & x"02" & QCountTag & QCountQAPin, -- I/O 63
        IOPortTag & x"03" & QCountTag & QCountIdxPin,-- I/O 64
        IOPortTag & x"02" & QCountTag & QCountIdxPin,-- I/O 65
        IOPortTag & x"03" & PWMTag & PWMAOutPin,     -- I/O 66
        IOPortTag & x"02" & PWMTag & PWMAOutPin,     -- I/O 67
        IOPortTag & x"03" & PWMTag & PWMBDirPin,     -- I/O 68
        IOPortTag & x"02" & PWMTag & PWMBDirPin,     -- I/O 69
        IOPortTag & x"03" & PWMTag & PWMCEnaPin,     -- I/O 70
        IOPortTag & x"02" & PWMTag & PWMCEnaPin,     -- I/O 71

	
--		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
--		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		
--		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_REFPRINTER_72;
