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

package PIN_SUBSERIAL_BASE_72 is
    constant ModuleID : ModuleIDType :=( 
        (WatchDogTag,   x"00",  ClockLowTag,        x"01",  WatchDogTimeAddr&PadT,          WatchDogNumRegs,        x"00",  WatchDogMPBitMask),
        (IOPortTag,     x"00",  ClockLowTag,        x"03",  PortAddr&PadT,                  IOPortNumRegs,          x"00",  IOPortMPBitMask),   
        (SSerialTag,    x"01",  ClockLowTag,        x"02",  SSerialCommandAddr&PadT,        SSerialNumRegs,         x"10",  SSerialMPBitMask),
        (QcountTag,     x"03",  ClockLowTag,        x"09",  QcounterAddr&PadT,              QCounterNumRegs,        x"00",  QCounterMPBitMask),
        (StepGenTag,    x"02",  ClockLowTag,        x"0A",  StepGenRateAddr&PadT,           StepGenNumRegs,         x"00",  StepGenMPBitMask),
		  (PWMTag,			x"00",  ClockHighTag,		 x"02",	PWMValAddr&PadT,			        PWMNumRegs,				  x"00",	 PWMMPBitMask),		  
		  (LEDTag,        x"00",  ClockLowTag,        x"01",  LEDAddr&PadT,                   LEDNumRegs,             x"00",  LEDMPBitMask),    
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000")
        );
        
    
    constant PinDesc : PinDescType :=(
--  Base func  sec unit sec func     sec pin
        IOPortTag & x"00" & SSerialTag & SSerialRX0Pin,         -- I/O 00
        IOPortTag & x"00" & SSerialTag & SSerialRX1Pin,         -- I/O 01
        IOPortTag & x"00" & SSerialTag & SSerialRX2Pin,         -- I/O 02
        IOPortTag & x"00" & SSerialTag & SSerialRX3Pin,         -- I/O 03
        IOPortTag & x"00" & SSerialTag & SSerialTX0Pin,         -- I/O 04
        IOPortTag & x"00" & SSerialTag & SSerialTX1Pin,         -- I/O 05
        IOPortTag & x"00" & SSerialTag & SSerialTX2Pin,         -- I/O 06
        IOPortTag & x"00" & SSerialTag & SSerialTX3Pin,         -- I/O 07
        IOPortTag & x"00" & SSerialTag & SSerialRX4Pin,         -- I/O 08
        IOPortTag & x"00" & SSerialTag & SSerialRX5Pin,         -- I/O 09
        IOPortTag & x"00" & SSerialTag & SSerialRX6Pin,         -- I/O 10
        IOPortTag & x"00" & SSerialTag & SSerialRX7Pin,         -- I/O 11
        IOPortTag & x"00" & SSerialTag & SSerialTX4Pin,         -- I/O 12
        IOPortTag & x"00" & SSerialTag & SSerialTX5Pin,         -- I/O 13
        IOPortTag & x"00" & SSerialTag & SSerialTX6Pin,         -- I/O 14
        IOPortTag & x"00" & SSerialTag & SSerialTX7Pin,         -- I/O 15
        IOPortTag & x"00" & SSerialTag & SSerialTXEn1Pin,       -- I/O 16
        IOPortTag & x"00" & QCountTag & QCountQAPin,            -- I/O 17
        IOPortTag & x"00" & QCountTag & QCountQBPin,            -- I/O 18
        IOPortTag & x"00" & QCountTag & QCountIDXPin,           -- I/O 19
        IOPortTag & x"01" & QCountTag & QCountQAPin,            -- I/O 20
        IOPortTag & x"01" & QCountTag & QCountQBPin,            -- I/O 21
        IOPortTag & x"01" & QCountTag & QCountIDXPin,           -- I/O 22
        IOPortTag & x"02" & QCountTag & QCountQAPin,            -- I/O 23

        IOPortTag & x"02" & QCountTag & QCountQBPin,            -- I/O 24
        IOPortTag & x"02" & QCountTag & QCountIDXPin,           -- I/O 25
        IOPortTag & x"03" & QCountTag & QCountQAPin,            -- I/O 26
        IOPortTag & x"03" & QCountTag & QCountQBPin,            -- I/O 27
        IOPortTag & x"03" & QCountTag & QCountIDXPin,           -- I/O 28
        IOPortTag & x"04" & QCountTag & QCountQAPin,            -- I/O 29
        IOPortTag & x"04" & QCountTag & QCountQBPin,            -- I/O 30
        IOPortTag & x"04" & QCountTag & QCountIDXPin,           -- I/O 31
        IOPortTag & x"05" & QCountTag & QCountQAPin,            -- I/O 32
        IOPortTag & x"05" & QCountTag & QCountQBPin,            -- I/O 33
        IOPortTag & x"05" & QCountTag & QCountIDXPin,           -- I/O 34
        IOPortTag & x"06" & QCountTag & QCountQAPin,            -- I/O 35
        IOPortTag & x"06" & QCountTag & QCountQBPin,            -- I/O 36
        IOPortTag & x"06" & QCountTag & QCountIDXPin,           -- I/O 37
        IOPortTag & x"07" & QCountTag & QCountQAPin,            -- I/O 38
        IOPortTag & x"07" & QCountTag & QCountQBPin,            -- I/O 39
        IOPortTag & x"07" & QCountTag & QCountIDXPin,           -- I/O 40
        IOPortTag & x"01" & SSerialTag & SSerialRX0Pin,         -- I/O 41
        IOPortTag & x"01" & SSerialTag & SSerialRX1Pin,         -- I/O 42
        IOPortTag & x"01" & SSerialTag & SSerialRX2Pin,         -- I/O 43
        IOPortTag & x"01" & SSerialTag & SSerialRX3Pin,         -- I/O 44
        IOPortTag & x"01" & SSerialTag & SSerialTX0Pin,         -- I/O 45
        IOPortTag & x"01" & SSerialTag & SSerialTX1Pin,         -- I/O 46
        IOPortTag & x"01" & SSerialTag & SSerialTX2Pin,         -- I/O 47

        IOPortTag & x"01" & SSerialTag & SSerialTX3Pin,         -- I/O 48
        IOPortTag & x"01" & SSerialTag & SSerialRX4Pin,         -- I/O 49
        IOPortTag & x"01" & SSerialTag & SSerialRX5Pin,         -- I/O 50
        IOPortTag & x"01" & SSerialTag & SSerialTX6Pin,         -- I/O 51
        IOPortTag & x"01" & SSerialTag & SSerialTX7Pin,         -- I/O 52
        IOPortTag & x"01" & SSerialTag & SSerialTXEn2Pin,       -- I/O 53
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 54   SYSTEM ON/OFF relay (F1)

        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 55   PIN 1       Output 2 just GPIO
        IOPortTag & x"00" & PWMTag & PWMAOutPin,                -- I/O 56   PIN 14      Spindle DAC PWM
        IOPortTag & x"00" & StepGenTag & StepGenStepPin,        -- I/O 57   PIN 2       X Step
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 58   PIN 15      Fault in just GPIO
        IOPortTag & x"00" & StepGenTag & StepGenDirPin,         -- I/O 59   PIN 3       X Dir
        IOPortTag & x"04" & StepGenTag & StepGenStepPin,        -- I/O 60   PIN 16      Charge Pump (16 KHz)
        IOPortTag & x"01" & StepGenTag & StepGenStepPin,        -- I/O 61   PIN 4       Y Step
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 62   PIN 17      Output 1 just GPIO
        IOPortTag & x"01" & StepGenTag & StepGenDirPin,         -- I/O 63   PIN 5       Y Dir
        IOPortTag & x"02" & StepGenTag & StepGenStepPin,        -- I/O 64   PIN 6       Z Step
        IOPortTag & x"02" & StepGenTag & StepGenDirPin,         -- I/O 65   PIN 7       Z Dir
        IOPortTag & x"03" & StepGenTag & StepGenStepPin,        -- I/O 66   PIN 8       A Step
        IOPortTag & x"03" & StepGenTag & StepGenDirPin,         -- I/O 67   PIN 9       A Dir
        IOPortTag & x"08" & QCountTag & QCountQAPin,            -- I/O 68   PIN 10      Input 1 (Quad A)
        IOPortTag & x"08" & QCountTag & QCountQBPin,            -- I/O 69   PIN 11      Input 2 (Quad B)
        IOPortTag & x"08" & QCountTag & QCountIdxPin,           -- I/O 70   PIN 12      Input 3 (Quad Idx)
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 71   PIN 13      Input 4 just GPIO





        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,

        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_SUBSERIAL_BASE_72;
