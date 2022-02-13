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

entity resolverdaq2 is -- specific SPI DAQ subsystem for AD7265 type A-D chips for resolver input   
	port ( 
		clk : in std_logic;
		ibus : in std_logic_vector(31 downto 0);
      obus : out std_logic_vector(31 downto 0);
		hostaddr : in std_logic_vector(9 downto 0);
		ioradd0: in std_logic;
		readram : in std_logic;
		loadmode : in std_logic;
--		readmode : in std_logic;
		clear : in std_logic;
		readstat: in std_logic;
		startburst: in std_logic;
      spiclk : out std_logic;
      spiin0 : in std_logic;
      spiin1 : in std_logic;
		spiframe: out std_logic;
		channelsel0: out std_logic;
		channelsel1: out std_logic;
		channelsel2: out std_logic;
		testout: out std_logic
		
       );
end resolverdaq2;

architecture behavioral of resolverdaq2 is

constant DivWidth: integer := 4;


-- spi interface related signals

signal RateDiv : std_logic_vector(DivWidth -1 downto 0);
signal ModeReg : std_logic_vector(31 downto 0);
alias  BitcountReg : std_logic_vector(4 downto 0) is ModeReg(4 downto 0); -- bits are N+1
alias	SwapMem : std_logic is ModeReg(5);
alias CPOL : std_logic is ModeReg(6);
alias CPHA : std_logic is ModeReg(7);
alias RateDivReg : std_logic_vector(DivWidth -1 downto 0) is ModeReg(11 downto 8);  -- sets SPI shift clock rate CLK/(2*(N+1))
alias  BurstDivReg : std_logic_vector(11 downto 0) is ModeReg(23 downto 12);	-- sets A-D conversion rate during burst CLK/(N+2);
alias  BurstCountReg : std_logic_vector(7 downto 0) is ModeReg(31 downto 24); -- sets length of A-D burst (N+2)
signal fixaddr0 : std_logic;
signal burstcount: std_logic_vector(7 downto 0);
signal burstdiv: std_logic_vector(11 downto 0);
alias burstcountmsb : std_logic is burstcount(7);
signal oldburstcountmsb: std_logic; 
alias burstdivmsb : std_logic is burstdiv(11);
signal BitCount : std_logic_vector(4 downto 0);
alias BitCountMSB : std_logic is BitCount(4);
signal ClockFF: std_logic; 
signal SPISReg0: std_logic_vector(15 downto 0);
signal SPISReg1: std_logic_vector(15 downto 0);
signal LFrame: std_logic := '0'; 
signal Dav: std_logic; 
signal SPIIn0Latch: std_logic;
signal SPIIn1Latch: std_logic;
signal FirstLeadingEdge: std_logic;
signal Channel: std_logic_vector(2 downto 0);
signal BufferHalf: std_logic;

signal startconv: std_logic;
signal daqreset: std_logic;
signal DHostAddr: std_logic;
signal oldstartburst: std_logic;
signal muxtime: std_logic;
signal oldmuxtime: std_logic;

-- daqram related signals
signal daqaddr: std_logic_vector(8 downto 0);
signal daqdata: std_logic_vector(31 downto 0);
signal hostdata: std_logic_vector(31 downto 0);  
			
 
begin 

   -- dual ported 512 x 32 
	adaqram : entity work.dpram
	generic map(
		width => 32,
		depth => 512
		)
	port map(
		addra => daqaddr,
		addrb => hostaddr(9 downto 1), 	-- read by host as 1024 16 bit values
		clk  => clk,							-- sign extended to 32 bits
		dina  => daqdata,
   	doutb => hostdata,
		wea	=> Dav
		);

	aresolverdaq2: process (clk,SPISReg1, SPISReg0, Channel, ClockFF, 
	                       ModeReg, LFrame, readram, hostaddr, hostdata,
								   BitCount, ioradd0, readstat, daqaddr)
	begin
		if rising_edge(clk) then
			if loadmode = '1' then
				modereg <= ibus;
			end if;	
			
			if startconv = '1' then
				BitCount <= BitCountReg;
				LFrame <= '1';
				ClockFF <= '0';
				FirstLeadingEdge <= '1';
				RateDiv <= RateDivReg;
				startconv <= '0';
			end if;

			if Dav = '1' then 	-- increment daq address as we write new data
				Dav <= '0';
				daqaddr <= daqaddr +1;
			end if;

			if muxtime = '1' and oldmuxtime = '0'  then		-- mux at start of spi cycle for maximum settling time		
				channel <= channel +1;
				if channel = 5 then									-- hardwired for AD7265, 6 channels single ended mode
					channel <= "000";
					if burstcountmsb = '0' then
						burstcount <= burstcount -1;
					end if;
				end if;	
			end if;
			
			if burstcountmsb = '1' and oldburstcountmsb = '0' then -- set ptr reset request at end of burst
				daqreset <= '1';
			end if;						
		
			if startburst = '1' and oldstartburst = '0' then
				burstcount <= burstcountreg;
			end if;
			
			if burstcountmsb = '0' then		--	if burst running
				burstdiv <= burstdiv -1;
				if burstdivmsb = '1' then
					burstdiv <= BurstDivReg;
					startconv <= '1';
				end if;
			end if;		
		
			if dav = '1' and daqreset = '1' then
				if bufferhalf = '0' then
					daqaddr <= (others => '0');	
				else
					daqaddr <= "100000000";
				end if;	
				bufferhalf <= not bufferhalf;
				daqreset <= '0';
			end if;
									
			if LFrame = '1' then 									-- single shift register SPI
				if RateDiv = 0 then									-- maybe update to dual later to allow
					RateDiv <= RateDivReg;							-- receive data skew adjustment
					SPIIn0Latch <= spiin0;
					SPIIn1Latch <= spiin1;
					if ClockFF = '0' then
						if BitCountMSB = '1' then
							LFrame <= '0';								-- LFrame cleared 1/2 SPI clock after GO
							Dav <= '1';									-- we're done!
						else						
							ClockFF <= '1';
						end if;	
						if CPHA = '1'  and FirstLeadingEdge = '0' then				-- shift out on leading edge for CPHA = 1 case
							SPISreg0 <= SPISreg0(14 downto 0) & (SPIIn0Latch);		-- left shift
							SPISreg1 <= SPISreg1(14 downto 0) & (SPIIn1Latch);
						end if;
						FirstLeadingEdge <= '0';						
					else										-- clockff is '1'
						ClockFF <= '0';
						BitCount <= BitCount -1;	
						if CPHA = '0' then				-- shift out on trailing edge for CPHA = 0 case
							SPISreg0 <= SPISreg0(14 downto 0) & (SPIIn0Latch);		-- left shift
							SPISreg1 <= SPISreg1(14 downto 0) & (SPIIn1Latch);
						end if;	
					end if;	
				else -- ratediv not 0					
					RateDiv <= RateDiv -1;
				end if;
			end if; -- LFrame = 1

			if clear = '1' then 
				LFrame <= '0';
				ClockFF <= '0';
				Dav <= '0';
				daqaddr <= (others => '0');	
				channel <= (others => '0');
			end if;
			oldstartburst <=	startburst;
			oldmuxtime <= muxtime;
			oldburstcountmsb <= burstcountmsb;
		end if; -- clk
		
		if bitcount(3 downto 0) = x"A" then  -- change mux 3 clocks into conversion
			muxtime <= '1';
		else
			muxtime <= '0';
		end if;
		
		daqdata(31 downto 16) <= SPISReg1;
		daqdata(15 downto  0) <= SPISReg0;

		channelsel0 <= channel(0);	
		channelsel1 <= channel(1);	
		channelsel2 <= channel(2);	
		spiclk <= ClockFF xor CPOL;
		spiframe <= not LFrame;
		fixaddr0 <= ioradd0 xor SwapMem;		--  swap sin/cos of output data for step response
		obus <= (others => 'Z');
		if readram = '1' then
			-- all this mungeology is to take the signed 12 bit A-D data
			-- and present it to the processor as 12 bit number sign extended to 32 bits
			-- it may get removed if there's enough time at 10 KHz sample frequency
			if fixaddr0 = '0' then
				obus(11 downto 0) <= hostdata(11 downto 0);  -- for 7265/66
			else
				obus(11 downto 0) <= hostdata(27 downto 16);
			end if;
			
			if (hostdata(11) = '0' and fixaddr0 = '0') or (hostdata(27) = '0' and fixaddr0 = '1') then -- sign extend to 32 bits
				obus(31 downto 12) <= (others => '0');
			end if;
			if (hostdata(11) = '1' and fixaddr0 = '0') or (hostdata(27) = '1' and fixaddr0 = '1') then
				obus(31 downto 12) <= (others => '1');
			end if;							
		end if;		
		if readstat = '1' then
			obus(8 downto 0) <= daqaddr;
		end if;
		testout <= bitcount(2);
	end process aresolverdaq2;
	
end Behavioral;
