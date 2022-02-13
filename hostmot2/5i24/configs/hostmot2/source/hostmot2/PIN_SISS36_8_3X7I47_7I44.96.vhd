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

package PIN_SISS36_8_3X7I47_7I44_96 is
	constant ModuleID : ModuleIDType :=( 
		(WatchDogTag,			x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,				x"00",	ClockLowTag,	x"04",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(SSerialTag,			x"00",	ClockLowTag,	x"01",	SSerialCommandAddr&PadT,	SSerialNumRegs,		x"10",	SSerialMPBitMask),
		(SSSITag,				x"00",	ClockLowTag,	x"24",	SSSIDataAddr&PadT,			SSSINumRegs,			x"00",	SSSIMPBitMask),
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
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000")
		);
			
	constant PinDesc : PinDescType :=(
-- 	Base func  sec unit sec func 	 		 sec pin										  7i47 PIN	
		IOPortTag & x"04" & SSSITag & SSSIClkPin,      					-- I/O 00  0  TX4 
		IOPortTag & x"05" & SSSITag & SSSIClkPin,      					-- I/O 01  1  TX5 
		IOPortTag & x"06" & SSSITag & SSSIClkPin,      					-- I/O 02  2  TX6	 
		IOPortTag & x"07" & SSSITag & SSSIClkPin,      					-- I/O 03  3  TX7		
		IOPortTag & x"00" & SSSITag & SSSIDataPin,      				-- I/O 04  4  RX0 		
		IOPortTag & x"06" & SSSITag & SSSIDataPin,      				-- I/O 05  5  RX6		
		IOPortTag & x"01" & SSSITag & SSSIDataPin,      				-- I/O 06  6  RX1		
		IOPortTag & x"07" & SSSITag & SSSIDataPin,      				-- I/O 07  7  RX7			
		IOPortTag & x"02" & SSSITag & SSSIDataPin,     					-- I/O 08  8  RX2		
		IOPortTag & x"08" & SSSITag & SSSIDataPin,     					-- I/O 09  9  RX8		
		IOPortTag & x"03" & SSSITag & SSSIDataPin,     					-- I/O 10  10 RX3 
		IOPortTag & x"09" & SSSITag & SSSIDataPin,      				-- I/O 11  11 RX9 
		IOPortTag & x"04" & SSSITag & SSSIDataPin,      				-- I/O 12  12 RX4 
		IOPortTag & x"0A" & SSSITag & SSSIDataPin,      				-- I/O 13  13 RX10
		IOPortTag & x"05" & SSSITag & SSSIDataPin,     					-- I/O 14  14 RX5 
		IOPortTag & x"0B" & SSSITag & SSSIDataPin,     					-- I/O 15  15 RX11
		IOPortTag & x"08" & SSSITag & SSSIClkPin,      					-- I/O 16  16 TX8 
		IOPortTag & x"09" & SSSITag & SSSIClkPin,      					-- I/O 17  17 TX9 
		IOPortTag & x"0A" & SSSITag & SSSIClkPin,      					-- I/O 18  18 TX10
		IOPortTag & x"0B" & SSSITag & SSSIClkPin,      					-- I/O 19  19 TX11
		IOPortTag & x"00" & SSSITag & SSSIClkPin,      					-- I/O 20  20 TX0 
		IOPortTag & x"01" & SSSITag & SSSIClkPin,      					-- I/O 21  21 TX1 
		IOPortTag & x"02" & SSSITag & SSSIClkPin,      					-- I/O 22  22 TX2 
		IOPortTag & x"03" & SSSITag & SSSIClkPin,      					-- I/O 23  23 TX3 
					                                   
		IOPortTag & x"10" & SSSITag & SSSIClkPin,      					-- I/O 24  0  TX4 
		IOPortTag & x"11" & SSSITag & SSSIClkPin,      					-- I/O 25  1  TX5 
		IOPortTag & x"12" & SSSITag & SSSIClkPin,      					-- I/O 26  2  TX6	
		IOPortTag & x"13" & SSSITag & SSSIClkPin,      					-- I/O 27  3  TX7	
		IOPortTag & x"0C" & SSSITag & SSSIDataPin,      				-- I/O 28  4  RX0 
		IOPortTag & x"12" & SSSITag & SSSIDataPin,      				-- I/O 29  5  RX6	
		IOPortTag & x"0D" & SSSITag & SSSIDataPin,      				-- I/O 30  6  RX1	
		IOPortTag & x"13" & SSSITag & SSSIDataPin,      				-- I/O 31  7  RX7	
		IOPortTag & x"0E" & SSSITag & SSSIDataPin,      				-- I/O 32  8  RX2	
		IOPortTag & x"14" & SSSITag & SSSIDataPin,     					-- I/O 33  9  RX8	
		IOPortTag & x"0F" & SSSITag & SSSIDataPin,     					-- I/O 34  10 RX3 
		IOPortTag & x"15" & SSSITag & SSSIDataPin,     					-- I/O 35  11 RX9 
		IOPortTag & x"10" & SSSITag & SSSIDataPin,      				-- I/O 36  12 RX4 
		IOPortTag & x"16" & SSSITag & SSSIDataPin,      				-- I/O 37  13 RX10
		IOPortTag & x"11" & SSSITag & SSSIDataPin,      				-- I/O 38  14 RX5 
		IOPortTag & x"17" & SSSITag & SSSIDataPin,      				-- I/O 39  15 RX11
		IOPortTag & x"14" & SSSITag & SSSIClkPin,      					-- I/O 40  16 TX8 
		IOPortTag & x"15" & SSSITag & SSSIClkPin,      					-- I/O 41  17 TX9 
		IOPortTag & x"16" & SSSITag & SSSIClkPin,      					-- I/O 42  18 TX10
		IOPortTag & x"17" & SSSITag & SSSIClkPin,      					-- I/O 43  19 TX11
		IOPortTag & x"0C" & SSSITag & SSSIClkPin,      					-- I/O 44  20 TX0 
		IOPortTag & x"0D" & SSSITag & SSSIClkPin,      					-- I/O 45  21 TX1 
		IOPortTag & x"0E" & SSSITag & SSSIClkPin,      					-- I/O 46  22 TX2 
		IOPortTag & x"0F" & SSSITag & SSSIClkPin,      					-- I/O 47  23 TX3 
																					
		IOPortTag & x"1C" & SSSITag & SSSIClkPin,      					-- I/O 48  0  TX4 
		IOPortTag & x"1D" & SSSITag & SSSIClkPin,      					-- I/O 49  1  TX5 
		IOPortTag & x"1E" & SSSITag & SSSIClkPin,      					-- I/O 50  2  TX6		
		IOPortTag & x"1F" & SSSITag & SSSIClkPin,      					-- I/O 51  3  TX7		
		IOPortTag & x"18" & SSSITag & SSSIDataPin,      				-- I/O 52  4  RX0 	
		IOPortTag & x"1E" & SSSITag & SSSIDataPin,      				-- I/O 53  5  RX6		
		IOPortTag & x"19" & SSSITag & SSSIDataPin,      				-- I/O 54  6  RX1			
		IOPortTag & x"1F" & SSSITag & SSSIDataPin,      				-- I/O 55  7  RX7		
		IOPortTag & x"1A" & SSSITag & SSSIDataPin,      				-- I/O 56  8  RX2		
		IOPortTag & x"20" & SSSITag & SSSIDataPin,      				-- I/O 57  9  RX8	
		IOPortTag & x"1B" & SSSITag & SSSIDataPin,      				-- I/O 58  10 RX3 
		IOPortTag & x"21" & SSSITag & SSSIDataPin,      				-- I/O 59  11 RX9 
		IOPortTag & x"1C" & SSSITag & SSSIDataPin,      				-- I/O 60  12 RX4 
		IOPortTag & x"22" & SSSITag & SSSIDataPin,      				-- I/O 61  13 RX10
		IOPortTag & x"1D" & SSSITag & SSSIDataPin,      				-- I/O 62  14 RX5 
		IOPortTag & x"23" & SSSITag & SSSIDataPin,      				-- I/O 63  15 RX11
		IOPortTag & x"20" & SSSITag & SSSIClkPin,      					-- I/O 64  16 TX8 	
		IOPortTag & x"21" & SSSITag & SSSIClkPin,      					-- I/O 65  17 TX9 
		IOPortTag & x"22" & SSSITag & SSSIClkPin,      					-- I/O 66  18 TX10	
		IOPortTag & x"23" & SSSITag & SSSIClkPin,      					-- I/O 67  19 TX11
		IOPortTag & x"18" & SSSITag & SSSIClkPin,      					-- I/O 68  20 TX0 		
		IOPortTag & x"19" & SSSITag & SSSIClkPin,      					-- I/O 69  21 TX1 
		IOPortTag & x"1A" & SSSITag & SSSIClkPin,      					-- I/O 70  22 TX2 		
		IOPortTag & x"1B" & SSSITag & SSSIClkPin,      					-- I/O 71  23 TX3 

		IOPortTag & x"00" & SSerialTag & SSerialRX0Pin, 				-- I/O 72  0 
		IOPortTag & x"00" & SSerialTag & SSerialRX1Pin, 				-- I/O 73  1	
		IOPortTag & x"00" & SSerialTag & SSerialRX2Pin, 				-- I/O 74  2		
		IOPortTag & x"00" & SSerialTag & SSerialRX3Pin, 				-- I/O 75  3		
		IOPortTag & x"00" & SSerialTag & SSerialTX0Pin, 				-- I/O 76  4		
		IOPortTag & x"00" & SSerialTag & SSerialTXEn0Pin,				-- I/O 77  5		
		IOPortTag & x"00" & SSerialTag & SSerialTX1Pin,					-- I/O 78  6			
		IOPortTag & x"00" & SSerialTag & SSerialTXEn1Pin,				-- I/O 79  7		
		IOPortTag & x"00" & SSerialTag & SSerialTX2Pin, 				-- I/O 80  8		
		IOPortTag & x"00" & SSerialTag & SSerialTXEn2Pin,				-- I/O 81  9 
		IOPortTag & x"00" & SSerialTag & SSerialTX3Pin, 				-- I/O 82  10
		IOPortTag & x"00" & SSerialTag & SSerialTXEn3Pin,				-- I/O 83  11
		IOPortTag & x"00" & SSerialTag & SSerialRX4Pin, 				-- I/O 84  12
		IOPortTag & x"00" & SSerialTag & SSerialRX5Pin,   				-- I/O 85  13
		IOPortTag & x"00" & SSerialTag & SSerialRX6Pin,   				-- I/O 86  14	
		IOPortTag & x"00" & SSerialTag & SSerialRX7Pin, 				-- I/O 87  15
		IOPortTag & x"00" & SSerialTag & SSerialTX4Pin,   				-- I/O 88  16		
		IOPortTag & x"00" & SSerialTag & SSerialTXEn4Pin,  			-- I/O 89  17
		IOPortTag & x"00" & SSerialTag & SSerialTX5Pin,					-- I/O 90  18		
		IOPortTag & x"00" & SSerialTag & SSerialTXEn5Pin,				-- I/O 91  19
		IOPortTag & x"00" & SSerialTag & SSerialTX6Pin, 				-- I/O 92  20			
		IOPortTag & x"00" & SSerialTag & SSerialTXEn6Pin,  			-- I/O 93  21
		IOPortTag & x"00" & SSerialTag & SSerialTX7Pin,   				-- I/O 94  22			
		IOPortTag & x"00" & SSerialTag & SSerialTXEn7Pin,  			-- I/O 95  23

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_SISS36_8_3X7I47_7I44_96;
