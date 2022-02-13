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

package PIN_SV24_144 is
	constant ModuleID : ModuleIDType :=( 
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	x"06",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(QcountTag,		x"02",	ClockLowTag,	x"18",	QcounterAddr&PadT,			QCounterNumRegs,		x"00",	QCounterMPBitMask),
		(PWMTag,			x"00",	ClockHighTag,	x"18",	PWMValAddr&PadT,				PWMNumRegs,				x"00",	PWMMPBitMask),
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
		IOPortTag & x"01" & QCountTag & x"02",		-- I/O 00
		IOPortTag & x"01" & QCountTag & x"01",    -- I/O 01
		IOPortTag & x"00" & QCountTag & x"02",    -- I/O 02
		IOPortTag & x"00" & QCountTag & x"01",    -- I/O 03
		IOPortTag & x"01" & QCountTag & x"03",    -- I/O 04
		IOPortTag & x"00" & QCountTag & x"03",    -- I/O 05
		IOPortTag & x"01" & PWMTag & x"81",       -- I/O 06
		IOPortTag & x"00" & PWMTag & x"81",       -- I/O 07
		IOPortTag & x"01" & PWMTag & x"82",       -- I/O 08
		IOPortTag & x"00" & PWMTag & x"82",       -- I/O 09
		IOPortTag & x"01" & PWMTag & x"83",       -- I/O 10
		IOPortTag & x"00" & PWMTag & x"83",       -- I/O 11
		IOPortTag & x"03" & QCountTag & x"02",    -- I/O 12
		IOPortTag & x"03" & QCountTag & x"01",    -- I/O 13
		IOPortTag & x"02" & QCountTag & x"02",    -- I/O 14
		IOPortTag & x"02" & QCountTag & x"01",    -- I/O 15
		IOPortTag & x"03" & QCountTag & x"03",    -- I/O 16
		IOPortTag & x"02" & QCountTag & x"03",    -- I/O 17
		IOPortTag & x"03" & PWMTag & x"81",       -- I/O 18
		IOPortTag & x"02" & PWMTag & x"81",       -- I/O 19
		IOPortTag & x"03" & PWMTag & x"82",       -- I/O 20
		IOPortTag & x"02" & PWMTag & x"82",       -- I/O 21
		IOPortTag & x"03" & PWMTag & x"83",       -- I/O 22
		IOPortTag & x"02" & PWMTag & x"83",       -- I/O 23
					
		IOPortTag & x"05" & QCountTag & x"02",		-- I/O 24
		IOPortTag & x"05" & QCountTag & x"01",    -- I/O 25
		IOPortTag & x"04" & QCountTag & x"02",    -- I/O 26
		IOPortTag & x"04" & QCountTag & x"01",    -- I/O 27
		IOPortTag & x"05" & QCountTag & x"03",    -- I/O 28
		IOPortTag & x"04" & QCountTag & x"03",    -- I/O 29
		IOPortTag & x"05" & PWMTag & x"81",       -- I/O 30
		IOPortTag & x"04" & PWMTag & x"81",       -- I/O 31
		IOPortTag & x"05" & PWMTag & x"82",       -- I/O 32
		IOPortTag & x"04" & PWMTag & x"82",       -- I/O 33
		IOPortTag & x"05" & PWMTag & x"83",       -- I/O 34
		IOPortTag & x"04" & PWMTag & x"83",       -- I/O 35
		IOPortTag & x"07" & QCountTag & x"02",    -- I/O 36
		IOPortTag & x"07" & QCountTag & x"01",    -- I/O 37
		IOPortTag & x"06" & QCountTag & x"02",    -- I/O 38
		IOPortTag & x"06" & QCountTag & x"01",    -- I/O 39
		IOPortTag & x"07" & QCountTag & x"03",    -- I/O 40
		IOPortTag & x"06" & QCountTag & x"03",    -- I/O 41
		IOPortTag & x"07" & PWMTag & x"81",       -- I/O 42
		IOPortTag & x"06" & PWMTag & x"81",       -- I/O 43
		IOPortTag & x"07" & PWMTag & x"82",       -- I/O 44
		IOPortTag & x"06" & PWMTag & x"82",       -- I/O 45
		IOPortTag & x"07" & PWMTag & x"83",       -- I/O 46
		IOPortTag & x"06" & PWMTag & x"83",       -- I/O 47
					
		IOPortTag & x"09" & QCountTag & x"02",		-- I/O 48
		IOPortTag & x"09" & QCountTag & x"01",    -- I/O 49
		IOPortTag & x"08" & QCountTag & x"02",    -- I/O 50
		IOPortTag & x"08" & QCountTag & x"01",    -- I/O 51
		IOPortTag & x"09" & QCountTag & x"03",    -- I/O 52
		IOPortTag & x"08" & QCountTag & x"03",    -- I/O 53
		IOPortTag & x"09" & PWMTag & x"81",       -- I/O 54
		IOPortTag & x"08" & PWMTag & x"81",       -- I/O 55
		IOPortTag & x"09" & PWMTag & x"82",       -- I/O 56
		IOPortTag & x"08" & PWMTag & x"82",       -- I/O 57
		IOPortTag & x"09" & PWMTag & x"83",       -- I/O 58
		IOPortTag & x"08" & PWMTag & x"83",       -- I/O 59
		IOPortTag & x"0B" & QCountTag & x"02",    -- I/O 60
		IOPortTag & x"0B" & QCountTag & x"01",    -- I/O 61
		IOPortTag & x"0A" & QCountTag & x"02",    -- I/O 62
		IOPortTag & x"0A" & QCountTag & x"01",    -- I/O 63
		IOPortTag & x"0B" & QCountTag & x"03",    -- I/O 64
		IOPortTag & x"0A" & QCountTag & x"03",    -- I/O 65
		IOPortTag & x"0B" & PWMTag & x"81",       -- I/O 66
		IOPortTag & x"0A" & PWMTag & x"81",       -- I/O 67
		IOPortTag & x"0B" & PWMTag & x"82",       -- I/O 68
		IOPortTag & x"0A" & PWMTag & x"82",       -- I/O 69
		IOPortTag & x"0B" & PWMTag & x"83",       -- I/O 70
		IOPortTag & x"0A" & PWMTag & x"83",       -- I/O 71

		IOPortTag & x"0D" & QCountTag & x"02",		-- I/O 72
		IOPortTag & x"0D" & QCountTag & x"01",		-- I/O 73
		IOPortTag & x"0C" & QCountTag & x"02",		-- I/O 74
		IOPortTag & x"0C" & QCountTag & x"01",    -- I/O 75
		IOPortTag & x"0D" & QCountTag & x"03",    -- I/O 76
		IOPortTag & x"0C" & QCountTag & x"03",    -- I/O 77
		IOPortTag & x"0D" & PWMTag & x"81",       -- I/O 78
		IOPortTag & x"0C" & PWMTag & x"81",       -- I/O 79
		IOPortTag & x"0D" & PWMTag & x"82",       -- I/O 80
		IOPortTag & x"0C" & PWMTag & x"82",       -- I/O 81
		IOPortTag & x"0D" & PWMTag & x"83",       -- I/O 82
		IOPortTag & x"0C" & PWMTag & x"83",       -- I/O 83
		IOPortTag & x"0F" & QCountTag & x"02",    -- I/O 84
		IOPortTag & x"0F" & QCountTag & x"01",    -- I/O 85
		IOPortTag & x"0E" & QCountTag & x"02",    -- I/O 86
		IOPortTag & x"0E" & QCountTag & x"01",    -- I/O 87
		IOPortTag & x"0F" & QCountTag & x"03",    -- I/O 88
		IOPortTag & x"0E" & QCountTag & x"03",    -- I/O 89
		IOPortTag & x"0F" & PWMTag & x"81",       -- I/O 90
		IOPortTag & x"0E" & PWMTag & x"81",       -- I/O 91
		IOPortTag & x"0F" & PWMTag & x"82",       -- I/O 92
		IOPortTag & x"0E" & PWMTag & x"82",       -- I/O 93
		IOPortTag & x"0F" & PWMTag & x"83",       -- I/O 94
		IOPortTag & x"0E" & PWMTag & x"83",       -- I/O 95

		IOPortTag & x"11" & QCountTag & x"02",		-- I/O 96
		IOPortTag & x"11" & QCountTag & x"01",		-- I/O 97
		IOPortTag & x"10" & QCountTag & x"02",		-- I/O 98
		IOPortTag & x"10" & QCountTag & x"01",    -- I/O 99
		IOPortTag & x"11" & QCountTag & x"03",    -- I/O 100
		IOPortTag & x"10" & QCountTag & x"03",    -- I/O 101
		IOPortTag & x"11" & PWMTag & x"81",       -- I/O 102
		IOPortTag & x"10" & PWMTag & x"81",       -- I/O 103
		IOPortTag & x"11" & PWMTag & x"82",       -- I/O 104
		IOPortTag & x"10" & PWMTag & x"82",       -- I/O 105
		IOPortTag & x"11" & PWMTag & x"83",       -- I/O 106
		IOPortTag & x"10" & PWMTag & x"83",       -- I/O 107
		IOPortTag & x"13" & QCountTag & x"02",    -- I/O 108
		IOPortTag & x"13" & QCountTag & x"01",    -- I/O 109
		IOPortTag & x"12" & QCountTag & x"02",    -- I/O 110
		IOPortTag & x"12" & QCountTag & x"01",    -- I/O 111
		IOPortTag & x"13" & QCountTag & x"03",    -- I/O 112
		IOPortTag & x"12" & QCountTag & x"03",    -- I/O 113
		IOPortTag & x"13" & PWMTag & x"81",       -- I/O 114
		IOPortTag & x"12" & PWMTag & x"81",       -- I/O 115
		IOPortTag & x"13" & PWMTag & x"82",       -- I/O 116
		IOPortTag & x"12" & PWMTag & x"82",       -- I/O 117
		IOPortTag & x"13" & PWMTag & x"83",       -- I/O 118
		IOPortTag & x"12" & PWMTag & x"83",       -- I/O 119

		IOPortTag & x"15" & QCountTag & x"02",		-- I/O 120
		IOPortTag & x"15" & QCountTag & x"01",		-- I/O 121
		IOPortTag & x"14" & QCountTag & x"02",		-- I/O 122
		IOPortTag & x"14" & QCountTag & x"01",    -- I/O 123
		IOPortTag & x"15" & QCountTag & x"03",    -- I/O 124
		IOPortTag & x"14" & QCountTag & x"03",    -- I/O 125
		IOPortTag & x"15" & PWMTag & x"81",       -- I/O 126
		IOPortTag & x"14" & PWMTag & x"81",       -- I/O 127
		IOPortTag & x"15" & PWMTag & x"82",       -- I/O 128
		IOPortTag & x"14" & PWMTag & x"82",       -- I/O 129
		IOPortTag & x"15" & PWMTag & x"83",       -- I/O 130
		IOPortTag & x"14" & PWMTag & x"83",       -- I/O 131
		IOPortTag & x"17" & QCountTag & x"02",    -- I/O 132
		IOPortTag & x"17" & QCountTag & x"01",    -- I/O 133
		IOPortTag & x"16" & QCountTag & x"02",    -- I/O 134
		IOPortTag & x"16" & QCountTag & x"01",    -- I/O 135
		IOPortTag & x"17" & QCountTag & x"03",    -- I/O 136
		IOPortTag & x"16" & QCountTag & x"03",    -- I/O 137
		IOPortTag & x"17" & PWMTag & x"81",       -- I/O 138
		IOPortTag & x"16" & PWMTag & x"81",       -- I/O 139
		IOPortTag & x"17" & PWMTag & x"82",       -- I/O 140
		IOPortTag & x"16" & PWMTag & x"82",       -- I/O 141
		IOPortTag & x"17" & PWMTag & x"83",       -- I/O 142
		IOPortTag & x"16" & PWMTag & x"83");      -- I/O 143

end package PIN_SV24_144;
