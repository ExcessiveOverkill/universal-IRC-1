
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

--
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
-- 

entity xfrmrout is
    generic ( clock : integer;
	            pins : integer);
	 port ( ibus : in  std_logic_vector (31 downto 0);
			  obus : out std_logic_vector(31 downto 0);	
           loadrate : in  std_logic;
			  readrate : in  std_logic;
			  loaddata : in  std_logic; 
			  readdata : in  std_logic;
           acout : out std_logic_vector(pins-1 downto 0);
			  acref : out std_logic;
			  clk : in std_logic
			  );
end xfrmrout;

architecture Behavioral of xfrmrout is

constant defaultdivisor : real := round((real(clock/2)/1000000.0)) -2.0; -- default driverate is 1.00 MHz
                                                                       -- 
signal rate: std_logic_vector(11 downto 0) := std_logic_vector(to_unsigned(integer(defaultdivisor),12)); 
signal count: std_logic_vector(11 downto 0);
alias  countmsb: std_logic is  count(11);
signal enable: std_logic := '0';
signal toggle: std_logic;
signal preacout: std_logic;
signal preacoutd: std_logic;
signal datareg: std_logic_vector(pins-1 downto 0);

begin
	arate: process (clk,count,readrate,rate,enable,readdata,datareg,
						 preacoutd,preacout)
	begin
		report("Xfrmr rate divisor: "& real'image(defaultdivisor));
		report("Xfrmr pins: "& integer'image(pins));
		if rising_edge(clk) then	
			if countmsb= '0' then 
				count <= count -1;
			else
				count <= rate;
				toggle <= not toggle;
			end if;
			if loadrate = '1' then
			   rate <= ibus(11 downto 0);
				enable <= ibus(12);
			end if;
			if enable = '1' then 
				preacout <= toggle;
			else
				preacout <= '0';
			end if;
			if loaddata = '1' then
				datareg <= ibus(pins-1 downto 0);
			end if;	
		end if;	

		if falling_edge(clk) then				
			preacoutd <= preacout;
		end if;
	
		obus <= (others => 'Z');
		
		if readrate = '1' then
		   obus(11 downto 0) <= rate;
			obus(12) <= enable;
			obus(31 downto 13) <= (others => '0');
		end if;
		
		if readdata = '1' then
		   obus(pins-1 downto 0) <= datareg;
			obus(31 downto pins) <= (others => '0');
		end if;

		for i in 0 to pins-1 loop
			acout(i) <= preacoutd xor datareg(i);
		end loop;

		acref <= preacout;	
	end process;
end Behavioral;
