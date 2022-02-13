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

package PIN_7IA0_38 is
	constant ModuleID : ModuleIDType :=( 
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	x"02",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(XFrmrOutTag,	x"00",	ClockLowTag,	x"01",	XFrmrDataAddr&PadT,			XFrmrNumRegs,			x"00",	XFrmrMPBitMask ),
		(InMuxTag,		x"00",	ClockLowTag,	x"02",	InMuxControlAddr&PadT,		InMuxNumRegs,			x"00",	InmuxMPBitMask),
		(DSADTag,		x"00",	ClockLowTag,	x"01",	DSADAddr&PadT,					DSADNumRegs,			x"00",	DSADMPBitMask),
		(LEDTag,			x"00",	ClockLowTag,	x"01",	LEDAddr&PadT,					LEDNumRegs,				x"00",	LEDMPBitMask),
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
		(InMuxWidth0Tag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000018"), -- hide this tag here until we find a better way
		(InMuxWidth1Tag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000018") -- hide this tag here until we find a better way
		);
			
	constant PinDesc : PinDescType :=(
	
-- 	Base func  sec unit sec func 	sec pin						 	      
		
																			--		
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut0Pin,   	-- I/O 00 	F 7IA0 XFRMR out
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut1Pin,   	-- I/O 01   	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut2Pin,   	-- I/O 02   
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut3Pin,   	-- I/O 03		
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut4Pin,   	-- I/O 04	F
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut5Pin,   	-- I/O 05		
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut6Pin,   	-- I/O 06   
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut7Pin,   	-- I/O 07   	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut8Pin,   	-- I/O 08   F
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut9Pin,   	-- I/O 09   
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOutAPin,   	-- I/O 10   
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOutBPin,   	-- I/O 11   
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOutCPin,   	-- I/O 12   F
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOutDPin,   	-- I/O 13		
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOutEPin,   	-- I/O 14   	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOutFPin,   	-- I/O 15   	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut10Pin,   -- I/O 16  7 	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut11Pin,   -- I/O 17	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut12Pin,   -- I/O 18	

		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut13Pin,   -- I/O 19	0 F
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut14Pin,   -- I/O 20	1 
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut15Pin,   -- I/O 21	2
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut16Pin,   -- I/O 22	3
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut17Pin,   -- I/O 23	4 F
		IOPortTag & x"00" & XfrmrOutTag & XfrmrRefPin,    	-- I/O 24	5 
		IOPortTag & x"00" & InMuxTag & InMuxAddr0Pin,		-- I/O 25	6
		IOPortTag & x"00" & InMuxTag & InMuxAddr1Pin,		-- I/O 26	7
		IOPortTag & x"00" & InMuxTag & InMuxAddr2Pin,		-- I/O 27	8 7
		IOPortTag & x"00" & InMuxTag & InMuxAddr3Pin,		-- I/O 28	9 
		IOPortTag & x"00" & InMuxTag & InMuxAddr4Pin,		-- I/O 29	10
		IOPortTag & x"00" & InMuxTag & InMuxDataPin,       -- I/O 30	11
		IOPortTag & x"01" & InMuxTag & InMuxAddr0Pin,		-- I/O 31	12 F
		IOPortTag & x"01" & InMuxTag & InMuxAddr1Pin,		-- I/O 32	13 
		IOPortTag & x"01" & InMuxTag & InMuxAddr2Pin,		-- I/O 33	14
		IOPortTag & x"01" & InMuxTag & InMuxAddr3Pin,		-- I/O 34 	15
		IOPortTag & x"01" & InMuxTag & InMuxAddr4Pin,		-- I/O 35   16 1
		IOPortTag & x"01" & InMuxTag & InMuxDataPin,       -- I/O 36   17 
		IOPortTag & x"00" & NullTag & x"00",       			-- I/O 37	18
		
		-- 7IA0 local I/O bits
		LIOPortTag & x"00" & DSADTag & DSADFBOutPin0,		-- LIO 0
		LIOPortTag & x"00" & DSADTag & DSADFBOutPin1,		-- LIO 1
		LIOPortTag & x"00" & DSADTag & DSADFBOutPin2,		-- LIO 2
		LIOPortTag & x"00" & DSADTag & DSADFBOutPin3,		-- LIO 3
		LIOPortTag & x"00" & DSADTag & DSADCompInNPin0,		-- LIO 4
		LIOPortTag & x"00" & DSADTag & DSADCompInPPin0,		-- LIO 5
		LIOPortTag & x"00" & DSADTag & DSADCompInNPin1,		-- LIO 6
		LIOPortTag & x"00" & DSADTag & DSADCompInPPin1,		-- LIO 7
		LIOPortTag & x"00" & DSADTag & DSADCompInNPin2,		-- LIO 8
		LIOPortTag & x"00" & DSADTag & DSADCompInPPin2,		-- LIO 9
		LIOPortTag & x"00" & DSADTag & DSADCompInNPin3,		-- LIO 10
		LIOPortTag & x"00" & DSADTag & DSADCompInPPin3,		-- LIO 11
		LIOPortTag & x"00" & DSADTag & DSADPWMPin,			-- LIO 12
		
	
		emptypin,emptypin,emptypin,emptypin,emptypin, 
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_7IA0_38;
