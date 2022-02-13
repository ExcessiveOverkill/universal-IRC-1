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

package PIN_7i76x1_bstechx1d_51 is
	constant ModuleID : ModuleIDType :=( 
		(HM2DPLLTag,	x"00",	ClockLowTag,	x"01",	HM2DPLLBaseRateAddr&PadT,	HM2DPLLNumRegs,		x"00",	HM2DPLLMPBitMask),
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	x"03",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(StepGenTag,	x"02",	ClockLowTag,	x"0A",	StepGenRateAddr&PadT,		StepGenNumRegs,		x"00",	StepGenMPBitMask),
		(QcountTag,		x"02",	ClockLowTag,	x"02",	QcounterAddr&PadT,			QCounterNumRegs,		x"00",	QCounterMPBitMask),
		(PWMTag,			x"00",	ClockHighTag,	x"01",	PWMValAddr&PadT,				PWMNumRegs,				x"00",	PWMMPBitMask),
		(SSerialTag,	x"00",	ClockLowTag,	x"01",	SSerialCommandAddr&PadT,	SSerialNumRegs,		x"10",	SSerialMPBitMask),
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
		(NullTag,				x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000")
		);
			
	constant PinDesc : PinDescType :=(
	
-- 	Base func  sec unit sec func 	sec pin						 	      
		IOPortTag & x"00" & StepGenTag & StepGenDirPin,					-- I/O 00	embedded 7I76
		IOPortTag & x"00" & StepGenTag & StepGenStepPin,				-- I/O 01	
		IOPortTag & x"01" & StepGenTag & StepGenDirPin,					-- I/O 02	
		IOPortTag & x"01" & StepGenTag & StepGenStepPin,				-- I/O 03	
		IOPortTag & x"02" & StepGenTag & StepGenDirPin,					-- I/O 04	
		IOPortTag & x"02" & StepGenTag & StepGenStepPin,				-- I/O 05	
		IOPortTag & x"03" & StepGenTag & StepGenDirPin,					-- I/O 06	
		IOPortTag & x"03" & StepGenTag & StepGenStepPin,				-- I/O 07	
		IOPortTag & x"04" & StepGenTag & StepGenDirPin,					-- I/O 08	
		IOPortTag & x"04" & StepGenTag & StepGenStepPin,				-- I/O 09	
		IOPortTag & x"00" & SSerialTag & SSerialTX0Pin, 				-- I/O 10	
		IOPortTag & x"00" & SSerialTag & SSerialRX0Pin, 				-- I/O 11	
		IOPortTag & x"00" & SSerialTag & SSerialTX1Pin, 				-- I/O 12	
		IOPortTag & x"00" & SSerialTag & SSerialRX1Pin, 				-- I/O 13	
		IOPortTag & x"00" & QCountTag & x"03",  			 			 	-- I/O 14	
		IOPortTag & x"00" & QCountTag & x"02",    						-- I/O 15	
		IOPortTag & x"00" & QCountTag & x"01",    						-- I/O 16	
		
																						--		P1		DB25		26 HDR
		IOPortTag & x"00" & PWMTag & PWMAOutPin,				-- I/O 17	PIN 1		PIN 1 	Spindle DAC PWM
		IOPortTag & x"00" & NullTag & NullPin,					-- I/O 18   PIN 2		PIN 14	GPIO
		IOPortTag & x"05" & StepGenTag & StepGenStepPin,	-- I/O 19   PIN 3		PIN 2	   X Step
		IOPortTag & x"00" & NullTag & NullPin,					-- I/O 20	PIN 4		PIN 15	GPIO
		IOPortTag & x"05" & StepGenTag & StepGenDirPin,		-- I/O 21	PIN 5		PIN 3	   X Dir    
		IOPortTag & x"09" & StepGenTag & StepGenStepPin,	-- I/O 22	PIN 6		PIN 16	B Step
		IOPortTag & x"06" & StepGenTag & StepGenStepPin,	-- I/O 23	PIN 7		PIN 4	   Y Step
		IOPortTag & x"09" & StepGenTag & StepGenDirPin,		-- I/O 24	PIN 8		PIN 17	B Dir
		IOPortTag & x"06" & StepGenTag & StepGenDirPin,		-- I/O 25	PIN 9		PIN 5	   Y Dir
		IOPortTag & x"07" & StepGenTag & StepGenStepPin,	-- I/O 26	PIN 11	PIN 6	   Z Step
		IOPortTag & x"07" & StepGenTag & StepGenDirPin,		-- I/O 27	PIN 13	PIN 7	   Z Dir
		IOPortTag & x"08" & StepGenTag & StepGenStepPin,	-- I/O 28	PIN 15	PIN 8	   A Step
		IOPortTag & x"08" & StepGenTag & StepGenDirPin,		-- I/O 29	PIN 17	PIN 9	   A Dir
		IOPortTag & x"01" & QCountTag & QCountQAPin,  		-- I/O 30	PIN 19	PIN 10	GPIO(Quad A)
		IOPortTag & x"01" & QCountTag & QCountQBPin,  		-- I/O 31	PIN 21	PIN 11  	GPIO(Quad B)
		IOPortTag & x"01" & QCountTag & QCountIdxPin,    	-- I/O 32	PIN 23	PIN 12	GPIO(Quad Idx)
		IOPortTag & x"00" & NullTag & NullPin,	 	   		-- I/O 33	PIN 25	PIN 13	GPIO

																						--		P2
		IOPortTag & x"00" & NullTag & x"00",    			   			-- I/O 34 	PIN 1
		IOPortTag & x"00" & NullTag & x"00",   			    			-- I/O 35   PIN 14
		IOPortTag & x"00" & NullTag & x"00",   			    			-- I/O 36   PIN 2
		IOPortTag & x"00" & NullTag & x"00",  			     				-- I/O 37	PIN 15
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 38	PIN 3
		IOPortTag & x"00" & NullTag & x"00",			       		 	-- I/O 39	PIN 16
		IOPortTag & x"00" & NullTag & x"00",    			   			-- I/O 40   PIN 4
		IOPortTag & x"00" & NullTag & x"00",      			 			-- I/O 41   PIN 17
		IOPortTag & x"00" & NullTag & x"00",    							-- I/O 42   PIN 5
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 43   PIN 6
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 44   PIN 7
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 45   PIN 8
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 46   PIN 9
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 47	PIN 10
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 48   PIN 11
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 49   PIN 12
		IOPortTag & x"00" & NullTag & x"00",       						-- I/O 50   PIN 13
																										
		LIOPortTag & x"00" & SSerialTag & SSerialNTXEn1Pin,  
		
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, 
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,

		emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_7i76x1_bstechx1d_51;