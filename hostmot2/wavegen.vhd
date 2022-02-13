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

entity wavegen is
	generic (
		buswidth : integer := 32;
		pdmwidth : integer := 13  --13 max
		);    
	port (
		clk: in std_logic;
		hclk: in std_logic;
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
end wavegen;

architecture behavioral of wavegen is
signal rateacc: std_logic_vector (32 downto 0);
alias ratemsb: std_logic is rateacc(32);
signal oldratemsb: std_logic;

signal pdmrate: std_logic_vector (7 downto 0);
alias pdmratemsb: std_logic is pdmrate(7);
signal pdmval: std_logic_vector (pdmwidth-2 downto 0);
signal pdmaccum: std_logic_vector (pdmwidth-1 downto 0);
alias pdmbit: std_logic is pdmaccum(pdmwidth-1);

signal ptabledata: std_logic_vector (15 downto 0);  -- need to parametize
signal htableptr: std_logic_vector (9 downto 0);
signal ptableptr: std_logic_vector (9 downto 0);

signal hratereg: std_logic_vector(31 downto 0);
signal ratereg: std_logic_vector(31 downto 0);
signal loadratereq: std_logic;
signal oldloadratereq: std_logic;
signal olderloadratereq: std_logic;

signal hlengthreg: std_logic_vector(9 downto 0);
signal plengthreg: std_logic_vector(9 downto 0);
signal loadlengthreq: std_logic;
signal oldloadlengthreq: std_logic;
signal olderloadlengthreq: std_logic;

signal pdmratereg: std_logic_vector (7 downto 0);
signal hpdmratereg: std_logic_vector (7 downto 0);
signal loadpdmratereq: std_logic;
signal oldloadpdmratereq: std_logic;
signal olderloadpdmratereq: std_logic;

signal htabledatareg: std_logic_vector (15 downto 0);
signal hhtabledatareg: std_logic_vector (15 downto 0);
signal loadhtabledatareq: std_logic;
signal oldloadhtabledatareq: std_logic;
signal olderloadhtabledatareq: std_logic;

signal premwrite: std_logic;
signal mwrite: std_logic;

signal triggerreg: std_logic_vector(3 downto 0);
	 
begin
   -- 1024 long max, 12 bit resolution max + 4 trigger bits 
	waveram : entity work.waveram 
	port map(
		addra => htableptr(9 downto 0),
		addrb => ptableptr(9 downto 0),
		clk  => hclk,
		dina  => htabledatareg,
   	doutb => ptabledata,
		wea	=> mwrite
	 );
	 
	awavegen: process  (hclk,clk,ptabledata, olderloadhtabledatareq, olderloadratereq,
                       olderloadpdmratereq, olderloadlengthreq, pdmaccum, triggerreg)							
	begin
		if rising_edge(hclk) then	  		
			
			if pdmratemsb = '1' then
				pdmaccum <= ('0'&pdmaccum(pdmwidth-2 downto 0)) + ('0'&pdmval);
				pdmrate <= pdmratereg;	
			else
				pdmrate <= pdmrate -1;
			end if;	

			rateacc <= rateacc +	('0' & ratereg);
			oldratemsb <= ratemsb;

			-- bus speed to pdm speed register write sync

			if oldloadratereq = '1' and olderloadratereq ='1' then
 		   	ratereg <= hratereg;			
			end if;
			olderloadratereq <= oldloadratereq;
			oldloadratereq <= loadratereq;

			if oldloadlengthreq = '1' and olderloadlengthreq ='1' then
 		   	plengthreg <= hlengthreg;			
			end if;
			olderloadlengthreq <= oldloadlengthreq;
			oldloadlengthreq <= loadlengthreq;

			if oldloadpdmratereq = '1' and olderloadpdmratereq ='1' then
 		   	pdmratereg <= hpdmratereg;			
			end if;
			olderloadpdmratereq <= oldloadpdmratereq;
			oldloadpdmratereq <= loadpdmratereq;

			mwrite <= premwrite;		-- mwrite 1 clock after register
			
			if oldloadhtabledatareq = '1' and olderloadhtabledatareq ='1' then
 		   	htabledatareg <= hhtabledatareg;	
				premwrite <= '1';
			else
				premwrite <= '0';
			end if;
			olderloadhtabledatareq <= oldloadhtabledatareq;
			oldloadhtabledatareq <= loadhtabledatareq;


			if ratemsb /= oldratemsb then
				if ptableptr >= plengthreg then
					ptableptr <= (others => '0');
				else	
					ptableptr <= ptableptr +1;
				end if;
			end if;
		pdmval <= ptabledata(pdmwidth-2 downto 0);
		triggerreg <= ptabledata(15 downto 12);
		end if; -- hclk	
		pdmval <= ptabledata(pdmwidth-2 downto 0);
		
		if rising_edge(clk) then -- 33/48/50 mhz local bus clock			

			if loadtableptr = '1' then
				htableptr <= ibus(9 downto 0);  -- no need to sync
			end if;
			
			if loadtabledata = '1' then
				hhtabledatareg <= ibus(15 downto 0);
				loadhtabledatareq <= '1';
			end if;	
			
			if loadpdmrate = '1' then
				hpdmratereg <= ibus(7 downto 0);
				loadpdmratereq <= '1';
			end if;	

			if loadrate = '1' then
				hratereg <= ibus(31 downto 0);
				loadratereq <= '1';
			end if;	

			if loadlength = '1' then
				hlengthreg <= ibus(9 downto 0);
				loadlengthreq <= '1';
			end if;	
		end if; -- clk

		if olderloadhtabledatareq = '1' then -- asynchronous request clear  
			loadhtabledatareq <= '0';			 -- if only I had used read and write strobes 	
		end if;								 		-- these would have folded up into a single slowstrobe-faststrobe 
		
		if olderloadratereq = '1' then -- asynchronous request clear ""
			loadratereq <= '0';
		end if;	
		
		if olderloadpdmratereq = '1' then -- asynchronous request clear ""
			loadpdmratereq <= '0';
		end if;	

		if olderloadlengthreq = '1' then -- asynchronous request clear ""
			loadlengthreq <= '0';
		end if;	
		
		pdmouta <= pdmbit; 			-- push pull pdm
		pdmoutb <= not pdmbit;	
		trigger0 <= triggerreg(0);
		trigger1 <= triggerreg(1);
		trigger2 <= triggerreg(2);
		trigger3 <= triggerreg(3);
		
	end process;
end behavioral;

