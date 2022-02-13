
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


entity scalercounter is
    Port ( obus : out  std_logic_vector (31 downto 0);
           countina : in  std_logic;
           countinb : in  std_logic;
           readcount : in  std_logic;
           readlatch : in  std_logic;
           latch : in  std_logic;
           clk : in  std_logic);
end scalercounter;

architecture Behavioral of scalercounter is
signal CountA : std_logic_vector(15 downto 0);
signal CountB : std_logic_vector(15 downto 0);
signal CountFilterA : std_logic_vector(1 downto 0);
signal CountFilterB : std_logic_vector(1 downto 0);
signal CountLatchA : std_logic_vector(15 downto 0);
signal CountLatchB : std_logic_vector(15 downto 0);
signal FilterA : std_logic;
signal FilterB : std_logic;
signal FilterAD : std_logic;
signal FilterBD : std_logic;

begin

	acounter: process (clk)
	begin
		if rising_edge(clk) then
			if countina = '1' then
				if CountFilterA /= "11" then
					CountFilterA <= CountFilterA +1;
				end if;
			end if;		
			if countina = '0' then
				if CountFilterA /= "00" then
					CountFilterA <= CountFilterA -1;
				end if;
			end if;		
			
			if countinb = '1' then
				if CountFilterB /= "11" then
					CountFilterB <= CountFilterB +1;
				end if;
			end if;		
			if countinb = '0' then
				if CountFilterB /= "00" then
					CountFilterB <= CountFilterB -1;
				end if;
			end if;	
			
			if CountFilterA = "11" then 
				FilterA <= '1'; 
			end if;
			if CountFilterA = "00" then 
				FilterA <= '0';
			end if;
			if CountFilterB = "11" then 
				FilterB <= '1';
			end if;
			if CountFilterB = "00" then 
				FilterB <= '0';
			end if;
			
			FilterAD <= FilterA;
			FilterBD <= FIlterB;

			if FilterA = '1' and FilterAD = '0' then
				CountA <= CountA +1;
			end if;	

			if FilterB = '1' and FilterBD = '0' then
				CountB <= CountB +1;
			end if;	
			if latch = '1' then
				CountLatchA <= CountA;
				CountLatchB <= CountB;
			end if;
		end if; -- clk	
		obus <= (others => 'Z');
		if readcount = '1' then
			obus(15 downto 0) <= CountA;
			obus(31 downto 16) <= CountB;		
		end if;
		if readlatch = '1' then
			obus(15 downto 0) <= CountLatchA;
			obus(31 downto 16) <= CountLatchB;		
		end if;
	end process;	
end Behavioral;

