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
use work.FixICap.all;
use work.IDROMConst.all;	

-------------------- option selection area ----------------------------

use work.@Card@.all;

-------------------- select one card type------------------------------


--use work.i80db_x16card.all; 			-- needs 7i80db.ucf and SP6 x16 256 pin
--use work.i80db_x25card.all; 			-- needs 7i80db.ucf and SP6 x25 256 pin
--use work.i80hd_x16card.all;      		-- needs 7i80hd.ucf and SP6 x16 256 pin
--use work.i80hd_x25card.all; 			-- needs 7i80hd.ucf and SP6 x25 256 pin
--use work.i76E_x16card.all;           -- needs 7i76e.ucf and SP6 x16 256 pin
--use work.i92_x9card.all; 				-- needs 7i92.ucf and SP6 x9 144 pin
--use work.i93_x9card.all; 				-- needs 7i93.ucf and SP6 x9 144 pin
--use work.i94_x9card.all;                                -- needs 7i94.ucf and SP6 x9 144 pin
--use work.i95_x9card.all; 				-- needs 7i95.ucf and SP6 x9 144 pin
--use work.i96_x9card.all;             -- needs 7i96.ucf and SP6 x9 144 pin
--use work.i97_x9card.all; 				-- needs 7i97.ucf and SP6 x9 144 pin
--use work.i98_x9card.all; 				-- needs 7i98.ucf and SP6 x9 144 pin
-----------------------------------------------------------------------

use work.@Pin@.all;

-------------------- select (or add) one pinout -----------------------
--use work.PIN_FALLBACK_34.all;			-- IO only configuration for fast compiles whilst debugging PCI and fallback config
--use work.PIN_G540x2D_34.all;  			-- 7i92 step config with DPLL for 2X Gecko 540
--use work.PIN_G540_7I85SD_34.all;  	-- 7i92 step config with DPLL for 1X Gecko 540 and 1X 7I85S
--use work.PIN_7I76x1D_34.all;  			-- 7i92 step config with DPLL for 1X 7I76 step/dir breakout
--use work.PIN_7I76x2D_34.all;  			-- 7i92 step config with DPLL for 1X 7I76 step/dir breakout
--use work.PIN_R990x2D_34.all;			-- 7i92 step config with DPLL for 2x Rutex R990 MB
--use work.PIN_DMMBOB1x2D_34.all;		-- DMM DBM4250 bob step/dir config with DPLL 
--use work.PIN_MX3660x2D_34.all;			-- config for Leadshine MX3660 triple step motor drive
--use work.PIN_MX4660Plus_34.all;			-- config for Leadshine MX4660 quad step motor drive
--use work.PIN_MX3660_7I78D_34.all;		-- config for Leadshine MX3660 and 7I78
--use work.PIN_7I77_7I76D_34.all;  		-- 7i92 analog servo config+ 7i76 step/dir config for 7I77 and 7I76
--use work.PIN_7I76_7I74D_34.all;		-- 7i92 step config for 7I76 step/dir breakout (P3) and 7I74 SSerial breakout (P2)
--use work.PIN_7I76_7I74D_SS6_34.all;		-- 7i92 step config for 7I76 step/dir breakout (P3) and 7I74 SSerial breakout (P2)
--use work.PIN_7I77_7I74D_34.all;  		-- 7i92 analog servo config for 7I77 analog servo breakout (P3) and 7I74 SSerial (P2)
--use work.PIN_7I76x2_34.all;  			-- 7i92 step config for 2X 7I76 step/dir breakout
--use work.PIN_7I76x1DPL_34.all;  		-- 7i92 step config for 1X 7I76 step/dir breakout with 3X A only encoders for plasma
--use work.PIN_7I76_1Px2D_34.all;  		-- 7i92 step config for 2X 7I76 step/dir breakout last stepgen replaced with PWM on both 
--use work.PIN_7I76x2R_34.all;  			-- Reversed 7i92 step config for 2X 7I76 step/dir breakout
--use work.PIN_7I74_7I76_34.all;			-- 7i92 step config for 7I76 step/dir breakout (P2) and 7I74 SSerial breakout (P3)
--use work.PIN_7I77x2_34.all;  			-- 7i92 analog servo config for 2X 7I77 analog servo breakout
--use work.PIN_7I77x2RD_34.all;  			-- Reversed 7i92 analog servo config for 2X 7I77 analog servo breakout
--use work.PIN_7I77_7I74_34.all;  		-- 7i92 analog servo config for 7I77 analog servo breakout (P3) and 7I74 SSerial (P2)
--use work.PIN_7I74_7I77_34.all;  		-- 7i92 analog servo config for 7I77 analog servo breakout (P2) and 7I74 SSerial (P3)
--use work.PIN_7I77_7I76_34.all;  		-- 7i92 analog servo config+ 7i76 step/dir config for 7I77 and 7I76
--use work.PIN_7I77_7I78_34.all;  		-- 7i92 analog servo config+ 7i78 step/dir config for 7I77 and 7I76
--use work.PIN_7I74x2_34.all;  			-- 7i92 config for 2X 7I74 RS-422 SSerial I/O expansion
--use work.PIN_7I74x1D_34.all;  			-- 7i92 config for 1X 7I74 RS-422 SSerial I/O expansion
--use work.PIN_7I74x2D_34.all;  			-- 7i92 config for 2X 7I74 RS-422 SSerial I/O expansion +DPLL
--use work.PIN_7I74_SSI_SSx2_34.all;  	-- 7i92 config for 2X 7I74 RS-422 SSerial I/O expansion +SSI +DPLL
--use work.PIN_5ABOB_7I74D_34.all;  	-- 7i92 config for 5Axis Ebay Bob + 7I74 RS-422 SSerial I/O expansion +DPLL
--use work.PIN_5ABOB_7I74FAD_34.all;  	-- 7i92 config for 5Axis Ebay Bob + 7I74 RS-422 Fanuc serial encoder +DPLL
--use work.PIN_7I78x2_34.all;				-- 7i92 step config for 2x 7I78 step/dir breakout 
--use work.PIN_7I76_7I78D_34.all;		-- 7i92 step config for 7I76 and 7I78 step/dir breakout 
--use work.PIN_PROB_RFx2D_34.all;			-- 7i92 step config for Probotix step/dir breakout
--use work.PIN_7I85x2D_34.all;			-- 2x 7I85 encoder + sserial
--use work.PIN_7I85Sx2D_34.all;			-- 2x 7I85S encoder + stepgens + sserial
--use work.PIN_7I85Sx2DMQ4_34.all;		-- 2x 7I85S encoder + stepgens + sserial verison 4 encoders
--use work.PIN_7I85SPx2_34.all;			-- 2x 7I85S encoder + pwmgens + sserial
--use work.PIN_7I76_7I85S_34.all;		-- 7I76 and 7I85S
--use work.PIN_7I76P_7I85_34.all;		-- 7I76 PWM and 7I85
--use work.PIN_7I76_7I85_34.all;			-- 7I76 and 7I85
--use work.PIN_7I85S_7I78_34.all;		-- 7I85S and 7I78
--use work.PIN_7I77_7I85SD_34.all;		-- 7I77 +7I85S step/dir config
--use work.PIN_7I77_7I85SP_34.all;		-- 7I77 +7I85S pwm/dir config
--use work.PIN_7I77x1_IMS_34.all;		-- config for 7I77 with spindle index mask
--use work.PIN_7I85SP_7I85_34.all;		-- config for PWM/enc on P3 7I85S plus ss and encoder on P2 7I85
--use work.PIN_BISS_SSI_TEST_34.all;	
--use work.PIN_5ABOBx2D_34.all;			-- 7i92 step config for Cheap Ebay 5 axis BOBs
--use work.PIN_5ABOB2Px2D_34.all;			-- 7i92 step config for Cheap Ebay 5 axis BOBs 2 PWM
--use work.PIN_5ABOB_XYDPD_34.all;			-- 7i92 step config for Cheap Ebay 5 axis BOB+ XY100/DPainter on P1
--use work.PIN_5ABOB_EncD_34.all;		-- 7i92 step config for Cheap Ebay 5 axis BOBs
--use work.PIN_C11x2D_34.all;				-- 7i92 step config for CNC4PC C11 BOB
--use work.PIN_C11Gx2D_34.all;			-- 7i92 step config for CNC4PC C11G BOB
--use work.PIN_ST8_D_34.all;				-- 7i92 step config just 8 stepgens on P2
--use work.PIN_ST12_D_34.all;				-- 7i92 step config 6 stepgens on P2, 6 on P1
--use work.PIN_PMDX126x2_34.all;			-- pinout for up to 2 PMDX126s
--use work.PIN_7I77_7I88PD_34.all;		-- 7I77 +7I88 step/dir config
--use work.PIN_7I88SSx1_34.all;			-- 7I88 step/dir+SS config
--use work.PIN_DBSPI2_34.all;				-- 2X DBSPI each with 5 CS pins

--use work.PIN_TW17_34.all;

-- 68 I/O pinouts for 7I80DB:
--use work.PIN_JUSTIO_68.all;
--use work.PIN_7I76x3D_68.all;		
--use work.PIN_7I76x4D_68.all; 			-- needs optimize for area on -16		
--use work.PIN_7I76x2_7I77x1D_68.all;	
--use work.PIN_7I76x1_7I85Sx2D_68.all;	
--use work.PIN_7I77x4D_68.all;
--use work.PIN_Benezanx2_68.all;
--use work.PIN_Benezanx2_7I74_68.all;
--use work.PIN_MX4660x2D_68.all;			-- 2X leadshine MX4660
--use work.PIN_HDBB2x2D_68.all;			-- 2X CNCDrive HDBB2 + 2 enc on ports 2,3
--use work.PIN_DMMBOBx2_ENCD_68.all;		-- DMM BOB plus 5 Encoders
--use work.PIN_7I77x4_MQ4_68.all;
--use work.PIN_7I76x2_7I77x2D_68.all;	-- just barely fits in -16
--use work.PIN_7I74x4_68.all;				-- 25 only
--use work.PIN_Benezanx2_7I74x2_68.all;-- 25 only	
--use work.PIN_7I77x2_7I74x2_68.all;	-- 25 only	
--use work.PIN_7I76x2_7I74x2_68.all;	-- 25 only
--use work.PIN_7I76x3_7I74_68.all;		-- 25 only	
--use work.PIN_7I76x2_7I77x2_68.all;	-- 25 only
--use work.PIN_7I76x2_7I77x2_68.all;	-- 25 only

-- 51 pin pinouts for 7I76E
--use work.PIN_7I76x1D_51.all;
--use work.PIN_7I76x1DPL_51.all;
--use work.PIN_7I76x2D_51.all;
--use work.PIN_7I76x3D_51.all;
--use work.PIN_7I76x1PD_51.all;
--use work.PIN_7I76x5PD_51.all;
--use work.PIN_7I76X1_7I85x1D_51.all;
--use work.PIN_7I76X1_7I89x1D_51.all;
--use work.PIN_7I76_7I88SS_7I89D_51.all;
--use work.PIN_7I76X1_7I78x1D_51.all;
--use work.PIN_7I76X1_7I78x1PD_51.all;
--use work.PIN_7I76X1_7I85x1_5abobD_51.all;
--use work.PIN_7I76x1_7I85sx1_7I74x1D_51.all;
--use work.PIN_7I76X1_7I77x1D_51.all;
--use work.PIN_7I76X1_7I77x1DP2_51.all;
--use work.PIN_7I76X1_7I74x1D_51.all;
--use work.PIN_7I76X1_7I74x1SSID_51.all;
--use work.PIN_7i76x1_7i85sx1D_51.all;
--use work.PIN_7I76X1_7I85sx2D_51.all;
--use work.PIN_7i76x1_7i85x1_7i85sx1D_51.all;
--use work.PIN_7i76x1_pmdx126DR_51.all;
--use work.PIN_7i76x1_bstechx1d_51.all;
--use work.PIN_7i76x1_bstechx2d_51.all;
--use work.PIN_7I76x1_PktD_51.all;
--use work.PIN_7i76x1_7i77x1_7i85sx1D_51.all;

-- 51 pin pinouts for 7I96
--use work.PIN_7I96D_7I76_51.all;
--use work.PIN_7I96D_7I78_51.all;
--use work.PIN_7I96D_7I85S_51.all;
--use work.PIN_7I96D_7I89_51.all;
--use work.PIN_7I96D_7I85S_SS45_51.all;
--use work.PIN_7I96_inmD_7I85S_51.all;
--use work.PIN_7I96D_7I77_51.all;
--use work.PIN_7I96D_1pwm_51.all;
--use work.PIN_7I96D_51.all;
--use work.PIN_7I96D_TTEST_51.all;
--use work.PIN_7I96Dss45_51.all;
--use work.PIN_7I96DPL_51.all;
--use work.PIN_7I96_6encD_51.all;
--use work.PIN_7I96inmD_51.all;
--use work.PIN_7I96inmD_dp_51.all;
--use work.PIN_7I96inmD_5abob_51.all;
--use work.PIN_7I96D_5abob_51.all;
--use work.PIN_7I96_PktD_51.all;
--use work.PIN_7I96_BISSD_51.all;
--use work.PIN_7I96_XY2ModD_51.all;
--use work.PIN_JUSTIO_51.all;

-- 42 pin pinouts for 7I94
--use work.PIN_7I94SSD_42.all;
--use work.PIN_7I94_7I74SSD_42.all;
--use work.PIN_7I94SS45D_42.all;
--use work.PIN_7I94SS_5ABOBD_42.all;
--use work.PIN_7I94SS_7I85SD_42.all;
--use work.PIN_7I94SS_7I85D_42.all;
--use work.PIN_7I94SS_7I77D_42.all;
--use work.PIN_7I94SS_7I76D_42.all;
--use work.PIN_7I94SSID_42.all;
--use work.PIN_7I94BISSD_42.all;
--use work.PIN_7I94PKTD_42.all;
--use work.PIN_FALLBACK_42.all;


-- 51 pin pinouts for 7I97
--use work.PIN_7I97D_51.all;
--use work.PIN_7I97_7I78D_51.all;
--use work.PIN_7I97_7I74D_51.all;
--use work.PIN_JUSTIO_51.all;

-- 51 pin pinouts for 7I98
--use work.PIN_5ABOBx3D_51.all;
--use work.PIN_G540x3D_51.all;
--use work.PIN_JUSTIO_51.all;

-- 58 pin pinouts for 7I95
--use work.PIN_JUSTIO_58.all;
--use work.PIN_7I95D_58.all;
--use work.PIN_7I95_7I78D_58.all;
--use work.PIN_7I95PRD_58.all;
 
-- 72 pin pinouts for 7I80HD
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
--use work.PIN_SVSTSS12_12_8_7I52SD_72.all;
--use work.PIN_SVSS6_6_72.all;
--use work.PIN_SVSS6_8_72.all;
--use work.PIN_BASACKWARDS_SVSS6_8_72.all;
--use work.PIN_SSSVST8_1_5_7I47_72.all;
--use work.PIN_SVSS8_44_72.all;
--use work.PIN_SVSSST4_8_4_7I47SD_72.all;
--use work.PIN_RMSVSS6_8_72.all;
--use work.PIN_RMESVSS6_6_72.all;
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
--use work.PIN_PktUARTTest_72.all;
--use work.PIN_SSSV18_12_72.all;
--use work.PIN_SVTP2_SI2_72.all;
--use work.PIN_SVTP2_SI2_UA4_72.all;
--use work.PIN_SVSSSI6_4_4_72.all;

-- 48 pin pinouts for 7I93


--use work.PIN_SV8_48.all;
--use work.PIN_TPEN4_5D_48.all;
--use work.PIN_JUSTIO_48.all;
--use work.PIN_SV6_7I52S_48.all;
--use work.PIN_SVSPD6_2_48.all;
--use work.PIN_SPSVST_7I47_7I65_48.all;
--use work.PIN_SVSP6_2_48.all;
--use work.PIN_SVST4_4_48.all;
--use work.PIN_SVST6_6_7I48_48.all;
--use work.PIN_SVST4_6_48.all;
--use work.PIN_SVST2_4_7I47_48.all;
--use work.PIN_SVST4_12_48.all ;
--use work.PIN_SVSSP4_6_7I46_48.all;
--use work.PIN_SVST2_4_7I47_48.all ;
--use work.PIN_SVUA4_8_48.all;
--use work.PIN_SVSS4_8D_48.all; 
--use work.PIN_SVSS4_5D_48.all; 
--use work.PIN_SVSS7_2D_48.all; 
--use work.PIN_SVSS4_4_48.all;
--use work.PIN_SVSS6_6_48.all; 
--use work.PIN_SVSS6_4_48.all;
--use work.PIN_SVTW4_24_24_48.all ;
--use work.PIN_SVTP4_7I39_48.all;
--use work.PIN_SVST6_6_7I48_48.all;
--use work.PIN_SVRM6_48.all;
--use work.PIN_SVRMSS6_8_48.all;
--use work.PIN_SISVST6_2_3_7I47_48.all;
--use work.PIN_BOSSV.all ;
--use work.PIN_Enslavko_48.all;
--use work.PIN_SVSTS47S_44_48.all;
--use work.PIN_RLUKEN_48.all;
--use work.PIN_THYDE_48.all;
--use work.PIN_SVSI8_48.all;

----------------------------------------------------------
	
	
-- dont change anything below unless you know what you are doing -----
	
entity TopEthernetHostMot2 is -- for 7I80DB,7I80HD,7I77E,7I76E,7I92,7I93,7I96,7I97
	 generic 
	 (
		ThePinDesc: PinDescType := PinDesc;
		TheModuleID: ModuleIDType := ModuleID;
		PWMRefWidth: integer := 13;	-- PWM resolution is PWMRefWidth-1 bits 
		IDROMType: integer := 3;		
		UseStepGenPrescaler : boolean := true;
		UseIRQLogic: boolean := true;
		UseWatchDog: boolean := true;
		OffsetToModules: integer := 64;
		OffsetToPinDesc: integer := 448;
		BusWidth: integer := 32;
		AddrWidth: integer := 16;
		InstStride0: integer := 4;			-- instance stride 0 = 4 bytes = 1 x 32 bit
		InstStride1: integer := 64;		-- instance stride 1 = 64 bytes = 16 x 32 bit registers sserial
--		InstStride1: integer := 16;		-- 4..7 16 for BSPI/UART Ick double Ick
		RegStride0: integer := 256;		-- register stride 0 = 256 bytes = 64 x 32 bit registers
		RegStride1: integer := 256;      -- register stride 1 = 256 bytes - 64 x 32 bit
		FallBack: boolean := false			-- is this a fallback config?

		);
						
		
	Port (	CLK : in std_logic;
				LEDS : out std_logic_vector(LEDCount -1 downto 0);
				IOBITS : inout std_logic_vector(IOWidth -1 downto 0);		-- external I/O bits
				LIOBITS: inout std_logic_vector (LIOWidth -1 downto 0);	-- local I/O bits		
				ED : inout std_logic_vector(15 downto 0);
				ECMD : out std_logic;
				NEREAD : out std_logic;
				NEWRITE : out std_logic;
				NECS : out std_logic;
				EINT : in std_logic;
				ECLK : out std_logic;
				NERST : out std_logic;
				SPICLK : out std_logic;
				SPIIN : in std_logic;
				SPIOUT : out std_logic;
				SPICS : out std_logic;
				NINIT : out std_logic;
				TP : out std_logic_vector(1 downto 0);
				OPTS : in std_logic_vector(1 downto 0)
		 );
end TopEthernetHostMot2;


architecture Behavioral of TopEthernetHostMot2 is
	 
-- GPIO interface signals

signal LoadSPIReg : std_logic;
signal ReadSPIReg : std_logic;
signal LoadSPICS : std_logic;
signal ReadSPICS : std_logic;

signal LoadEthDataReg : std_logic;
signal ReadEthData : std_logic;
signal LoadEthControlReg : std_logic;
signal RLoadEthControlReg : std_logic;
signal LoadEthResetReg : std_logic;
signal ReadEthStatus : std_logic;
signal EthDataReg : std_logic_vector(15 downto 0);
signal EthDiv : std_logic_vector(1 downto 0);
signal EthContReg : std_logic_vector(4 downto 0) := "00000";
signal EthResetReg : std_logic := '0';
alias  Eth_CS : std_logic is EthContReg(0);
alias  Eth_CMD : std_logic is EthContReg(1);
alias  Eth_Read : std_logic is EthContReg(2);
alias  Eth_Write : std_logic is EthContReg(3);
alias  Eth_TS : std_logic is EthContReg(4);

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
signal LocalLEDs : std_logic_vector(3 downto 0);	
signal LEDMode: std_logic;
signal LEDErrFF: std_logic;
signal WriteErrLED: std_logic;
signal WDLBite: std_logic;

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

signal ICapO : std_logic_vector(15 downto 0);
signal ICapI : std_logic_vector(15 downto 0);

signal ICapSel : std_logic;
signal ICapClk : std_logic;
signal ICapRW : std_logic;
signal LoadICapClk : std_logic;
signal LoadICapRW : std_logic;
signal LoadICap : std_logic;
signal ReadICap : std_logic;



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
		ledcount  => LEDCount		)
	port map (
		ibus =>  HM2WriteBuffer,
		obus => HM2obus, 
		addr => ExtAddress(15 downto 2),
		readstb => Read32,
		writestb => Write32,
		clklow => procclk,
		clkmed => procclk,			-- on Ethernet cards procclk is same as clocklow
		clkhigh =>  hm2fastclock,
--		int => INT, 
		iobits => IOBITS,			
		liobits => LIOBITS,			
		rates => Rates,
		leds => HM2LEDS,	
      wdlatchedbite => WDLBite 
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



  Etherhm2 : entity work.etherhm2
  port map(
		addr => iabus(11 downto 0),
		clk  => procclk,
		din  => x"000000",
		dout => idbus,
		we	=> '0'
	 );

	DataRam : entity work.dpram 
	generic map (
		width => 16,
		depth => 4096
				)
	port map(
		addra => mwadd(11 downto 0),
		addrb => mradd(11 downto 0),
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
		rseladd <= ioradd(7 downto 0);			-- 8 rather than 7 bits to ease hex decode addr spec
		wseladd <= mwadd(7 downto 0);
		
		if ioradd(11 downto 7) = "00000" then	-- bottom 128 words are I/O space
			riosel <= '1';
		else
			riosel <= '0';
		end if;
		
		if mwadd(11 downto 7) = "00000" then	-- bottom 128 words are I/O space
			wiosel <= '1';
		else
			wiosel <= '0';
		end if;
		
		if wseladd = x"0020" and wiosel = '1' and mwrite = '1' then
			LoadICap <= '1';
		else
			LoadICap <= '0';		
		end if;	

		if rseladd = x"0020" and riosel = '1' then
			ReadICap <= '1';
		else
			ReadIcap <= '0';		
		end if;	

		if wseladd = x"0021" and wiosel = '1' and mwrite = '1' then
			LoadICapClk <= '1';
		else
			LoadICapClk <= '0';		
		end if;	

		if wseladd = x"0022" and wiosel = '1' and mwrite = '1' then
			LoadICapRW <= '1';
		else
			LoadICapRW <= '0';		
		end if;	


		if wseladd = x"30" and wiosel = '1' and mwrite = '1'then
			LoadEthDataReg <= '1';
		else
			LoadEthDataReg <= '0';		
		end if;	

		if rseladd = x"30" and riosel = '1' then
			ReadEthData <= '1';
		else
			ReadEthData <= '0';		
		end if;	

		if rseladd = x"31" and riosel = '1' then
			ReadEthStatus <= '1';
		else
			ReadEthStatus <= '0';		
		end if;	
		
		if wseladd = x"32" and wiosel = '1' and mwrite = '1'then
			LoadEthResetReg <= '1';
		else
			LoadEthResetReg <= '0';		
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

		if wseladd(7 downto 5) = "010" and wiosel = '1' and mwrite = '1'then  -- 0x40 through 0x5F
			LoadEthControlReg <= '1';							-- this sets the low level read/write strobes				
		else															-- for the KSZ8816 Ethernet chip
			LoadEthControlReg <= '0';		
		end if;	

		if rseladd(7 downto 5) = "010" and riosel = '1' and mread = '1'then  -- 0x40 through 0x5F
			RLoadEthControlReg <= '1';							-- this sets the low level read/write strobes				
		else															-- for the KSZ8816 Ethernet chip
			RLoadEthControlReg <= '0';		
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
											 readextadd,extaddress,ledmode,
											 hm2leds,localleds )
	begin	
		if rising_edge(procclk) then
			Read32 <= StartExtRead;
		  	if WriteLEDS = '1' then
				LocalLEDs <= mobus(3 downto 0);
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
				
	end process;	
	
	EthInterfaceDrive: process (procclk, EthDataReg, ED, Eth_TS, RLoadEthControlReg, 
										 ReadEthData, ReadEthStatus, EINT, EthResetReg, EthDiv)
	begin
		
		ED <= "ZZZZZZZZZZZZZZZZ";
		if Eth_TS = '1' then 
			ED <= EthDataReg;
		end if;
		
		mibus_io <= "ZZZZZZZZZZZZZZZZ";
		if (ReadEthData = '1' or RLoadEthControlReg = '1') and ReadEthStatus = '0' then 
			mibus_io <= ED;
		end if;

		if ReadEthStatus = '1' and ReadEthData = '0' then 
			mibus_io(0) <= EINT;			-- active low interrupt
			mibus_io(15 downto 1) <= (others => '0');
		end if;
		
		if rising_edge(procclk) then
			if LoadEthControlReg = '1' then
				EthContReg <= wseladd(4 downto 0);	-- address bits used as control bits
			end if;											-- so data/accumulator need not change

			if RLoadEthControlReg = '1' then
				EthContReg <= rseladd(4 downto 0);	-- address bits used as control bits
			end if;											-- so data/accumulator need not change
			
			if LoadEthDataReg = '1' then
				EthDataReg <= mobus;
			end if;

			if LoadEthResetReg = '1' then
				EthResetReg <= mobus(0);
			end if;
			EthDiv <= EthDiv +1;							-- for 100 MHz divide by 4 (25 MHz) Ethernet clock
			
		end if;
		NECS <= not Eth_CS;
		ECMD <= Eth_CMD;
		NEREAD <= not Eth_Read;
		NEWRITE <= not Eth_Write;
		NERST <= EthResetReg;
		ECLK <= EthDiv(1);				
	end process EthInterfaceDrive;	

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
		NormalMode : process(LEDErrFF,WDLBite)
		begin
--			NINIT <= 'Z';
			NINIT <= (not LEDErrFF) and (not WDLBite);
		end process;	
	end generate;		
		

end Behavioral;
