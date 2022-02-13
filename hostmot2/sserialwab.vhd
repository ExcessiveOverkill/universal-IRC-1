
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
use work.decodedstrobe.all;	
use work.oneofndecode.all;	

entity sserialwab is
	generic (
		Ports : integer;
		InterfaceRegs : integer;	-- must be power of 2
		BaseClock : integer;
		NeedCRC8 : boolean
			);
   port ( 
		clk : in std_logic;
		clkmed : in std_logic;
		ibus : in std_logic_vector(31 downto 0);
      obus : out std_logic_vector(31 downto 0);
		hloadcommand : in std_logic;
		hreadcommand : in std_logic;
		hloaddata : in std_logic;
		hreaddata : in std_logic;           
		regaddr : in std_logic_vector(log2(InterfaceRegs) -1 downto 0);
		hloadregs0 : in std_logic;
		hreadregs0 : in std_logic;
		hloadregs1 : in std_logic;
		hreadregs1 : in std_logic;
		hloadregs2 : in std_logic;
		hreadregs2 : in std_logic;
		hloadregs3 : in std_logic;
		hreadregs3 : in std_logic;
		hloadregs4 : in std_logic;
		hreadregs4 : in std_logic;
		hloadregs5 : in std_logic;
		hreadregs5 : in std_logic;
		hloadregs6 : in std_logic;
		hreadregs6 : in std_logic;
		hloadregs7 : in std_logic;
		hreadregs7 : in std_logic;
		rxserial : in std_logic_vector(Ports -1 downto 0);
		txserial : out std_logic_vector(Ports -1 downto 0);
		txenable : out std_logic_vector(Ports -1 downto 0);
		ntxenable : out std_logic_vector(Ports -1 downto 0);
		testbit : out std_logic
		);
end sserialwab;

architecture Behavioral of sserialwab is


signal iabus: std_logic_vector(11 downto 0);
signal idbus: std_logic_vector(15 downto 0); 
signal mradd: std_logic_vector(11 downto 0);
signal mwadd: std_logic_vector(11 downto 0); 
signal fixedmra: std_logic_vector(9 downto 0);
signal fixedmwa: std_logic_vector(9 downto 0); 
signal mobus: std_logic_vector(7 downto 0);
signal mwrite: std_logic;      
signal mread: std_logic;	
			
-- data memory partitioning--			
signal muxedmibus: std_logic_vector(7 downto 0); 	-- the data input path to the processor 
signal ramdata: std_logic_vector(7 downto 0); 		-- and its sources
signal iodata: std_logic_vector(7 downto 0); 

signal ioradd: std_logic_vector(11 downto 0);

signal writedram: std_logic;

-- host interface signals
signal hcommandreg: std_logic_vector(15 downto 0);
alias  romwrena : std_logic is hcommandreg(14); -- if high, reset CPU and allow read/write CPU ROM access
signal syncromwrena  : std_logic;
signal hdatareg: std_logic_vector(7 downto 0); 
signal lloadcommand: std_logic;
signal lloadcommand1: std_logic;
signal lreadcommandl: std_logic;
signal lreadcommandh: std_logic;
signal lclrhdoorbell: std_logic;
signal lreadhdoorbell: std_logic;
signal clrhdoorbellreq1: std_logic;
signal clrhdoorbellreq2: std_logic;
signal hdoorbell: std_logic;

signal ldatareg: std_logic_vector(7 downto 0); 
signal lloaddata: std_logic;
signal lreaddata: std_logic;
signal romdata: std_logic_vector(15 downto 0); 
signal romdatabuf: std_logic_vector(15 downto 0); 
signal loadrom: std_logic;
signal hloadrom: std_logic;
signal loadromreq1: std_logic;
signal loadromreq2: std_logic;


-- UART interface signals (RX)
signal loadrxfiltersel: std_logic;
signal readrxdatasel: std_logic;
signal loadrxbitratelsel: std_logic;
signal loadrxbitratemsel: std_logic;
signal loadrxbitratehsel: std_logic;
signal clearrxfifosel: std_logic;
signal readrxfifocountsel: std_logic;
signal readrxmodesel: std_logic;
signal loadrxmodesel: std_logic;

signal loadrxfilter: std_logic_vector(Ports-1 downto 0);
signal readrxdata: std_logic_vector(Ports-1 downto 0);
signal loadrxbitratel: std_logic_vector(Ports-1 downto 0);
signal loadrxbitratem: std_logic_vector(Ports-1 downto 0);
signal loadrxbitrateh: std_logic_vector(Ports-1 downto 0);
signal clearrxfifo: std_logic_vector(Ports-1 downto 0);
signal readrxfifocount: std_logic_vector(Ports-1 downto 0);
signal readrxmode: std_logic_vector(Ports-1 downto 0);
signal loadrxmode: std_logic_vector(Ports-1 downto 0);
signal rxfifohasdata: std_logic_vector(Ports-1 downto 0);
signal drven: std_logic_vector(Ports-1 downto 0);			-- for half duplex rx mask
signal rxdata: std_logic_vector(Ports-1 downto 0);

-- UART interface signals (TX)
signal loadtxdatasel: std_logic;
signal loadtxbitratelsel: std_logic;
signal loadtxbitratemsel: std_logic;
signal loadtxbitratehsel: std_logic;
signal readtxbitratelsel: std_logic;
signal readtxbitratemsel: std_logic;
signal readtxbitratehsel: std_logic;
signal cleartxfifosel: std_logic;
signal readtxfifocountsel: std_logic;
signal loadtxmodesel: std_logic;
signal readtxmodesel: std_logic;

signal loadtxdata: std_logic_vector(Ports-1 downto 0);
signal loadtxbitratel: std_logic_vector(Ports-1 downto 0);
signal loadtxbitratem: std_logic_vector(Ports-1 downto 0);
signal loadtxbitrateh: std_logic_vector(Ports-1 downto 0);
--signal readtxbitratel: std_logic_vector(Ports-1 downto 0);
--signal readtxbitratem: std_logic_vector(Ports-1 downto 0);
--signal readtxbitrateh: std_logic_vector(Ports-1 downto 0);
signal cleartxfifo: std_logic_vector(Ports-1 downto 0);
signal readtxfifocount: std_logic_vector(Ports-1 downto 0);
signal loadtxmode: std_logic_vector(Ports-1 downto 0);
signal readtxmode: std_logic_vector(Ports-1 downto 0);
signal txfifoempty: std_logic_vector(Ports-1 downto 0);
signal txdata: std_logic_vector(Ports-1 downto 0);
   
-- interface RAM 8-32 shim signals
signal hibus32_0: std_logic_vector(31 downto 0);
signal hibus32_1: std_logic_vector(31 downto 0);
signal hibus32_2: std_logic_vector(31 downto 0);
signal hibus32_3: std_logic_vector(31 downto 0);
signal hibus32_4: std_logic_vector(31 downto 0);
signal hibus32_5: std_logic_vector(31 downto 0);
signal hibus32_6: std_logic_vector(31 downto 0);
signal hibus32_7: std_logic_vector(31 downto 0);
signal libus32_0: std_logic_vector(31 downto 0);
signal libus32_1: std_logic_vector(31 downto 0);
signal libus32_2: std_logic_vector(31 downto 0);
signal libus32_3: std_logic_vector(31 downto 0);
signal libus32_4: std_logic_vector(31 downto 0);
signal libus32_5: std_logic_vector(31 downto 0);
signal libus32_6: std_logic_vector(31 downto 0);
signal libus32_7: std_logic_vector(31 downto 0);
signal lobus32: std_logic_vector(31 downto 0);
signal lobus24: std_logic_vector(23 downto 0);
signal libuslatch: std_logic_vector(31 downto 8);
signal latchtop24: std_logic;
signal writeiram: std_logic;
signal lwriteiram0: std_logic;
signal lwriteiram1: std_logic;
signal lwriteiram2: std_logic;
signal lwriteiram3: std_logic;
signal lwriteiram4: std_logic;
signal lwriteiram5: std_logic;
signal lwriteiram6: std_logic;
signal lwriteiram7: std_logic;
signal lwriteiram: std_logic;
signal lreadiram: std_logic;

-- debug test bit out
signal ltestbit: std_logic;
signal lsettestbit: std_logic;
signal lclrtestbit: std_logic;

-- timer signals
signal lreadtimerl: std_logic;
signal lreadtimerh: std_logic;
signal lwritetimerl: std_logic;
signal lwritetimerh: std_logic;
signal timerdiv: std_logic_vector(15 downto 0);
signal timeracc: std_logic_vector(15 downto 0);
signal timerlatch: std_logic_vector(7 downto 0);
signal timercount: std_logic_vector(15 downto 0);
alias timermsb: std_logic is timeracc(15);

-- doorbell signals
signal doorbellreg: std_logic_vector(InterfaceRegs-1 downto 0); 
signal readdoorbell: std_logic;
signal cleardoorbell: std_logic;
 
-- read back baseclock signals
signal lreadclock: std_logic;
signal baseclockslv: std_logic_vector(31 downto 0);

-- read back # of channels
signal lreadchannels: std_logic;

-- crc8 signals

signal newxor: std_logic_vector(7 downto 0);
signal lreadcrc: std_logic;
signal lwritecrc: std_logic;
signal lclearcrc: std_logic;

begin

--	processor: entity work.DumbAss8sqw	 -- firmware version 36 and below 2K code space
--	processor: entity work.DumbAss8sqws	 -- firmware version 37 and above 2K code space
	processor: entity work.DumbAss8sqwsb -- firmware version 45 and SP6 above 4K code space
	port map (
		clk		 => clkmed,
		reset	  => syncromwrena,
		iabus	  =>  iabus,		  -- program address bus
		idbus	  =>  idbus,		  -- program data bus		 
		mradd	  =>  mradd,		  -- memory read address
		mwadd	  =>  mwadd,		  -- memory write address
		mibus	  =>  muxedmibus,	  
		-- memory data in bus	  
		mobus	  =>  mobus,		  -- memory data out bus
		mwrite  =>  mwrite,		  -- memory write signal	
      mread   =>  mread		     -- memory read signal	
--		carryflg  =>				  -- carry flag
		);

  sserialrom: entity work.sslbpb
  port map(
		addra => hcommandreg(11 downto 0),		-- 4k (x16)
		addrb => iabus(11 downto 0),
		clk  => clkmed,
		dina  => romdatabuf,
		douta => romdata,
		doutb => idbus,
		wea	=> loadrom
	 );
	
  DataRam : entity work.sslbpram	-- this is for the new pre-initialized RAM with sendstrings
--	DataRam : entity work.dpram   -- this is for the old generic empty RAM 
-- generic map (
--		width => 8,
--		depth => 1024
--				)
	port map(
		addra => fixedmwa,
		addrb => fixedmra,
		clk  => clkmed,
		dina  => mobus,
--		douta => 
		doutb => ramdata,
		wea	=> writedram
	 );	 

	interfaceramout0: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regaddr,
		clk  => clkmed,
		dina  => lobus32,
--		douta => 
		doutb => hibus32_0,
		wea	=> lwriteiram0
		); 

	interfaceramin0: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regaddr, 
		addrb => ioradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32_0,
		wea	=> hloadregs0
		); 
		
	interfaceramout1: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regaddr,
		clk  => clkmed,
		dina  => lobus32,
--		douta => 
		doutb => hibus32_1,
		wea	=> lwriteiram1
		); 

	interfaceramin1: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regaddr, 
		addrb => ioradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32_1,
		wea	=> hloadregs1
		); 

	interfaceramout2: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regaddr,
		clk  => clkmed,
		dina  => lobus32,
--		douta => 
		doutb => hibus32_2,
		wea	=> lwriteiram2
		); 

	interfaceramin2: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regaddr, 
		addrb => ioradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32_2,
		wea	=> hloadregs2
		); 		

	interfaceramout3: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regaddr,
		clk  => clkmed,
		dina  => lobus32,
--		douta => 
		doutb => hibus32_3,
		wea	=> lwriteiram3
		); 

	interfaceramin3: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regaddr, 
		addrb => ioradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32_3,
		wea	=> hloadregs3
		); 		
		
	interfaceramout4: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regaddr,
		clk  => clkmed,
		dina  => lobus32,
--		douta => 
		doutb => hibus32_4,
		wea	=> lwriteiram4
		); 

	interfaceramin4: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regaddr, 
		addrb => ioradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32_4,
		wea	=> hloadregs4
		); 		

	interfaceramout5: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regaddr,
		clk  => clkmed,
		dina  => lobus32,
--		douta => 
		doutb => hibus32_5,
		wea	=> lwriteiram5
		); 

	interfaceramin5: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regaddr, 
		addrb => ioradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32_5,
		wea	=> hloadregs5
		); 		

	interfaceramout6: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regaddr,
		clk  => clkmed,
		dina  => lobus32,
--		douta => 
		doutb => hibus32_6,
		wea	=> lwriteiram6
		); 

	interfaceramin6: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regaddr, 
		addrb => ioradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32_6,
		wea	=> hloadregs6
		); 		

	interfaceramout7: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regaddr,
		clk  => clkmed,
		dina  => lobus32,
--		douta => 
		doutb => hibus32_7,
		wea	=> lwriteiram7
		); 

	interfaceramin7: entity work.adpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regaddr, 
		addrb => ioradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32_7,
		wea	=> hloadregs7
		); 		
	 
		makeUARTRs: for i in 0 to Ports -1 generate
		auarrx: entity work.uartr8b	
			generic map (
				Clock => BaseClock
			)
			port map (
			clk => clkmed,
			ibus => mobus,
			obus => iodata,
			popfifo => readrxdata(i),
			loadbitratel => loadrxbitratel(i),
			loadbitratem => loadrxbitratem(i),
			loadbitrateh => loadrxbitrateh(i),
			readbitratel => '0',
			readbitratem => '0',
			readbitrateh => '0',
			clrfifo => clearrxfifo(i),
			readfifocount => readrxfifocount(i),
			loadmode => loadrxmode(i),
			readmode => readrxmode(i),
			loadfilter => loadrxfilter(i),
			fifohasdata => rxfifohasdata(i),
			rxmask => drven(i),			-- for half duplex rx mask
			rxdata => rxdata(i)
         );
	end generate;
	
	makeUARTTXs: for i in 0 to Ports -1 generate
		auartx:  entity work.uartx8b	
		port map (
			clk => clkmed,
			ibus => mobus,
			obus => iodata,
			pushfifo => loadtxdata(i),
			loadbitratel => loadtxbitratel(i),
			loadbitratem => loadtxbitratem(i),
			loadbitrateh => loadtxbitrateh(i),
			readbitratel => '0',					-- readtxbitratel(i), for debug
			readbitratem => '0',					-- readtxbitratem(i), for debug
			readbitrateh => '0',					-- readtxbitrateh(i), for debug
			clrfifo => cleartxfifo(i),
			readfifocount => readtxfifocount(i),
			loadmode => loadtxmode(i),
			readmode => readtxmode(i),
			fifoempty => txfifoempty(i),
			txen => '1',
			drven => drven(i),
			txdata => txData(i)
         );
	end generate;

	iobus:  process(clkmed,ioradd,ramdata,iodata,mradd,mwadd)
	begin
		if rising_edge(clkmed) then
			ioradd <= mradd;
		end if;
		
		if ioradd(9) = '0' then
			muxedmibus <= ramdata;		 		-- RAM is 0,1FF and 400,5FF 
		else
			muxedmibus <= iodata;				-- I/O space is 200,3FF and 600,7FF
		end if;
		
		fixedmra <= mradd(10)& mradd(8 downto 0);
		fixedmwa <= mwadd(10)& mwadd(8 downto 0); 
		
	end process iobus;		


	hostinterface : process (clk, clkmed, hloaddata, romwrena, hreadcommand,lreadhdoorbell,hdoorbell,
	                         hreaddata, ldatareg, romdata, lreadcommandl, lloadcommand1,  
									 lreadcommandh, hcommandreg, lreaddata, hdatareg, clrhdoorbellreq2, ltestbit)
	begin
		-- first host writes
		if rising_edge(clk) then
			-- first host writes 
			if hloadcommand = '1' and ibus(31) = '0' then	-- disable command regs write if data MSB = 0
				hcommandreg <= ibus(15 downto 0);				-- this is for DMA/TRAM where write side effects
				hdoorbell <= '1';										-- must be data dependent
			end if;	
			
			if hloaddata = '1' and romwrena = '1' then		-- request to write data to rom on host datareg writes
				hloadrom <= '1';
				romdatabuf <= ibus(15 downto 0);
			else
				hloadrom <= '0';
			end if;
		
			if hloaddata = '1' then 
				hdatareg <= ibus(7 downto 0);
			end if;	
		end if; -- clk

			-- next local writes and sync logic 

		if rising_edge(clkmed) then
			clrhdoorbellreq2 <=	clrhdoorbellreq1;
			loadromreq2 <= loadromreq1;
			loadromreq1 <= hloadrom;
			syncromwrena <= romwrena;
			lloadcommand1 <= lloadcommand;
			if (loadromreq2 =  '1') and (loadromreq1 = '0') then 	--write data to ROM on trailig edge of host datareg writes
				loadrom <= '1';
			else
				loadrom <= '0';
			end if;			
			
			if lclrhdoorbell = '1' then
				clrhdoorbellreq1 <= '1';
			end if;
			
			if lloaddata = '1' then 
				ldatareg <= mobus;				
			end if;	
			
			if lsettestbit = '1' then
				ltestbit <= '1';
			end if;	

			if lclrtestbit = '1' then
				ltestbit <= '0';
			end if;	
		end if; -- clkmed
		
		if lloadcommand1 = '1' then			-- async clear command reg
			hcommandreg <= (others => '0');
		end if;	


		if (clrhdoorbellreq2 = '1') then
			hdoorbell <= '0';
			clrhdoorbellreq1 <= '0';
		end if;
				
		-- then the reads
		-- first the host reads
		obus <= (others => 'Z');
		if hreaddata = '1' then
			if romwrena = '0' then							-- normally just read the data register
				obus(7 downto 0)  <= ldatareg;
				obus(31 downto 8) <= (others => '0');	
			else
				obus(15 downto 0) <= romdata;				-- but if romwrena set, read the ROM data
				obus(31 downto 16) <=(others => '0');
			end if;
		end if;	
		if hreadcommand = '1' then
			obus(15 downto 0) <= hcommandreg;			-- host readback command reg
			obus(31 downto 16) <=(others => '0');
		end if;
		
		iodata <= (others => 'Z');
		if lreadcommandl= '1' then
			iodata <= hcommandreg(7 downto 0);
		end if;
		if lreadcommandh = '1' then
			iodata <= hcommandreg(15 downto 8);
		end if;
		
		if lreaddata = '1' then
			iodata <= hdatareg;
		end if;

		if lreadhdoorbell = '1' then
			iodata(0) <= hdoorbell;
			iodata(7 downto 1) <= (others => '0');	
		end if;
		
		
		testbit <= ltestbit;
	end process hostinterface;	

	WidthShim : process (clkmed, lreadiram, ioradd, libus32_0, libus32_1, libus32_2, libuslatch, 
	                     hreadregs0,hreadregs1, hreadregs2,  hibus32_0, hibus32_1, hibus32_2, 
								mwadd, lwriteiram, writeiram, mobus, lobus24, libus32_3, hreadregs3, hibus32_3)
	begin
		-- first the writes
		-- local to host
		if rising_edge(clkmed) then
			if writeiram = '1' then
				lobus24 <= (others => '0');						-- clear the latch after write to RAM
			end if;
			if lwriteiram = '1' then								-- local write to any of the RAMs
				case mwadd(1 downto 0) is
					when "00" => lobus24(7 downto 0)   <= mobus;
					when "01" => lobus24(15 downto 8)  <= mobus;
					when "10" => lobus24(23 downto 16) <= mobus;
					when others => null;
				end case;
			end if;	
			if latchtop24 = '1' then
				case ioradd(7 downto 5) is
					when "000" => libuslatch <= libus32_0(31 downto 8);
					when "001" => libuslatch <= libus32_1(31 downto 8);
					when "010" => libuslatch <= libus32_2(31 downto 8);
					when "011" => libuslatch <= libus32_3(31 downto 8);
					when "100" => libuslatch <= libus32_4(31 downto 8);
					when "101" => libuslatch <= libus32_5(31 downto 8);
					when "110" => libuslatch <= libus32_6(31 downto 8);
					when "111" => libuslatch <= libus32_7(31 downto 8);
					when others => null;
				end case;
			end if;
		end if; --  clkmed
		writeiram <= decodedstrobe(mwadd(1 downto 0),"11",lwriteiram);		-- write on MS byte
		lwriteiram0 <= decodedstrobe(mwadd(7 downto 5),"000",writeiram);	--
		lwriteiram1 <= decodedstrobe(mwadd(7 downto 5),"001",writeiram);
		lwriteiram2 <= decodedstrobe(mwadd(7 downto 5),"010",writeiram);
		lwriteiram3 <= decodedstrobe(mwadd(7 downto 5),"011",writeiram);
		lwriteiram4 <= decodedstrobe(mwadd(7 downto 5),"100",writeiram);	--
		lwriteiram5 <= decodedstrobe(mwadd(7 downto 5),"101",writeiram);
		lwriteiram6 <= decodedstrobe(mwadd(7 downto 5),"110",writeiram);
		lwriteiram7 <= decodedstrobe(mwadd(7 downto 5),"111",writeiram);
		lobus32 <= mobus & lobus24;
		-- then the reads
		iodata <= (others => 'Z');
		latchtop24 <= '0';
		if lreadiram = '1' then
			if ioradd(1 downto 0) = "00" then					-- on a local read we read the bottom 8 bits
				case ioradd(7 downto 5) is
					when "000" => iodata <=  libus32_0(7 downto 0);
					when "001" => iodata <=  libus32_1(7 downto 0);
					when "010" => iodata <=  libus32_2(7 downto 0);
					when "011" => iodata <=  libus32_3(7 downto 0);
					when "100" => iodata <=  libus32_4(7 downto 0);
					when "101" => iodata <=  libus32_5(7 downto 0);
					when "110" => iodata <=  libus32_6(7 downto 0);
					when "111" => iodata <=  libus32_7(7 downto 0);
					when others => null;
				end case;	
				latchtop24 <= '1';									-- and signal to latch the other 24
			end if;														-- so we sample all 32 bits at once					
			case ioradd(1 downto 0) is
				when "01" => iodata <=  libuslatch(15 downto 8);
				when "10" => iodata <=  libuslatch(23 downto 16);
				when "11" => iodata <=  libuslatch(31 downto 24);
				when others => null;
			end case;
		end if;
		obus <= (others => 'Z');
		if hreadregs0 = '1' then
			obus <= hibus32_0;
		end if;	
		if hreadregs1 = '1' then
			obus <= hibus32_1;
		end if;	
		if hreadregs2 = '1' then
			obus <= hibus32_2;
		end if;	
		if hreadregs3 = '1' then
			obus <= hibus32_3;
		end if;	
		if hreadregs4 = '1' then
			obus <= hibus32_4;
		end if;	
		if hreadregs5 = '1' then
			obus <= hibus32_5;
		end if;	
		if hreadregs6 = '1' then
			obus <= hibus32_6;
		end if;	
		if hreadregs7 = '1' then
			obus <= hibus32_7;
		end if;	
	end process WidthShim;
	
	atimer: process(clkmed,lreadtimerl,lreadtimerh,lwritetimerl, 
	                lwritetimerh, timeracc, timerlatch, timercount)
	begin
		if rising_edge(clkmed) then
			if lwritetimerl = '1' then
				timerdiv(7 downto 0) <= mobus;
			end if;	
			if lwritetimerh = '1' then
				timerdiv(15 downto 8) <= mobus;
			end if;	
			timeracc <= timeracc -1;
			if lreadtimerl = '1' then
				timerlatch <= timercount(15 downto 8);
			end if;	
			if timermsb = '1' then
				timercount <= timercount +1;
				timeracc <= timerdiv;
			end if;	
		end if;
		iodata <= (others => 'Z');
		if lreadtimerl = '1' then
			iodata <= timercount(7 downto 0);
		end if;
		if lreadtimerh = '1' then
			iodata <= timerlatch;
		end if;
	end process;		

					
	getclock : process (ioradd,lreadclock,baseclockslv)
	begin
		baseclockslv <= conv_std_logic_vector(BaseClock,32);
		iodata <= (others => 'Z');
		if lreadclock = '1' then
			case ioradd(1 downto 0) is
				when "00" => iodata <=  baseclockslv(7 downto 0);
				when "01" => iodata <=  baseclockslv(15 downto 8);
				when "10" => iodata <=  baseclockslv(23 downto 16);
				when "11" => iodata <=  baseclockslv(31 downto 24);
				when others => null;
			end case;
		end if;
	end process;
	
	getchannels : process (ioradd,lreadchannels)
	begin
		iodata <= (others => 'Z');
		if lreadchannels = '1' then
			iodata <=  conv_std_logic_vector(Ports,8);
		end if;
	end process;
		
	acrc8 : if NeedCRC8 generate
		crc8 : process (clkmed,newxor,lreadcrc) -- note Maxim or DOW CRC8 poly = x8,x5,x4,x1
		variable crc: std_logic_vector(7 downto 0);	
		begin		
			crc := x"00";
			for i in 0 to 7 loop
				if newxor(i) = '1'  then
					case i is					
						when 0 => crc := crc xor x"5E"; 	-- crc of 1  
						when 1 => crc := crc xor x"BC"; 	-- crc of 2
						when 2 => crc := crc xor x"61"; 	-- crc of 4
						when 3 => crc := crc xor x"C2"; 	-- crc of 8
						when 4 => crc := crc xor x"9D"; 	-- crc of 16
						when 5 => crc := crc xor x"23"; 	-- crc of 32 
						when 6 => crc := crc xor x"46"; 	-- crc of 64
						when 7 => crc := crc xor x"8C"; 	-- crc of 128
					end case;
				else
					crc := crc;
				end if;
			end loop;
			if rising_edge(clkmed) then
				if lwritecrc = '1' then
					newxor <= crc xor mobus;
				end if;
				if lclearcrc = '1' then
					newxor <= x"00";
				end if;
			end if;
			iodata <= (others => 'Z');
			if lreadcrc = '1' then
				iodata <= crc;
			end if;
		end process;		
	end generate;			
		
			
	LocalDecode: process (mwadd,mradd,ioradd,mread,mwrite,readrxdatasel,loadtxdatasel,
								 loadrxbitratelsel,loadrxbitratemsel,loadrxbitratehsel,
								 clearrxfifosel,readrxfifocountsel,readrxmodesel,loadrxmodesel,
								 loadtxbitratelsel,loadtxbitratemsel,loadtxbitratehsel,
								 cleartxfifosel,readtxfifocountsel,loadtxmodesel,readtxmodesel)
	begin
		writedram				<= (not mwadd(9)) and mwrite;
		
		lloadcommand    		<= decodedstrobe(mwadd,x"200",mwrite);
		lreadcommandl    		<= decodedstrobe(ioradd,x"200",mread);
		lreadcommandh    		<= decodedstrobe(ioradd,x"201",mread);
		lloaddata       		<= decodedstrobe(mwadd,x"202",mwrite);
		lreaddata       		<= decodedstrobe(ioradd,x"202",mread);
		lclrhdoorbell			<= decodedstrobe(mwadd,x"203",mwrite);
		lreadhdoorbell       <= decodedstrobe(ioradd,x"203",mread);

		lsettestbit     		<= decodedstrobe(mwadd,x"220",mwrite);
		lclrtestbit     		<= decodedstrobe(mwadd,x"221",mwrite);

		lreadtimerl				<=	decodedstrobe(ioradd,x"222",mread);
		lreadtimerh				<=	decodedstrobe(ioradd,x"223",mread);
		lwritetimerl			<=	decodedstrobe(mwadd,x"222",mwrite);
		lwritetimerh			<=	decodedstrobe(mwadd,x"223",mwrite);

		lreadcrc					<=	decodedstrobe(ioradd,x"224",mread);
		lwritecrc				<=	decodedstrobe(mwadd,x"224",mwrite);
		lclearcrc				<=	decodedstrobe(mwadd,x"225",mwrite);

		lreadclock				<=	decodedstrobe(ioradd(11 downto 2),"0010001100",mread); 	-- 0x430..0x433 
		lreadchannels			<=	decodedstrobe(ioradd,x"234",mread);
		
		lwriteiram       		<= decodedstrobe(mwadd(11 downto 8),x"3",mwrite);		-- 256 bytes max, 32 per reg
		lreadiram       		<= decodedstrobe(ioradd(11 downto 8),x"3",mread);

--		readdoorbell			<= decodedstrobe(ioradd(11 downto 6),"011100",mread);		-- 0x700 -- 0x7BF
--		cleardoorbell       	<= decodedstrobe( mwadd(11 downto 6),"011100",mwrite);		-- 64 bytes max

	
	
		-- UART decodes
		-- RX
		loadrxfiltersel		<= decodedstrobe(mwadd(11 downto 4),x"27",mwrite);
		readrxdatasel 			<= decodedstrobe(ioradd(11 downto 4),x"28",mread);
		loadrxbitratelsel		<= decodedstrobe(mwadd(11 downto 4),x"29",mwrite);
		loadrxbitratemsel		<= decodedstrobe(mwadd(11 downto 4),x"2A",mwrite);	
		loadrxbitratehsel		<= decodedstrobe(mwadd(11 downto 4),x"2B",mwrite);	
		clearrxfifosel			<= decodedstrobe(mwadd(11 downto 4),x"2C",mwrite);
		readrxfifocountsel	<= decodedstrobe(ioradd(11 downto 4),x"2C",mread);
		readrxmodesel			<= decodedstrobe(ioradd(11 downto 4),x"2D",mread);
		loadrxmodesel			<= decodedstrobe(mwadd(11 downto 4),x"2D",mwrite);

		loadrxfilter <= OneOfNDecode(Ports,loadrxfiltersel,mwrite,mwadd(log2(Ports)-1 downto 0));
		readrxdata <= OneOfNDecode(Ports,readrxdatasel,mread,ioradd(log2(Ports)-1 downto 0));
		loadrxbitratel <= OneOfNDecode(Ports,loadrxbitratelsel,mwrite,mwadd(log2(Ports)-1 downto 0));
		loadrxbitratem <= OneOfNDecode(Ports,loadrxbitratemsel,mwrite,mwadd(log2(Ports)-1 downto 0));
		loadrxbitrateh <= OneOfNDecode(Ports,loadrxbitratehsel,mwrite,mwadd(log2(Ports)-1 downto 0));
		clearrxfifo <= OneOfNDecode(Ports,clearrxfifosel,mwrite,mwadd(log2(Ports)-1 downto 0));
		readrxfifocount <= OneOfNDecode(Ports,readrxfifocountsel,mread,ioradd(log2(Ports)-1 downto 0));
		readrxmode <= OneOfNDecode(Ports,readrxmodesel,mread,ioradd(log2(Ports)-1 downto 0));
		loadrxmode <= OneOfNDecode(Ports,loadrxmodesel,mwrite,mwadd(log2(Ports)-1 downto 0));

		-- UART decodes
		-- TX		
		loadtxdatasel 			<= decodedstrobe(mwadd(11 downto 4),x"28",mwrite);
		loadtxbitratelsel		<= decodedstrobe(mwadd(11 downto 4),x"29",mwrite);	-- note on top of read baud rate select
		loadtxbitratemsel		<= decodedstrobe(mwadd(11 downto 4),x"2A",mwrite);
		loadtxbitratehsel		<= decodedstrobe(mwadd(11 downto 4),x"2B",mwrite);
--		readtxbitratelsel		<= decodedstrobe(ioradd(11 downto 4),x"29",mread);	-- note on top of read baud rate select
--		readtxbitratemsel		<= decodedstrobe(ioradd(11 downto 4),x"2A",mread);	-- note on top of read baud rate select
--		readtxbitratehsel		<= decodedstrobe(ioradd(11 downto 4),x"2B",mread);
		cleartxfifosel			<= decodedstrobe(mwadd(11 downto 4),x"2E",mwrite);
		readtxfifocountsel	<= decodedstrobe(ioradd(11 downto 4),x"2E",mread);
		readtxmodesel			<= decodedstrobe(ioradd(11 downto 4),x"2F",mread);
		loadtxmodesel			<= decodedstrobe(mwadd(11 downto 4),x"2F",mwrite);

		loadtxdata <= OneOfNDecode(Ports,loadtxdatasel,mwrite,mwadd(log2(Ports)-1 downto 0));
		loadtxbitratel <= OneOfNDecode(Ports,loadtxbitratelsel,mwrite,mwadd(log2(Ports)-1 downto 0));
		loadtxbitratem <= OneOfNDecode(Ports,loadtxbitratemsel,mwrite,mwadd(log2(Ports)-1 downto 0));
		loadtxbitrateh <= OneOfNDecode(Ports,loadtxbitratehsel,mwrite,mwadd(log2(Ports)-1 downto 0));
--		readtxbitratel <= OneOfNDecode(Ports,readtxbitratelsel,mread,ioradd(log2(Ports)-1 downto 0));
--		readtxbitratem <= OneOfNDecode(Ports,readtxbitratemsel,mread,ioradd(log2(Ports)-1 downto 0));
--		readtxbitrateh <= OneOfNDecode(Ports,readtxbitratehsel,mread,ioradd(log2(Ports)-1 downto 0));
		cleartxfifo <= OneOfNDecode(Ports,cleartxfifosel,mwrite,mwadd(log2(Ports)-1 downto 0));
		readtxfifocount <= OneOfNDecode(Ports,readtxfifocountsel,mread,ioradd(log2(Ports)-1 downto 0));
		loadtxmode <= OneOfNDecode(Ports,loadtxmodesel,mwrite,mwadd(log2(Ports)-1 downto 0));
		readtxmode <= OneOfNDecode(Ports,readtxmodesel,mread,ioradd(log2(Ports)-1 downto 0));
	end process localdecode;
	
	looseends: process (drven,txdata,rxserial)
	begin
	 	txenable <= drven;
		ntxenable <= not drven;
--		txenable(Ports-1) <= hdoorbell;		-- test kludge to check host command --> serial interface jitter
		txserial <= txdata;
		rxdata <= rxserial;
	end process looseends;	
	
end Behavioral;

