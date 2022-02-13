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


entity dpainterd is
        generic (
			buswidth : integer;
			asize : integer;
			rsize : integer;
			usedpll : boolean
			);
			Port ( clk : in std_logic;
	 		  ibus : in std_logic_vector(buswidth-1 downto 0);
           obus : out std_logic_vector(buswidth-1 downto 0);
           loadrate : in std_logic;
			  loadaccum : in std_logic;
			  loadmode0 : in std_logic;
			  loadmode1 : in std_logic;
			  loadstartcomp : in std_logic;
			  loadstopcomp : in std_logic;
			  push : in std_logic;
           readrate : in std_logic;
			  readaccum : in std_logic;
			  readmode0 : in std_logic;
			  readmode1 : in std_logic;
			  readstartcomp : in std_logic;
			  readstopcomp : in std_logic;
			  timers : in std_logic_vector;
           videodataout : out std_logic;
			  videoclkout : out std_logic
          );
end dpainterd;

architecture Behavioral of dpainterd is


-- data painter related signals

	signal rateaccum: std_logic_vector(asize-1 downto 0);
	signal ratelatch: std_logic_vector(buswidth-1 downto 0);
	signal countlatch: std_logic_vector(buswidth-1 downto 0);
	signal nextaccum: std_logic_vector(asize-1 downto 0);
	signal startcomp: std_logic_vector(asize-1 downto rsize);
	signal stopcomp: std_logic_vector(asize-1 downto rsize);
	alias ratemsb: std_logic is nextaccum(rsize);
	alias fiftypc: std_logic is rateaccum(rsize-1);
	alias pwmref: std_logic_vector(7 downto 0) is rateaccum(rsize-1 downto rsize-8);
	signal pwmval: std_logic_vector(7 downto 0);
	signal apwmval: std_logic_vector(7 downto 0);
	signal sapwmval: std_logic_vector(16 downto 0);
	signal pwmout: std_logic;
	signal dratemsb: std_logic;
	alias bitcount: std_logic_vector(asize-rsize-1 downto 0) is rateaccum(asize-1 downto rsize);	
	signal shiftcount: std_logic_vector(4 downto 0);
	signal datagate: std_logic;
	signal rawdata: std_logic;
	signal videodata: std_logic;
	signal videoclk: std_logic;
	signal underrunerror: std_logic; 
	
-- mode register bits	
	signal modereg0: std_logic_vector(31 downto 0);	
	alias programmode: std_logic is modereg0(0);
	alias programgate: std_logic is modereg0(1);
	alias offdata: std_logic is modereg0(2);
	alias hardpwmgate: std_logic is modereg0(3);
	alias enablestart: std_logic is modereg0(4);
	alias enablestop: std_logic is modereg0(5);
	alias clearfifo: std_logic is modereg0(6);
	alias	pwmscale: std_logic_vector(8 downto 0) is modereg0(31 downto 23);
	
	signal modereg1: std_logic_vector(31 downto 0);  -- room for expansion
	alias  vclkwidth: std_logic_vector(11 downto 0) is modereg1(11 downto 0);
	signal vclktimer: std_logic_vector(11 downto 0);
	alias  timerselect: std_logic_vector(3 downto 0) is modereg1(15 downto 12);
	alias  pwmmode: std_logic is modereg1(16);
	alias  fiftypcclk: std_logic is modereg1(17);
	alias  debugloop: std_logic is modereg1(23);
	alias  offpwm: std_logic_vector(7 downto 0) is modereg1(31 downto 24);
-- DPLL related signals
	signal timer : std_logic; 
	signal dtimer : std_logic; 
	signal sample : std_logic;


-- FIFO related signals
	signal pushdata: std_logic_vector(31 downto 0);
	signal popadd: std_logic_vector(4 downto 0) := "11111";
	signal popdata: std_logic_vector(31 downto 0);
	signal datacounter: std_logic_vector(5 downto 0);
--	signal push: std_logic;  
	signal pop: std_logic;  
	signal fifohasdata: std_logic; 
	signal overrunerror: std_logic; 
	
  component SRLC32E
--
    generic (INIT : bit_vector);


--
    port (D   : in  std_logic;
          CE  : in  std_logic;
          CLK : in  std_logic;
          A0  : in  std_logic;
          A1  : in  std_logic;
          A2  : in  std_logic;
          A3  : in  std_logic;
          A4  : in  std_logic;
          Q   : out std_logic;
			 Q31 : out std_logic);
  end component;
	
			
begin

	fifosrl: for i in 0 to 31 generate
		asr32e: SRLC32E generic map (x"00000000") port map(
 			 D	  => ibus(i),
          CE  => push,
          CLK => clk,
          A0  => popadd(0),
          A1  => popadd(1),
          A2  => popadd(2),
          A3  => popadd(3),
          A4  => popadd(4),
          Q   => popdata(i)
			);	
  	end generate;

	

	afifo: process (clk,popdata,datacounter)
	begin
		if rising_edge(clk) then
			
			if push = '1'  and pop = '0'  then
				if datacounter /= 32 then	-- a push
					-- always increment the data counter if not full
					datacounter <= datacounter +1;
					popadd <= popadd +1;						-- popadd must follow data down shiftreg
				else
					overrunerror <= '1';							-- push when full error
				end if;	
			end if;		 										
						   
			if  (pop = '1') and (push = '0') and (fifohasdata = '1') then	-- a pop
				-- always decrement the data counter if not empty
				datacounter <= datacounter -1;
				popadd <= popadd -1;
			end if;												

-- the other cases = if push=pop we dont change either counter
	  
			if clearfifo = '1' then -- a clear fifo
				popadd  <= (others => '1');
				datacounter <= (others => '0');
				overrunerror <= '0';
			end if;	
	

		end if; -- clk rise
		if datacounter = 0 then
			fifohasdata <= '0';
		else
			fifohasdata <= '1';
		end if;
	end process afifo;

	adpainterd: process (clk )
	begin
		if rising_edge(clk) then

			rateaccum <= nextaccum;
			
			if (ratemsb /= dratemsb) then 		-- up or down
				if datagate = '1' then
					if shiftcount = 0 then
						if fifohasdata = '1' then
							if debugloop = '0' then	--dont pop data if debug mode	
								pop <= '1';
							end if;
						else		-- data empty
							underrunerror <= '1';
							datagate <= '0';
							programgate <= '0';
						end if;
						if pwmmode = '0' then
							shiftcount <= "11111";
						else
							shiftcount <= "00011";
						end if;	
					else
						shiftcount <= shiftcount -1;
					end if; -- shiftcount = 0
					
					case shiftcount(1 downto 0) is
						when "11" => pwmval <= popdata(31 downto 24);
						when "10" => pwmval <= popdata(23 downto 16);
						when "01" => pwmval <= popdata(15 downto 8);
						when "00" => pwmval <= popdata(7 downto 0);
						when others => pwmval <= (others => '0');
					end case;	
				
				end if;	-- datagate = 1
				vclktimer <= vclkwidth;
			end if;
		
		
			if datagate = '1' then
				apwmval <= pwmval;	
				if pwmmode = '0' then
					rawdata <= popdata(conv_integer(shiftcount));
				else
					rawdata <= pwmout;
				end if;	
			else				-- gate off
				if pwmmode = '0' then
					rawdata <= offdata;		-- replace with off state data
				else								-- if gated off in pwm mode chose offpwm
					apwmval <= offpwm;
					if hardpwmgate = '0' then
						rawdata <= pwmout;		-- idle pwmdata if not hard gate mode
					else
						rawdata <= offdata;		-- otherwise use the single bit idle state
					end if;	
				end if;	
			end if;

			sapwmval <= (UNSIGNED(apwmval) * UNSIGNED(pwmscale));

			if (UNSIGNED(pwmref) < UNSIGNED(sapwmval(15 downto 8))) then	-- do we need to futz with this depending on direction?
				pwmout <= '1';
			else 
				pwmout <= '0';
			end if;	
			
			if pop = '1' then			-- just one clock
				pop <= '0';
			end if;	
			
			if vclktimer /= 0 then	--	setpulse width
				vclktimer <= vclktimer -1;
				videoclk <= '1';
			else
				videoclk <= '0';
			end if;
			
			
			if programmode = '1' then
				datagate <= programgate;
			else
				if enablestart = '1' and (bitcount = startcomp) then
					datagate <= '1';
					enablestart <= '0';
				end if;
				if enablestop = '1' and (bitcount = stopcomp) then
					datagate <= '0';
					enablestop <= '0';
				end if;
			end if;
				
			if sample = '1' then
				countlatch <= rateaccum(asize -1 downto asize-buswidth);
			end if;		
			
			if loadrate = '1' then
				ratelatch <= ibus(rsize -1 downto 0);
			end if;

			if loadaccum = '1' then
				rateaccum(asize -1 downto asize-buswidth) <= ibus;
				dratemsb <= ibus(buswidth-1);								-- avoid generating a count when loading accumulator
			end if;

			if loadstartcomp = '1' then					   			
				startcomp <= ibus((asize-rsize)-1 downto 0);
			end if;

			if loadstopcomp = '1' then					   				
				stopcomp <= ibus((asize-rsize)-1 downto 0);
			end if;

			if loadmode0 = '1' then					   					
				modereg0 <= ibus(31 downto 0);
			end if;
			
			if usedpll then								
				if loadmode1 = '1' then					   					
					modereg1 <= ibus(31 downto 0);
				end if;
			else
				if loadmode1 = '1' then					   					
					modereg1(11 downto 0) <= ibus(11 downto 0);
					modereg1(15 downto 12) <= (others => '0');
					modereg1(31 downto 16) <= ibus(31 downto 16);	
				end if;
			end if;
			
			if clearfifo = '1' then											
				underrunerror <= '0';
				if pwmmode = '0' then
					shiftcount <= "11111";
				else
					shiftcount <= "00011";
				end if;	
				clearfifo <= '0';
			end if;
			
			dratemsb <= ratemsb;
			dtimer <= timer;
			videodata <= rawdata;
		end if; -- clk									
		
		nextaccum <= signed(rateaccum)+ signed(ratelatch);				-- to lookahead
		
		case timerselect(2 downto 0) is
			when "000" => timer <= timers(0);
			when "001" => timer <= timers(1);
			when "010" => timer <= timers(2);
			when "011" => timer <= timers(3);
			when "100" => timer <= timers(4);	
			when others => timer <= timers(0);
		end case;						
		
		if (timer = '1' and dtimer = '0') or (timerselect(3) = '0') then 		-- rising edge of selected timer
			sample <= '1';
		else
			sample <= '0';
		end if;
      
		obus <= (others => 'Z');     

		if readrate =  '1' then
			obus <= ratelatch;
		end if;
		
		if readaccum =  '1' then
			obus <= countlatch;
		end if;
		
		if readmode0 =  '1' then
			obus(6 downto 0) <= modereg0(6 downto 0);
			obus(7) <= datagate;
			obus(13 downto 8) <= datacounter;
			obus(15 downto 14) <= (others => '0');
			obus(20 downto 16) <= shiftcount;
			obus(21) <= underrunerror;
			obus(22) <= overrunerror;
			obus(31 downto 23) <= pwmscale;		
		end if;

		if readmode1 =  '1' then
			obus <= modereg1;	
		end if;
			
		if readstartcomp = '1' then
			obus(15 downto 0) <= startcomp;
			obus(31 downto 16) <= (others => '0');		
		end if;
		
		if readstopcomp = '1' then
			obus(15 downto 0) <= stopcomp;
			obus(31 downto 16) <= (others => '0');		
		end if;
		
		videodataout <= videodata;
		
		if fiftypcclk = '0' then 
			videoclkout <= videoclk;
		else
			videoclkout <= fiftypc;
		end if;
		
	end process adpainterd;
	
end Behavioral;
