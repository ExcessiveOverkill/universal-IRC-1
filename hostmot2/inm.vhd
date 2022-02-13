library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;
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
use work.log2.all;

entity inm is									-- simple input filter 32 bits max
			generic (							-- note that this somewhat wastefully mimics
				buswidth : integer := 32;	-- the external mux version (inmuxm) but this allows
				inwidth : integer				-- easy complete register level compatibility
				);
			Port (
				clk: in std_logic;
				ibus: in std_logic_vector (buswidth -1 downto 0);
				obus: out std_logic_vector (buswidth -1 downto 0);
				loadcontrol: in std_logic;
				readcontrol: in std_logic;
				loadfilter: in std_logic;
				readfilter: in std_logic;
				readfiltereddata: in std_logic;
				readrawdata: in std_logic;
				readmpg: in std_logic;				
				loadmpg: in std_logic;
				indata: in std_logic_vector(31 downto 0)
			);
end inm;

architecture behavioral of inm is
signal controlreg: std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(integer(inwidth-1),32));
alias maxcount: std_logic_vector(4 downto 0) is controlreg(4 downto 0);
alias globalinvert: std_logic is controlreg(5);
alias ratediv: std_logic_vector(9 downto 0) is controlreg(15 downto 6);
alias timelong: std_logic_vector(9 downto 0) is controlreg(31 downto 22);
alias timeshort: std_logic_vector(5 downto 0) is controlreg(21 downto 16);
signal ratecount: std_logic_vector(9 downto 0);
signal rawdata: std_logic_vector(inwidth -1 downto 0);
signal filtereddata: std_logic_vector(inwidth -1 downto 0);
signal filterreg: std_logic_vector(inwidth -1 downto 0);
type filtercounttype is array(inwidth -1 downto 0) of std_logic_vector(9 downto 0);
signal filtercount: filtercounttype;
signal muxdatad: std_logic;
signal gfcount: std_logic_vector(2 downto 0);
signal gfdata: std_logic;
signal muxcount: std_logic_vector(4 downto 0);
signal prescale: std_logic_vector(1 downto 0);
signal index: integer;
-- mpg signals
type mpgcounttype is array(3 downto 0) of std_logic_vector(7 downto 0);
signal mpgcounter: mpgcounttype;
alias  mpgin: std_logic_vector(7 downto 0) is filtereddata(7 downto 0);
signal mpgind: std_logic_vector(7 downto 0);
signal mpgmode: std_logic_vector(3 downto 0);

begin
	ainm: process  (clk,
                      controlreg, 
							 indata, 
							 ibus) 
	begin
		if rising_edge(clk) then
			prescale <= prescale +1;			
			if prescale = 0 then
			
				if ratecount /= 0 then
					ratecount <= ratecount -1;
				else 															-- for every scanned pin	
					ratecount <= ratediv;
					index <= to_integer(unsigned(muxcount));		-- note 1 muxcount pipeline delay
					rawdata(index) <= indata(index);							--	  
					if rawdata(integer(index)) = '1' then			-- count up
						if filterreg(index) = '1' then				-- if filter bit is 1 use timelong
							if filtercount(index) < timelong then		
								filtercount(index) <= filtercount(index) +1;
							end if;
							if filtercount(index) = timelong then
								filtereddata(index) <= '1';
							end if;	
						else
							if filtercount(index) < "0000"&timeshort then		-- if filter bit is 0 use timeshort
								filtercount(index) <= filtercount(index) +1;
							end if;
							if filtercount(index) >= "0000"&timeshort then
								filtereddata(index) <= '1';
							end if;	
						end if;
					else													-- count down
						if filtercount(index) > 0 then
							filtercount(index) <= filtercount(index) -1;
						end if;
						if filtercount(index) = 0 then
							filtereddata(index) <= '0';
						end if;	
					end if;
				
						
					if muxcount /= 0 then
						muxcount <= muxcount-1;
					else	
						muxcount <= maxcount;
					end if;
				
				end if;  -- ratecount=0
			end if; -- prescale = 0
			if loadcontrol = '1' then
				controlreg(31 downto 5) <= ibus(31 downto 5); -- mux max count (4 downto 0) is read only
			end if;
			if loadfilter = '1' then
				filterreg <= ibus(inwidth-1 downto 0);
			end if;
			if loadmpg = '1' then
				mpgmode(0) <= ibus(0);
				mpgmode(1) <= ibus(8);
				mpgmode(2) <= ibus(16);
				mpgmode(3) <= ibus(24);
			end if;
			
			mpgind <= mpgin;
			for i in 0 to 3 loop	   
				if mpgmode(i) = '0' then	-- 1X mode
					if ( mpgind(i*2) = '0' and mpgin(i*2) = '1' and mpgin(i*2+1) = '1') then 	-- rising A when B high		   
						mpgcounter(i) <= mpgcounter(i) + 1; 	
					end if;			
					if ( mpgind(i*2) = '1' and mpgin(i*2) = '0' and mpgin(i*2+1) = '1') then	-- falling A when B high   
					mpgcounter(i) <= mpgcounter(i) - 1;
					end if;		
				else	-- 4X  mode
					if ((mpgin(i*2) = '0'  and mpgind(i*2+1) = '0' and mpgin(i*2+1) = '1')  or 
					(mpgind(i*2) = '0' and mpgin(i*2) = '1'    and mpgin(i*2+1) = '1')  or
					(mpgind(i*2) = '1' and mpgin(i*2) = '0'    and mpgin(i*2+1) = '0')  or
					(mpgin(i*2) = '1'  and mpgind(i*2+1) = '1' and mpgin(i*2+1) = '0')) then
						mpgcounter(i) <= mpgcounter(i) + 1;
					end if;	
					if	((mpgind(i*2) = '0' and mpgin(i*2) = '1'   and mpgin(i*2+1) = '0')  or
					(mpgin(i*2) = '0' and mpgind(i*2+1) = '1' and mpgin(i*2+1) = '0')  or
					(mpgin(i*2) = '1' and mpgind(i*2+1) = '0' and mpgin(i*2+1) = '1')  or
					(mpgind(i*2) = '1' and mpgin(i*2) = '0'   and mpgin(i*2+1) = '1')) then		   
						mpgcounter(i) <= mpgcounter(i) - 1;
					end if;
				end if;
			end loop;
				
		end if; -- clk	
      obus <= (others => 'Z');     

		if readcontrol = '1' then 
			obus <= controlreg;
		end if;
		if readfilter = '1' then 
			obus(inwidth-1 downto 0) <= filterreg;
			obus(Buswidth-1 downto inwidth) <= ( others => '0' );
		end if;
		if readfiltereddata = '1' then 
			obus(inwidth-1 downto 0) <= filtereddata;
			obus(Buswidth-1 downto inwidth) <= ( others => '0' );
		end if;
		if readrawdata = '1' then 
			obus(inwidth-1 downto 0) <= rawdata;
			obus(Buswidth-1 downto inwidth) <= ( others => '0' );
		end if;
		if readmpg = '1' then 
			obus<= mpgcounter(3) & mpgcounter(2) & mpgcounter(1) & mpgcounter(0);
		end if;
		
	end process;

end behavioral;

