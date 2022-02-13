library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
--
-- Copyright (C) 2012, Peter C. Wallace, Mesa Electronics
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
--           permission.c1
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
-- dont change these:
use work.IDROMConst.all;	
use work.FixICap.all;

-------------------- option selection area ----------------------------


-------------------- select one card type------------------------------
use work.i90_x9card.all;
--use work.i90_x9card.all; 		-- 

-----------------------------------------------------------------------


-------------------- select (or add) one pinout -----------------------

use work.PIN_justio_72.all;

-- 72 pin pinouts for 7I90HD
--use work.PIN_JUSTIO_72.all;
--use work.PIN_SVST8_4IM2_72.all;
--use work.PIN_SVST8_4_72.all;
--use work.PIN_SVST4_8_72.all;
--use work.PIN_SVST4_8_ADO_72.all;
--use work.PIN_SVST8_8IM2_72.all;
--use work.PIN_SVST1_4_7I47S_72.all;
--use work.PIN_SVST2_4_7I47_72.all;
--use work.PIN_SVST1_5_7I47_72.all;
--use work.PIN_2X7I65_72.all;
--use work.PIN_ST12_72.all;
--use work.PIN_SV12_72.all;
--use work.PIN_SVST8_12_2x7I47_72.all;
--use work.PIN_SVSP8_6_7I46_72.all;
--use work.PIN_24XQCTRONLY_72.all;
--use work.PIN_2X7I65_72.all;
--use work.PIN_SV12IM_2X7I48_72.all;
--use work.PIN_SV6_7I49_72.all;
--use work.PIN_SVUA8_4_72.all;
--use work.PIN_SVUA8_8_72.all; -- 7I44 pinout UARTS
--use work.PIN_DA2_72.all;
--use work.PIN_SVST4_8_ADO_72.all;
--use work.PIN_SVSS8_8_72.all;
--use work.PIN_SSSVST8_8_8_72.all;
--use work.PIN_SVSS6_6_72.all;
--use work.PIN_SVSS6_8_72.all;
--use work.PIN_BASACKWARDS_SVSS6_8_72.all;
--use work.PIN_SSSVST8_1_5_7I47_72.all;
--use work.PIN_SVSS8_44_72.all;
--use work.PIN_RMSVSS6_8_72.all;
--use work.PIN_RMSVSS6_12_8_72.all; -- 4i69 5i24 7I80 only
--use work.PIN_ST8_PLASMA_72.all;
--use work.PIN_SV4_7I47S_72.all;
--use work.PIN_SVSTUA6_6_6_7I48_72.all;
--use work.PIN_SVSTTP6_6_7I39_72.all;
--use work.PIN_ST18_72.all;
--use work.PIN_SSSV6_36_72.all;
--use work.PIN_FASSSVRP4_4_4_72.all;
--use work.PIN_FA1_72.all;
--use work.PIN_BI1_72.all;
--use work.PIN_SISS4_4_72.all;
--use work.PIN_SUBSERIAL_BASE_72.all;
--use work.PIN_7I90SPIHost_72.all;
--use work.PIN_SC36_72.all;

----------------------------------------------------------------------
	
	
-- dont change anything below unless you know what you are doing -----
	
entity TopSerialHostMot2b is -- for 7I90HD/7I90DB
	 generic 
	 (
		ThePinDesc: PinDescType := PinDesc;
		TheModuleID: ModuleIDType := ModuleID;
		PWMRefWidth: integer := 13;	-- PWM resolution is PWMRefWidth-1 bits 
		IDROMType: integer := 3;		
		UseIRQLogic: boolean := true;
		UseWatchDog: boolean := true;
		OffsetToModules: integer := 64;
		OffsetToPinDesc: integer := 448;
		BusWidth: integer := 32;
		AddrWidth: integer := 16;
		InstStride0: integer := 4;			-- instance stride 0 = 4 bytes = 1 x 32 bit
		InstStride1: integer := 64;		-- instance stride 1 = 64 bytes = 16 x 32 bit registers
		RegStride0: integer := 256;		-- register stride 0 = 256 bytes = 64 x 32 bit registers
		RegStride1: integer := 256;      -- register stride 1 = 256 bytes - 64 x 32 bit
		FallBack: boolean := false			-- is this a fallback config?

		);
						
		
	Port (	CLK : in std_logic;
				LEDS : out std_logic_vector(LEDCount -1 downto 0);
				IOBITS : inout std_logic_vector(IOWidth -1 downto 0);
				SPICLK : out std_logic;
				SPIIN : in std_logic;
				SPIOUT : out std_logic;
				SPICS : out std_logic;
				NINIT : out std_logic;
				RXDATA : in std_logic;
				TXDATA : out std_logic;
				TXEN : out std_logic;
				TP : out std_logic_vector(1 downto 0);
				OPTS : in std_logic_vector(1 downto 0);
				RECONFIG : out std_logic
		 );
end TopSerialHostMot2b;


architecture Behavioral of TopSerialHostMot2b is
	 
-- GPIO interface signals

signal LoadSPIReg : std_logic;
signal ReadSPIReg : std_logic;
signal LoadSPICS : std_logic;
signal ReadSPICS : std_logic;

signal TPReg : std_logic_vector(1 downto 0);
signal SetTPReg0 : std_logic;
signal ClrTPReg0 : std_logic;
signal SetTPReg1 : std_logic;
signal ClrTPReg1 : std_logic;
signal ReadOpts : std_logic;

signal iabus : std_logic_vector(11 downto 0);	-- program address bus 
signal idbus : std_logic_vector(23 downto 0);	-- program data bus		 
signal mradd : std_logic_vector(11 downto 0);	-- memory read address
signal ioradd :  std_logic_vector(11 downto 0);	-- I/O read address
signal mwadd : std_logic_vector(11 downto 0);	-- memory write address
signal mibus : std_logic_vector(15 downto 0);	-- memory data in bus	  
signal mobus : std_logic_vector(15 downto 0);	-- memory data out bus
signal mwrite : std_logic;								-- memory write signal		  
signal mread : std_logic;								-- memory read signal	

signal mibus_ram : std_logic_vector(15 downto 0);	-- memory data in bus RAM
signal mibus_io : std_logic_vector(15 downto 0);	-- memory data in bus IO

signal wiosel : std_logic;
signal riosel : std_logic;

signal WriteLEDs : std_logic;
signal WriteLEDMode : std_logic;
signal LocalLEDs : std_logic_vector(1 downto 0);	
signal LEDMode: std_logic;
signal LEDErrFF: std_logic;
signal WriteErrLED: std_logic;

signal ReadExtData : std_logic;
signal WriteExtData : std_logic;
signal ReadExtAdd	 : std_logic;	
signal WriteExtAdd : std_logic;		
signal StartExtRead : std_logic;	
signal StartExtWrite : std_logic;
signal ExtAddrInc	 : std_logic;
signal Rates : std_logic_vector(4 downto 0);
signal ReadRates : std_logic;
signal ReadTimer : std_logic;
signal Timer : std_logic_vector(15 downto 0);
signal PreScale : std_logic_vector(7 downto 0);
signal HM2ReadBuffer: std_logic_vector(31 downto 0);
signal HM2WriteBuffer : std_logic_vector(31 downto 0);

signal Write32 : std_logic;
signal Read32 : std_logic;
signal Read32d : std_logic;

-- RX UART signals
signal ReadPktUARTRData : std_logic;
signal ReadPktUARTRFrameCount : std_logic;			
signal LoadPktUARTRBitRateL : std_logic;
signal ReadPktUARTRBitrateL : std_logic;
signal LoadPktUARTRBitRateH : std_logic;
signal ReadPktUARTRBitrateH : std_logic;
signal LoadPktUARTRModeRegL : std_logic;
signal ReadPktUARTRModeRegL : std_logic;
signal LoadPktUARTRModeRegH : std_logic;
signal ReadPktUARTRModeRegH : std_logic;
-- TX UART signals
signal LoadPktUARTTData : std_logic;
signal LoadPktUARTTFrameCount : std_logic;
signal ReadPktUARTTFrameCount : std_logic;
signal LoadPktUARTTBitRateL : std_logic;
signal ReadPktUARTTBitrateL : std_logic;
signal LoadPktUARTTBitRateH : std_logic;
signal ReadPktUARTTBitrateH : std_logic;
signal LoadPktUARTTModeRegL : std_logic;
signal ReadPktUARTTModeRegL : std_logic;
signal LoadPktUARTTModeRegH : std_logic;
signal ReadPktUARTTModeRegH : std_logic;
signal PTXEn : std_logic;

signal ForceReconfig : std_logic;
signal ReconfigLatch	 : std_logic := '0';
	
signal ExtAddress: std_logic_vector(15 downto 0);	

signal HM2obus	 : std_logic_vector(31 downto 0);
signal HM2LEDs	 : std_logic_vector(LEDCount -1 downto 0);

signal wseladd: std_logic_vector(7 downto 0); 
signal rseladd: std_logic_vector(7 downto 0); 

signal blinkcount : std_logic_vector(23 downto 0);

signal clk0fx : std_logic;
signal clk0 : std_logic;
signal procclk : std_logic;

signal clk1fx : std_logic;
signal clk1 : std_logic;
signal hm2fastclock : std_logic;

-- crc16 signals
signal NewXor: std_logic_vector(15 downto 0);
signal LReadCRC: std_logic;
signal LWriteCRC: std_logic;
signal LClearCRC: std_logic;

-- icap signals
signal ICapO : std_logic_vector(15 downto 0);
signal ICapI : std_logic_vector(15 downto 0);

signal ICapSel : std_logic;
signal ICapClk : std_logic;
signal ICapRW : std_logic;
signal LoadICapClk : std_logic;
signal LoadICapRW : std_logic;
signal LoadICap : std_logic;
signal ReadICap : std_logic;


begin


ahostmot2: entity work.HostMot2
	generic map (
		thepindesc => ThePinDesc,
		themoduleid => TheModuleID,
		idromtype  => IDROMType,		
	   sepclocks  => SepClocks,
		onews  => OneWS,
		useirqlogic  => UseIRQLogic,
		pwmrefwidth  => PWMRefWidth,
		usewatchdog  => UseWatchDog,
		offsettomodules  => OffsetToModules,
		offsettopindesc  => OffsetToPinDesc,
		clockhigh  => ClockHigh,
		clockmed => CLockMed,
		clocklow  => ClockLow,
		boardnamelow => BoardNameLow,
		boardnamehigh => BoardNameHigh,
		fpgasize  => FPGASize,
		fpgapins  => FPGAPins,
		ioports  => IOPorts,
		iowidth  => IOWidth,
		liowidth  => LIOWidth,
		portwidth  => PortWidth,
		buswidth  => BusWidth,
		addrwidth  => AddrWidth,
		inststride0 => InstStride0,
		inststride1 => InstStride1,
		regstride0 => RegStride0,
		regstride1 => RegStride1,
		ledcount  => LEDCount)
	port map (
		ibus =>  HM2WriteBuffer,
		obus => HM2obus, 
		addr => ExtAddress(15 downto 2),
		readstb => Read32,
		writestb => Write32,
		clklow => procclk,
		clkmed => procclk,			-- on 7I90 procclk is same as clocklow
		clkhigh =>  hm2fastclock,
--		int => INT, 
		iobits => IOBITS,			
		rates => Rates,
		leds => HM2LEDS	

		);

	


	ClockMult1 : DCM
		generic map (
			CLKDV_DIVIDE => 2.0,
			CLKFX_DIVIDE => 2, 
			CLKFX_MULTIPLY => 8,			-- 8/2 * 50 MHz = 200 mhz fast clock
			CLKIN_DIVIDE_BY_2 => FALSE, 
			CLKIN_PERIOD => 19.9,          
			CLKOUT_PHASE_SHIFT => "NONE", 
			CLK_FEEDBACK => "1X",         
			DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", 
															
			DFS_FREQUENCY_MODE => "LOW",
			DLL_FREQUENCY_MODE => "LOW",
			DUTY_CYCLE_CORRECTION => TRUE,
			FACTORY_JF => X"C080",
			PHASE_SHIFT => 0, 
			STARTUP_WAIT => FALSE)
		port map (
	
			CLK0 => clk1,   	-- 
			CLKFB => clk1,  	-- DCM clock feedback
			CLKFX => clk1fx,
			CLKIN => CLK,    	-- 50 Mhz source
			PSCLK => '0',    	-- Dynamic phase adjust clock input
			PSEN => '0',     	-- Dynamic phase adjust enable input
			PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
			RST => '0'        -- DCM asynchronous reset input
		);
  
	BUFG1_inst : BUFG
		port map (
			O => hm2fastclock,    		-- Clock buffer output
			I => clk1fx      				-- Clock buffer input
		);

  -- End of DCM_inst instantiation
	ClockMult2 : DCM
		generic map (
 			CLKDV_DIVIDE => 2.0,
			CLKFX_DIVIDE => 2, 
			CLKFX_MULTIPLY =>4,					-- 4/2 100 MHz	interface clock
			CLKIN_DIVIDE_BY_2 => FALSE, 
			CLKIN_PERIOD => 19.9,          
			CLKOUT_PHASE_SHIFT => "NONE", 
			CLK_FEEDBACK => "1X",         
			DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", 
															
			DFS_FREQUENCY_MODE => "LOW",
			DLL_FREQUENCY_MODE => "LOW",
			DUTY_CYCLE_CORRECTION => TRUE,
			FACTORY_JF => X"C080",
			PHASE_SHIFT => 0, 
			STARTUP_WAIT => FALSE)
		port map (
	
			CLK0 => clk0,   	-- 
			CLKFB => clk0,  	-- DCM clock feedback
			CLKFX => clk0fx,
			CLKIN => CLK,    	-- Clock input (from IBUFG, BUFG or DCM)
			PSCLK => '0',    	-- Dynamic phase adjust clock input
			PSEN => '0',     	-- Dynamic phase adjust enable input
			PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
			RST => '0'        -- DCM asynchronous reset input
		);
  
	BUFG2_inst : BUFG
		port map (
			O => procclk,    		-- Clock buffer output
			I => clk0fx      						-- Clock buffer input
		);

  -- End of DCM_inst instantiation

   ICAP_SPARTAN6_inst : ICAP_SPARTAN6
   generic map (
      DEVICE_ID => X"2000093",     -- Specifies the pre-programmed Device ID value
      SIM_CFG_FILE_NAME => "NONE"  -- Specifies the Raw Bitstream (RBT) file to be parsed by the simulation
                                   -- model
   )
   port map (
--      BUSY => BUSY, 			-- 1-bit output: Busy/Ready output
      O => ICapO,       		-- 16-bit output: Configuration data output bus
      CE => '0',   				-- 1-bit input: Active-Low ICAP Enable input
      CLK => ICapClk,   		-- 1-bit input: Clock input
      I => ICapI,   				-- 16-bit input: Configuration data input bus
      WRITE => ICapRW			-- 1-bit input: Read/Write control input
   );

	asimplspi: entity work.simplespi8
		generic map
		(
			buswidth => 8,
			div => 1,	-- for divide by 2 = 25 MHz
			bits => 8
		)	
		port map 
		( 
			clk  => procclk,
			ibus => mobus(7 downto 0),
			obus => mibus_io(7 downto 0),
			loaddata => LoadSPIReg,
			readdata => ReadSPIReg,
			loadcs => LoadSPICS,
			readcs => ReadSPICS,
			spiclk => SPIClk,
			spiin => SPIIn,
			spiout => SPIOut,
			spics =>SPICS 
		 );


	processor: entity work.D16W
	
	port map (
		clk     => procclk,
		reset	  => '0',
		iabus	  =>  iabus,		  -- program address bus
		idbus	  =>  idbus,		  -- program data bus		 
		mradd	  =>  mradd,		  -- memory read address
		mwadd	  =>  mwadd,		  -- memory write address
		mibus	  =>  mibus,		  -- memory data in bus	  
		mobus	  =>  mobus,		  -- memory data out bus
		mwrite  =>  mwrite,		  -- memory write signal	
      mread   =>  mread		     -- memory read signal	
--		carryflg  =>				  -- carry flag
		);


	apktuartrx16: entity work.pktuartr16
	generic map (MaxFrameSize => 1024) 		-- in bytes (-1) maximum is 2K bytes
	port map (
			clk => procclk,
			ibus => mobus,
         obus => mibus_io,			
			popdata => ReadPktUARTRData,
			poprc=> ReadPktUARTRFrameCount,
			loadbitratel => LoadPktUARTRBitRateL,
         readbitratel => ReadPktUARTRBitrateL,          
			loadbitrateh => LoadPktUARTRBitRateH,
         readbitrateh => ReadPktUARTRBitrateH,          
			loadmodel => LoadPktUARTRModeRegL,
			readmodel => ReadPktUARTRModeRegL,
			loadmodeh => LoadPktUARTRModeRegH,
			readmodeh => ReadPktUARTRModeRegH,
			rxmask => PTXEn,
			rxdata => RXData
			);

	apktuarttx16: entity work.pktuartx16
	generic map (MaxFrameSize => 1024) 		-- in bytes (-1) maximum is 2K bytes
	port map (
			clk => procclk,
			ibus => mobus,
         obus => mibus_io,			
			pushdata => LoadPktUARTTData,
			pushsc => LoadPktUARTTFrameCount,
			readsc => ReadPktUARTTFrameCount,
			loadbitratel => LoadPktUARTTBitRateL,
         readbitratel => ReadPktUARTTBitrateL,          
			loadbitrateh => LoadPktUARTTBitRateH,
         readbitrateh => ReadPktUARTTBitrateH,          
			loadmodel => LoadPktUARTTModeRegL,
			readmodel => ReadPktUARTTModeRegL,
			loadmodeh => LoadPktUARTTModeRegH,
			readmodeh => ReadPktUARTTModeRegH,
			drven => PTXEn,
			txdata => TXData
			);


  Serialhm2 : entity work.serhm2
  port map(
		addr => iabus(10 downto 0),
		clk  => procclk,
		din  => x"000000",
		dout => idbus,
		we	=> '0'
	 );

	DataRam : entity work.dpram 
	generic map (
		width => 16,
		depth => 2048
				)
	port map(
		addra => mwadd(10 downto 0),
		addrb => mradd(10 downto 0),
		clk  => procclk,
		dina  => mobus,
--		douta => 
		doutb => mibus_ram,
		wea	=> mwrite
	 );	 
	 
	 
	MiscProcFixes : process (procclk, mradd)		-- need to match BlockRAM address pipeline register for I/O
	begin	
		if rising_edge(procclk) then
			ioradd <= mradd;
		end if;
	end process;		
	
	ram_iomux : process (ioradd(10),mibus_ram,mibus_io)
	begin
		if ioradd(11 downto 7) =  "00000" then 	-- bottom 128 bytes are I/O, notched into RAM
			mibus <= mibus_io;
		else
			mibus <= mibus_ram;
		end if;
	end process;

	iodecode: process(ioradd, mwadd, mwrite, rseladd, wseladd, extaddress,
							writeextdata, readextdata, riosel, wiosel, mread)
	begin
		rseladd <= ioradd(7 downto 0);
		wseladd <= mwadd(7 downto 0);
		
		if ioradd(10 downto 7) = x"0" then
			riosel <= '1';
		else
			riosel <= '0';
		end if;
		
		if mwadd(10 downto 7) = x"0" then
			wiosel <= '1';
		else
			wiosel <= '0';
		end if;
		
		if wseladd = x"20" and wiosel = '1' and mwrite = '1' then
			LoadICap <= '1';
		else
			LoadICap <= '0';		
		end if;	

		if rseladd = x"20" and riosel = '1' then
			ReadICap <= '1';
		else
			ReadIcap <= '0';		
		end if;	

		if wseladd = x"21" and wiosel = '1' and mwrite = '1' then
			LoadICapClk <= '1';
		else
			LoadICapClk <= '0';		
		end if;	

		if wseladd = x"22" and wiosel = '1' and mwrite = '1' then
			LoadICapRW <= '1';
		else
			LoadICapRW <= '0';		
		end if;			
		
		if rseladd = x"23" and riosel = '1' then
			LReadCRC <= '1';
		else
			LReadCRC <= '0';		
		end if;	

		if wseladd = x"23" and wiosel = '1' and mwrite = '1' then
			LWriteCRC <= '1';
		else
			LWriteCRC <= '0';		
		end if;	

		if wseladd = x"24" and wiosel = '1' and mwrite = '1' then
			LClearCRC<= '1';
		else
			LClearCRC<= '0';		
		end if;	

		if rseladd = x"30" and riosel = '1' then
			ReadPktUARTRData <= '1';
		else
			ReadPktUARTRData <= '0';		
		end if;	

		if rseladd = x"31" and riosel = '1' then
			ReadPktUARTRFrameCount <= '1';
		else
			ReadPktUARTRFrameCount <= '0';		
		end if;	
		
		if wseladd = x"32" and wiosel = '1' and mwrite = '1' then
			LoadPktUARTRBitRateL <= '1';
		else
			LoadPktUARTRBitRateL <= '0';		
		end if;	

		if rseladd = x"32" and riosel = '1' then
			ReadPktUARTRBitrateL <= '1';
		else
			ReadPktUARTRBitrateL <= '0';		
		end if;	

		if wseladd = x"33" and wiosel = '1' and mwrite = '1' then
			LoadPktUARTRBitRateH <= '1';
		else
			LoadPktUARTRBitRateH <= '0';		
		end if;	

		if rseladd = x"33" and riosel = '1' then
			ReadPktUARTRBitrateH <= '1';
		else
			ReadPktUARTRBitrateH <= '0';		
		end if;	

		if wseladd = x"34" and wiosel = '1' and mwrite = '1'then
			LoadPktUARTRModeRegL <= '1';
		else
			LoadPktUARTRModeRegL <= '0';		
		end if;	

		if rseladd = x"34" and riosel = '1' then
			ReadPktUARTRModeRegL <= '1';
		else
			ReadPktUARTRModeRegL <= '0';		
		end if;	
		
		if wseladd = x"35" and wiosel = '1' and mwrite = '1'then
			LoadPktUARTRModeRegH <= '1';
		else
			LoadPktUARTRModeRegH <= '0';		
		end if;	

		if rseladd = x"35" and riosel = '1' then
			ReadPktUARTRModeRegH <= '1';
		else
			ReadPktUARTRModeRegH <= '0';		
		end if;	

		if wseladd = x"36" and wiosel = '1' and mwrite = '1'then
			LoadPktUARTTData <= '1';
		else
			LoadPktUARTTData <= '0';		
		end if;	

		if wseladd = x"37" and wiosel = '1' and mwrite = '1'then
			LoadPktUARTTFrameCount <= '1';
		else
			LoadPktUARTTFrameCount <= '0';		
		end if;	

		if rseladd = x"37" and riosel = '1' then
			ReadPktUARTTFrameCount <= '1';
		else
			ReadPktUARTTFrameCount <= '0';		
		end if;	
		
		if wseladd = x"38" and wiosel = '1' and mwrite = '1'then
			LoadPktUARTTBitRateL <= '1';
		else
			LoadPktUARTTBitRateL <= '0';		
		end if;	

		if rseladd = x"38" and riosel = '1' then
			ReadPktUARTTBitrateL <= '1';
		else
			ReadPktUARTTBitrateL <= '0';		
		end if;	

		if wseladd = x"39" and wiosel = '1' and mwrite = '1'then
			LoadPktUARTTBitRateH <= '1';
		else
			LoadPktUARTTBitRateH <= '0';		
		end if;	

		if rseladd = x"39" and riosel = '1' then
			ReadPktUARTTBitrateH <= '1';
		else
			ReadPktUARTTBitrateH <= '0';		
		end if;	

		if wseladd = x"3A" and wiosel = '1' and mwrite = '1'then
			LoadPktUARTTModeRegL <= '1';
		else
			LoadPktUARTTModeRegL <= '0';		
		end if;	

		if rseladd = x"3A" and riosel = '1' then
			ReadPktUARTTModeRegL <= '1';
		else
			ReadPktUARTTModeRegL <= '0';		
		end if;	

		if wseladd = x"3B" and wiosel = '1' and mwrite = '1'then
			LoadPktUARTTModeRegH <= '1';
		else
			LoadPktUARTTModeRegH <= '0';		
		end if;	

		if rseladd = x"3B" and riosel = '1' then
			ReadPktUARTTModeRegH <= '1';
		else
			ReadPktUARTTModeRegH <= '0';		
		end if;	

		if wseladd = x"3C" and wiosel = '1' and mwrite = '1'then
			SetTPReg0 <= '1';
		else
			SetTPReg0 <= '0';		
		end if;	

		if wseladd = x"3D" and wiosel = '1' and mwrite = '1'then
			ClrTPReg0 <= '1';
		else
			ClrTPReg0 <= '0';		
		end if;	

		if wseladd = x"3E" and wiosel = '1' and mwrite = '1'then
			SetTPReg1 <= '1';
		else
			SetTPReg1 <= '0';		
		end if;	

		if wseladd = x"3F" and wiosel = '1' and mwrite = '1'then
			ClrTPReg1 <= '1';
		else
			ClrTPReg1 <= '0';		
		end if;	

		if rseladd = x"3F" and riosel = '1' then
			ReadOpts <= '1';
		else
			ReadOpts <= '0';		
		end if;	

		if wseladd = x"40" and wiosel = '1' and mwrite = '1' then
			ForceReconfig <= '1';
		else
			ForceReconfig <= '0';		
		end if;	
		
		
		if rseladd (7 downto 2) = "011000" and riosel = '1' then -- 0x60 through 0x63
			ReadExtData <= '1';
		else
			ReadExtData <= '0';		
		end if;	

		if wseladd (7 downto 2) = "011000" and wiosel = '1' and mwrite = '1' then -- 0x60 through 0x63
			WriteExtData <= '1';
		else
			WriteExtData <= '0';		
		end if;	

		if rseladd = x"68" and riosel = '1' then
			ReadExtAdd <= '1';
		else
			ReadExtAdd <= '0';		
		end if;	

		if wseladd = x"68" and wiosel = '1' and mwrite= '1' then
			WriteExtAdd <= '1';
		else
			WriteExtAdd <= '0';		
		end if;	

		if wseladd = x"6C" and wiosel = '1' and mwrite = '1' then
			StartExtRead <= '1';
		else
			StartExtRead <= '0';		
		end if;	

		if wseladd = x"6D" and wiosel = '1' and mwrite= '1' then
			StartExtWrite <= '1';
		else
			StartExtWrite <= '0';		
		end if;	
	
		if wseladd = x"6E" and wiosel = '1' and mwrite = '1' then
			ExtAddrInc <= '1';
		else
			ExtAddrInc <= '0';		
		end if;	

		if rseladd = x"70" and riosel = '1' then
			ReadRates <= '1';
		else
			ReadRates <= '0';		
		end if;	
		
		if wseladd = x"79" and wiosel = '1' and mwrite = '1'then
			WriteErrLED <= '1';
		else
			WriteErrLED <= '0';		
		end if;	
	

		if wseladd = x"7A" and wiosel = '1' and mwrite = '1'then
			WriteLEDs <= '1';
		else
			WriteLEDs <= '0';		
		end if;	

		if wseladd = x"7B" and wiosel = '1' and mwrite = '1'then
			WriteLEDMode <= '1';
		else
			WriteLEDMode <= '0';		
		end if;	

		if rseladd = x"7C" and riosel = '1' then
			ReadTimer <= '1';
		else
			ReadTimer <= '0';		
		end if;	
		
		if wseladd = x"007D" and wiosel = '1' and mwrite = '1' then
			LoadSPICS <= '1';
		else
			LoadSPICS <= '0';		
		end if;	

		if rseladd = x"007D" and riosel = '1' then
			ReadSPICS <= '1';
		else
			ReadSPICS <= '0';		
		end if;	

		if wseladd = x"007E" and wiosel = '1' and mwrite = '1' then
			LoadSPIReg <= '1';
		else
			LoadSPIReg <= '0';		
		end if;	

		if rseladd = x"007E" and riosel = '1' then
			ReadSPIReg <= '1';
		else
			ReadSPIReg <= '0';		
		end if;	
		
	end process iodecode;
	
		
	SyncHM2InterfaceShim: process (procclk, readextdata,rseladd, 
											 hm2readbuffer, startextwrite,
											 readextadd,extaddress,ReadRates,
											 Rates,ledmode,hm2leds,localleds,PTXEn )
	begin	
		if rising_edge(procclk) then
			Read32 <= StartExtRead;
		  	if WriteLEDS = '1' then
				LocalLEDs <= mobus(1 downto 0);
			end if;
			
		  	if WriteLEDMode = '1' then
				LEDMode <= mobus(0);
			end if;

		  	if WriteErrLED = '1' then
				LEDErrFF <= mobus(0);
			end if;
			
			if WriteExtData = '1' then 
				case wseladd(0) is
					when'0' => HM2WriteBuffer(15 downto  0) <= mobus;
					when'1' => HM2WriteBuffer(31 downto  16) <= mobus;
					when others => null;
				end case;
			end if;

			if WriteExtAdd = '1' then
				ExtAddress <= mobus;
			end if;	

			if Read32 = '1' then
				HM2ReadBuffer <= HM2OBus;
			end if;	
			

			if (ExtAddrInc = '1') and (mobus(7) = '1') then -- hack to allow inc via lbp inc bit
				ExtAddress <= ExtAddress +4;
			end if;	
			
			
		end if;	-- procclk
	   Write32 <= StartExtWrite;
		
		mibus_io <= "ZZZZZZZZZZZZZZZZ";
		
		if ReadExtData = '1' then
			case rseladd(0) is
				when '0' => mibus_io <= HM2ReadBuffer(15 downto  0);
				when '1' => mibus_io <= HM2ReadBuffer(31 downto  16);
				when others => null;
			end case;
		end if;
		
		if ReadRates = '1' then
			mibus_io(4 downto 0) <= Rates;
		end if;	
		
		if ReadExtAdd = '1' then
			mibus_io <= ExtAddress;
		end if;

		if LEDMode = '0' then
			LEDS <= HM2LEDs;
		else	
			LEDS <= not LocalLEDs;
		end if;	
		TXEN <= PTXEn;		
	end process;	
	

	uSTimer: process (procclk,ReadTimer,Timer) -- one usec timer
	begin				
		mibus_io <= "ZZZZZZZZZZZZZZZZ";
		if ReadTimer = '1' then
			mibus_io <= Timer;
		end if;
		if rising_edge(procclk) then			-- hardwired for divide by 100!!!
			PreScale <= PreScale -1;
			if PreScale(7) = '1' then
				PreScale <= x"62";					-- modulo = n+2 = 100
				Timer <= Timer +1;
			end if;
		end if;
	end process uSTimer;	

	crc16 : process (procclk,NewXor,LReadCRC) -- note CCITT (Kermit) X^16 + X^12 + X^5 + 1
	variable crc: std_logic_vector(15 downto 0);	
	begin		
		crc := x"0000";
		for i in 0 to 15 loop
			if NewXor(i) = '1'  then
				case i is					
					when 0  => crc := crc xor x"8911"; 	-- crc of 1  
					when 1  => crc := crc xor x"1223"; 	-- crc of 2
					when 2  => crc := crc xor x"2446"; 	-- crc of 4
					when 3  => crc := crc xor x"488C"; 	-- crc of 8
					when 4  => crc := crc xor x"8110"; 	-- crc of 16
					when 5  => crc := crc xor x"0221"; 	-- crc of 32 
					when 6  => crc := crc xor x"0442"; 	-- crc of 64
					when 7  => crc := crc xor x"0884"; 	-- crc of 128
					when 8  => crc := crc xor x"D819"; 	-- crc of 256  
					when 9  => crc := crc xor x"B033"; 	-- crc of 512
					when 10 => crc := crc xor x"6067"; 	-- crc of 1024
					when 11 => crc := crc xor x"C0CE"; 	-- crc of 2048
					when 12 => crc := crc xor x"9195"; 	-- crc of 4096
					when 13 => crc := crc xor x"3323"; 	-- crc of 8192 
					when 14 => crc := crc xor x"6646"; 	-- crc of 16384
					when 15 => crc := crc xor x"CC8C"; 	-- crc of 32768
				end case;
			else
				crc := crc;
			end if;
		end loop;
		if rising_edge(procclk) then
			if LWriteCRC = '1' then
				NewXor<= crc xor mobus;
			end if;
			if LClearCRC= '1' then
				NewXor<= x"0000";
			end if;
		end if;
		mibus_io <= (others => 'Z');
		if LReadCRC = '1' then
			mibus_io <= crc;
		end if;
	end process;		
	

	OptsDebug: process (procclk,OPTS,ReadOpts,TPReg)
	begin
				
		mibus_io <= "ZZZZZZZZZZZZZZZZ";
		if ReadOpts = '1' then
			mibus_io(1 downto 0) <= OPTS;
		end if;
		
		if rising_edge(procclk) then
			if SetTPReg0 = '1' then
				TPReg(0) <= '1';
			end if;
			if ClrTPReg0 = '1' then
				TPReg(0) <= '0';
			end if;
			if SetTPReg1 = '1' then
				TPReg(1) <= '1';
			end if;
			if ClrTPReg1 = '1' then
				TPReg(1) <= '0';
			end if;
		end if;
		TP <= TPReg;	
	end process OptsDebug;	

	doreconfig : process(procclk,ReconfigLatch)
	begin
		if rising_edge(procclk) then 
			if ForceReconfig = '1' then
				ReconfigLatch <= '1';
			end if;	
		end if;
		if ReconfigLatch = '1' then
			RECONFIG <= '0';
		else
			RECONFIG <= 'Z';
		end if;
	end process;		
	
	ICapSupport: process (procclk,ReadICap,LoadICap)
	begin
		if rising_edge(procclk) then
			if LoadICap = '1' then
				ICapI <= FixIcap(mobus);
--				ICapI <= mobus;
			end if;
			if LoadICapRW= '1' then
				ICapRW <= mobus(0);
			end if;	
			if LoadICapClk= '1' then
				ICapClk <= mobus(0);
			end if;	
		end if;		
		mibus_io <= "ZZZZZZZZZZZZZZZZ";
		if ReadICap= '1' then
			mibus_io <= FixICap(ICapO);
--			mibus_io <= ICapO;
		end if;
	end process;	
		
	dofallback: if fallback generate -- do blinky red light to indicate failure to load primary bitfile
		Fallbackmode : process(procclk)
		begin
			if rising_edge(procclk) then 
				blinkcount <= blinkcount +1;
			end if;
			NINIT <= blinkcount(23);
		end process;	
	end generate;	
		
	donormal: if not fallback generate
		NormalMode : process(LEDErrFF)
		begin
--			NINIT <= 'Z';
			NINIT <= not LEDErrFF;
		end process;	
	end generate;		
		


end Behavioral;
