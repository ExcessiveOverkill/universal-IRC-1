library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

--
-- Copyright (C) 2018, Peter C. Wallace, Mesa Electronics
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


entity simpledsad is
	 generic (
		buswidth: integer;
		channels: integer
		);	
	port ( 
		clk : in std_logic;
		ibus : in std_logic_vector(buswidth-1 downto 0);
		obus : out std_logic_vector(buswidth-1 downto 0);
		a : in std_logic_vector(3 downto 0);
		readdata : in std_logic;
		loadcontrol : in std_logic;
		compin_p : in std_logic_vector(channels-1 downto 0);
		compin_n : in std_logic_vector(channels-1 downto 0);
		fbout : out std_logic_vector(channels-1 downto 0);
		pwmout : out std_logic
		 );
end simpledsad;

architecture behavioral of simpledsad is

-- ssi interface related signals

signal compin: std_logic_vector(channels-1 downto 0);
signal count: std_logic_vector(15 downto 0);
signal bits: std_logic_vector(3 downto 0);
signal pwmval: std_logic_vector(11 downto 0);
signal pwmcount: std_logic_vector(11 downto 0);
signal pwmbit: std_logic;
signal msb: std_logic;
signal msbd: std_logic;
type datatype is array(channels -1 downto 0) of std_logic_vector(15 downto 0);
signal data: datatype;
type datalatchtype is array (channels -1 downto 0) of std_logic_vector(15 downto 0);
signal datalatch: datalatchtype;
signal flip: std_logic_vector(channels-1 downto 0);
signal chanindex: integer range 0 to 15;

begin 

ibufs: for i in 0 to channels-1 generate
	compbuf : IBUFDS
		generic map (
			DIFF_TERM => FALSE,
			IBUF_LOW_PWR => TRUE,
			IOSTANDARD => "DEFAULT")
		port map (
			O  => compin(i),
			I  => compin_p(i),
			IB => compin_n(i)
		);
end generate ibufs;

	asimpledsad: process (clk,readdata,a,datalatch,flip,pwmbit)
	begin
		if rising_edge(clk) then
			pwmcount <= pwmcount+1;
			if pwmval < pwmcount then
				pwmbit <= '0';
			else
				pwmbit <= '1';
			end if;	
			msbd <= msb;
			for i in 0 to 15 loop		-- se bitsize
				if i=bits then
					msb <= count(i);
				end if;
			end loop;	
			count <= count+1;

			for i in 0 to channels -1 loop
				flip(i) <= compin(i);
				if flip(i) = '0' then
					data(i) <= data(i)+1;
				end if;	
				if msbd = '1' and msb = '0' then	-- free running for now
					datalatch(i) <= data(i);
					data(i) <= (others => '0');
				end if;
			end loop;	

			if loadcontrol = '1' then 
				bits <= ibus(3 downto 0);
				pwmval <= ibus(15 downto 4);
			end if;
		end if; -- clk
		
		obus <= (others => 'Z');
		if readdata =  '1' then			
			for i in 0 to channels -1 loop
				if a = i then
					obus(15 downto 0) <= datalatch(conv_integer(a));
					obus(buswidth -1 downto 16) <= (others => '0');
				end if;
			end loop;
		end if;	
		
		fbout <= flip;
		pwmout <= pwmbit;
		
	end process asimpledsad;

end Behavioral;
