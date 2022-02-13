library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
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

-------------------- option selection area ----------------------------


-------------------- select one card type------------------------------
use work.@Card@.all;
--use work.i43_200card.all; 	-- needs 7i43u.ucf and SP3 200K 144 pin
--use work.i43_400card.all;   -- needs 7i43u.ucf and SP3 400K 144 pin
--use work.i61_x16card.all;   	-- needs 7i61u.ucf and SP6 x16 256 pin
--use work.i61_x25card.all;   	-- needs 7i61u.ucf and SP6 x25 256 pin
-----------------------------------------------------------------------


-------------------- select (or add) one pinout -----------------------
-- note that all the USB configurations drop the address translation
-- as the LB Protocol has its own address system 
use work.@Pin@.all;
-- 48 I/O pinouts for the 7I43
--use work.PIN_SV8_48.all;
--use work.PIN_SVSPD6_2_48.all;
--use work.PIN_SPSVST_7I47_7I65_48.all;
--use work.PIN_SVSP6_2_48.all;
--use work.PIN_SVST4_4_48.all;
--use work.PIN_SVST4_6_48.all;
--use work.PIN_SVST2_4_7I47_48.all;
--use work.PIN_SVST4_12_48.all ;
--use work.PIN_SVSSP4_6_7I46_48.all;
--use work.PIN_SVST2_4_7I47_48.all ;
--use work.PIN_SVUA4_8_48.all;
--use work.PIN_SVSS4_8_48.all;
--use work.PIN_SVSI8_48.all;
--use work.PIN_SVFA8_48.all;
--use work.PIN_SVTW4_24_24_48.all ;
--use work.PIN_SVTP4_7I39_48.all;
--use work.PIN_SVST6_6_7I48_48.all;
--use work.PIN_SVRM6_48.all;
--use work.PIN_SISVST6_2_3_7I47_48.all;
--use work.PIN_BOSSV.all ;
--use work.PIN_Enslavko_48.all;

-- 96 I/O pinouts for 7I61:
--use work.PIN_SV16_96.all;
--use work.PIN_SVST8_8_96.all;
--use work.PIN_SVST8_24_96.all;
--use work.PIN_SVSTSP8_12_6_96.all;
--use work.PIN_SV12_2X7I49_96.all;
--use work.PIN_SVST12_12_2X7I48_2X7I47_96.all;
----------------------------------------------------------------------
	
	
-- dont change anything below unless you know what you are doing -----
	
entity TopUSBHostMot2 is -- for 7I43/7I61 in USB mode
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
		RegStride1: integer := 256      -- register stride 1 = 256 bytes - 64 x 32 bit

		);
						
		
	Port (	CLK : in std_logic;
				LEDS : out std_logic_vector(LEDCount -1 downto 0);
				IOBITS : inout std_logic_vector(IOWidth -1 downto 0);
				DATABUS : inout std_logic_vector(7 downto 0);
				USB_WRITE : out std_logic;
				USB_RD : out std_logic;
				USB_TXE : in std_logic;
				USB_RXF : in std_logic;
				RECONFIG : out std_logic;
				HRECONFIG : out std_logic;
				PARACONFIG : out std_logic;
				SPICLK : out std_logic;
				SPIIN : in std_logic;
				SPIOUT : out std_logic;
				SPICS : out std_logic
		 );
end TopUSBHostMot2;

architecture Behavioral of TopUSBHostMot2 is
	 
-- GPIO interface signals
signal ReconfigSel : std_logic;
signal ReConfigreg : std_logic := '0';

signal LoadSPIReg : std_logic;
signal ReadSPIReg : std_logic;
signal LoadSPICS : std_logic;
signal ReadSPICS : std_logic;

signal LoadUSBDataReg : std_logic;
signal ReadUSBData : std_logic;
signal LoadUSBControlReg : std_logic;
signal ReadUSBStatus : std_logic;
signal USBDataReg : std_logic_vector(7 downto 0);
signal USBContReg : std_logic_vector(2 downto 0) := "011";
alias  USB_RdReg : std_logic is USBContReg(0);
alias  USB_WriteReg : std_logic is USBContReg(1);
alias  USB_TSEn : std_logic is USBContReg(2);


signal iabus : std_logic_vector(10 downto 0);	-- program address bus (changed to 11 bits 8/2010)
signal idbus : std_logic_vector(15 downto 0);	-- program data bus		 
signal mradd : std_logic_vector(11 downto 0);	-- memory read address
signal ioradd :  std_logic_vector(11 downto 0);	-- I/O read address
signal mwadd : std_logic_vector(11 downto 0);	-- memory write address
signal mibus : std_logic_vector(7 downto 0);		-- memory data in bus	  
signal mobus : std_logic_vector(7 downto 0);		-- memory data out bus
signal mwrite : std_logic;								-- memory write signal		  
signal mread : std_logic;								-- memory read signal	
signal pagedmradd : std_logic_vector(10 downto 0);
signal pagedmwadd : std_logic_vector(10 downto 0);
signal pagedmwrite : std_logic;

signal mibus_ram : std_logic_vector(7 downto 0);		  -- memory data in bus RAM
signal mibus_io : std_logic_vector(7 downto 0);			  -- memory data in bus IO

alias wiosel : std_logic is mwadd(10); 
alias riosel : std_logic is ioradd(10);

signal WriteLEDs : std_logic;
Signal LocalLEDs : std_logic_vector(7 downto 0);	

signal ReadExtData : std_logic;
signal WriteExtData : std_logic;
signal ReadExtAddLow	 : std_logic;	
signal WriteExtAddLow : std_logic;		
signal ReadExtAddHigh : std_logic;		
signal WriteExtAddHigh : std_logic;		
signal StartExtRead : std_logic;	
signal StartExtReadRQ : std_logic;
signal StartExtReadDel : std_logic_vector(1 downto 0); 	
signal StartExtWrite : std_logic;
signal StartExtWriteRQ : std_logic;	
signal StartExtWriteDel : std_logic_vector(1 downto 0); 	
signal ReadEIOCookie : std_logic;		

signal HM2ReadBuffer0 : std_logic_vector(31 downto 0);
signal HM2WriteBuffer0 : std_logic_vector(31 downto 0);
signal HM2ReadBuffer1 : std_logic_vector(31 downto 0);
signal HM2WriteBuffer1 : std_logic_vector(31 downto 0);
signal Write32 : std_logic;
signal Read32 : std_logic;
signal ExtAddress0: std_logic_vector(15 downto 0);	
signal ExtAddress1: std_logic_vector(15 downto 0);
signal HM2obus	 : std_logic_vector(31 downto 0);

signal wseladd: std_logic_vector(7 downto 0); 
signal rseladd: std_logic_vector(7 downto 0); 

signal clk0fx : std_logic;
signal clk0 : std_logic;
signal procclk : std_logic;

signal clk1fx : std_logic;
signal clk1 : std_logic;
signal hm2fastclock : std_logic;


constant EIOCookie: std_logic_vector(7 downto 0) := x"EE"; 

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
		ibus =>  HM2WriteBuffer1,
		obus => HM2obus,
		addr => ExtAddress1(15 downto 2),
		readstb => Read32,
		writestb => Write32,
		clklow => CLK,
		clkmed => procclk,
		clkhigh =>  hm2fastclock,
--		int => INT, 
		leds => LEDS,	
		iobits => IOBITS			

		);

 	Is7I61: if (BoardNameHigh = BoardName7i61)  generate
	
   ClockMult0 : DCM
		generic map (
			CLKDV_DIVIDE => 2.0,
			CLKFX_DIVIDE => 4, 
			CLKFX_MULTIPLY =>2,			-- 4/2 for 100 MHz
			CLKIN_DIVIDE_BY_2 => FALSE, 
			CLKIN_PERIOD => 19.5,          
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
			CLKIN => hm2fastclock,    	-- cascaded clock input (from IBUFG, BUFG or DCM) fails on spartan 3
			PSCLK => '0',  	-- Dynamic phase adjust clock input
			PSEN => '0',     	-- Dynamic phase adjust enable input
			PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
			RST => '0'        -- DCM asynchronous reset input
		);
		BUFG0_inst : BUFG
		port map (
			O => procclk,    		-- Clock buffer output
			I => clk0fx      	-- Clock buffer input
		);
		
  ClockMult1 : DCM
		generic map (
			CLKDV_DIVIDE => 2.0,
			CLKFX_DIVIDE => 2, 
			CLKFX_MULTIPLY =>8,			-- 8/2 for 200 MHz
			CLKIN_DIVIDE_BY_2 => FALSE, 
			CLKIN_PERIOD => 19.5,          
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
			CLKIN => CLK,    	-- Clock input (from IBUFG, BUFG or DCM)
			PSCLK => '0',    	-- Dynamic phase adjust clock input
			PSEN => '0',     	-- Dynamic phase adjust enable input
			PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
			RST => '0'        -- DCM asynchronous reset input
		);
  
	BUFG1_inst : BUFG
		port map (
			O => hm2fastclock,    		-- Clock buffer output
			I => clk1fx      	-- Clock buffer input
		);

  -- End of DCM_inst instantiation		
	end generate;
	
 	Isnot7I61: if (BoardNameHigh /= BoardName7i61)  generate	 

		ClockMult0 : DCM
		generic map (
			CLKDV_DIVIDE => 2.0,
			CLKFX_DIVIDE => 2, 
			CLKFX_MULTIPLY =>3,			-- 3/2 FOR 75 MHz
			CLKIN_DIVIDE_BY_2 => FALSE, 
			CLKIN_PERIOD => 19.5,          
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
			CLKIN => CLK,    	-- External clock input (from IBUFG, BUFG or DCM) not possible on SP6 7I61 
			PSCLK => '0',  	-- Dynamic phase adjust clock input
			PSEN => '0',     	-- Dynamic phase adjust enable input
			PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
			RST => '0'        -- DCM asynchronous reset input
		);
  
	BUFG0_inst : BUFG
		port map (
			O => procclk,    		-- Clock buffer output
			I => clk0fx      	-- Clock buffer input
		);
		
  ClockMult1 : DCM
		generic map (
			CLKDV_DIVIDE => 2.0,
			CLKFX_DIVIDE => 2, 
			CLKFX_MULTIPLY =>4,			-- 4/2 for 100 MHz
			CLKIN_DIVIDE_BY_2 => FALSE, 
			CLKIN_PERIOD => 19.5,          
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
			CLKIN => CLK,    	-- Clock input (from IBUFG, BUFG or DCM)
			PSCLK => '0',    	-- Dynamic phase adjust clock input
			PSEN => '0',     	-- Dynamic phase adjust enable input
			PSINCDEC => '0', 	-- Dynamic phase adjust increment/decrement
			RST => '0'        -- DCM asynchronous reset input
		);
  
	BUFG1_inst : BUFG
		port map (
			O => hm2fastclock,    		-- Clock buffer output
			I => clk1fx      	-- Clock buffer input
		);

  -- End of DCM_inst instantiation		
	end generate;
	

 


	asimplspi: entity work.simplespi8
		generic map
		(
			buswidth => 8,
			div => 2,	-- for divide by 3
			bits => 8
		)	
		port map 
		( 
			clk  => procclk,
			ibus => mobus,
			obus => mibus_io,
			loaddata => LoadSPIReg,
			readdata => ReadSPIReg,
			loadcs => LoadSPICS,
			readcs => ReadSPICS,
			spiclk => SPIClk,
			spiin => SPIIn,
			spiout => SPIOut,
			spics =>SPICS 
		 );


	processor: entity work.DumbAss8sq

	
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



  programROM : entity work.usbrom 
  port map(
		addr => iabus,
		clk  => procclk,
		din  => x"0000",
		dout => idbus,
		we	=> '0'
	 );

  DataRam : entity work.usbram 
  port map(
		addra => pagedmwadd,
		addrb => pagedmradd,
		clk  => procclk,
		dina  => mobus,
--		douta => 
		doutb => mibus_ram,
		wea	=> pagedmwrite
	 );
	 
	MiscProcFixes : process (procclk, mradd, mwadd, mwrite)		-- need to match BlockRAM address pipeline register for I/O
	begin									 		-- and map memory/IO so 1K IO,1K memory, 1K IO, 1K memory
		if rising_edge(procclk) then
			ioradd <= mradd;
		end if;
		pagedmradd <= mradd(11) & mradd(9 downto 0);
		pagedmwadd <= mwadd(11) & mwadd(9 downto 0);
		pagedmwrite <= mwrite and mwadd(10);
	end process;		
	
	ram_iomux : process (ioradd(10),mibus_ram,mibus_io)
	begin
		if ioradd(10) = '1' then
			mibus <= mibus_ram;
		else
			mibus <= mibus_io;
		end if;
	end process;

	iodecode: process(ioradd,mwadd,mwrite,rseladd,wseladd,extaddress0,writeextdata,readextdata)
	begin
		rseladd <= ioradd(7 downto 0);
		wseladd <= mwadd(7 downto 0);

		if rseladd (7 downto 3) = "01100" and riosel = '0' then -- 0x60 through 0x67
			ReadExtData <= '1';
		else
			ReadExtData <= '0';		
		end if;	

		if wseladd (7 downto 3) = "01100" and wiosel = '0' and mwrite = '1' then -- 0x60 through 0x67
			WriteExtData <= '1';
		else
			WriteExtData <= '0';		
		end if;	

		if rseladd = x"68" and riosel = '0' then
			ReadExtAddLow <= '1';
		else
			ReadExtAddLow <= '0';		
		end if;	

		if wseladd = x"68" and wiosel = '0' and mwrite= '1' then
			WriteExtAddLow <= '1';
		else
			WriteExtAddLow <= '0';		
		end if;	

		if rseladd = x"69" and riosel = '0' then
			ReadExtAddHigh <= '1';
		else
			ReadExtAddHigh <= '0';		
		end if;	

		if wseladd = x"69" and wiosel = '0' and mwrite= '1' then
			WriteExtAddHigh <= '1';
		else
			WriteExtAddHigh <= '0';		
		end if;	

		if wseladd = x"6D" and wiosel = '0' and mwrite = '1' then
			StartExtRead <= '1';
		else
			StartExtRead <= '0';		
		end if;	

		if wseladd = x"6E" and wiosel = '0' and mwrite= '1' then
			StartExtWrite <= '1';
		else
			StartExtWrite <= '0';		
		end if;	

		if rseladd = x"6F" and riosel = '0' then
			ReadEIOCookie <= '1';
		else
			ReadEIOCookie <= '0';		
		end if;	

		if wseladd = x"7A" and wiosel = '0' and mwrite = '1'then
			WriteLEDs <= '1';
		else
			WriteLEDs <= '0';		
		end if;	

		if wseladd = x"7B" and wiosel = '0' and mwrite = '1'then
			LoadUSBControlReg <= '1';
		else
			LoadUSBControlReg <= '0';		
		end if;	

		if rseladd = x"7B" and riosel = '0' then
			ReadUSBStatus <= '1';
		else
			ReadUSBStatus <= '0';		
		end if;	
		
		if wseladd = x"7C" and wiosel = '0' and mwrite = '1'then
			LoadUSBDataReg <= '1';
		else
			LoadUSBDataReg <= '0';		
		end if;	

		if rseladd = x"7C" and riosel = '0' then
			ReadUSBData <= '1';
		else
			ReadUSBData <= '0';		
		end if;	

		if wseladd = x"007D" and wiosel = '0' and mwrite = '1' then
			LoadSPICS <= '1';
		else
			LoadSPICS <= '0';		
		end if;	

		if rseladd = x"007D" and riosel = '0' then
			ReadSPICS <= '1';
		else
			ReadSPICS <= '0';		
		end if;	

		if wseladd = x"007E" and wiosel = '0' and mwrite = '1'then
			LoadSPIReg <= '1';
		else
			LoadSPIReg <= '0';		
		end if;	

		if rseladd = x"007E" and riosel = '0' then
			ReadSPIReg <= '1';
		else
			ReadSPIReg <= '0';		
		end if;	
		
		if ExtAddress0 = x"7F7F" and WriteExtData = '1' and wiosel = '0' and mwrite = '1' then
			ReconfigSel <= '1';
		else
			ReconfigSel <= '0';		
		end if;	

	end process iodecode;
	
	doreconfig: process (procclk,ReConfigreg)
	begin
		if rising_edge(procclk) then
			if ReconfigSel = '1' then
				if mobus = x"5A" then
					ReConfigreg <= '1';
				end if;
			end if;
		end if;		
		RECONFIG <= not ReConfigreg;
		HRECONFIG <= not ReConfigreg; -- for 7I43H
	end process doreconfig;
	
	HM2InterfaceShim: process (procclk,CLK,startextreaddel,
	                           startextwritedel,readextdata,rseladd,
										HM2ReadBuffer1,extaddress0,readextaddhigh,
										extaddress0,readeiocookie,readextaddlow)
	begin	
		if rising_edge(procclk) then
		  	if WriteLEDS = '1' then
				LocalLEDs <= mobus;
			end if;
			
			HM2ReadBuffer1 <= HM2ReadBuffer0;
			if WriteExtData = '1' then 
				case wseladd(1 downto 0) is
					when "00" => HM2WriteBuffer0( 7 downto  0) <= mobus;
					when "01" => HM2WriteBuffer0(15 downto  8) <= mobus;
					when "10" => HM2WriteBuffer0(23 downto 16) <= mobus;
					when "11" => HM2WriteBuffer0(31 downto 24) <= mobus;
					when others => null;
				end case;
			end if;

			if StartExtRead = '1' then		-- set read request - this is to sync processor I/O to
				StartExtReadRq <= '1'; 		-- slower HM2 base clock 
			end if;
			if StartExtWrite = '1' then	-- set write request - this is to sync processor I/O to
				StartExtWriteRq <= '1';		-- slower HM2 base clock 
			end if;
			
			if WriteExtAddLow = '1' then
				ExtAddress0(7 downto 0) <= mobus;
			end if;	
			if WriteExtAddHigh = '1' then
				ExtAddress0(15 downto 8) <= mobus;
			end if;			
			
		end if;	-- procclk
		
		if rising_edge(CLK) then
			HM2WriteBuffer1 <= HM2WriteBuffer0;
			ExtAddress1 <= ExtAddress0;
			StartExtReadDel <= StartExtReadDel(0) & StartExtReadRq;
			StartExtWriteDel <= StartExtWriteDel(0) & StartExtWriteRq;
			if Read32 = '1' then
				HM2ReadBuffer0 <= HM2OBus;	
			end if;	
		end if;
		
		if StartExtReadDel = "11" then
			Read32 <= '1';
		else
			Read32 <= '0';
		end if;
		
		if StartExtWriteDel = "11" then
			Write32 <= '1';
		else
			Write32 <= '0';
		end if;
		
		if StartExtReadDel(1) = '1' then	-- asynchronous clear read request
			StartExtReadRq <= '0';
		end if;
		
		if StartExtWriteDel(1) = '1' then	-- asynchronous clear write request
			StartExtWriteRq <= '0';
		end if;
		
		mibus_io <= "ZZZZZZZZ";
		
		if ReadExtData = '1' then
			case rseladd(1 downto 0) is
				when "00" => mibus_io <= HM2ReadBuffer1( 7 downto  0);
				when "01" => mibus_io <= HM2ReadBuffer1(15 downto  8);
				when "10" => mibus_io <= HM2ReadBuffer1(23 downto 16);
				when "11" => mibus_io <= HM2ReadBuffer1(31 downto 24);
				when others => null;
			end case;
		end if;
		
		if ReadExtAddLow = '1' then
			mibus_io <= ExtAddress0( 7 downto  0);
		end if;
		if ReadExtAddHigh = '1' then
			mibus_io <= ExtAddress0(15 downto  8);
		end if;

		if ReadEIOCookie = '1' then
			mibus_io <= EIOCookie;
		end if;
-- 	LEDS <= HM2WriteBuffer1(7 downto 0); -- debug kludge
	end process;	
	
	USBInterfaceDrive: process (procclk, USBDataReg, DATABUS, USB_TSEn, 
										 ReadUSBData, ReadUSBStatus, USB_RXF, USB_TXE)
	begin
		
		DATABUS <= "ZZZZZZZZ";
		if USB_TSEn = '1' then 
			DATABUS <= USBDataReg;
		end if;
		
		mibus_io <= "ZZZZZZZZ";
		if ReadUSBData = '1' and ReadUSBStatus = '0' then 
			mibus_io <= DATABUS;
		end if;

		if ReadUSBStatus = '1' and ReadUSBData = '0' then 
			mibus_io(0) <= USB_RXF;			-- active low receiver has data
			mibus_io(1) <= USB_TXE;			-- active low xmit buffer has space
			mibus_io(7 downto 2) <= "101010";
		end if;
		
		if rising_edge(procclk) then
			if LoadUSBControlReg = '1' then
				USBContReg <= mobus(2 downto 0);
			end if;
			
			if LoadUSBDataReg = '1' then
				USBDataReg <= mobus;
			end if;

		end if;
		USB_RD <= USB_RdReg;
		USB_WRITE <= USB_WriteReg;
--		LEDS <= not LocalLEDs;				-- debug kludge
--		LEDS <= not ExtAddress0(7 downto 0);	-- debug kludge		
--		LEDS <= not ExtAddress0(15 downto 8);	-- debug kludge		
--		LEDS <= not HM2WriteBuffer0(7 downto 0);	-- debug kludge
		PARACONFIG <= '0';
	end process USBInterfaceDrive;	


end Behavioral;
