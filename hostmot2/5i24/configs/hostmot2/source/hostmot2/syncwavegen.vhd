 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
-- Copyright (C) 2010, Peter C. Wallace, Mesa Electronics
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

entity syncwavegen is -- same as wavegen but for single clock
	generic (
		buswidth : integer := 32;
		pdmwidth : integer := 13  --13 max
		);    
	port (
		clk: in std_logic;
		ibus: in std_logic_vector (buswidth -1 downto 0);
--		obus: out std_logic_vector (buswidth -1 downto 0);
		loadrate:  in std_logic;
		loadlength:  in std_logic;
		loadpdmrate:  in std_logic;
		loadtableptr: in std_logic;
		loadtabledata: in std_logic;
		trigger0: out std_logic;
		trigger1: out std_logic;
		trigger2: out std_logic;
		trigger3: out std_logic;
		pdmouta: out std_logic;
		pdmoutb: out std_logic
	);
end syncwavegen;

architecture behavioral of syncwavegen is
signal rateacc: std_logic_vector (16 downto 0);
alias ratemsb: std_logic is rateacc(16);
signal oldratemsb: std_logic;

signal pdmrate: std_logic_vector (7 downto 0);
alias pdmratemsb: std_logic is pdmrate(7);
signal pdmval: std_logic_vector (pdmwidth-2 downto 0);
signal pdmaccum: std_logic_vector (pdmwidth-1 downto 0);
alias pdmbit: std_logic is pdmaccum(pdmwidth-1);

signal ptabledata: std_logic_vector (15 downto 0);  -- need to parametize
signal htableptr: std_logic_vector (7 downto 0);
signal ptableptr: std_logic_vector (7 downto 0);

signal ratereg: std_logic_vector(15 downto 0);
signal lengthreg: std_logic_vector(7 downto 0);
signal pdmratereg: std_logic_vector(7 downto 0);

signal triggerreg: std_logic_vector(3 downto 0);
	 
begin
   -- 256 long max, 12 bit resolution max + 4 trigger bits 
	
	waveram : entity work.dpram 
	generic map (
		width => 16,
		depth => 256
				)
	port map(
		addra => htableptr,
		addrb => ptableptr,
		clk  => clk,
		dina  => ibus(15 downto 0),
   	doutb => ptabledata,
		wea	=> loadtabledata
	 );	 

	awavegen: process  (clk,ptabledata, pdmaccum, triggerreg)							
	begin
		if rising_edge(clk) then	  		
			
			if pdmratemsb = '1' then
				pdmaccum <= ('0'&pdmaccum(pdmwidth-2 downto 0)) + ('0'&pdmval);
				pdmrate <= pdmratereg;	
			else
				pdmrate <= pdmrate -1;
			end if;	

			rateacc <= rateacc +	('0' & ratereg);
			oldratemsb <= ratemsb;

			if ratemsb /= oldratemsb then
				if ptableptr >= lengthreg then
					ptableptr <= (others => '0');
				else	
					ptableptr <= ptableptr +1;
				end if;
			end if;
			pdmval <= ptabledata(pdmwidth-2 downto 0);
			triggerreg <= ptabledata(15 downto 12);
		
			if loadtableptr = '1' then
				htableptr <= ibus(7 downto 0);  -- no need to sync
			end if;
		
			if loadpdmrate = '1' then
				pdmratereg <= ibus(7 downto 0);
			end if;	

			if loadrate = '1' then
				ratereg <= ibus(15 downto 0);
			end if;	

			if loadlength = '1' then
				lengthreg <= ibus(7 downto 0);
			end if;	

		end if; -- clk	
		pdmval <= ptabledata(pdmwidth-2 downto 0);
		
		pdmouta <= pdmbit; 			-- push pull pdm
		pdmoutb <= not pdmbit;	
		trigger0 <= triggerreg(0);
		trigger1 <= triggerreg(1);
		trigger2 <= triggerreg(2);
		trigger3 <= triggerreg(3);
		
	end process;
end behavioral;

