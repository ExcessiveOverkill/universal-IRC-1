library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
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
use work.decodedstrobe.all;	

entity resolver is      
	generic (
			Clock : integer
			);    
  port (
		clk : in std_logic;
		ibus : in std_logic_vector(31 downto 0);
      obus : out std_logic_vector(31 downto 0);
		hloadcommand : in std_logic;
		hreadcommand : in std_logic;
		hloaddata : in std_logic;
		hreaddata : in std_logic;
		hreadstatus	 : in std_logic;
		regaddr : in std_logic_vector(2 downto 0);
		readvel : in std_logic; -- for range 0..7
		readpos: in std_logic;-- for range 0..7
		testbit : out std_logic;
		respdmp : out std_logic;   
		respdmm : out std_logic;
		spics : out std_logic;
		spiclk : out std_logic;
		spidi0 : in std_logic;
		spidi1 : in std_logic;
		pwren : out std_logic;
		chan0 : out std_logic;
		chan1 : out std_logic;
		chan2 : out std_logic
		);
		
end resolver;

architecture dataflow of resolver is

signal iabus: std_logic_vector(11 downto 0);
signal idbus: std_logic_vector(23 downto 0); 
signal mradd: std_logic_vector(11 downto 0);
signal mwadd: std_logic_vector(11 downto 0); 
signal mobus: std_logic_vector(31 downto 0);
signal mwrite: std_logic;      
signal mread: std_logic;	
			
-- data memory partitioning--			
signal muxedmibus: std_logic_vector(31 downto 0); 	-- the data input path to the processor 
signal ramdata: std_logic_vector(31 downto 0); 		-- and its sources
signal sinedata: std_logic_vector(15 downto 0); 
signal iodata: std_logic_vector(31 downto 0); 

signal ioradd: std_logic_vector(11 downto 0);

signal lloadvel: std_logic;
signal writedram: std_logic;

-- daq decode signals
signal daqreadram: std_logic;
signal daqloadmode: std_logic;
signal daqreadptr: std_logic;
signal daqclear: std_logic;
signal startburst: std_logic;
signal oldstartburst: std_logic;


-- wavegen decode signals
signal wgloadrate: std_logic;
signal wgloadlength: std_logic;
signal wgloadpdmrate: std_logic;
signal wgloadtableptr: std_logic;
signal wgloadtabledata: std_logic;

-- host interface signals
signal hcommandreg: std_logic_vector(15 downto 0);
signal hdatareg: std_logic_vector(31 downto 0);
alias  romwrena : std_logic is hcommandreg(14); -- if high, reset CPU and allow read/write CPU ROM access
signal lcommandreg: std_logic_vector(15 downto 0);
signal lloadcommand: std_logic;
signal lreadcommand: std_logic;
signal ldatareg: std_logic_vector(31 downto 0); 
signal lloaddata: std_logic;
signal lstatusreg: std_logic_vector(31 downto 0); 
signal lloadstatus: std_logic;
signal lreaddata: std_logic;
signal romdata: std_logic_vector(23 downto 0); 
signal loadrom: std_logic;
signal velramdata: std_logic_vector(31 downto 0); 
signal hostreq: std_logic; 
signal lloadveli: std_logic; 
signal lloadintrate: std_logic;
signal lreadpos: std_logic;

-- our one bit pwr enable register
signal lpwren: std_logic; 
signal loadpwren: std_logic;

-- our logic for syncing processor to DAQ 
signal lreadccount: std_logic; 
signal ldeccount: std_logic; 
signal lcyclecount: std_logic_vector(7 downto 0); 

-- debug test bit out
signal ltestbit: std_logic;
signal lsettestbit: std_logic;
signal lclrtestbit: std_logic;

-- clock frequency read
signal clockslv: std_logic_vector(31 downto 0);
signal lreadclkfreq: std_logic;

begin

 
aproc: entity work.Big32v2 -- normally b32qcondmac2ws.vhd 

	port map (
		clk      => clk,
		reset    => romwrena,
		iabus    => iabus,  		-- program address bus
		idbus    => idbus,      -- program data bus  
		mradd    => mradd,  		-- memory read address
		mwadd    => mwadd,  		-- memory write address
		mibus    => muxedmibus, -- memory data in bus     
		mobus    => mobus, 		-- memory data out bus
		mwrite   => mwrite,		-- memory write signal        
		mread		=> mread      -- memory read signal 				
		);
	
	ResolverROM: entity work.resrom 
	port map(
		addra => hcommandreg(9 downto 0),		-- 1k (x24) till we run out of space
		addrb => iabus(9 downto 0),
		clk  => clk,
		dina  => ibus(23 downto 0),
		douta => romdata,
		doutb => idbus,
		wea	=> loadrom
	);
	 

	DataRam : entity work.dpram 
	generic map (
		width => 32,
		depth => 512 --256
				)
	port map(
		addra => mwadd(8 downto 0), --7
		addrb => mradd(8 downto 0), --7
		clk  => clk,
		dina  => mobus,
--		douta => 
		doutb => ramdata,
		wea	=> writedram
	 );
	 
	SineTable : entity work.sine16 
	port map (
	addr => mradd(9 downto 0),
	clk => clk,
	din => x"0000",
	dout => sinedata,
	we => '0'
	);

	velram: entity work.dpram
	generic map (
		width => 32,
		depth => 8
				)
	port map(
		addra => mwadd(2 downto 0),
		addrb => regaddr,
		clk  => clk,
		dina  => mobus,
--		douta => 
		doutb => velramdata,
		wea	=> lloadvel
		); 

	interfaceInteg : entity work.OutputInteg	
	-- velocity --> position part of integrator (accumulator)
	-- is done in hardware so it can run faster than the sample rate (256 times here)
	-- so that the (asynchronous) host reads of position do not suffer
	-- major aliasing errors
	port map(
		dspdin => mobus,
      dspdout => iodata,
		hostdout => obus,
		dspraddr => mradd(2 downto 0),
		dspwaddr => mwadd(2 downto 0),
		hostaddr => regaddr,
		loadvel => lloadveli,
		loadrate => lloadintrate,
		dspread => lreadpos,
		hostread => readpos,
--		testout => testbit,
		clk =>  clk
		);
	
	ADAQ: entity work.resolverdaq2
	-- A-D samples are written by SPI interface to dual ported RAM and read
   -- by DSP on other RAM port. Also handles DAQ rate and channel muxing
	port map ( 
		clk =>  clk,
		ibus =>  mobus,
      obus =>  iodata,
		hostaddr =>  mradd(9 downto 0),
		ioradd0 => ioradd(0),
		readram =>  daqreadram,
		loadmode =>  daqloadmode,
		clear => daqclear,
		readstat => daqreadptr,
		startburst=> startburst,
      spiclk => spiclk,
      spiin0 => spidi0,
      spiin1 => spidi1,
		spiframe => spics,
		channelsel0 => chan0,
		channelsel1 => chan1,
		channelsel2 => chan2,
		testout => testbit
		
       );

	AWavegen: entity work.syncwavegen
	port map(
		clk => clk ,
		ibus => mobus, 
		loadrate => wgloadrate,
		loadlength => wgloadlength,
		loadpdmrate => wgloadpdmrate,
		loadtableptr => wgloadtableptr,
		loadtabledata => wgloadtabledata,
		trigger1 => startburst,
		pdmouta => respdmp,
		pdmoutb => respdmm 
	);

	iobus:  process(clk,ioradd,ramdata, iodata, sinedata)
	begin
		if rising_edge(clk) then
			ioradd <= mradd;
		end if;
		
		case ioradd(11 downto 10) is
			when "00" => muxedmibus <= ramdata;		 		-- bottom 1K is RAM (only 512B now)
			when "01" => muxedmibus <= iodata;				-- 1K is I/O space
			when "10" =>
				muxedmibus(15 downto 0) <= sinedata;		-- next 1K is 16 bit sine table	
				muxedmibus(31 downto 16) <= (others => '0');	
			when "11" => muxedmibus <= iodata; 				-- top 1K is DAQ read data
			when others => null;
		end case;
		
	end process iobus;	

	hostinterface : process (clk,lpwren, hloaddata, romwrena, hreadcommand, lcommandreg, hostreq, 
	                         hreaddata, ldatareg, romdata, readvel, velramdata, lreadcommand, 
									 hcommandreg, lreaddata, hdatareg, lstatusreg, hreadstatus, lreadccount, lcyclecount)
	begin
		clockslv <= conv_std_logic_vector(Clock,32);
		-- first the writes
		if rising_edge(clk) then
			-- first host writes 
			if hloadcommand = '1' then
				hcommandreg <= ibus(15 downto 0);
				hostreq <= '1';
			end if;	
			if hloaddata = '1' then 
				hdatareg <= ibus;
			end if;	

			-- next local writes and sync logic 
			if lloadcommand = '1' then
				lcommandreg <= mobus(15 downto 0);
				hostreq <= '0';
			end if;	
			if lloaddata = '1' then 
				ldatareg <= mobus;				
			end if;	
			
			if lloadstatus = '1' then 
				lstatusreg <= mobus;				
			end if;	
			
			if loadpwren = '1' then
				lpwren <= mobus(0);
			end if;	

			if oldstartburst = '0' and startburst = '1' then
				if ldeccount = '0' then
					lcyclecount <= lcyclecount +1;
				end if;
			else
				if ldeccount = '1' then
					lcyclecount <= lcyclecount -1;
				end if;	
			end if;
			
			if lsettestbit = '1' then
				ltestbit <= '1';
			end if;	

			if lclrtestbit = '1' then
				ltestbit <= '0';
			end if;	

			oldstartburst <= startburst;
--			testbit <= startburst;
		end if; -- clk
		pwren <= not lpwren;											-- resolver drive power enable
		
		if hloaddata = '1' and romwrena = '1' then		-- write data to rom on host datareg writes
			loadrom <= '1';
		else
			loadrom <= '0';
		end if;
		
		-- then the reads
		-- first the host reads
		obus <= (others => 'Z');
		if hreadcommand = '1' then
			obus(15 downto 0) <= lcommandreg;
			obus(30 downto 16) <= (others => '0'); 
			obus(31) <= hostreq;
		end if;	
		if hreaddata = '1' then
			if romwrena = '0' then							-- normally just read the local data register
				obus  <= ldatareg;	
			else
				obus(23 downto 0) <= romdata;				-- but if romwrena set, read the ROM data
				obus(31 downto 24) <=(others => '0');
			end if;
		end if;	
		if hreadstatus = '1' then
			obus <= lstatusreg;
		end if;	
		if readvel = '1' then
			obus <= velramdata;
		end if;	

		-- then the local reads
		iodata <= (others => 'Z');
		if lreadcommand = '1' then
			iodata(15 downto 0) <= hcommandreg;
			iodata(30 downto 16) <= (others => '0');
			iodata(31) <= hostreq;
		end if;
		if lreaddata = '1' then
			iodata <= hdatareg;
		end if;
		if lreadccount = '1' then
			iodata(7 downto 0) <= lcyclecount;
			iodata(31 downto 8) <= (others => '0');
		end if;
		if lreadclkfreq = '1' then
			iodata <= clockslv;
		end if;
		
--		testbit <= ltestbit;
	end process hostinterface;	

	localdecode : process (mradd,mwadd,ioradd,mwrite,mread)
	begin

		lloadcommand    <= decodedstrobe(mwadd,x"400",mwrite);
		lreadcommand    <= decodedstrobe(ioradd,x"400",mread);
		lloaddata       <= decodedstrobe(mwadd,x"401",mwrite);
		lreaddata       <= decodedstrobe(ioradd,x"401",mread);

		daqloadmode     <= decodedstrobe(mwadd,x"402",mwrite);
		daqreadptr		 <= decodedstrobe(ioradd,x"402",mread);
		daqclear        <= decodedstrobe(mwadd,x"403",mwrite);
		daqreadram      <= decodedstrobe(ioradd(11 downto 10),"11",'1');		

		wgloadrate      <= decodedstrobe(mwadd,x"404",mwrite);
		wgloadlength    <= decodedstrobe(mwadd,x"405",mwrite);
		wgloadpdmrate   <= decodedstrobe(mwadd,x"406",mwrite);
		wgloadtableptr  <= decodedstrobe(mwadd,x"407",mwrite);
		wgloadtabledata <= decodedstrobe(mwadd,x"408",mwrite);
		
		loadpwren       <= decodedstrobe(mwadd,x"409",mwrite);

		ldeccount       <= decodedstrobe(mwadd,x"40A",mwrite);
		lreadccount     <= decodedstrobe(ioradd,x"40A",mread);
		
		lsettestbit		 <= decodedstrobe(mwadd,x"40B",mwrite);
		lclrtestbit		 <= decodedstrobe(mwadd,x"40C",mwrite);
		lloadintrate	 <= decodedstrobe(mwadd,x"40D",mwrite);
		lloadstatus	    <= decodedstrobe(mwadd,x"40E",mwrite);
		lreadclkfreq    <= decodedstrobe(ioradd,x"40F",mread);
		
		writedram       <= decodedstrobe(mwadd(11 downto 10),"00",mwrite);
		lloadvel        <= decodedstrobe(mwadd(11 downto 3),"010000010",mwrite);-- 0x410 to 0x417

		lloadveli       <= decodedstrobe(mwadd(11 downto 3), "010000011",mwrite);-- 0x418 to 0x41F
		lreadpos      	 <= decodedstrobe(ioradd(11 downto 3),"010000100",'1');-- 0x420 to 0x427
		
	end process localdecode;	

	
end dataflow;

  