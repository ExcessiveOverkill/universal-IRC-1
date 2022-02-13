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


package PIN_7C80_5ABOBD_54 is
	constant ModuleID : ModuleIDType :=( 
		(HM2DPLLTag,			x"00",	ClockLowTag,	x"01",	HM2DPLLBaseRateAddr&PadT,	HM2DPLLNumRegs,		x"00",	HM2DPLLMPBitMask),
		(WatchDogTag,			x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,				x"00",	ClockLowTag,	x"02",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(QcountTag,				x"02",	ClockLowTag,	x"02",	QcounterAddr&PadT,			QCounterNumRegs,		x"00",	QCounterMPBitMask),
		(StepGenTag,			x"02",	ClockLowTag,	x"09",	StepGenRateAddr&PadT,		StepGenNumRegs,		x"00",	StepGenMPBitMask),
		(SSerialTag,			x"00",	ClockLowTag,	x"01",	SSerialCommandAddr&PadT,	SSerialNumRegs,		x"10",	SSerialMPBitMask),
		(PWMTag,					x"00",	ClockHighTag,	x"02",	PWMValAddr&PadT,				PWMNumRegs,				x"00",	PWMMPBitMask),
		(XFrmrOutTag,			x"00",	ClockLowTag,	x"01",	XFrmrDataAddr&PadT,			XFrmrNumRegs,			x"00",	XFrmrMPBitMask ),
		(InMuxTag,				x"00",	ClockLowTag,	x"01",	InMuxControlAddr&PadT,		InMuxNumRegs,			x"00",	InmuxMPBitMask),
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
		(InMuxWidth0Tag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000018") -- hide this tag here until we find a better way
		);
			
	constant PinDesc : PinDescType :=(
	
-- 	Base func  sec unit sec func 	sec pin						 	      
		
																						--		
		IOPortTag & x"00" & StepGenTag & StepGenStepPin,				-- I/O 00 	embedded 7C80 Stepgen
		IOPortTag & x"00" & StepGenTag & StepGenDirPin,					-- I/O 01   	
		IOPortTag & x"01" & StepGenTag & StepGenStepPin,				-- I/O 02   
		IOPortTag & x"01" & StepGenTag & StepGenDirPin,					-- I/O 03		

		IOPortTag & x"02" & StepGenTag & StepGenStepPin,				-- I/O 04	
		IOPortTag & x"02" & StepGenTag & StepGenDirPin,					-- I/O 05		
		IOPortTag & x"03" & StepGenTag & StepGenStepPin,				-- I/O 06   
		IOPortTag & x"03" & StepGenTag & StepGenDirPin,					-- I/O 07   	

		IOPortTag & x"04" & StepGenTag & StepGenStepPin,				-- I/O 08   
		IOPortTag & x"04" & StepGenTag & StepGenDirPin,					-- I/O 09   
		IOPortTag & x"05" & StepGenTag & StepGenStepPin,				-- I/O 10   
		IOPortTag & x"05" & StepGenTag & StepGenDirPin,					-- I/O 11   

		IOPortTag & x"00" & SSerialTag & SSerialRX0Pin,					-- I/O 12	embedded sserial expansion   
		IOPortTag & x"00" & SSerialTag & SSerialTX0Pin,					-- I/O 13		
		IOPortTag & x"00" & SSerialTag & SSerialTXEn0Pin,				-- I/O 14   	
		IOPortTag & x"00" & QCountTag & QCountQAPin,						-- I/O 15	embedded 7C80 encoder 	

		IOPortTag & x"00" & QCountTag & QCountQBPin,						-- I/O 16   	
		IOPortTag & x"00" & QCountTag & QCountIDXPin,					-- I/O 17	
		IOPortTag & x"00" & PWMTag & PWMAOutPin,							-- I/O 18	Spindle PWM
		IOPortTag & x"00" & PWMTag & PWMCEnaPin,        				-- I/O 19	Analog ENA

		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 20	ENA/FWD	
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 21	DIR/REV
		IOPortTag & x"00" & InMuxTag & InMuxAddr0Pin,       			-- I/O 22	muxadd0
		IOPortTag & x"00" & InMuxTag & InMuxAddr1Pin,       			-- I/O 23	muxadd1

		IOPortTag & x"00" & InMuxTag & InMuxAddr2Pin,       			-- I/O 24	muxadd2
		IOPortTag & x"00" & InMuxTag & InMuxAddr3Pin,       			-- I/O 25	muxadd3
		IOPortTag & x"00" & InMuxTag & InMuxAddr4Pin,       			-- I/O 26	muxadd4


		IOPortTag & x"00" & InMuxTag & InMuxDataPin,       			-- I/O 27	muxindata
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut0Pin,   				-- I/O 28	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut1Pin,   				-- I/O 29	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut2Pin,   				-- I/O 30	muxindata
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut3Pin,   				-- I/O 31	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut4Pin,   				-- I/O 32	
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut5Pin,   				-- I/O 33
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut6Pin,   				-- I/O 34		
		IOPortTag & x"00" & XfrmrOutTag & XfrmrOut7Pin,   				-- I/O 35		
		IOPortTag & x"00" & XfrmrOutTag & XfrmrRefPin,    				-- I/O 36																									
		IOPortTag & x"01" & PWMTag & PWMAOutPin,							-- I/O 37	PIN 1		PIN 1 	Spindle DAC PWM
		IOPortTag & x"00" & NullTag & NullPin,								-- I/O 48   PIN 2		PIN 14	just GPIO
		IOPortTag & x"06" & StepGenTag & StepGenStepPin,				-- I/O 59   PIN 3		PIN 2	   X2 Dir
		IOPortTag & x"00" & NullTag & NullPin,								-- I/O 40	PIN 4		PIN 15	just GPIO
		IOPortTag & x"06" & StepGenTag & StepGenDirPin,					-- I/O 41	PIN 5		PIN 3	   X2 Step    
		IOPortTag & x"00" & NullTag & NullPin,								-- I/O 42	PIN 6		PIN 16	just GPIO
		IOPortTag & x"07" & StepGenTag & StepGenStepPin,				-- I/O 43	PIN 7		PIN 4	   Y2 Dir
		IOPortTag & x"00" & NullTag & NullPin,								-- I/O 44	PIN 8		PIN 17	just GPIO
		IOPortTag & x"07" & StepGenTag & StepGenDirPin,					-- I/O 45	PIN 9		PIN 5	   Y2 Step
		IOPortTag & x"08" & StepGenTag & StepGenStepPin,				-- I/O 46	PIN 11	PIN 6	   Z2 Dir
		IOPortTag & x"08" & StepGenTag & StepGenDirPin,					-- I/O 47	PIN 13	PIN 7	   Z2 Step
		IOPortTag & x"00" & NullTag & NullPin,								-- I/O 48	PIN 15	PIN 8	   just GPIO
		IOPortTag & x"00" & NullTag & NullPin,								-- I/O 49	PIN 17	PIN 9	   just GPIO
		IOPortTag & x"00" & NullTag & NullPin,								-- I/O 50	PIN 19	PIN 10	just GPIO
		IOPortTag & x"01" & QCountTag & QCountQAPin,  					-- I/O 51	PIN 21	PIN 11  	Input 2 (Quad A)
		IOPortTag & x"01" & QCountTag & QCountQBPin,  					-- I/O 52	PIN 23	PIN 12	Input 3 (Quad B))
		IOPortTag & x"01" & QCountTag & QCountIdxPin,   			 	-- I/O 53	PIN 25	PIN 13	Input 4 (Quad Idx)

																										
		emptypin,emptypin,
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
	   
		
end package PIN_7C80_5ABOBD_54;
