library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--
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
--         * Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
-- 
--         * Redistributions in binary form must reproduce the above
--           copyright notice, this list of conditions and the following
--           disclaimer in the documentation and/or other materials
--           provided with the distribution.
-- 
--         * Neither the name of Mesa Electronics nor the names of its
--           contributors may be used to endorse or promote products
--           derived from this software without specific prior written
--           permission.
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


entity hm2dpll is
	port (
		clk     			: in  std_logic;
		ibus    			: in  std_logic_vector (31 downto 0);
		obus    			: out std_logic_vector (31 downto 0);
		loadbaserate	: in  std_logic;
		readbaserate	: in  std_logic;
		loadphase	   : in  std_logic;
		readphase	   : in  std_logic;
		loadcontrol0	: in  std_logic;	
		readcontrol0	: in  std_logic;
		loadcontrol1	: in  std_logic;	
		readcontrol1	: in  std_logic;
		loadtimers12	: in  std_logic;
		readtimers12	: in  std_logic;
		loadtimers34	: in  std_logic;
		readtimers34	: in  std_logic;
		syncwrite		: in  std_logic;
		syncread			: in  std_logic;
		syncin			: in  std_logic;
		timerout			: out std_logic_vector(3 downto 0);
		refout			: out std_logic
		
    );
end hm2dpll;

architecture behavioral of hm2dpll is
constant AccumSize: integer := 42;
constant Ilimit: signed(23 downto 0) := x"700000";
signal PLimit: signed(23 downto 0);
signal Accum: signed(AccumSize-1 downto 0);
signal Prescale : unsigned(7 downto 0);
signal PrescaleCount : unsigned(7 downto 0);
signal FilterPrescale : unsigned(15 downto 0);
signal FilterPrescaleCount : unsigned(15 downto 0);
signal Accum16: unsigned(15 downto 0);
signal PhaseErr: signed(31 downto 0);
alias PhaseErr23: signed(23 downto 0) is PhaseErr(31 downto 8);
signal BaseRate: signed(31 downto 0);
signal ITerm: signed(23 downto 0);
signal BoundedPhaseErr: signed(23 downto 0);
signal FilteredPhaseErr: signed(23 downto 0);
signal DPLLCorrection: signed(23 downto 0);
signal Timer1: unsigned(15 downto 0);
signal Timer2: unsigned(15 downto 0);
signal Timer3: unsigned(15 downto 0);
signal Timer4: unsigned(15 downto 0);
signal TimerOff1: unsigned(15 downto 0);
signal TimerOff2: unsigned(15 downto 0);
signal TimerOff3: unsigned(15 downto 0);
signal TimerOff4: unsigned(15 downto 0);
signal SyncInD: std_logic;	
signal SyncInFilter: unsigned(3 downto 0);
signal FilteredSync: std_logic_vector(1 downto 0);
signal TimerOutReg: std_logic_vector(3 downto 0);
begin
	ahm2dpll : process (clk,readphase,readbaserate,readcontrol0,readcontrol1,
								syncread,readtimers12,readtimers34,Accum16,
								Accum,Timer1,Timer2,Timer3,Timer4,PreScale,PhaseErr,
								DPLLCorrection,FilterPreScale,BaseRate,TimerOutReg)
	begin
		if clk'event and clk = '1' then 	-- per clk stuff
				-- Simple proportional  DPLL
			SyncInD <= syncin;
			if SyncInD = '1' then
				if SyncInFilter /= X"F" then
					SyncInFilter <= SyncInFilter + 1;
				end if;
			else	
				if SyncInFilter /= X"0" then
					SyncInFilter <= SyncInFilter - 1;
				end if;
			end if;
			
			if SyncInFilter = X"F" then
				FilteredSync <= FilteredSync(0)&'1';
			end if;
			if SyncInFilter = X"0" then
				FilteredSync <= FilteredSync(0)&'0';
			end if;
			
			if PrescaleCount = x"01" then
				PrescaleCount <= PreScale;
				Accum <= Accum + (x"00"&BaseRate)  -DPLLCorrection;
				if PhaseErr23 > Plimit then
					BoundedPhaseErr <= Plimit;
				elsif PhaseErr23 < -Plimit then
					BoundedPhaseErr <= -Plimit;
				else
					BoundedPhaseErr <= PhaseErr23;
				end if;	
				if FilterPrescaleCount = x"01" then
					FilterPrescaleCount <= FilterPreScale;
					FilteredPhaseErr <= FilteredPhaseErr + (resize(BoundedPhaseErr(23 downto 8),24) - resize(FilteredPhaseErr(23 downto 8),24));
					if Iterm > Ilimit then
						ITerm <= Ilimit;
					end if;
					if Iterm < -Ilimit then
						Iterm <= -Ilimit;
					end if;	
					ITerm <= ITerm + resize(BoundedPhaseErr(23 downto 12),24);
				else
					FilterPreScaleCount <= FilterPreScaleCount -1;
				end if;
			else
				PreScaleCount <= PreScaleCount -1;
			end if;  -- prescale;


			DPLLCorrection <= FilteredPhaseErr + resize(BoundedPhaseErr(23 downto 4),24) + ITerm;		
--			DPLLCorrection <= FilteredPhaseErr + resize(BoundedPhaseErr(23 downto 4),24);		
--			DPLLCorrection <= FilteredPhaseErr;
			
			if syncread = '1' or syncwrite = '1' or FilteredSync = "01" then 
				PhaseErr   <= Accum(AccumSize-1 downto AccumSize-32); -- top 32 bits
			end if;

			if loadphase = '1' then
				Accum(AccumSize-1 downto AccumSize-32) <=  signed(ibus);
			end if;

			if loadbaserate = '1' then
				baserate <= signed(ibus);
			end if;

			if loadcontrol0 = '1' then
				Plimit  <= signed(ibus(23 downto 0));
				PreScale <= unsigned(ibus(31 downto 24));
				FilteredPhaseErr <= (others => '0');
				PhaseErr <= (others => '0');
				ITerm <= (others => '0');
			end if;

			if loadcontrol1 = '1' then
				FilterPreScale <= unsigned(ibus(31 downto 16));
			end if;
			
			if loadtimers12 = '1' then
				timer1 <= unsigned(ibus(15 downto 0));
				timer2 <= unsigned(ibus(31 downto 16));
			end if;
						
			if loadtimers34 = '1' then
				timer3 <= unsigned(ibus(15 downto 0));
				timer4 <= unsigned(ibus(31 downto 16));
			end if;			
		
			TimerOutReg(0) <= TimerOff1(15);
			TimerOutReg(1) <= TimerOff2(15);
			TimerOutReg(2) <= TimerOff3(15);
			TimerOutReg(3) <= TimerOff4(15);

		end if;  -- clk      

		Accum16 <= unsigned(std_logic_vector(Accum(AccumSize-1 downto AccumSize-16)));

		obus <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

		if readphase = '1' or syncread= '1' then
			obus <= std_logic_vector(Accum(AccumSize-1 downto AccumSize-32));
		end if;

		if readbaserate = '1'  then
			obus <= std_logic_vector(BaseRate);
		end if;

		if readcontrol0 = '1' then
			obus(31 downto 24) <= std_logic_vector(PreScale);
			obus(23 downto 0) <= std_logic_vector(DPLLCorrection);
		end if;

		if readcontrol1 = '1' then
			obus(31 downto 16) <= std_logic_vector(FilterPreScale);	
			obus(15 downto 8) <= (others => '0');
			obus(7 downto 0) <= std_logic_vector(to_unsigned(AccumSize,8));
		end if;

		if readtimers12 = '1' then
			obus(15 downto 0)  <= std_logic_vector(Timer1);
			obus(31 downto 16) <= std_logic_vector(Timer2);
		end if;

		if readtimers34 = '1' then
			obus(15 downto 0)  <= std_logic_vector(Timer3);
			obus(31 downto 16) <= std_logic_vector(Timer4);
		end if;
		
		TimerOff1 <= Timer1 + Accum16;
		TimerOff2 <= Timer2 + Accum16;
		TimerOff3 <= Timer3 + Accum16;
		TimerOff4 <= Timer4 + Accum16;
		
		timerout <= not TimerOutReg;				-- These are inverted since we use the rising
		refout <= not Accum(AccumSize-1);		-- edge as the external timing reference
	end process;

end behavioral;
