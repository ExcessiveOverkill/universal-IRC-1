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

package PIN_SVST8_12_2x7I47_72 is
	constant ModuleID : moduleIDType :=( 
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	x"03",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(QcountTag,		x"02",	ClockLowTag,	x"08",	QcounterAddr&PadT,			QCounterNumRegs,		x"00",	QCounterMPBitMask),
		(StepGenTag,	x"02",	ClockLowTag,	x"0C",	StepGenRateAddr&PadT,		StepGenNumRegs,		x"00",	StepGenMPBitMask),
		(LEDTag,			x"00",	ClockLowTag,	x"01",	LEDAddr&PadT,					LEDNumRegs,				x"00",	LEDMPBitMask),
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
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000")
		);
			
	constant PinDesc : PinDescType :=(
-- 	Base func  sec unit sec func 	 sec pin		

		IOPortTag & x"02" & StepGenTag & StepGenStepPin,				-- I/O 0  0 
		IOPortTag & x"02" & StepGenTag & StepGenDirPin,					-- I/O 1  1	
		IOPortTag & x"03" & StepGenTag & StepGenStepPin,				-- I/O 2  2		
		IOPortTag & x"03" & StepGenTag & StepGenDirPin,					-- I/O 3  3		
		IOPortTag & x"00" & QCountTag & QCountQAPin,						-- I/O 4  4		
		IOPortTag & x"02" & QCountTag & QCountQAPin,						-- I/O 5  5		
		IOPortTag & x"00" & QCountTag & QCountQBPin,						-- I/O 6  6			
		IOPortTag & x"02" & QCountTag & QCountQBPin,						-- I/O 7  7		
		IOPortTag & x"00" & QCountTag & QCountIDXPin,					-- I/O 8  8		
		IOPortTag & x"02" & QCountTag & QCountIDXPin,					-- I/O 9  9 
		IOPortTag & x"01" & QCountTag & QCountQAPin,						-- I/O 10  10
		IOPortTag & x"03" & QCountTag & QCountQAPin,						-- I/O 11  11
		IOPortTag & x"01" & QCountTag & QCountQBPin,						-- I/O 12  12
		IOPortTag & x"03" & QCountTag & QCountQBPin,						-- I/O 13  13
		IOPortTag & x"01" & QCountTag & QCountIDXPin,					-- I/O 14  14	
		IOPortTag & x"03" & QCountTag & QCountIDXPin,					-- I/O 15  15
		IOPortTag & x"04" & StepGenTag & StepGenStepPin,				-- I/O 16  16		
		IOPortTag & x"04" & StepGenTag & StepGenDirPin,					-- I/O 17  17
		IOPortTag & x"05" & StepGenTag & StepGenStepPin,				-- I/O 18  18		
		IOPortTag & x"05" & StepGenTag & StepGenDirPin,					-- I/O 19  19
		IOPortTag & x"00" & StepGenTag & StepGenStepPin,				-- I/O 20  20			
		IOPortTag & x"00" & StepGenTag & StepGenDirPin,					-- I/O 21  21
		IOPortTag & x"01" & StepGenTag & StepGenStepPin,				-- I/O 22  22			
		IOPortTag & x"01" & StepGenTag & StepGenDirPin,					-- I/O 23  23
					
		IOPortTag & x"08" & StepGenTag & StepGenStepPin,				-- I/O 24  0 
		IOPortTag & x"08" & StepGenTag & StepGenDirPin,					-- I/O 25  1	
		IOPortTag & x"09" & StepGenTag & StepGenStepPin,				-- I/O 26  2		
		IOPortTag & x"09" & StepGenTag & StepGenDirPin,					-- I/O 27  3		
		IOPortTag & x"04" & QCountTag & QCountQAPin,						-- I/O 28  4		
		IOPortTag & x"06" & QCountTag & QCountQAPin,						-- I/O 29  5		
		IOPortTag & x"04" & QCountTag & QCountQBPin,						-- I/O 30  6			
		IOPortTag & x"06" & QCountTag & QCountQBPin,						-- I/O 31  7		
		IOPortTag & x"04" & QCountTag & QCountIDXPin,					-- I/O 32  8		
		IOPortTag & x"06" & QCountTag & QCountIDXPin,					-- I/O 33  9 
		IOPortTag & x"05" & QCountTag & QCountQAPin,						-- I/O 34  10
		IOPortTag & x"07" & QCountTag & QCountQAPin,						-- I/O 35  11
		IOPortTag & x"05" & QCountTag & QCountQBPin,						-- I/O 36  12
		IOPortTag & x"07" & QCountTag & QCountQBPin,						-- I/O 37  13
		IOPortTag & x"05" & QCountTag & QCountIDXPin,					-- I/O 38  14	
		IOPortTag & x"07" & QCountTag & QCountIDXPin,					-- I/O 39  15
		IOPortTag & x"0A" & StepGenTag & StepGenStepPin,				-- I/O 40  16		
		IOPortTag & x"0A" & StepGenTag & StepGenDirPin,					-- I/O 41  17
		IOPortTag & x"0B" & StepGenTag & StepGenStepPin,				-- I/O 42  18		
		IOPortTag & x"0B" & StepGenTag & StepGenDirPin,					-- I/O 43  19
		IOPortTag & x"06" & StepGenTag & StepGenStepPin,				-- I/O 44  20			
		IOPortTag & x"06" & StepGenTag & StepGenDirPin,					-- I/O 45  21
		IOPortTag & x"07" & StepGenTag & StepGenStepPin,				-- I/O 46  22			
		IOPortTag & x"07" & StepGenTag & StepGenDirPin,					-- I/O 47  23

		IOPortTag & x"00" & NullTag & x"00",					-- I/O 48
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 49
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 50
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 51
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 52
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 53
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 54
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 55
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 56
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 57
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 58
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 59
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 60
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 61
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 62
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 63
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 64
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 65
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 66
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 67
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 68
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 69
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 70
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 71

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);					

end package PIN_SVST8_12_2x7I47_72;
