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

use work.log2.all;

entity DAQFIFO16 is
	generic (
		Depth : integer  	-- and when parametized, width as well
			);
    port ( clk : in  std_logic;
			  ibus : in  std_logic_vector (31 downto 0);
           obus : out  std_logic_vector (31 downto 0);
           readfifo : in  std_logic;
           readfifocount : in  std_logic;
           clearfifo : in  std_logic;
           loadmode : in  std_logic;
           readmode : in  std_logic;
			  pushfrac : in std_logic;
           daqdata : in  std_logic_vector (15 downto 0);
			  daqfull : out std_logic;
			  daqreq : out std_logic;
           daqstrobe : in  std_logic );
end DAQFIFO16;

architecture Behavioral of DAQFIFO16 is

signal pushadd: std_logic_vector(log2(depth)-1 downto 0);
signal pushdata: std_logic_vector(31 downto 0);
signal popadd: std_logic_vector(log2(depth)-1 downto 0);
signal popdata: std_logic_vector(31 downto 0);
signal datacounter: std_logic_vector(log2(depth) downto 0);
signal push: std_logic;  -- the write enable for our dual ported RAM
signal pop: std_logic;  
signal oddword: std_logic; 
signal syncpush: std_logic; 
signal modereg: std_logic_vector(31 downto 0);
alias strobepol: std_logic is modereg(0);		-- 0 for falling edge, 1 for rising edge
alias underflow: std_logic is modereg(1);		-- read (pop) without data
alias overflow: std_logic is modereg(2);		--	write (push) when FIFO full
alias dreqthresh: std_logic_vector(log2(depth)-1 downto 0) is modereg(log2(depth)+15 downto 16);
signal strobepipe: std_logic_vector(1 downto 0);
signal datapipe0: std_logic_vector(15 downto 0);
signal datapipe1: std_logic_vector(15 downto 0);
signal evenwordlatch: std_logic_vector(15 downto 0);
signal ldaqreq: std_logic; 
begin
	daqram : entity work.dpram 
	generic map (
		width => 32,
		depth => Depth
				)
	port map(
		addra => pushadd,
		addrb => popadd,
		clk  => clk,
		dina  => pushdata,
--		douta => 
		doutb => popdata,
		wea	=> push
	);	 
	
	
	adaqfifo: process (clk,strobepipe, strobepol, oddword, pushfrac, datapipe1, evenwordlatch, 
	                   datacounter, readfifo, popdata, readfifocount, readmode, modereg, ldaqreq)
	begin
		if clk'event and clk = '1' then
			-- first the FIFO pointer management
			if push = '1' and pop = '0' then		-- a push			 			
				datacounter <= datacounter + 1;
				pushadd <= pushadd + 1;				
			end if;				
		
			if  pop = '1' and push = '0' then	-- a pop						
				datacounter <= datacounter -1;
				popadd <= popadd + 1;
			end if;
				if  pop = '1' and push = '1' then	-- a push and a pop						
				popadd <= popadd + 1;
				pushadd <= pushadd + 1;
			end if;
				-- if neither push nor pop, do nothing... --
  
			if clearfifo = '1' then 
				pushadd <= (others => '0');
				popadd  <= (others => '0');
				datacounter <= (others => '0');
				oddword <= '0';
			end if;	
			
			if syncpush = '1' and datacounter = depth then
				overflow <= '1';
			end if;
			
			if  readfifo = '1'  and datacounter = 0 then
				underflow <= '1';
			end if;	
			
			-- then the data acq stuff
			strobepipe <= strobepipe(0) & daqstrobe;
			datapipe1 <= datapipe0;
			datapipe0 <= daqdata;
			
			if (strobepipe(0) = '1' and strobepipe(1) = '0' and strobepol = '1') 			-- rising edge
			or (strobepipe(0) = '0' and strobepipe(1) = '1' and strobepol = '0') then	-- falling edge
				if oddword = '0' then
					evenwordlatch <= datapipe1;
					oddword <= '1';
				else
					oddword <= '0';
				end if;	
			end if;
			
			if loadmode = '1' then
				modereg <= ibus;
			end if;	
			
		end if; -- clk rise
		if (((strobepipe(0) = '1' and strobepipe(1) = '0' and strobepol = '1') 			
		or (strobepipe(0) = '0' and strobepipe(1) = '1' and strobepol = '0')) and oddword = '1') or pushfrac = '1' then						
			syncpush <= '1';
		else
			syncpush <= '0';
		end if;	
	
		pushdata <= datapipe1 & evenwordlatch;				-- 32 bit push data is 
	
		if syncpush = '1' and datacounter /= depth then
			push <= '1';
		else
			push <= '0';
		end if;
		
		if  readfifo = '1'  and datacounter /= 0 then
			pop <= '1';
		else			
			pop <= '0';
		end if;
		
		obus <= (others => 'Z');
		if readfifo = '1' then
			obus <= popdata;
		end if;
		
		if  readfifocount = '1'  then
			obus(log2(Depth) downto 0) <= datacounter;
			obus(23 downto log2(Depth)+1) <= (others => '0');
			obus(31 downto 25) <= (others => '0');
			obus(24) <= oddword;		-- eventually if this gets parametized the piece count goes here				
		end if;
		
		if readmode = '1' then
			obus(31 downto 4) <= modereg(31 downto 4);
			obus(3) <= ldaqreq;
			obus(2 downto 0) <= modereg(2 downto 0);
		end if;	
		
		if datacounter = depth then
			daqfull <= '1';
		else
			daqfull <= '0';
		end if;	
	
		if (datacounter >= dreqthresh) then
			ldaqreq <= '1';			
		else
			ldaqreq <= '0';
		end if;	
		daqreq <= ldaqreq;
		
	end process;
end Behavioral;

