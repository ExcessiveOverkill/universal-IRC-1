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

entity irqlogics is
    generic ( 
			buswidth : integer
			);		
	 port ( 
			clk : in  std_logic;
         ibus : in  std_logic_vector (buswidth-1 downto 0);
         obus : out  std_logic_vector (buswidth-1 downto 0);
         loadstatus : in  std_logic;
         readstatus : in  std_logic;
         clear : in  std_logic;
         ratesource : in  std_logic_vector (4 downto 0);
         int : out  std_logic);
end irqlogics;

architecture Behavioral of irqlogics is

signal statusreg : std_logic_vector(4 downto 0);
alias mask : std_logic is statusreg(1);
alias irqff : std_logic is statusreg(0);
alias ratesel : std_logic_vector(2 downto 0) is statusreg(4 downto 2);
signal rated : std_logic_vector(1 downto 0);
signal rate : std_logic;

begin
	-- changed to rising edge 8/16 to match DPLL source
	PeriodicIRQlogic : process (clk,statusreg,irqff,readstatus,ratesource)
	begin
		if rising_edge(clk) then
			rated  <= rated(0) & rate;
			if loadstatus = '1' then 
				statusreg <= ibus(4 downto 0);
			end if;	
			if rated = "01" then					-- rising edge of rate source
				irqff <= '1';
			end if; -- rate rising edge
			if clear = '1' then
				irqff <= '0';
			end if;		
		end if; -- (clk)	
		obus <= (others => 'Z');
		if readstatus = '1' then
			obus(4 downto 0) <= statusreg;
			obus(buswidth-1 downto 5) <= (others => '0');
		end if;
		int <= not (irqff and mask);							-- fixed active low interrupt
		rate <= ratesource(CONV_INTEGER(ratesel));		-- we chose ratesource from appropriate timer
	end process;

end Behavioral;

