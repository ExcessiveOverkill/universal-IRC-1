library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;
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
Library UNISIM;
use UNISIM.vcomponents.all;

-- dont change these:
use work.IDROMConst.all;	
use work.decodedstrobe.all;
use work.FixICap.all;

-------------------- option selection area ----------------------------


-------------------- select one card type------------------------------
use work.i90_x9card.all;

-- use work.i90_x9card.all;        -- needs 7i90spi.ucf and SP6 x9 144 pin
-----------------------------------------------------------------------
use work.PIN_justio_72.all;

--72 pin pinouts for 7I90
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
--use work.PIN_SVSSST6_6_12_72.all;
--use work.PIN_SVSS6_8_72.all;
--use work.PIN_SSSVST8_1_5_7I47_72.all;
--use work.PIN_SVSS8_44_72.all;
--use work.PIN_RMSVSS6_8_72.all;
--use work.PIN_RMSVSS6_12_8_72.all; -- 4i69 5i24 only
--use work.PIN_ST8_PLASMA_72.all;
--use work.PIN_SV4_7I47S_72.all;
--use work.PIN_SVSTUA6_6_6_7I48_72.all;
--use work.PIN_SVSTTP6_6_7I39_72.all;
--use work.PIN_ST18_72.all;
--use work.PIN_SSST8_6_72.all;

----------------------------------------------------------------------
	
	
-- dont change anything below unless you know what you are doing -----
	
entity TopGCSPIHostMot2b is -- for 7I90 in SPI mode
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
				COM_SPICLK : in std_logic;			-- host interface SPI ( FPGA is slave)
				COM_SPIIN : in std_logic;
				COM_SPIOUT : out std_logic;
				COM_SPICS : in std_logic;
				TEST0 : out std_logic;
				RECONFIG : out std_logic;
				NINIT : out std_logic;
				SPICLK : out std_logic;				-- config flash spi interface (FPGA is master)
				SPIIN : in std_logic;
				SPIOUT : out std_logic;
				SPICS : out std_logic
		 );
end TopGCSPIHostMot2b;

architecture Behavioral of TopGCSPIHostMot2b is

constant SPIRead : std_logic_vector(3 downto 0) := x"A";
constant SPIWrite : std_logic_vector(3 downto 0) := x"B";
	
constant SPITimeoutR : real  := round(real(ClockLow)*0.000050);	-- 50 usec default SPI timeout
constant SPITimeout : std_logic_vector(15 downto 0) :=  std_logic_vector(to_unsigned(integer(SPITimeoutR),16));
signal obus : std_logic_vector(31 downto 0);
signal translateaddr : std_logic_vector(AddrWidth-1 downto 0);
alias  translatestrobe : std_logic is  translateaddr(AddrWidth-1);
signal loadtranslateram : std_logic;
signal readtranslateram : std_logic;
signal translateramsel : std_logic;

signal loadspics : std_logic;
signal readspics : std_logic;
signal loadspireg : std_logic;
signal readspireg : std_logic;

signal Read32 : std_logic;
signal Write32Pipe : std_logic_vector(3 downto 0);
alias Write32: std_logic is Write32Pipe(3);

signal ReconfigSel : std_logic;
signal fooidata: std_logic_vector(7 downto 0);

signal ReConfigreg : std_logic := '0';
signal blinkcount : std_logic_vector(25 downto 0);
-- SPI interface signals

signal SPIRegIn : std_logic_vector(31 downto 0);
signal SPIRegOut : std_logic_vector(31 downto 0);
signal HM2DataOut : std_logic_vector(31 downto 0);
signal HM2DataOutL : std_logic_vector(31 downto 0);
signal HM2DataInL : std_logic_vector(31 downto 0);
signal AddrPtr : std_logic_vector(15 downto 0);
signal SyncAddrPtr : std_logic_vector(15 downto 0);
signal SPIBitCount : std_logic_vector(4 downto 0);
signal SPIHeader : std_logic;
signal DCOM_SPICS : std_logic;
signal SPICommand : std_logic_vector(3 downto 0);
signal SPIBurstCount : std_logic_vector(6 downto 0);
signal SPIAutoInc : std_logic;
signal FrameTimer : std_logic_vector(15 downto 0);
alias  FrameTimerMSB : std_logic is FrameTimer(15);
signal  FrameTimerMSBD : std_logic;

signal SPIReadRequest : std_logic;
signal SPIReadRequest1 : std_logic;
signal SPIReadRequest2 : std_logic;
signal SPIWriteRequest : std_logic;
signal SPIWriteRequest1 : std_logic;
signal SPIWriteRequest2 : std_logic;
signal SPIHeaderFlag : std_logic;
signal SPIHeaderFlag1 : std_logic;
signal SPIHeaderFlag2 : std_logic;
signal UpdateSPIReg : std_logic;
signal UpdateSPIRegD : std_logic;
signal NeedWrite : std_logic;
-- ICap interface		

signal LoadICap : std_logic;
signal ReadICapCookie : std_logic;
signal ICapI : std_logic_vector(15 downto 0);
signal ICapClock : std_logic;
signal ICapTimer : std_logic_vector(5 downto 0) := "000000";

signal fclk : std_logic;
signal clkfx0: std_logic;
signal clk0_0: std_logic;

signal clklow : std_logic;
signal clkfx1: std_logic;
signal clk0_1: std_logic;


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
		clockmed => ClockMed,
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
		ledcount  => LEDCount		)
	port map (
		ibus =>  HM2DataInL,
		obus => HM2DataOut,
		addr => SyncAddrPtr(AddrWidth-1 downto 2),
		readstb => read32,
		writestb => write32,
		clklow => clklow,					-- I/O clock
		clkmed  => clklow,				-- Processor clock
		clkhigh =>  fclk,					-- PWM clock
--		int => INT, 
		iobits => IOBITS,			
		leds => LEDS	
		);



		
   ClockMultH : DCM
   generic map (
      CLKDV_DIVIDE => 2.0,
      CLKFX_DIVIDE => 2, 
      CLKFX_MULTIPLY => 8,			-- 8 FOR 200 MHz
      CLKIN_DIVIDE_BY_2 => FALSE, 
      CLKIN_PERIOD => 20.0,          
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
 
      CLK0 => clk0_0,   	-- 
      CLKFB => clk0_0,  	-- DCM clock feedback
		CLKFX => clkfx0,
      CLKIN => CLK,    -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => '0',   	-- Dynamic phase adjust clock input
      PSEN => '0',     	-- Dynamic phase adjust enable input
      PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
      RST => '0'        -- DCM asynchronous reset input
   );
  
  BUFG_inst0 : BUFG
   port map (
      O => fclk,    -- Clock buffer output
      I => clkfx0      -- Clock buffer input
   );
	
   ClockMultM : DCM
   generic map (
      CLKDV_DIVIDE => 2.0,
      CLKFX_DIVIDE => 2, 
      CLKFX_MULTIPLY => 4,			-- 4 FOR 100 MHz
      CLKIN_DIVIDE_BY_2 => FALSE, 
      CLKIN_PERIOD => 20.0,          
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
 
      CLK0 => clk0_1,   	-- 
      CLKFB => clk0_1,  	-- DCM clock feedback
		CLKFX => clkfx1,
      CLKIN => CLK,    -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => '0',   	-- Dynamic phase adjust clock input
      PSEN => '0',     	-- Dynamic phase adjust enable input
      PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
      RST => '0'        -- DCM asynchronous reset input
   );
  
  BUFG_inst1 : BUFG
   port map (
      O => clklow,    -- Clock buffer output
      I => clkfx1      -- Clock buffer input
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
--      O => ICapO,       		-- 16-bit output: Configuration data output bus
      CE => '0',   				-- 1-bit input: Active-Low ICAP Enable input
      CLK => ICapClock,   		-- 1-bit input: Clock input
      I => ICapI,   				-- 16-bit input: Configuration data input bus
      WRITE => '0'				-- 1-bit input: Read/Write control input
   );

	gcspi: process(clklow,COM_SPICLK)		-- SPI interface with separate GClk SPI clock CPOL 0 CPHA 0
	begin
		if Rising_edge(COM_SPICLK) then		-- sample the SPI data in on rising edge
			if UpdateSPIReg = '1' then
				UpdateSPIReg <= '0';
			end if;	
			if COM_SPICS= '0' then				
				SPIRegIn <= SPIRegIN(30 downto 0) & COM_SPIIn;		-- shift left (MSB first)
				SPIBitCount <= SPIBitCount +1; 
				if SPIHeader= '1' then
					if SPIBitCount = "01000" then							-- clear command etc at 8
						AddrPtr <= x"0000";
						SPICommand <= "0000";								
						SPIBurstCount <= "0000000";						
						SPIAutoInc <= '0';
					end if;
					if SPIBitCount = "10000" then
						AddrPtr <= SPIRegIn(15 downto 0);				-- grab address on the fly at 16
					end if;
					if SPIBitCount = "10100" then 
						SPICommand <= SPIRegIn(3 downto 0);				-- grab command on the fly at 20
					end if;
					if SPIBitCount = "10101" then 
						SPIAutoInc <= SPIRegIn(0);							-- grab autoinc on the fly at 21
						SPIHeaderFlag <= '1';								-- signal HM2 clock domain process
					end if;
					if SPIBitCount = "11100" then							-- grab burst count at 28
						SPIBurstCount <= SPIRegIn(6 downto 0);
					end if;		
					if SPIBitCount = "11111" then							 
						SPIHeader <= '0';
					end if;
				else																-- not header												
					if SPIBitCount = "11111" then
						if SPIBurstCount = 1 then
							SPIHeader <= '1';
						else	
							SPIBurstCount <= SPIBurstCount -1;
						end if;	
					end if; 							
					
				end if; --header

				if (SPICommand = SPIRead) and (SPIBitCount = "10110") and (SPIBurstCount /= 1) then -- read request at bit 22
					SPIReadRequest <= '1';
					UpdateSPIReg <= '1';
				end if;	

				if (SPICommand = SPIWrite) and (SPIBitCount = "10110") and SPIHeader = '0' then -- write request at bit 22
					NeedWrite <= '1';
				end if;	

				if NeedWrite = '1' and SPIBitCount = "00000" then
					SPIWriteRequest <= '1';
					HM2DataInL <= SPIRegIn;
					NeedWrite <= '0';
				end if;	

			end if;	-- CS = 0
		end if;	-- clk falling edge
		
		if Falling_edge(COM_SPICLK) then									-- shift data out on falling edge						
			if COM_SPICS = '0' then
				if UpDateSPIReg = '1' then
					UpDateSPIRegD <= '1';
				end if;	
				SPIRegOut <= SPIRegOut(30 downto 0) & '0';
				if SPIBitCount = "00000" and UpdateSPIRegD = '1' then
					SPIRegOut <= HM2DataOutL;
					UpdateSPIRegD <= '0';
				end if;	
			end if;
		end if;
		
		if rising_edge(ClkLow) then

			SPIReadRequest2 <= SPIReadRequest1;			
			SPIWriteRequest2 <= SPIWriteRequest1;
			SPIHeaderFlag2 <= SPIHeaderFlag1;	

			SPIReadRequest1 <= SPIReadRequest;			
			SPIWriteRequest1 <= SPIWriteRequest;			
			SPIHeaderFlag1 <= SPIHeaderFlag;	
			
			FrameTimerMSBD <= FrameTimerMSB;
			
			DCOM_SPICS <= COM_SPICS;
			if DCOM_SPICS = '1' then
				if FrameTimerMSB = '0' then
					FrameTimer <= FrameTimer -1;
				end if;
			else
				FrameTimer <= SPITimeout;
			end if;									
			
			if Read32 = '1' then 
				HM2DataOutL <= HM2DataOut;
				if SPIAutoInc = '1' then
					SyncAddrPtr <= SyncAddrPtr +4; 
				end if;	
			end if;
			
			Write32Pipe <= Write32Pipe(2 downto 0) & (SPIWriteRequest1 and SPIWriteRequest2) ;

			if Write32 = '1' then 
				if SPIAutoInc = '1' then
					SyncAddrPtr <= SyncAddrPtr +4; 
				end if;	
			end if;
			
			if (SPIHeaderFlag1 = '1') and (SPIHeaderFlag2 = '1') then
				SyncAddrPtr <= AddrPtr;
			end if;

		end if; -- clock low
		
		if (FrameTimerMSB = '1') and (FrameTimerMSBD = '0') then		-- always set header on frame timeout
			SPIHeader <= '1';					-- async set header
			SPIRegOut <= x"AAAAAAAA";
		end if;	
		
		if (SPIReadRequest1 = '1') and (SPIReadRequest2 = '1') then
			SPIReadRequest <= '0';							-- async clear request
			Read32 <= '1';
		else
			Read32 <= '0';
		end if;	
		
		
		if (SPIWriteRequest1 = '1') and (SPIWriteRequest2 = '1') then
			SPIWriteRequest <= '0';							-- async clear request
		end if;

		if (SPIHeaderFlag1 = '1') and (SPIHeaderFlag2 = '1') then
			SPIHeaderFlag <= '0';							-- async clear request
		end if;
		
		if COM_SPICS = '1' then								-- need filter!
			SPIBitCount <= "00000";							-- async clear bit count
		end if;	
		
		COM_SPIOUT <= SPIRegOut(31);
		TEST0 <= SPIReadRequest;
	end process;
		
	

	ConfigDecode : process(AddrPtr,Read32,Write32) 
	begin	
		LoadSPICS  <= decodedstrobe(AddrPtr(AddrWidth-1 downto 2)&"00",x"0070",Write32);
		ReadSPICS  <= decodedstrobe(AddrPtr(AddrWidth-1 downto 2)&"00",x"0070",Read32);
		LoadSPIReg <= decodedstrobe(AddrPtr(AddrWidth-1 downto 2)&"00",x"0074",Write32);
		ReadSPIReg <= decodedstrobe(AddrPtr(AddrWidth-1 downto 2)&"00",x"0074",Read32);
	end process ConfigDecode;
	
	doreconfig: process (clklow,ReConfigreg, AddrPtr)
	begin
		if AddrPtr = x"7F7F" then
			ReconfigSel <= '1';
		else
			ReconfigSel <= '0';		
		end if;	
		if rising_edge(clklow) then
			if Write32 = '1' and ReconfigSel = '1' then
				if HM2DataInL(7 downto 0) = x"5A" then
					ReConfigReg <= '1';
				end if;
			end if;
		end if;		
		RECONFIG <= not ReConfigReg;
	end process doreconfig;	
	
	asimplspi: entity work.simplespi8	-- configuration serial EEPROM access SPI port
	generic map
	(
		buswidth => 8,
		div => 7,	-- for divide by 8	-- 12.5 MHz
		bits => 8
	)	
	port map 
	( 
		clk  => clklow,
		ibus =>  HM2DataInL(7 downto 0),
		obus => HM2DataOut(7 Downto 0),
		loaddata => LoadSPIReg,
		readdata => ReadSPIReg,
		loadcs => LoadSPICS,
		readcs => ReadSPICS,
		spiclk => SPICLK,
		spiin => SPIIN,
		spiout => SPIOUT,
		spics =>SPICS 
	);

	ICapDecode : process(Addrptr,Write32) 
	begin
		LoadICap  <= decodedstrobe(AddrPtr(AddrWidth-1 downto 2)&"00",x"0078",Write32);
		ReadICapCookie  <= decodedstrobe(AddrPtr(AddrWidth-1 downto 2)&"00",x"0078",Read32);
	end process ICAPDecode;

	ICapSupport: process (clklow,LoadICap)
	begin
		if rising_edge(clklow) then
			if LoadICap = '1' then
				ICapI <= FixICap(HM2DataInL(15 downto 0));
				ICapTimer <= "111111";
			end if;		
			if ICapTimer /= "000000" then
				ICapTimer <= ICapTimer -1;
			end if;				
			ICapClock <= ((not ICapTImer(5)) and ICapTimer(4));	-- 16 counts wide , 32 counts late 
		end if;
		HM2DataOut <= (others => 'Z');	
		if ReadICAPCookie = '1' then
			HM2DataOut <= x"1CAB1CAB";
		end if;	
	end process ICapSupport;	

	dofallback: if fallback generate -- do blinky red light to indicate failure to load primary bitfile
		Fallbackmode : process(clklow)
		begin
			if rising_edge(clklow) then 
				blinkcount <= blinkcount +1;
			end if;
			NINIT <= blinkcount(25);
		end process;	
	end generate;	
	
	donormal: if not fallback generate
		NormalMode : process(clklow)
		begin
			NINIT <= 'Z';
		end process;	
	end generate;		
	
end;

