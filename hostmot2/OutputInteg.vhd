library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
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

entity OutputInteg is		-- 8 channel integrator/accumulator with accumlators readable by host
    port ( dspdin : in  std_logic_vector (31 downto 0);
           dspdout : out  std_logic_vector (31 downto 0);
			  hostdout : out  std_logic_vector (31 downto 0);
           dspraddr : in  std_logic_vector (2 downto 0);
           dspwaddr : in  std_logic_vector (2 downto 0);
           hostaddr : in  std_logic_vector (2 downto 0);
           loadvel : in  std_logic;			
           loadrate : in  std_logic;
           dspread : in  std_logic;
           hostread : in  std_logic;
			  testout : out std_logic;
			  clk : in std_logic);
end OutputInteg;

architecture Behavioral of OutputInteg is
constant divwidth :integer := 16;
constant channels : integer := 8;
constant offset : integer := 8;			-- accumulator runs 256 times faster than host sample rate so sr by 8
constant csize : integer := log2(channels);
constant width : integer := 32;

signal acca: std_logic_vector(width-1 downto 0);
signal accb: std_logic_vector(width-1 downto 0);
signal accsum: std_logic_vector(width-1 downto 0);
signal rawhostdout: std_logic_vector(width-1 downto 0);
signal rawdspdout: std_logic_vector(width-1 downto 0);
signal offsetdin: std_logic_vector(width-1 downto 0);
signal smaddr: std_logic_vector(log2(channels)-1 downto 0);
signal smwrite: std_logic;
signal run: std_logic;
signal ratereg: std_logic_vector(divwidth-1 downto 0);
signal ratediv: std_logic_vector(divwidth-1 downto 0);
alias ratedivmsb: std_logic is ratediv(divwidth-1);
signal oldratedivmsb: std_logic;

begin

	inputdpram: entity work.dpram
	generic map (
		width => width,
		depth => channels
				)
	port map(
		addra => dspwaddr,
		addrb => smaddr,
		clk  => clk,
		dina  => offsetdin,
--		douta =>	 
		doutb => acca,
		wea	=> loadvel
		); 
	
	feedbackdpram: entity work.dpram
	generic map (
		width => width,
		depth => channels
				)
	port map(
		addra => smaddr,
		addrb => dspraddr,
		clk  => clk,
		dina  => accsum,
		douta => accb,
		doutb => rawdspdout,
		wea	=> smwrite
		); 

	outputdpram: entity work.dpram
	generic map (
		width => width,
		depth => channels
				)
	port map(
		addra => smaddr,
		addrb => hostaddr,
		clk  => clk,
		dina  => accsum,
--		douta => snugglebunnies,
		doutb => rawhostdout,
		wea	=> smwrite
		); 


	accumulator:  process(clk,acca,accb, dspdin, hostread, 
								 rawhostdout, dspread, rawdspdout, smwrite)		-- multi channel accumulator
	begin
		if rising_edge(clk) then
			ratediv <= ratediv + ratereg;
			if ratedivmsb /= oldratedivmsb then
				smaddr <= conv_std_logic_vector(0,csize);
				smwrite <= '0';	-- start channel processing at channel 0 read
				run <= '1';
			end if;	
				
			if run = '1' then
				if smwrite = '1' then -- if write asserted, increment channel
					if smaddr = conv_std_logic_vector(channels -1,csize) then 
						run <= '0';	-- if last channel stop till next rate req 
					else
						smaddr <= smaddr +1;
					end if;
				end if;						
				smwrite <= not smwrite;	-- alternate read/write per channel					
			end if;
		
			oldratedivmsb <= ratedivmsb;
		
			if loadrate = '1' then 
				ratereg <= dspdin(divwidth-1 downto 0);
			end if;
		
		end if; -- clk
		
		accsum <= acca + accb;
		
		offsetdin(width-offset-1 downto 0) <= dspdin(width-1 downto offset);
		if dspdin(width -1) = '1' then -- sign extend
			offsetdin(width-1 downto width-offset) <= (others => '1'); 
		else
			offsetdin(width-1 downto width-offset) <= (others => '0'); 
		end if;	
			
		
		hostdout <= (others => 'Z');
		if hostread = '1' then	
			hostdout <= rawhostdout;
		end if;

		dspdout <= (others => 'Z');
		if dspread = '1' then	
			dspdout <= rawdspdout;
		end if;
		
		testout <= smwrite;
	end process;	

end Behavioral;

