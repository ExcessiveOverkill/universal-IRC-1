library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
-- Copyright (C) 2009, Peter C. Wallace, Mesa Electronics
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
-- 

entity threephasepwm is
	port (
		clk: in std_logic;
		hclk: in std_logic;
		refcount: in std_logic_vector (10 downto 0);
		ibus: in std_logic_vector (31 downto 0);
		obus: out std_logic_vector (31 downto 0);
		loadpwmreg: in std_logic;
		loadenareg: in std_logic;
		readenareg: in std_logic;
		loaddzreg: in std_logic;
		pwmouta: out std_logic;
		pwmoutb: out std_logic;
		pwmoutc: out std_logic;
		npwmouta: out std_logic;
		npwmoutb: out std_logic;
		npwmoutc: out std_logic;
		pwmenaout: out std_logic;
		pwmfault: in std_logic;
		pwmsample: out std_logic
	);
end threephasepwm;



architecture behavioral of threephasepwm is
constant buswidth : integer := 32;

signal pwmval: std_logic_vector (BusWidth -1 downto 0);
alias  pwmaval: std_logic_vector(9 downto 0) is pwmval(9 downto 0);
alias  pwmbval: std_logic_vector(9 downto 0) is pwmval(19 downto 10);
alias  pwmcval: std_logic_vector(9 downto 0) is pwmval(29 downto 20);
signal pwma: std_logic;
signal pwmb: std_logic;
signal pwmc: std_logic;
signal npwma: std_logic;
signal npwmb: std_logic;
signal npwmc: std_logic;
signal prepwmval: std_logic_vector (BusWidth -1 downto 0);
signal preenareg: std_logic_vector(1 downto 0);
signal enareg: std_logic_vector(1 downto 0);
alias pwmena: std_logic is enareg(0);
alias pwmfltflg: std_logic is enareg(1);
signal fltcnt: std_logic_vector(2 downto 0);
signal predzreg: std_logic_vector(31 downto 0);
signal dzreg: std_logic_vector(31 downto 0);
alias  dzval: std_logic_vector(8 downto 0) is dzreg (8 downto 0);
alias  sampleval : std_logic_vector(10 downto 0) is dzreg(26 downto 16);
alias fltpol: std_logic is dzreg(15);
signal loadpwmreq: std_logic;
signal oldloadpwmreq: std_logic;
signal olderloadpwmreq: std_logic;
signal loadenareq: std_logic;
signal oldloadenareq: std_logic;
signal olderloadenareq: std_logic;
signal loaddzreq: std_logic;
signal oldloaddzreq: std_logic;
signal olderloaddzreq: std_logic;
signal cyclestart: std_logic;
signal oldrefcount10: std_logic;
signal samplereq : std_logic;
signal dsamplereq : std_logic_vector(1 downto 0);
signal pwmsamplet : std_logic;
signal fixedrefcount: std_logic_vector(9 downto 0);
begin
	
	hspwm: process  (hclk,refcount(10),oldrefcount10)
							
	begin
		if rising_edge(hclk) then	  		
			if ((pwmfault xor fltpol) = '0') and (fltcnt < "111") then -- ~70 ns filter
				fltcnt <= fltcnt + 1;												-- on fault input
			end if;
			if ((pwmfault xor fltpol) = '1') and (fltcnt /= 0) then 
				fltcnt <= fltcnt -1;
			end if;
			
			if fltcnt = "111" then													-- on fault, disable outputs
				pwmena <= '0';
				pwmfltflg <= '1';		
			end if;	
		
			if oldloadpwmreq = '1'  and olderloadpwmreq = '1' then
				pwmval <= prepwmval;
				oldloadpwmreq <= '0';
			end if;  		

			if oldloaddzreq = '1'  and olderloaddzreq = '1' then
				dzreg <= predzreg;
				oldloaddzreq <= '0';
			end if;  		

			if oldloadenareq = '1' and olderloadenareq ='1' then
 		   	enareg <= preenareg;			
			end if;
			
			olderloadpwmreq <= oldloadpwmreq;
			olderloadenareq <= oldloadenareq;
			olderloaddzreq <= oldloaddzreq;
			
			if (loadpwmreq and cyclestart) = '1' then
				oldloadpwmreq <= '1';
			end if;
			
			if (loaddzreq and cyclestart) = '1' then
				oldloaddzreq <= '1';
			end if;
			

			oldloadenareq <= loadenareq;
			oldrefcount10 <= refcount(10);
			
			
			-- was combinatorial but now pipelined to meet 100 MHz timing 	

			if (UNSIGNED('0'&fixedrefcount) < UNSIGNED('0'&pwmaval -dzval)) then 
				pwma <= '1'; 
			else 
				pwma <= '0';
			end if;
			if (UNSIGNED('0'&fixedrefcount) < UNSIGNED('0'&pwmaval +dzval)) then 
				npwma <= '1'; 
			else 
				npwma <= '0';
			end if;

			if (UNSIGNED('0'&fixedrefcount) < UNSIGNED('0'&pwmbval -dzval)) then 
				pwmb <= '1'; 
			else 
				pwmb <= '0';
			end if;
			if (UNSIGNED('0'&fixedrefcount) < UNSIGNED('0'&pwmbval +dzval)) then 
				npwmb <= '1'; 
			else 
				npwmb <= '0';
			end if;			
			
			if (UNSIGNED('0'&fixedrefcount) < UNSIGNED('0'&pwmcval -dzval)) then 
				pwmc <= '1'; 
			else 
				pwmc <= '0';
			end if;
			if (UNSIGNED('0'&fixedrefcount) < UNSIGNED('0'&pwmcval +dzval)) then 
				npwmc <= '1'; 
			else 
				npwmc <= '0';
			end if;	

			if refcount = SampleVal then 
				samplereq <= '1'; 
			end if;	
			
			if refcount(10) = '0' then		-- always symmetrical (triangle) mode
				fixedrefcount <= refcount(9 downto 0);					-- up
			else
				fixedrefcount <=	(not refcount(9 downto 0));		-- down
	  		end if;
		end if; -- hclk	
		
		if dsamplereq = "11" then
			samplereq <= '0';
		end if;

		cyclestart <= not refcount(10) and oldrefcount10; -- falling edge of refcount msb		
	end process hspwm;

	lspwm: process(clk,olderloadpwmreq, olderloadenareq, olderloaddzreq, 
	               pwma, enareg, pwmb, pwmc, npwma, npwmb, npwmc)
	begin
		if rising_edge(clk) then -- 33/48/50 mhz local bus clock			
			if loadpwmreg = '1' then			 
				prepwmval <= ibus;	
				loadpwmreq <= '1';
			end if;	
			if loadenareg = '1' then
				preenareg <= ibus(1 downto 0);
				loadenareq <= '1';
			end if;	
			if loaddzreg = '1' then
				predzreg <= ibus(31 downto 0);
				loaddzreq <= '1';
			end if;	
			dsamplereq <= dsamplereq(0) & samplereq;
			if dsamplereq = "10" then
				pwmsamplet <= '1';
			else
				pwmsamplet <= '0';
			end if;	
		end if; -- clk

		obus <= (others => 'Z');
		if readenareg = '1' then			
			obus(1 downto 0) <= enareg;
		end if;
		
		if olderloadpwmreq = '1' then -- asynchronous request clear, could use flancter but dont need async clear 
			loadpwmreq <= '0';
		end if;		

		if olderloadenareq = '1' then -- asynchronous request clear ""
			loadenareq <= '0';
		end if;	

		if olderloaddzreq = '1' then -- asynchronous request clear ""
			loaddzreq <= '0';
		end if;	
		
		pwmouta <= pwma and pwmena;
		pwmoutb <= pwmb and pwmena;
		pwmoutc <= pwmc and pwmena;
		npwmouta <= (not npwma) and pwmena;
		npwmoutb <= (not npwmb) and pwmena;
		npwmoutc <= (not npwmc) and pwmena;
		pwmenaout <= not pwmena;
		pwmsample <= pwmsamplet;
	end process lspwm;
end behavioral;

