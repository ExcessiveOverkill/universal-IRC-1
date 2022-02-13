library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

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
use work.parity.all;


entity xy2mod is
        generic (
			shiftdiv : unsigned(7 downto 0);
			buswidth : integer;
			usedpll : boolean
			);
			Port ( 
           clk : in std_logic;
	 		  ibus : in std_logic_vector(buswidth-1 downto 0);
           obus : out std_logic_vector(buswidth-1 downto 0);
           loadaccelx : in std_logic;
           loadaccely : in std_logic;
           loadvelx : in std_logic;
           loadvely : in std_logic;
			  loadposx : in std_logic;
			  loadposy : in std_logic;
			  loadmode : in std_logic;
			  loadcommand : in std_logic;
			  loadtimerselcmd : in std_logic;
			  loadtimerselfb : in std_logic;
           readaccelx : in std_logic;
           readaccely : in std_logic;
           readvelx : in std_logic;
           readvely : in std_logic;
			  readposx : in std_logic;
			  readposy : in std_logic;
			  readmode : in std_logic;
			  readcommand : in std_logic;
			  readstatus : in std_logic;
			  readtimerselcmd : in std_logic;
			  readtimerselfb : in std_logic;
			  timers : in std_logic_vector;
           xdataout : out std_logic;
			  ydataout : out std_logic;
			  dataclkout : out std_logic;
			  syncout : out std_logic;
			  status : in std_logic
          );
end xy2mod;

architecture Behavioral of xy2mod is


-- serisl data related signals
	signal shiftdivcount: unsigned(7 downto 0);
	constant ssize: integer := 20;
	constant datasize16: integer := ssize-4;
	constant datasize18: integer := ssize-2;
 	signal xshiftreg: std_logic_vector(ssize-1 downto 0);
	signal yshiftreg: std_logic_vector(ssize-1 downto 0);
	signal statusshiftreg: std_logic_vector(ssize-1 downto 0);
	signal statusreg: std_logic_vector(ssize-1 downto 0);
	constant framediv: unsigned(4 downto 0) := to_unsigned(ssize-1,5);
	signal framedivcount: unsigned(4 downto 0);
	signal statuscount: unsigned(2 downto 0);
	signal filteredstatus: std_logic;
   signal commandx: std_logic_vector(15 downto 0);
   signal commandy: std_logic_vector(15 downto 0);
	signal accelscale: unsigned(11 downto 0);
	signal velscale: unsigned(7 downto 0);

	signal posx: signed(buswidth downto 0);
	signal galvoposx: std_logic_vector(datasize18-1 downto 0);
	signal velx: signed(buswidth-1 downto 0);
	signal nextvelx: signed(buswidth-1 downto 0);
	signal accelx: signed(buswidth-1 downto 0);
	signal poslatchx: signed(buswidth-1 downto 0);
	signal vellatchx: signed(buswidth-1 downto 0);
	signal poscmdlatchx: signed(buswidth downto 0);
	signal velcmdlatchx: signed(buswidth-1 downto 0);
	signal accelcmdlatchx: signed(buswidth-1 downto 0);
	signal poscmdlatchreqx: std_logic;
	signal velcmdlatchreqx: std_logic;
	signal accelcmdlatchreqx: std_logic;
	signal nextposx: signed(buswidth downto 0);

	signal posy: signed(buswidth downto 0);
	signal galvoposy: std_logic_vector(datasize18-1 downto 0);
	signal vely: signed(buswidth-1 downto 0);
	signal nextvely: signed(buswidth-1 downto 0);
	signal accely: signed(buswidth-1 downto 0);
	signal poslatchy: signed(buswidth-1 downto 0);
	signal vellatchy: signed(buswidth-1 downto 0);
	signal poscmdlatchy: signed(buswidth downto 0);
	signal velcmdlatchy: signed(buswidth-1 downto 0);
	signal accelcmdlatchy: signed(buswidth-1 downto 0);
	signal poscmdlatchreqy: std_logic;
	signal velcmdlatchreqy: std_logic;
	signal accelcmdlatchreqy: std_logic;
	signal nextposy: signed(buswidth downto 0);
	
-- mode register bits	
	signal modereg: std_logic_vector(15 downto 0);	
	alias controlbitsx: std_logic_vector(2 downto 0) is modereg(2 downto 0); 
	alias controlbitsy: std_logic_vector(2 downto 0) is modereg(5 downto 3); 
	alias  xposover: std_logic is modereg(6);	
	alias  yposover: std_logic is modereg(7);	
	alias  xvelover: std_logic is modereg(8);	
	alias  yvelover: std_logic is modereg(9);	
	alias mode18bitx: std_logic is modereg(10);
	alias mode18bity: std_logic is modereg(11);
	alias commandmodex: std_logic is modereg(12);
	alias commandmodey: std_logic is modereg(13);

-- DPLL related signals
	signal timerselect_fb : std_logic_vector(3 downto 0); 
	signal timerselect_cmd : std_logic_vector(3 downto 0); 
	signal timerfb : std_logic; 
	signal timercmd : std_logic; 
	signal dtimerfb : std_logic; 
	signal dtimercmd : std_logic; 
	signal samplefb : std_logic;
	signal updatecmd : std_logic;


-- output signals
	signal sync : std_logic;
	signal dataclk : std_logic;
	signal xdata : std_logic;
	signal ydata : std_logic;

begin
	axy2mod: process (clk )
	begin
		if rising_edge(clk) then
			dtimerfb <= timerfb;
			dtimercmd <= timercmd;
			
			-- simple 3 count digital filter on status input
			if status = '1' then
				if statuscount < 3 then  
					statuscount <= statuscount +1;
				end if;
			end if;	
			if status = '0' then
				if statuscount /= 0 then  
					statuscount <= statuscount -1;
				end if;
			end if;	
			if statuscount = 3 then
				filteredstatus <= '1';
			end if;	
			if statuscount = 0 then
				filteredstatus <= '0';
			end if;	
			
			accelscale <= accelscale -1;
			if accelscale = 0 then			-- accel scaled by 1/4096 = ~25 khz velocity update rate
				if (nextvelx > 1073741823) or (nextvelx < -1073741823) then   
					xvelover <= '1';		-- x velocity overflow				   
				else
					velx <= nextvelx;
				end if;

				if (nextvely > 1073741823) or (nextvely < -1073741823) then   
					yvelover <= '1';		-- y velocity overflow				   
				else
					vely <= nextvely;
				end if;
			end if;

			velscale <= velscale -1;
			if velscale = 0 then			-- velocity scaled by 1/256 = ~400 khz position update rate
				if (nextposx > 2147418112) or (nextposx < -2147418112) then   
					xposover <= '1';		-- x position overflow				   
				else
					posx <= nextposx;
				end if;

				if (nextposy > 2147418112) or (nextposy < -2147418112) then   
					yposover <= '1';		-- y position overflow				   
				else
					posy <= nextposy;
				end if;
			end if;
			shiftdivcount <= shiftdivcount -1;
			if shiftdivcount = 0 then						-- at 2 MHz
				shiftdivcount <= shiftdiv;
				framedivcount <= framedivcount -1;
				if framedivcount = 0 then					-- load shift registers
					galvoposx <= std_logic_vector(posx(buswidth-1 downto buswidth-datasize18) + 131072);		-- offset 1/2 way up
					galvoposy <= std_logic_vector(posy(buswidth-1 downto buswidth-datasize18) + 131072);		-- offset 1/2 way up
					framedivcount <= framediv;
					statusreg <= statusshiftreg;			-- capture status
					
					if mode18bitx = '1' then	-- 18 bit mode
						xshiftreg(datasize18 downto 1) <= galvoposx;
						xshiftreg(ssize-1) <= controlbitsx(2);
						xshiftreg(0) <= not parity(controlbitsx(2) & galvoposx); -- odd parity
					else 								-- 16 bit mode
					   xshiftreg(datasize16 downto 1) <= galvoposx(datasize18-1 downto 2);
					   xshiftreg(ssize-1 downto ssize-3) <= controlbitsx;
					   xshiftreg(0) <= parity(controlbitsx & galvoposx(datasize18-1 downto 2)); -- even parity
					end if;
					if commandmodex = '1' then
						xshiftreg(datasize16 downto 1) <= commandx;
						xshiftreg(ssize-1 downto ssize-3) <= controlbitsx;
						xshiftreg(0) <= parity(controlbitsx & commandx); -- even parity
					end if;
					
					if mode18bity = '1' then	-- 18 bit mode
						yshiftreg(datasize18 downto 1) <= galvoposy;
						yshiftreg(ssize-1) <= controlbitsy(2);
						yshiftreg(0) <= not parity(controlbitsy(2) & galvoposy); -- odd parity
					else 								-- 16 bit mode
					   yshiftreg(datasize16 downto 1) <=  galvoposy(datasize18-1 downto 2);
					   yshiftreg(ssize-1 downto ssize-3) <= controlbitsy;
					   yshiftreg(0) <= parity(controlbitsy & galvoposx(datasize18-1 downto 2)); -- even parity
					end if;
					if commandmodey = '1' then
						yshiftreg(datasize16 downto 1) <= commandy;
						yshiftreg(ssize-1 downto ssize-3) <= controlbitsy;
						yshiftreg(0) <= parity(controlbitsy & commandy); -- even parity
					end if;

				end if; --  framedivcount = 0 load shift registers

				if framedivcount /= 0 then
					xshiftreg <= xshiftreg(ssize-2 downto 0) & '0';	-- left shift
					yshiftreg <= yshiftreg(ssize-2 downto 0) & '0';	-- left shift
					statusshiftreg <= statusshiftreg(ssize-2 downto 0) & filteredstatus;	-- may need retiming	
				end if;	
				
			end if;-- shiftdivcount = 0

			if framedivcount = 0	then
				sync <= '1';
			else
				sync <= '0';
			end if;
			if shiftdivcount > ('0' & shiftdiv(7 downto 1)) then	-- roughly 50%
				dataclk <= '1';												-- starts high	
			else
				dataclk <= '0';
			end if;	

			xdata <= xshiftreg(ssize-1);	-- msb first							
			ydata <= yshiftreg(ssize-1);	-- msb first
			
			
			if samplefb = '1' then														
				poslatchx <= posx(31 downto 0);
				poslatchy <= posy(31 downto 0);
				vellatchx <= velx;
				vellatchy <= vely;
			end if;		
			
			if updatecmd = '1' then														
				if poscmdlatchreqx = '1' then
					posx <= poscmdlatchx; 
					poscmdlatchreqx <= '0';
				end if;	
				if poscmdlatchreqy = '1' then
					posy <= poscmdlatchy; 
					poscmdlatchreqy <= '0';
				end if;	
				if velcmdlatchreqx = '1' then
					velx <= velcmdlatchx;
					velcmdlatchreqx <= '0';
				end if;	
				if velcmdlatchreqy = '1' then
					vely <= velcmdlatchy;
					velcmdlatchreqy <= '0';
				end if;	
				if accelcmdlatchreqx = '1' then
					accelx <= accelcmdlatchx;
					accelcmdlatchreqx <= '0';
				end if;	
				if accelcmdlatchreqy = '1' then
					accely <= accelcmdlatchy;
					accelcmdlatchreqy <= '0';
				end if;	
			end if;		
		
			if loadaccelx = '1' then
				accelcmdlatchx <= signed(ibus);
				accelcmdlatchreqx <= '1';
			end if;

			if loadaccely = '1' then
				accelcmdlatchy <= signed(ibus);
				accelcmdlatchreqy <= '1';
			end if;

			if loadvelx = '1' then
				velcmdlatchx <= signed(ibus);
				velcmdlatchreqx <= '1';
			end if;

			if loadvely = '1' then
				velcmdlatchy <= signed(ibus);
				velcmdlatchreqy <= '1';
			end if;

			if loadposx = '1' then
				poscmdlatchx(31 downto 0) <= signed(ibus);
				if ibus(31) = '0' then
					poscmdlatchx(32) <= '0';
				else
					poscmdlatchx(32) <= '1';
				end if;	
				poscmdlatchreqx <= '1';
			end if;

			if loadposy = '1' then
				poscmdlatchy(31 downto 0) <= signed(ibus);
				if ibus(31) = '0' then
					poscmdlatchy(32) <= '0';
				else
					poscmdlatchy(32) <= '1';
				end if;	
				poscmdlatchreqy <= '1';
			end if;

			if loadmode = '1' then					   					
				modereg(5 downto 0) <= ibus(5 downto 0); -- the control bits
				if ibus(6) = '1' then 		-- clear position overflow flags by writing a '1'
					modereg(6) <= '0';			
				end if;
				if ibus(7) = '1' then 
					modereg(7) <= '0';			
				end if;
				if ibus(8) = '1' then 		-- clear velocity overflow flags by writing a '1'
					modereg(8) <= '0';			
				end if;
				if ibus(9) = '1' then 
					modereg(9) <= '0';			
				end if;
				modereg(13 downto 10) <= ibus(13 downto 10); -- more control bits
			end if;

			if loadcommand = '1' then					   					
				commandx <= ibus(15 downto 0);
				commandy <= ibus(31 downto 16);
			end if;
			
			if usedpll then								
				if loadtimerselfb = '1' then					   					
					timerselect_fb <= ibus(15 downto 12);
				end if;
				if loadtimerselcmd = '1' then					   					
					timerselect_cmd <= ibus(15 downto 12);
				end if;				
			end if;
			
		end if; -- clk									
		
		nextposx <= posx + velx;		
		nextposy <= posy + vely;
		nextvelx <= velx + accelx;
		nextvely <= vely + accely;
		
		case timerselect_fb(2 downto 0) is
			when "000" => timerfb <= timers(0);
			when "001" => timerfb <= timers(1);
			when "010" => timerfb <= timers(2);
			when "011" => timerfb <= timers(3);
			when "100" => timerfb <= timers(4);	
			when others => timerfb <= timers(0);
		end case;						
		
		if (timerfb = '1' and dtimerfb = '0') or (timerselect_fb(3) = '0') then 		-- rising edge of selected timer
			samplefb <= '1';																		-- or always if timerselect(3)=0				
		else
			samplefb <= '0';
		end if;

		case timerselect_cmd(2 downto 0) is
			when "000" => timercmd <= timers(0);
			when "001" => timercmd <= timers(1);
			when "010" => timercmd <= timers(2);
			when "011" => timercmd <= timers(3);
			when "100" => timercmd <= timers(4);	
			when others => timercmd <= timers(0);
		end case;						
		
		if (timercmd = '1' and dtimercmd = '0') or (timerselect_cmd(3) = '0') then 		-- rising edge of selected timer
			updatecmd <= '1';																		-- or always if timerselect(3)=0				
		else
			updatecmd <= '0';
		end if;
      
		obus <= (others => 'Z');     

		if readaccelx = '1' then
			obus <= std_logic_vector(accelx);
		end if;
		
		if readaccely = '1' then
			obus <= std_logic_vector(accely);
		end if;

		if readvelx = '1' then
			obus <= std_logic_vector(vellatchx);
		end if;
		
		if readvely = '1' then
			obus <= std_logic_vector(vellatchy);
		end if;
		
		if readposx = '1' then
			obus <= std_logic_vector(poslatchx);			
		end if;

		if readposy = '1' then
			obus <= std_logic_vector(poslatchy);
		end if;
		
		if readmode = '1' then
			obus(15 downto 0) <= modereg;
			obus(31 downto 16) <= (others => '0');
		end if;

		if readcommand = '1' then
			obus(15 downto 0) <= commandx;
			obus(31 downto 16) <= commandy;
		end if;

		if readtimerselfb =  '1' then
			obus(31 downto 16) <= (others => '0');
			obus(11 downto 0) <= (others => '0');
			if usedpll then
				obus(15 downto 12) <= timerselect_fb;
			else
				obus(15 downto 12) <= (others => '0');
			end if;	
		end if;

		if readtimerselcmd =  '1' then
			obus(31 downto 16) <= (others => '0');
			obus(11 downto 0) <= (others => '0');
			if usedpll then
				obus(15 downto 12) <= timerselect_cmd;
			else
				obus(15 downto 12) <= (others => '0');
			end if;	
		end if;

		if readstatus = '1' then
			obus(ssize-1 downto 0) <= statusreg;
			obus(31 downto ssize) <= (others => '0');
		end if;
		
		syncout <= not sync;  --sync pulse is active low
		dataclkout <= dataclk;
		xdataout <= xdata;
		ydataout <= ydata;
					
	end process axy2mod;
	
end Behavioral;
