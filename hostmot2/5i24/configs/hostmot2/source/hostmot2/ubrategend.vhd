library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
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

entity rategend is
    Port ( ibus : in std_logic_vector(31 downto 0);
           obus : out std_logic_vector(31 downto 0);
           loadbasicrate : in std_logic;
           readbasicrate : in std_logic;
           loadtimerselect : in std_logic;
           readtimerselect : in std_logic;
			  hold : in std_logic;
           basicrate : out std_logic;
			  timers : in std_logic_vector(4 downto 0);
			  timer : out std_logic;
           timerenable : out std_logic;
           clk : in std_logic);
end rategend;

architecture Behavioral of rategend is

signal rateaccum: std_logic_vector (32 downto 0);
alias  ratemsb: std_logic is rateaccum(32);
signal oldratemsb: std_logic;
signal ratelatch: std_logic_vector (31 downto 0);
signal rateout: std_logic;
signal timerselect: std_logic_vector(3 downto 0);

begin

	rategend: process (clk,readbasicrate, ratelatch, timerselect, readtimerselect, timers, rateout)
	begin
		if rising_edge(clk) then
			if hold = '0' then
				rateaccum <= rateaccum + ratelatch;			
			end if;
			if oldratemsb /= ratemsb then
				rateout <= '1';
			else
				rateout <= '0';
			end if;	 
			oldratemsb <= ratemsb;
			if loadbasicrate = '1' then
				ratelatch <= ibus;
				rateaccum <= (others => '0');
			end if;
			if loadtimerselect = '1' then
				timerselect <= ibus(15 downto 12);
			end if;	
		end if; -- clk

		obus <= (others => 'Z');

		if readbasicrate = '1' then
			obus <= ratelatch;
		end if;		

		if readtimerselect = '1' then
			obus(15 downto 12) <= timerselect;
			obus(11 downto 0) <= (others => '0');	
			obus(31 downto 16) <= (others => '0');	
		end if;	
		
		case timerselect(2 downto 0) is
			when "000" => timer <= timers(0);
			when "001" => timer <= timers(1);
			when "010" => timer <= timers(2);
			when "011" => timer <= timers(3);
			when "100" => timer <= timers(4);	
			when others => timer <= timers(0);
		end case;
		
		timerenable <= timerselect(3);			
		basicrate <= rateout;
	 end process;
		
end Behavioral;
