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
Library UNISIM;
use UNISIM.vcomponents.all;

-- dont change these:
use work.IDROMConst.all;	
use work.decodedstrobe.all;
use work.FixICap.all;
-------------------- option selection area ----------------------------


-------------------- select one card type------------------------------
use work.@Card@.all;

--use work.i90_x9card.all;        -- needs 7i90.ucf and SP6 x9 144 pin
--use work.c80_x9card.all;        -- needs 7c80epp.ucf and SP6 x9 144 pin
--use work.c81_x9card.all;        -- needs 7c81epp.ucf and SP6 x9 144 pin

-----------------------------------------------------------------------
use work.@Pin@.all;
--72 pin pinouts for 7I90
--use work.PIN_JUSTIO_72.all;
--use work.PIN_SVST8_4IM2_72.all;
--use work.PIN_SVST8_4_72.all;
--use work.PIN_SVST4_8_72.all;
--use work.PIN_SVST4_8_I90_72.all; -- has UART on RJ45 for loopback test
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
--use work.PIN_SSST8_6_72.all;
--use work.PIN_SVSSST10_4_8_72.all;
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
--use work.PIN_ST24_72.all;
--use work.PIN_STSVSS6_6_4_72.all;
--use work.PIN_REFPRINTER_72.all;
--use work.PIN_bjames_72.all;
--use work.PIN_7I49_7I77_72.all;

-- 54 pin pinouts for 7C80
--use work.PIN_7C80D_54.all;

-- 56 pin pinouts for 7C81
--use work.PIN_5ABOBx3D_56.all;
--use work.PIN_5ABOBx2D_56.all;

----------------------------------------------------------------------
	
	
-- dont change anything below unless you know what you are doing -----
	
entity TopEPPSHostMot2 is -- for 7I90/7C80/7C81 in EPP mode
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
				LIOBITS: inout std_logic_vector (LIOWidth -1 downto 0);	-- local I/O bits		
				EPP_DATABUS : inout std_logic_vector(7 downto 0);
				EPP_DSTROBE : in std_logic;
				EPP_ASTROBE : in std_logic;
				EPP_WAIT : out std_logic;
				EPP_READ : in std_logic;
				RECONFIG : out std_logic;
				SPICLK : out std_logic;
				SPIIN : in std_logic;
				SPIOUT : out std_logic;
				SPICS : out std_logic;
				NINIT : out std_logic
		 );
end TopEPPSHostMot2;

architecture Behavioral of TopEPPSHostMot2 is

	
signal afcnt : std_logic_vector(1 downto 0) := "00";
signal afilter : std_logic := '0';
signal dfcnt : std_logic_vector(1 downto 0) := "00";
signal dfilter : std_logic := '0';
signal rfcnt : std_logic_vector(1 downto 0) := "11";
signal rfilter : std_logic := '1';
signal acycle : std_logic_vector(3 downto 0) := "0000";
signal dcycle : std_logic_vector(3 downto 0) := "0000";
signal waitpipe : std_logic := '0';
signal oldwaitpipe : std_logic := '0';
signal alatch : std_logic_vector(AddrWidth-1 downto 0); 
signal seladd : std_logic_vector(AddrWidth-1 downto 0);
signal aread : std_logic;
signal wasaddr : std_logic := '0';
signal wasaddrrq : std_logic := '0';
signal dread : std_logic;
signal dreadle : std_logic;
signal dwritete : std_logic; 
signal awritete : std_logic; 
signal dstrobete : std_logic; 
signal autoincrq : std_logic := '0';
signal astrobete : std_logic; 
signal depp_dstrobe : std_logic := '1';
signal depp_astrobe : std_logic := '1';
signal depp_read : std_logic := '1';

signal wdlatch : std_logic_vector(31 downto 0);
signal rdlatch : std_logic_vector(31 downto 0);
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

signal read32 : std_logic;
signal write32 : std_logic;
signal dwrite32 : std_logic;

signal ReconfigSel : std_logic;
signal idata: std_logic_vector(7 downto 0);

signal ReConfigreg : std_logic := '0';
signal blinkcount : std_logic_vector(25 downto 0);
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
		ibus =>  wdlatch,
		obus => obus,
		addr => seladd(AddrWidth-1 downto 2),
		readstb => read32,
		writestb => dwrite32,
		clklow => clklow,					-- I/O clock
		clkmed  => clklow,				-- Processor clock
		clkhigh =>  fclk,					-- PWM clock
--		int => INT, 
		iobits => IOBITS,			
		liobits => LIOBITS,
		leds => LEDS	
		);

	transmogrifier: entity work.atrans 
	generic map (
				width => AddrWidth,
				depth =>  8)
	port map(
 		clk => clklow,
		wea => loadtranslateram,
		rea => readtranslateram,
		reb => '1',
 		adda => alatch(9 downto 2),
		addb => alatch(7 downto 0),
 		din => wdlatch(15 downto 0),
 		douta => obus(15 downto 0),
		doutb => translateaddr
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
--    BUSY => BUSY, 			-- 1-bit output: Busy/Ready output
--    O => ICapO,       		-- 16-bit output: Configuration data output bus
      CE => '0',   				-- 1-bit input: Active-Low ICAP Enable input
      CLK => ICapClock,   		-- 1-bit input: Clock input ~6 MHz max
      I => ICapI,   				-- 16-bit input: Configuration data input bus
      WRITE => '0'				-- 1-bit input: Read/Write control input 1= read 0= write
   );
  

	EPPInterface: process(clk, waitpipe, alatch, afilter, dfilter,  
								 EPP_READ, EPP_DSTROBE, EPP_ASTROBE,
								 depp_dstrobe, depp_astrobe, dcycle, rfilter, acycle)
	begin

		if rising_edge(clklow) then
			depp_dstrobe <= EPP_DSTROBE;			-- async so one level of FF before anything else
			depp_astrobe <= EPP_ASTROBE;
			depp_read <= EPP_READ;
         oldwaitpipe <= waitpipe;
			if  depp_astrobe = '0' then
				if afcnt /= 3 then 
					afcnt <= afcnt +1;
				end if;
			else
				if afcnt /= 0 then 
					afcnt <= afcnt -1;
				end if;
			end if;

			if afcnt = 3 then						-- afilter set 80-100 ns after strobe 	 
				afilter <= '1';
			end if;
			if afcnt = 0 then 
				afilter <= '0';
			end if;

			if  depp_dstrobe = '0' then
				if dfcnt /= 3 then 
					dfcnt <= dfcnt +1;
				end if;
			else
				if dfcnt /= 0 then 
					dfcnt <= dfcnt -1;
				end if;
			end if;

			if dfcnt = 3 then						-- dfilter set 80-100 ns after strobe  
				dfilter <= '1';
			end if;
			if dfcnt = 0 then 
				dfilter <= '0';
			end if;

			if  depp_read = '1' then
				if rfcnt /= 3 then 
					rfcnt <= rfcnt +1;
				end if;
			else
				if rfcnt /= 0 then 
					rfcnt <= rfcnt -1;
				end if;
			end if;
			
			if rfcnt = 3 then	 
				rfilter <= '1';
			end if;
			if rfcnt = 0 then 
				rfilter <= '0';
			end if;

			if afilter = '1' then					-- if filtered astrobe is true, count timer
				if acycle /= 15 then					-- dead-ended at 15
					acycle <= acycle + 1;
				end if;
			else
				acycle <= "0000";						-- otherwise clear
			end if;		

			if dfilter = '1' then					-- if filtered dstrobe is true, count timer
				if dcycle /= 15 then					-- dead-ended at 15
					dcycle <= dcycle + 1;			
				end if;
			else
				dcycle <= "0000";							-- otherwise clear
			end if;		

			if awritete = '1' then 
				if wasaddr = '0' then
					alatch(7 downto 0) <= EPP_DATABUS;
				else
					alatch(15 downto 8) <= EPP_DATABUS;
				end if;
			end if;
			
			if (acycle = 15) or (dcycle = 15) then		-- end cycle ~ 400 ns after leading edge of strobe
				waitpipe <= '1';
			else
				waitpipe <= '0';
			end if;	
			
			if dstrobete = '1' then
				wasaddr <= '0';
			end if;

			-- second address write writes to high order addresses
			-- setting the wasaddr bit is deferred so address reads will be correct
			-- as wasaddr is use to select address readback data
			if astrobete = '1' then
				wasaddrrq <= '1';
			end if;
			
			if wasaddrrq = '1' and waitpipe = '0' and oldwaitpipe = '1' then
				wasaddr <= '1';
				wasaddrrq <= '0';
			end if;	
			
			-- auto increment logic, increment is deferred until cycle is over
			-- so that we are guaranteed that the host read has taken place before we 
			-- increment the address.
			
			if dstrobete = '1' and alatch(15) = '1' then
			-- request post increment address on data access if address MSB is 1
				autoincrq <= '1'; -- set request
			end if;	

			if autoincrq = '1' and waitpipe = '0' and oldwaitpipe = '1' then			
			-- auto increment address on data access if address MSB is 1
				alatch(14 downto 0) <= alatch(14 downto 0) +1;
				autoincrq <= '0';	-- clear request
			end if;
			
		end if; -- clk	
		
		EPP_WAIT <= waitpipe;
		
		if (dcycle = 14) and (rfilter = '0') then		-- do internal write ~360 ns from start of strobe 
			dwritete <= '1';
		else
			dwritete <= '0';
		end if;

		if (dcycle = 1) and (rfilter = '1') then		-- do internal data read ~120 ns from start of strobe 
			dreadle <= '1';
		else
			dreadle <= '0';
		end if;

		if dcycle = 14 then									-- ~360 ns from start of strobe  
			dstrobete <= '1';
		else
			dstrobete <= '0';
		end if;

		if (acycle = 14) and (rfilter = '0') then	  	-- ~360 ns from start of strobe 
			awritete <= '1';
		else
			awritete <= '0';
		end if;

		if acycle = 14 then									-- ~360 ns from start of strobe  
			astrobete <= '1';
		else
			astrobete <= '0';
		end if;
		
		if (rfilter = '1') and (dfilter = '1') then
			dread <= '1';
		else
			dread <= '0';
		end if;
		
		if (rfilter = '1') and (afilter = '1') then
			aread <= '1';
		else
			aread <= '0';
		end if;		
		
	end process EPPInterface;

	bus_shim32: process (clklow,alatch,EPP_DATABUS, seladd, rdlatch, dwritete, dreadle, translateaddr) -- 8 to 32 bit bus shim
	begin
		if rising_edge(clklow) then
			dwrite32 <= write32;
			if dwritete = '1' then				-- on writes, latch the data in our 32 bit write data latch
				case seladd(1 downto 0) is		-- 32 data is written after last byte saved in latch
					when "00" =>  wdlatch(7 downto 0)   <= EPP_DataBus;
					when "01" =>  wdlatch(15 downto 8)  <= EPP_DataBus;
					when "10" =>  wdlatch(23 downto 16) <= EPP_DataBus;
					when "11" =>  wdlatch(31 downto 24) <= EPP_DataBus;
					when others => null;
				end case;	
			end if;	
			if alatch(14 downto 9) = TranslateRegionAddr(6 downto 1) then
				if dreadle = '1' and translatestrobe = '1' then
					rdlatch <= obus;
				end if;		
			else
				if dreadle = '1' and seladd(1 downto 0) = "00" then
					rdlatch <= obus;
				end if;
			end if;
		end if; -- clklow
				
		case seladd(1 downto 0) is								-- on reads, data previously stored in read data latch
			when "00" => idata <= rdlatch(7 downto 0); 	-- is muxed onto 8 bit bus by A(0..1)
			when "01" => idata <= rdlatch(15 downto 8);
			when "10" => idata <= rdlatch(23 downto 16);
			when "11" => idata <= rdlatch(31 downto 24);
			when others => null;
		end case;	
		
		if alatch(14 downto 10) = TranslateRamAddr(6 downto 2) then
			translateramsel <= '1';
		else
			translateramsel <= '0';
		end if;
		
		if dwritete = '1' and translateramsel = '1' then
			loadtranslateram <= '1';
		else
			loadtranslateram <= '0';
		end if;	
			
		if dreadle = '1' and translateramsel = '1' then
			readtranslateram <= '1';
		else
			readtranslateram <= '0';
		end if;

		if alatch(14 downto 8) = TranslateRegionAddr(6 downto 0) then
			write32 <= dwritete and translatestrobe;
			read32 <= dreadle and translatestrobe;
			seladd <= '0'&translateaddr(AddrWidth-2 downto 0);	-- drop msb = translatestrobe
		else
			write32 <= dwritete and alatch(1) and alatch(0);
			read32 <= dreadle and ((not alatch(1)) and (not alatch(0)));
			seladd <= '0'&alatch(AddrWidth-2 downto 0);	-- drop msb = autoincbit
		end if;
	end process;
	
	doreconfig: process (clklow,ReConfigreg, alatch)
	begin
		if alatch = x"7F7F" then
			ReconfigSel <= '1';
		else
			ReconfigSel <= '0';		
		end if;	
		if rising_edge(clklow) then
			if dwritete = '1' and ReconfigSel = '1' then
				if EPP_DATABUS = x"5A" then
					ReConfigreg <= '1';
				end if;
			end if;
		end if;		
		RECONFIG <= not ReConfigreg;
	end process doreconfig;
	
	BusDrive: process (aread,dread,idata,alatch,wasaddr)
	begin
		EPP_DATABUS <= "ZZZZZZZZ";
		if dread = '1'  then 
			EPP_DATABUS <= idata;
		end if;
		if aread = '1' then  
			if wasaddr = '0' then
				EPP_DATABUS <= alatch(7 downto 0);
			else
				EPP_DATABUS <= alatch(15 downto 8);
			end if;	
		end if;
	end process BusDrive;	

	ConfigDecode : process(seladd,Read32,DWrite32) 
	begin	
		LoadSPICS  <= decodedstrobe(seladd(AddrWidth-1 downto 2)&"00",x"0070",DWrite32);
		ReadSPICS  <= decodedstrobe(seladd(AddrWidth-1 downto 2)&"00",x"0070",Read32);
		LoadSPIReg <= decodedstrobe(seladd(AddrWidth-1 downto 2)&"00",x"0074",DWrite32);
		ReadSPIReg <= decodedstrobe(seladd(AddrWidth-1 downto 2)&"00",x"0074",Read32);
	end process ConfigDecode;
	
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
		ibus => wdlatch(7 downto 0),
		obus => obus(7 downto 0),
		loaddata => LoadSPIReg,
		readdata => ReadSPIReg,
		loadcs => LoadSPICS,
		readcs => ReadSPICS,
		spiclk => SPICLK,
		spiin => SPIIN,
		spiout => SPIOUT,
		spics =>SPICS 
	);

	ICapDecode : process(seladd,DWrite32)
	begin
		LoadICap <= decodedstrobe(seladd(AddrWidth-1 downto 2)&"00",x"0078",DWrite32);
		ReadICapCookie  <= decodedstrobe(seladd(AddrWidth-1 downto 2)&"00",x"0078",Read32);
	end process ICAPDecode;

	ICapSupport: process (clklow,LoadICap)
	begin
		if rising_edge(clklow) then
			if LoadICap = '1' then
				ICapI <= FixICap(wdlatch(15 downto 0));
				ICapTimer <= "111111";				-- 16 counts = 160 ns strobe width at 100 MHz clcok low
			end if;		
			if ICapTimer /= "000000" then
				ICapTimer <= ICapTimer -1;
			end if;				
			ICapClock <= ((not ICapTImer(5)) and ICapTimer(4));	-- 16 counts wide , 32 counts late 
		end if;	
		obus <= (others => 'Z');	
		if ReadICAPCookie = '1' then
			obus <= x"1CAB1CAB";
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

