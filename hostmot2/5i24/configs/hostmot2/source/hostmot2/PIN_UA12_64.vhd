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

package PIN_UA12_64 is
	constant ModuleID : ModuleIDType :=( 
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	x"02",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(UARTTTag,		x"00",	ClockLowTag,	x"0C",	UARTTDataAddr&PadT,			UARTTNumRegs,			x"00",	UARTTMPBitMask),
		(UARTRTag,		x"00",	ClockLowTag,	x"0C",	UARTRDataAddr&PadT,			UARTRNumRegs,			x"00",	UARTRMPBitMask),
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
		IOPortTag & x"00" & UARTTTag & UTDataPin, 	-- I/O 00  
		IOPortTag & x"00" & UARTRTag & URDataPin, 	-- I/O 01  
		IOPortTag & x"01" & UARTTTag & UTDataPin, 	-- I/O 02
		IOPortTag & x"01" & UARTRTag & URDataPin, 	-- I/O 03
		IOPortTag & x"02" & UARTTTag & UTDataPin, 	-- I/O 04
		IOPortTag & x"02" & UARTRTag & URDataPin, 	-- I/O 05
		IOPortTag & x"03" & UARTTTag & UTDataPin, 	-- I/O 06
		IOPortTag & x"03" & UARTRTag & URDataPin, 	-- I/O 07
		IOPortTag & x"04" & UARTTTag & UTDataPin, 	-- I/O 08
		IOPortTag & x"04" & UARTRTag & URDataPin, 	-- I/O 09
		IOPortTag & x"05" & UARTTTag & UTDataPin, 	-- I/O 10
		IOPortTag & x"05" & UARTRTag & URDataPin, 	-- I/O 11
		IOPortTag & x"06" & UARTTTag & UTDataPin, 	-- I/O 12
		IOPortTag & x"06" & UARTRTag & URDataPin, 	-- I/O 13
		IOPortTag & x"07" & UARTTTag & UTDataPin, 	-- I/O 14
		IOPortTag & x"07" & UARTRTag & URDataPin, 	-- I/O 15
		IOPortTag & x"08" & UARTTTag & UTDataPin, 	-- I/O 16
		IOPortTag & x"08" & UARTRTag & URDataPin, 	-- I/O 17
		IOPortTag & x"09" & UARTTTag & UTDataPin, 	-- I/O 18
		IOPortTag & x"09" & UARTRTag & URDataPin, 	-- I/O 19
		IOPortTag & x"0A" & UARTTTag & UTDataPin, 	-- I/O 20
		IOPortTag & x"0A" & UARTRTag & URDataPin, 	-- I/O 21
		IOPortTag & x"0B" & UARTTTag & UTDataPin, 	-- I/O 22
		IOPortTag & x"0B" & UARTRTag & URDataPin, 	-- I/O 23
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 24
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 25
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 26
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 27
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 28
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 29
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 30
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 31
		
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 32 rxen 0,2
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 33 rxen 1,3
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 34 rxen 4,6
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 35 rxen 5,7	
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 36 rxen 8,10 
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 37 rxen 9,11
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 38 rxen 12,14
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 39 rxen 13,15
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 40 rxen 16,18
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 41 rxen 17,19
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 42 rxen 20,22
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 43 rxen 21,23
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 44 
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 45 
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 46 
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 47 
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 48 txen 0,2
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 49 txen 1,3
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 50 txen 4,6
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 51 txen 5,7	
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 52 txen 8,10 
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 53 txen 9,11
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 54 txen 12,14
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 55 txen 13,15
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 56 txen 16,18
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 57 txen 17,19
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 58 txen 20,22
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 59 txen 21,23
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 60
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 61
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 62
		IOPortTag & x"00" & NullTag & x"00",       	-- I/O 63

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
					
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_UA12_64;
