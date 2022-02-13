library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
-- Copyright (C) 2011, Peter C. Wallace, Mesa Electronics
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
use work.decodedstrobe2.all;	
use work.parity.all;
use work.FixICap.all;

-------------------- option selection area ----------------------------


-------------------- select one card type------------------------------
use work.i25_x9card.all;
--use work.i25_x9card.all;        -- needs 5i25.ucf and SP6 x9 144 pin
--use work.i74_x9card.all;   	-- needs 4I74.ucf and SP6 x9 144 pin
--use work.Sixi25_x9card.all;	-- needs 5i25.ucf and SP6 x9 144 pin
--use work.i24_x16card.all; 	-- needs 5I24.ucf and SP6 x16 256 pin
--use work.i24_x25card.all;   -- needs 5I24.ucf and SP6 x25 256 pin

-----------------------------------------------------------------------


-------------------- select (or add) one pinout -----------------------
use work.PIN_DMMBOB1x2_34.all;

-- 34 I/O pinouts for 5I25, 5I26 and 6I25:

--use work.PIN_7I76x2_34.all;  			-- 5i25/6 step config for 2X 7I76 step/dir breakout
--use work.PIN_7I76x2D_34.all;                    -- 5i25/6 step config for 2X 7I76 step/dir breakout
--use work.PIN_7I76x2R_34.all;  			-- Reversed 5i25/6 step config for 2X 7I76 step/dir breakou
--use work.PIN_G540x2_34.all;  			-- 5i25/6 step config for 2X Gecko 540
--use work.PIN_7I76_7I74_34.all;			-- 5i25/6 step config for 7I76 step/dir breakout (P3) and 7I74 SSerial breakout (P2)
--use work.PIN_7I74_7I76_34.all;			-- 5i25/6 step config for 7I76 step/dir breakout (P2) and 7I74 SSerial breakout (P3)
--use work.PIN_7I77x2_34.all;  			-- 5i25/6 analog servo config for 2X 7I77 analog servo breakout
--use work.PIN_7I77x2R_34.all;  			-- Reversed 5i25/6 analog servo config for 2X 7I77 analog servo breakout
--use work.PIN_7I77_7I74_34.all;  		-- 5i25/6 analog servo config for 7I77 analog servo breakout (P3) and 7I74 SSerial (P2)
--use work.PIN_7I74_7I77_34.all;  		-- 5i25/6 analog servo config for 7I77 analog servo breakout (P2) and 7I74 SSerial (P3)
--use work.PIN_7I77_7I76_34.all;  		-- 5i25/6 analog servo config+ 7i76 step/dir config for 7I77 and 7I76 (7I77 on P3)
--use work.PIN_7I76_7I77_34.all;  		-- 5i25/6 analog servo config+ 7i76 step/dir config for 7I77 and 7I76 (7I76 on P3)
--use work.PIN_7I77_7I78_34.all;  		-- 5i25/6 analog servo config+ 7i78 step/dir config for 7I77 and 7I76
--use work.PIN_7I74x2_34.all;  			-- 5i25/6 config for 2X 7I74 RS-422 SSerial I/O expansion
--use work.PIN_7I78x2_34.all;				-- 5i25/6 step config for 2x 7I78 step/dir breakout 
--use work.PIN_7I76_7I78_34.all;			-- 5i25/6 step config for 7I76 and 7I78 step/dir breakout 
--use work.PIN_PROB_RFx2_34.all;			-- 5i25/6 step config for Probotix step/dir breakout
--use work.PIN_7I85x2_34.all;				-- 2x 7I85 encoder + sserial
--use work.PIN_7I85Sx2_34.all;			-- 2x 7I85S encoder + stepgens + sserial
--use work.PIN_7I85SPx2_34.all;			-- 2x 7I85S encoder + pwmgens + sserial
--use work.PIN_7I76_7I85S_34.all;		-- 7I76 and 7I85S
--use work.PIN_7I76P_7I85_34.all;		-- 7I76 PWM and 7I85
--use work.PIN_7I76_7I85_34.all;			-- 7I76 and 7I85
--use work.PIN_7I85S_7I78_34.all;		-- 7I85S and 7I78
--use work.PIN_7I77_7I85S_34.all;		-- 7I77 +7I85S step/dir config
--use work.PIN_7I77_7I85SP_34.all;		-- 7I77 +7I85S pwm/dir config
--use work.PIN_R990x2_34.all;				-- 5i25/6i25 step config for 2x Rutex R990 MB
--use work.PIN_DMMBOB1x2_34.all;			-- DMM DBM4250 bob step/dir config
--use work.PIN_FALLBACK_34.all;			-- IO only configuration for fast compiles whilst debugging PCI and fallback config
--use work.PIN_MX3660x2_34.all;			-- config for Leadshine MX3660 triple step motor drive
--use work.PIN_7I77x1_IMS_34.all;		-- config for 7I77 with spindle index mask
--use work.PIN_7I85SP_7I85_34.all;		-- config for PWM/enc on P3 7I85S plus ss and encoder on P2 7I85
--use work.PIN_DRINGx2_34.all;				-- 5i25/6 step config for Dring laser BOB

--Non standard
--use work.PIN_7I77_7I76_micges_34.all;  		-- 5i25/6 analog servo config+ 7i76 step/dir config for 7I77 and 7I76
--use work.PIN_BISSTEST_34.all;			-- 8 channel BISS interface test  
--use work.PIN_UA2_34.all;					-- simple UART config for 7I76 SSERIAL device access
--use work.PIN_7I76_34.all;  				-- 5i25/6 step config for 7I76 step/dir breakout
--use work.PIN_7I78_34.all;				-- 5i25/6 step config for 7I78 step/dir breakout 
--use work.PIN_SYIL1_34.all;				-- Syil stepper config	
--use work.PIN_STSV6_1_34.all;			-- simple pin order six channel step/dir plus PWM +spindle enc 
--use work.PIN_TORMACH1_34.all;  			-- 5i25/6i25 step config for Tormach lathe
--use work.PIN_TORMACHT_34.all;  		-- 5i25/6i25 step config for Tormach lathe test
--use work.PIN_TORMACH2_34.all;  		-- 5i25/6i25 step config for Tormach mill
--use work.PIN_7I77_7I74_SSI_34.all;	-- 7I77 + 7I74 with 8 SSI channels
--use work.PIN_7I77_SSI_7I74_34.all;	-- 7I77 + 7I74 with 1 SSI on 7I77 exp
--use work.PIN_7I77_7I76P_34.all;  		-- 5i25/6 analog servo config+ 7i76 PWM/DIR config for 7I77 and 7I76
--use work.PIN_7I77_7I74_34_toromatic.all;
--use work.PIN_7I77_GBOB_34.all;
--use work.PIN_7I76x2_ssi_34.all;
--use work.PIN_7I76x2_biss_34.all;
--use work.PIN_7I76x2ST_34.all;
--use work.PIN_G540_7I85S_34.all;
--use work.PIN_7I77x2_ssi_34.all;
--use work.PIN_SP4_34.all;
--use work.PIN_7I77_7I74_SSI_FANUC_34.all;	-- 7I77 + 7I74 with 4 SSI channels 2 FAbs and DPLL
--use work.PIN_Fritz1_34.all;

--use work.PIN_PBX_SS1_34.all;

-- 42 PIN PINOUTS FOR THE 4I74

--use work.PIN_SVSS8_8_42.all;			-- 8 encoder + 8 sserial channels
--use work.PIN_SVSI8_8_42.all;			-- 8 encoder + 8 SSI channels
--use work.PIN_SVBI8_4_42.all;			-- 8 encoder + 4 BISS channels
--use work.PIN_SVBI8_1T_42.all;			-- 8 encoder + 1 test BISS channel
--use work.PIN_FALLBACK_42.all;			-- IO only configuration 

-- 72 I/O pinouts for the 5I24/6I24

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
--use work.PIN_SVST6_6_7I52S_72.all;
--use work.PIN_SVSSST6_6_12_72.all;
--use work.PIN_SVSS6_8_72.all;
--use work.PIN_SSSVST8_1_5_7I47_72.all;
--use work.PIN_SVSS8_44_72.all;
--use work.PIN_RMSVSS6_8_72.all;
--use work.PIN_RMSVSS6_12_8_72.all; -- 4i69 5i24 only
--use work.PIN_RMSVSS6_10_8_72.all;
--use work.PIN_ST8_PLASMA_72.all;
--use work.PIN_SV4_7I47S_72.all;
--use work.PIN_SVSTUA6_6_6_7I48_72.all;
--use work.PIN_SVSTTP6_6_7I39_72.all;
--use work.PIN_ST18_72.all;

-- custom and special
--use work.PIN_TORMACH1_34.all;
--use work.PIN_FA1_72.all;
--use work.PIN_MIKA2_CPR_72.all;
--use work.PIN_HARRISON_72.all;
--use work.PIN_MAUROPON.all;
--use work.PIN_Andy1_72.all;
--use work.PIN_BASACKWARDS_SVSS6_8_72.all;
--use work.PIN_SVSTTP6_5_7I39_72.all;
--use work.PIN_SVFASS6_6_8_72.all;

entity TopPCIHostMot2b is -- for 5I24,5I25, 5I26, 6I25 PCI target mode
	generic 
	(
		ThePinDesc: PinDescType := PinDesc;
		TheModuleID: ModuleIDType := ModuleID;
		PWMRefWidth: integer := 13;			-- PWM resolution is PWMRefWidth-1 bits 
		IDROMType: integer := 3;		
		UseIRQLogic: boolean := true;			--- note this will pull in PWM ref
		UseWatchDog: boolean := true;
		OffsetToModules: integer := 64;
		OffsetToPinDesc: integer := 448;
		BusWidth: integer := 32;
		AddrWidth: integer := 16;
		InstStride0: integer := 4;			-- instance stride 0 = 4 bytes = 1 x 32 bit
		InstStride1: integer := 64;		-- instance stride 1 = 64 bytes = 16 x 32 bit registers !! UARTS need 0x10
--		InstStride1: integer := 16;		-- instance stride 1 = 64 bytes = 16 x 32 bit registers !! UARTS need 0x10
		RegStride0: integer := 256;		-- register stride 0 = 256 bytes = 64 x 32 bit registers
		RegStride1: integer := 256;      -- register stride 1 = 256 bytes - 64 x 32 bit
		FallBack: boolean := false			-- is this a fallback config?
	);    
	port 
	( 
		AD : inout  std_logic_vector (31 downto 0);
		NCBE : in  std_logic_vector (3 downto 0);
		PAR : inout  std_logic;
		NFRAME : in  std_logic;
		NIRDY : in  std_logic;
		NTRDY : out  std_logic;
		NSTOP : out  std_logic;
		NLOCK : in  std_logic;
		IDSEL : in  std_logic;
		NDEVSEL : inout  std_logic; -- inout is kludge
		NPERR : out  std_logic;
      NSERR : out  std_logic;
      NINTA : out  std_logic;
		NRST : in  std_logic;
		NREQ : out std_logic;
		PCLK  : in	 std_logic; -- PCI clock
		IOBITS: inout std_logic_vector (IOWidth -1 downto 0);		-- external I/O bits		
		LIOBITS: inout std_logic_vector (LIOWidth -1 downto 0);	-- local I/O bits		
		XCLK: in std_logic;		-- Xtal clock
		LEDS: out std_logic_vector(LEDCount -1 downto 0);
		NINIT: out std_logic;
		SPICLK : out std_logic;
		SPIDI : in std_logic;
		SPIDO : out std_logic;
		SPICS  : out std_logic
		);
		
end TopPCIHostMot2b;

architecture Behavioral of TopPCIHostMot2b is 

-- PCI constants
constant InterruptAck 		: std_logic_vector(3 downto 0) := x"0";
constant SpecialCycle 		: std_logic_vector(3 downto 0) := x"1";
constant IORead 				: std_logic_vector(3 downto 0) := x"2";
constant IOWrite 				: std_logic_vector(3 downto 0) := x"3";
constant MemRead 				: std_logic_vector(3 downto 0) := x"6";
constant MemWrite 			: std_logic_vector(3 downto 0) := x"7";
constant ConfigRead 			: std_logic_vector(3 downto 0) := x"A";
constant ConfigWrite 		: std_logic_vector(3 downto 0) := x"B";
constant MemReadMultiple 	: std_logic_vector(3 downto 0) := x"C";
constant DualAddressCycle 	: std_logic_vector(3 downto 0) := x"D";
constant MemReadLine 		: std_logic_vector(3 downto 0) := x"E";
constant MemWriteandInv 	: std_logic_vector(3 downto 0) := x"F";


constant DIDVIDAddr : std_logic_vector(7 downto 0) := x"00";	
constant StatComAddr : std_logic_vector(7 downto 0) := x"04";
constant ClassRevAddr : std_logic_vector(7 downto 0) := x"08"; 
constant ClassRev : std_logic_vector(31 downto 0) := x"11000001";  -- data acq & rev 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
--constant ClassRev : std_logic_vector(31 downto 0) := x"07010000";    -- parallel port                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
constant MiscAddr : std_logic_vector(7 downto 0) := x"0C";
constant MiscReg : std_logic_vector(31 downto 0) := x"00000000";
constant SSIDAddr : std_logic_vector(7 downto 0) := x"2C";
constant BAR0Addr : std_logic_vector(7 downto 0) := x"10";
constant IntAddr : std_logic_vector(7 downto 0) := x"3C";


-- Misc global signals --
signal D: std_logic_vector (BusWidth-1 downto 0);							-- internal data bus
signal A: std_logic_vector (BusWidth-1 downto 0);

signal DataStrobe: std_logic;
signal ReadStb: std_logic;
signal WriteStb: std_logic;
signal ConfigReadStb: std_logic;
signal ConfigWriteStb: std_logic;

-- PCI bus interface signals
signal NFrame1 : std_logic;
signal IDevSel : std_logic;
signal IDevSel1 : std_logic;
signal IDevSel2 : std_logic;
signal LIDSel : std_logic;
signal Lint : std_logic;
signal PerrStb : std_logic;
signal PerrStb1 : std_logic;
signal PerrStb2 : std_logic;
signal StatPerr : std_logic;
signal SerrStb : std_logic;
signal SerrStb1 : std_logic;
--signal SerrStb2 : std_logic;
signal StatSerr : std_logic;
signal PCIFrame : std_logic;
signal ITRDY : std_logic;
signal IStop : std_logic;    
signal Selected : std_logic;  
signal ConfigSelect : std_logic;
signal NormalSelect : std_logic;  
signal IPar : std_logic;
signal CPar : std_logic;
signal PAR1 : std_logic;
signal BusCmd : std_logic_vector(3 downto 0);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
signal ADDrive : std_logic;  
signal ParDrive : std_logic; 
signal BusRead : std_logic; 
-- signal BusRead1 : std_logic; 
-- signal BusRead2 : std_logic; 
signal BusWrite : std_logic; 
signal BusWrite1 : std_logic; 
signal BusWrite2 : std_logic; 

-- PCI configuration space registers
signal StatComReg : std_logic_vector(31 downto 0) := x"02000000"; -- medium devsel
alias MemEna : std_logic is StatComReg(1);
alias ParEna : std_logic is StatComReg(6);
alias SerrEna : std_logic is StatComReg(8);
alias IntDis : std_logic is StatComReg(10);
signal BAR0Reg : std_logic_vector(31 downto 0) := x"00000000";
signal IntReg : std_logic_vector(31 downto 0) := x"00000100";

-- debug

signal ledff0 : std_logic := '0'; 
signal ledff1 : std_logic := '0'; 
signal blinkcount : std_logic_vector(23 downto 0);

-- configuration flash SPI interface		

signal LoadSPIReg : std_logic;
signal ReadSPIReg : std_logic;
signal LoadSPICS : std_logic;
signal ReadSPICS : std_logic;

-- ICap interface		

signal LoadICap : std_logic;
signal ReadICapCookie : std_logic;
signal ICapI : std_logic_vector(15 downto 0);
signal ICapClock : std_logic;
signal ICapTimer : std_logic_vector(3 downto 0) := "0000";

-- CLK multiplier DCM signals

signal fclk : std_logic;
signal clkfx0: std_logic;
signal clk0: std_logic;

signal clkmed : std_logic;
signal clkfx1: std_logic;
signal clk1: std_logic;

begin

  ClockMult0 : DCM						-- This takes 100 MHz clkmed an multiplies it to ClockHigh  
   generic map (
      CLKDV_DIVIDE => 2.0,
      CLKFX_DIVIDE => 2, 
      CLKFX_MULTIPLY => 4,			-- 4 FOR 200, 5 for 250, 6 for 300, 8 for 400
      CLKIN_DIVIDE_BY_2 => FALSE, 
      CLKIN_PERIOD => 10.0,          
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
		CLKFX => clkfx0,
      CLKIN => clkmed,  -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => '0',   	-- Dynamic phase adjust clock input
      PSEN => '0',     	-- Dynamic phase adjust enable input
      PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
      RST => '0'        -- DCM asynchronous reset input
   );
  
  BUFG_inst0 : BUFG
   port map (
      O => fclk,    -- Clock buffer output = clock high
      I => clkfx0      -- Clock buffer input
   );

  -- End of DCM_inst instantiation

-- CLK multiplier DCM signals

  ClockMult1 : DCM						-- This takes 50 MHz XTAL an multiplies it to ClockMed  
   generic map (
      CLKDV_DIVIDE => 2.0,
      CLKFX_DIVIDE => 2, 
      CLKFX_MULTIPLY => 4,			-- 4 FOR 100, 5 for 125, 6 for 150, 8 for 200
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
 
      CLK0 => clk1,   	-- 
      CLKFB => clk1,  	-- DCM clock feedback
		CLKFX => clkfx1,
      CLKIN => XCLK,    -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => '0',   	-- Dynamic phase adjust clock input
      PSEN => '0',     	-- Dynamic phase adjust enable input
      PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
      RST => '0'        -- DCM asynchronous reset input
   );
  
  BUFG_inst1 : BUFG
   port map (
      O => clkmed,    	-- Clock buffer output - clock med
      I => clkfx1      	-- Clock buffer input
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
		ibus =>  AD,
		obus => D,
		addr => A(AddrWidth-1 downto 2),
		readstb => ReadStb,
		writestb => WriteStb,
		clklow => PCLK,				-- PCI clock
		clkmed  => clkmed,			-- Processor clock
		clkhigh =>  fclk,				-- High speed clock
		int => LINT, 
		iobits => IOBITS,		
		leds => LEDS	
		);

	ADDrivers: process (D,ADDrive)
	begin 
		if  ADDrive	='1' then	
			AD <= D;
		else
			AD <= (others => 'Z');			
		end if;
	end process ADDrivers;

	BusCycleGen: process (PCLK, NIRDY, DataStrobe, ConfigSelect, PCIFrame, A, 
								 IDevSel, IdevSel1, IDevSel2, ITRDY, ISTOP, ParDrive, IPar, CPar, 
								 LIDSel, Bar0Reg, BusCmd, LInt, IntReg, ConfigSelect, BusRead,Selected,
								 NCBE, NormalSelect, SerrStb1, PerrStb2, StatComReg, BusWrite1,BusWrite2)		-- to do: parity error reporting in status
	begin 
		if rising_edge(PCLK) then
			if  NFRAME = '0' and Nframe1 = '1' then 	-- falling edge of NFRAME = start of frame
				A <= AD;											-- so latch address and PCI command	
				BusCmd <= NCBE;
				PCIFrame <= '1';
				SerrStb <= '1';
				LIDSel <= IDSEL;
			else
				SerrStb <= '0';
			end if;

			if PCIFrame = '1' then							-- if we are in a PCI frame, check if we are selected
				if Selected = '1' then
					IDevSel <= '1';							-- if so assert DEVSEL
				end if;
			end if;

			if IDevSel = '1' then
				if NIRDY = '0' then
					ITRDY <= '1';								-- note one clock delay for one wait state;
				end if;
				if ITRDY = '1' then 							-- only asserted for one clock
					ITRDY <= '0';
				end if;
			end if;

			if	(NFRAME = '1') then		-- any time frame is high end frame
				PCIFrame <= '0';
				if (NIRDY= '0') and (ITRDY = '1') then	-- if frame is de-asserted and we have a data transfer, we're done
					IDevSel <= '0';
				end if;	
			end if;			

			if (NIRDY = '0') and (ITRDY = '1') and (NCBE /= x"F") then 	-- increment address after every transfer
				A <= A + 4;
			end if;	
			
			IDevSel2 <= IDevSel1;
			IDevSel1 <= IDevSel;

--			BusRead2 <= BusRead1;
--			BusRead1 <= BusRead;

			BusWrite2 <= BusWrite1;
			BusWrite1 <= BusWrite;

			PerrStb2 <= PerrStb1;
			PerrStb1 <= PerrStb;

--			SerrStb2 <= SerrStb1;
			SerrStb1 <= SerrStb;
						
					
			NFrame1 <= NFRAME;
			PAR1 <= PAR;

			IStop <= '0';			-- for  now
			
			IPar <= parity(AD&NCBE&'0');		-- Parity generation 1 clock behind data (0 is even reminder)
			CPar <= IPar xor PAR1;			   -- Parity check 2 clocks behind data (high = error)
			ParDrive <= ADDrive;					-- 1 clock behind AD Tristate

			if NRST = '0' then
				PCIFrame <= '0';
				IDevSel <= '0';
				ITRDY <= '0';
			end if;			
		end if; -- clk


		if NIRDY = '0' and ITRDY = '1' and (NCBE /= x"F") then -- data cycle when IRDY AND TRDY and a least one byte enable
			DataStrobe <= '1';
		else
			DataStrobe <= '0';
		end if;	
		
		if (DataStrobe = '1') and ((BusCmd = MemRead) or (BusCmd = MemReadMultiple)) then
			ReadStb<= '1';
		else
			ReadStb <= '0';
		end if;	

		if (DataStrobe = '1') and (BusCmd = MemWrite) then
			WriteStb <= '1';
		else
			WriteStb <= '0';
		end if;	

		if DataStrobe = '1' and (BusCmd = ConfigRead) then
			ConfigReadStb <= '1';
		else
			ConfigReadStb <= '0';
		end if;	

		if DataStrobe = '1' and (BusCmd = ConfigWrite) then
			ConfigWriteStb <= '1';
		else
			ConfigWriteStb <= '0';
		end if;	

		if DataStrobe = '1' and ((BusCmd = MemWrite) or (BusCmd = ConfigWrite)) then
			PErrStb <= '1';
		else
			PErrStb <= '0';
		end if;			
		
		Selected <= (ConfigSelect or (NormalSelect and MemEna));
				
		if ((PCIFrame = '1') and (Selected='1')) or (IDevSel= '1') or (IDevSel1 = '1') then					-- keep driving NDEVSEL/NTRDY/NSTOP one clock after IDevsel de-sasserted	
			NDEVSEL <= not IDevSel;
			NTRDY <= not ITRDY;
			NSTOP <= not IStop;
		else
			NDEVSEL <= 'Z';
			NTRDY <= 'Z';
			NSTOP <= 'Z';
		end if;	
		
		if (IdevSel = '1') and (busread = '1') then
			ADDrive <= '1';
		else
			ADDrive <= '0';
		end if;	

		if ParDrive = '1' then				-- PAR is driven with the AD buffer enable signal but one clock later
			PAR <= IPar;
		else
			PAR <= 'Z';
		end if;	
		
		if ((IDevSel1 = '1') or (IdevSel2 = '1')) and ((BusWrite1 = '1') or (BusWrite2 = '1')) then
			NPERR <= not (CPar and PerrStb2 and ParEna);
			StatPerr <= (CPar and PerrStb2);
		else
			NPERR <= 'Z';
			StatPerr <= '0';
		end if;	

		if ((IDevSel = '1') and (SerrStb1 = '1') and (SerrEna = '1') and (ParEna = '1')) then
			NSERR <= not CPar;
			StatSerr <= CPar;
		else
			NSERR <= 'Z';
			StatSerr <= '0';
			
		end if;	
				
		if (LIDSel = '1') and ((BusCmd = ConfigRead) or (BusCmd = ConfigWrite)) then
			ConfigSelect <= '1';
		else
			ConfigSelect <= '0';
		end if;		
		
		if (Bar0Reg(31 downto 16) = A(31 downto 16)) and (MemEna = '1') and ((BusCmd = MemRead) or (BusCmd = MemReadMultiple) or (BusCmd = MemWrite)) then			-- hard wired for 64 K select
			NormalSelect <= '1';
		else
			NormalSelect <= '0';
		end if;	
	
		if (BusCmd = MemRead) or (BusCmd = MemReadMultiple) or (BusCmd = ConfigRead) then
			BusRead <= '1';
		else
			BusRead <= '0';
		end if;	

		if ((BusCmd = MemWrite) or (BusCmd = ConfigWrite)) then
			BusWrite <= '1';
		else
			BusWrite <= '0';
		end if;	
		
		if (LINT = '0') and IntDis = '0' then
			NINTA <= '0';
		else
			NINTA <= 'Z';
		end if;	
			
	end process BusCycleGen;

	
	PCIConfig : process (PCLK, A, ConfigSelect, BusCmd, LInt, StatComReg, Bar0Reg, IntReg)
	begin

		-- first the config space reads
		D <= (others => 'Z');
		StatComReg(19) <= not LINT;
		if (ConfigSelect = '1') and (BusCmd = ConfigRead) then
			case A(7 downto 0) is
				when DIDVIDAddr  	=> D <= DIDVID;
				when StatComAddr  => D <= StatComReg;
				when ClassRevAddr => D <= ClassRev;
				when MiscAddr		=>	D <= MiscReg;
				when BAR0Addr		=>	D <= BAR0Reg;
				when SSIDAddr		=>	D <= SSID;
				when IntAddr		=> D <= IntReg;	
				when others			=>	D <= (others => '0'); 	-- all unused config space reads as 0s
			end case;
		end if;		
		
		-- then the config space writes
		if rising_edge(PCLK) then
			if StatPerr = '1' then
				StatComReg(31) <= '1'; -- signal data parity error in status reg
			end if;	
			if StatSerr = '1' then
				StatComReg(30) <= '1'; -- signal address parity error in status reg
			end if;	
			if (ConfigSelect = '1') and (BusCmd = ConfigWrite) and (DataStrobe = '1') then			
				case A(7 downto 0) is
					when StatComAddr  => 
						if NCBE(0) = '0' then 
							StatComReg(1) <= AD(1);	-- MemEna
							StatComReg(6) <= AD(6); -- ParEna
						end if;	
						if NCBE(1) = '0' then	
							StatComReg(8) <= AD(8); -- SerrEna
							StatComReg(10) <= AD(10); -- IntDis
						end if;	
						if NCBE(3) = '0' then
							StatComReg(27) <= StatComReg(27) and not AD(27);  	-- status bits cleared when a 1 is written
							StatComReg(30) <= StatComReg(30) and not AD(30);
							StatComReg(31) <= StatComReg(31) and not AD(31);
						end if;
					when BAR0Addr		=>													-- 64K range so only top 16 bits used
						if NCBE(2) = '0' then 
							BAR0Reg(23 downto 16) <= AD(23 downto 16);
						end if;                                       
						if NCBE(3) = '0' then 
							BAR0Reg(31 downto 24) <= AD(31 downto 24);
						end if;				
					when IntAddr		=> 												-- only R/W byte of int reg supported
						if NCBE(0) = '0' then			
							IntReg(7 downto 0) <= AD(7 downto 0);
						end if;			
					when others			=>	null;
				end case;
			end if;		
			if NRST = '0' then
				BAR0Reg(31 downto 16) <= (others => '0');
				StatComReg <= x"02000000";
				IntReg <= x"00000100";
--				ledff0 <= '0';
--				ledff1 <= '0';
			end if;
		
		end if; -- clk
	end process PCIConfig;

	ConfigDecode : process(A,ReadStb,WriteStb,NCBE) 
	begin
		LoadSPICS <= decodedstrobe2(A(15 downto 0),x"0070",WriteStb,not NCBE(0));
		ReadSPICS <= decodedstrobe2(A(15 downto 0),x"0070",ReadStb,not NCBE(0));
		LoadSPIReg <= decodedstrobe2(A(15 downto 0),x"0074",WriteStb,not NCBE(0));
		ReadSPIReg <= decodedstrobe2(A(15 downto 0),x"0074",ReadStb,not NCBE(0));
	end process ConfigDecode;

	ICapDecode : process(A,WriteStb,NCBE) 
	begin
		LoadICap <= decodedstrobe2(A(15 downto 0),x"0078",WriteStb,not (NCBE(0) or NCBE(1)));
		ReadICapCookie <= decodedstrobe2(A(15 downto 0),x"0078",ReadStb,not (NCBE(0) or NCBE(1) or NCBE(2) or NCBE(3)));
	end process ICAPDecode;

	ICapSupport: process (PCLK,LoadICap)
	begin
		if rising_edge(PCLK) then
			if LoadICap = '1' then
				ICapI <= FixICap(AD(15 downto 0));
				ICapTimer <= "1111";
			end if;		
			if ICapTimer /= "0000" then
				ICapTimer <= ICapTimer -1;
			end if;				
			ICapClock <= ((not ICapTImer(3)) and ICapTimer(2));	-- 4 counts wide , 8 counts late 
		end if;	
		D <= (others => 'Z');
		if ReadICAPCookie = '1' then
			D <= x"1CAB1CAB";
		end if;	
	end process ICapSupport;	
	
	asimplspi: entity work.simplespi8	-- configuration serial EEPROM access SPI port
	generic map
	(
		buswidth => 8,
		div => 2,	-- for divide by 3	-- 11 MHz
		bits => 8
	)	
	port map 
	( 
		clk  => PCLK,
		ibus => AD(7 downto 0),
		obus => D(7 downto 0),
		loaddata => LoadSPIReg,
		readdata => ReadSPIReg,
		loadcs => LoadSPICS,
		readcs => ReadSPICS,
		spiclk => SPICLK,
		spiin => SPIDI,
		spiout => SPIDO,
		spics =>SPICS 
	);

	
	PCILooseEnds : process (PCLK)
	begin
		NREQ <= '1';	
	end process PCILooseEnds;
	
	dofallback: if fallback generate -- do blinky red light to indicate failure to load primary bitfile
		Fallbackmode : process(PCLK)
		begin
			if rising_edge(PCLK) then 
				blinkcount <= blinkcount +1;
			end if;
			NINIT <= blinkcount(23);
		end process;	
	end generate;	

	donormal: if not fallback generate
		NormalMode : process(PCLK)
		begin
			NINIT <= 'Z';
--			NINIT <= not ledff0;
		end process;	
	end generate;		
	
end Behavioral;
