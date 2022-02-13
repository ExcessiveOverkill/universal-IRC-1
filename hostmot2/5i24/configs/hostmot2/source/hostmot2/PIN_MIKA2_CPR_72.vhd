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

package PIN_MIKA2_CPR_72 is
	constant ModuleID : ModuleIDType :=( 
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	x"04",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(QcountTag,		x"02",	ClockLowTag,	x"08",	QcounterAddr&PadT,			QCounterNumRegs,		x"00",	QCounterMPBitMask),
		(SSerialTag,	x"00",	ClockLowTag,	x"01",	SSerialCommandAddr&PadT,	SSerialNumRegs,		x"10",	SSerialMPBitMask),
		(StepGenTag,	x"02",	ClockLowTag,	x"0A",	StepGenRateAddr&PadT,		StepGenNumRegs,		x"00",	StepGenMPBitMask),
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
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000")
		);

		
	constant PinDesc : PinDescType :=(
-- 	Base func  sec unit sec func 	 sec pin					-- 7I47 pinout	
		IOPortTag & x"00" & StepGenTag & StepGenStepPin,	-- I/O 00	TX4
		IOPortTag & x"00" & StepGenTag & StepGenDirPin,		-- I/O 01	TX5
		IOPortTag & x"01" & StepGenTag & StepGenStepPin,	-- I/O 02	TX6	
		IOPortTag & x"01" & StepGenTag & StepGenDirPin,		-- I/O 03	TX7	
		IOPortTag & x"00" & QCountTag & QCountQAPin,			-- I/O 04	RX0	
		IOPortTag & x"02" & QCountTag & QCountQAPin,			-- I/O 05	RX6	
		IOPortTag & x"00" & QCountTag & QCountQBPin,			-- I/O 06	RX1		
		IOPortTag & x"02" & QCountTag & QCountQBPin,			-- I/O 07	RX7	
		IOPortTag & x"00" & QCountTag & QCountIDXPin,		-- I/O 08	RX2	
		IOPortTag & x"02" & QCountTag & QCountIDXPin,		-- I/O 09	RX8
		IOPortTag & x"01" & QCountTag & QCountQAPin,			-- I/O 10	RX3
		IOPortTag & x"03" & QCountTag & QCountQAPin,			-- I/O 11	RX9
		IOPortTag & x"01" & QCountTag & QCountQBPin,			-- I/O 12	RX4	
		IOPortTag & x"03" & QCountTag & QCountQBPin,			-- I/O 13	RX10
		IOPortTag & x"01" & QCountTag & QCountIDXPin,		-- I/O 14	RX5
		IOPortTag & x"03" & QCountTag & QCountIDXPin,		-- I/O 15	RX11
		IOPortTag & x"04" & StepGenTag & StepGenStepPin,	-- I/O 16	TX8
		IOPortTag & x"04" & StepGenTag & StepGenDirPin,		-- I/O 17 	TX9
		IOPortTag & x"05" & StepGenTag & StepGenStepPin,	-- I/O 18 	TX10	
		IOPortTag & x"05" & StepGenTag & StepGenDirPin,		-- I/O 19 	TX11
		IOPortTag & x"02" & StepGenTag & StepGenStepPin,	-- I/O 20	TX0		
		IOPortTag & x"02" & StepGenTag & StepGenDirPin,		-- I/O 21	TX1
		IOPortTag & x"03" & StepGenTag & StepGenStepPin,	-- I/O 22	TX2		
		IOPortTag & x"03" & StepGenTag & StepGenDirPin,		-- I/O 23	TX3
		
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 24
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 25
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 26
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 27
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 28
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 29
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 30
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 31
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 32
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 33
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 34
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 35
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 36
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 37
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 38
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 39
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 40
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 41
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 42
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 43
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 44
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 45
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 46
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 47
		
-- 	Base func  sec unit sec func 	 sec pin					-- 7I47 pinout	
		IOPortTag & x"06" & StepGenTag & StepGenStepPin,	-- I/O 48	TX4	
		IOPortTag & x"06" & StepGenTag & StepGenDirPin,		-- I/O 49   TX5
		IOPortTag & x"07" & StepGenTag & StepGenStepPin,	-- I/O 50   TX6	
		IOPortTag & x"07" & StepGenTag & StepGenDirPin,		-- I/O 51   TX7	
		IOPortTag & x"04" & QCountTag & QCountQAPin,			-- I/O 52   RX0	
		IOPortTag & x"06" & QCountTag & QCountQAPin,			-- I/O 53   RX6	
		IOPortTag & x"04" & QCountTag & QCountQBPin,			-- I/O 54   RX1	
		IOPortTag & x"06" & QCountTag & QCountQBPin,			-- I/O 55   RX7	
		IOPortTag & x"04" & QCountTag & QCountIDXPin,		-- I/O 56   RX2	
		IOPortTag & x"06" & QCountTag & QCountIDXPin,		-- I/O 57   RX8
		IOPortTag & x"05" & QCountTag & QCountQAPin,			-- I/O 58   RX3
		IOPortTag & x"00" & SSerialTag & SSerialRX0Pin, 	-- I/O 59   RX9
		IOPortTag & x"05" & QCountTag & QCountQBPin,			-- I/O 60   RX4	
		IOPortTag & x"00" & SSerialTag & SSerialRX1Pin, 	-- I/O 61   RX10
		IOPortTag & x"05" & QCountTag & QCountIDXPin,		-- I/O 62   RX5
		IOPortTag & x"00" & SSerialTag & SSerialRX2Pin, 	-- I/O 63   RX11
		IOPortTag & x"00" & NullTag & x"00",					-- I/O 64   TX8
		IOPortTag & x"00" & SSerialTag & SSerialTX0Pin, 	-- I/O 65   TX9
		IOPortTag & x"00" & SSerialTag & SSerialTX1Pin, 	-- I/O 66   TX10	
		IOPortTag & x"00" & SSerialTag & SSerialTX2Pin, 	-- I/O 67   TX11
		IOPortTag & x"08" & StepGenTag & StepGenStepPin,	-- I/O 68   TX0	
		IOPortTag & x"08" & StepGenTag & StepGenDirPin,		-- I/O 69   TX1
		IOPortTag & x"09" & StepGenTag & StepGenStepPin,	-- I/O 70   TX2	
		IOPortTag & x"09" & StepGenTag & StepGenDirPin,		-- I/O 71   TX3
		
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);					

end package PIN_MIKA2_CPR_72;
