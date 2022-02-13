library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Created from 12bitsin.bin
-- On 2/26/2010
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
entity waveram is
	port (
	addra: in std_logic_vector(9 downto 0);
	addrb: in std_logic_vector(9 downto 0);
	clk: in std_logic;
	dina: in std_logic_vector(15 downto 0);
	douta: out std_logic_vector(15 downto 0);
	doutb: out std_logic_vector(15 downto 0);
	wea: in std_logic);
end waveram;

architecture syn of waveram is
   type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
   signal RAM : ram_type := 
   (
   x"07FF", x"080C", x"0818", x"0825", x"0831", x"083E", x"084A", x"0857",
   x"0863", x"0870", x"087D", x"0889", x"0896", x"08A2", x"08AF", x"08BB",
   x"08C8", x"08D4", x"08E1", x"08ED", x"08FA", x"0906", x"0912", x"091F",
   x"092B", x"0938", x"0944", x"0951", x"095D", x"0969", x"0976", x"0982",
   x"098E", x"099B", x"09A7", x"09B3", x"09C0", x"09CC", x"09D8", x"09E4",
   x"09F0", x"09FD", x"0A09", x"0A15", x"0A21", x"0A2D", x"0A39", x"0A45",
   x"0A51", x"0A5D", x"0A69", x"0A75", x"0A81", x"0A8D", x"0A99", x"0AA5",
   x"0AB1", x"0ABC", x"0AC8", x"0AD4", x"0AE0", x"0AEB", x"0AF7", x"0B03",
   x"0B0E", x"0B1A", x"0B26", x"0B31", x"0B3D", x"0B48", x"0B53", x"0B5F",
   x"0B6A", x"0B76", x"0B81", x"0B8C", x"0B97", x"0BA3", x"0BAE", x"0BB9",
   x"0BC4", x"0BCF", x"0BDA", x"0BE5", x"1BF0", x"0BFB", x"0C06", x"0C11",
   x"0C1B", x"0C26", x"0C31", x"0C3C", x"0C46", x"0C51", x"0C5B", x"0C66",
   x"0C70", x"0C7B", x"1C85", x"0C8F", x"0C9A", x"0CA4", x"0CAE", x"0CB8",
   x"0CC2", x"0CCC", x"0CD6", x"0CE0", x"0CEA", x"0CF4", x"0CFE", x"0D08",
   x"1D12", x"0D1B", x"0D25", x"0D2F", x"0D38", x"0D42", x"0D4B", x"0D54",
   x"0D5E", x"0D67", x"0D70", x"0D79", x"0D82", x"0D8C", x"1D95", x"0D9E",
   x"0DA6", x"0DAF", x"0DB8", x"0DC1", x"0DCA", x"0DD2", x"0DDB", x"0DE3",
   x"0DEC", x"0DF4", x"0DFC", x"0E05", x"1E0D", x"0E15", x"0E1D", x"0E25",
   x"0E2D", x"0E35", x"0E3D", x"0E45", x"0E4D", x"0E54", x"0E5C", x"0E64",
   x"0E6B", x"0E73", x"1E7A", x"0E81", x"0E89", x"0E90", x"0E97", x"0E9E",
   x"0EA5", x"0EAC", x"0EB3", x"0EBA", x"0EC0", x"0EC7", x"0ECE", x"0ED4",
   x"1EDB", x"0EE1", x"0EE8", x"0EEE", x"0EF4", x"0EFA", x"0F00", x"0F06",
   x"0F0C", x"0F12", x"0F18", x"0F1E", x"0F23", x"0F29", x"1F2F", x"0F34",
   x"0F39", x"0F3F", x"0F44", x"0F49", x"0F4E", x"0F53", x"0F58", x"0F5D",
   x"0F62", x"0F67", x"0F6C", x"0F70", x"1F75", x"0F79", x"0F7E", x"0F82",
   x"0F86", x"0F8B", x"0F8F", x"0F93", x"0F97", x"0F9B", x"0F9E", x"0FA2",
   x"0FA6", x"0FA9", x"1FAD", x"0FB0", x"0FB4", x"0FB7", x"0FBA", x"0FBE",
   x"0FC1", x"0FC4", x"0FC7", x"0FC9", x"0FCC", x"0FCF", x"0FD2", x"0FD4",
   x"1FD7", x"0FD9", x"0FDB", x"0FDE", x"0FE0", x"0FE2", x"0FE4", x"0FE6",
   x"0FE8", x"0FEA", x"0FEB", x"0FED", x"0FEF", x"0FF0", x"1FF2", x"0FF3",
   x"0FF4", x"0FF5", x"0FF6", x"0FF7", x"0FF8", x"0FF9", x"0FFA", x"0FFB",
   x"0FFC", x"0FFC", x"0FFD", x"0FFD", x"1FFD", x"0FFE", x"0FFE", x"0FFE",
   x"0FFE", x"0FFE", x"0FFE", x"0FFE", x"0FFD", x"0FFD", x"0FFD", x"0FFC",
   x"0FFC", x"0FFB", x"1FFA", x"0FF9", x"0FF8", x"0FF7", x"0FF6", x"0FF5",
   x"0FF4", x"0FF3", x"0FF2", x"0FF0", x"0FEF", x"0FED", x"0FEB", x"0FEA",
   x"1FE8", x"0FE6", x"0FE4", x"0FE2", x"0FE0", x"0FDE", x"0FDB", x"0FD9",
   x"0FD7", x"0FD4", x"0FD2", x"0FCF", x"0FCC", x"0FC9", x"1FC7", x"0FC4",
   x"0FC1", x"0FBE", x"0FBA", x"0FB7", x"0FB4", x"0FB0", x"0FAD", x"0FA9",
   x"0FA6", x"0FA2", x"0F9E", x"0F9B", x"1F97", x"0F93", x"0F8F", x"0F8B",
   x"0F86", x"0F82", x"0F7E", x"0F79", x"0F75", x"0F70", x"0F6C", x"0F67",
   x"0F62", x"0F5D", x"1F58", x"0F53", x"0F4E", x"0F49", x"0F44", x"0F3F",
   x"0F39", x"0F34", x"0F2F", x"0F29", x"0F23", x"0F1E", x"0F18", x"0F12",
   x"1F0C", x"0F06", x"0F00", x"0EFA", x"0EF4", x"0EEE", x"0EE8", x"0EE1",
   x"0EDB", x"0ED4", x"0ECE", x"0EC7", x"0EC0", x"0EBA", x"1EB3", x"0EAC",
   x"0EA5", x"0E9E", x"0E97", x"0E90", x"0E89", x"0E81", x"0E7A", x"0E73",
   x"0E6B", x"0E64", x"0E5C", x"0E54", x"1E4D", x"0E45", x"0E3D", x"0E35",
   x"0E2D", x"0E25", x"0E1D", x"0E15", x"0E0D", x"0E05", x"0DFC", x"0DF4",
   x"0DEC", x"0DE3", x"1DDB", x"0DD2", x"0DCA", x"0DC1", x"0DB8", x"0DAF",
   x"0DA6", x"0D9E", x"0D95", x"0D8C", x"0D82", x"0D79", x"0D70", x"0D67",
   x"1D5E", x"0D54", x"0D4B", x"0D42", x"0D38", x"0D2F", x"0D25", x"0D1B",
   x"0D12", x"0D08", x"0CFE", x"0CF4", x"0CEA", x"0CE0", x"1CD6", x"0CCC",
   x"0CC2", x"0CB8", x"0CAE", x"0CA4", x"0C9A", x"0C8F", x"0C85", x"0C7B",
   x"0C70", x"0C66", x"0C5B", x"0C51", x"0C46", x"0C3C", x"0C31", x"0C26",
   x"0C1B", x"0C11", x"0C06", x"0BFB", x"0BF0", x"0BE5", x"0BDA", x"0BCF",
   x"0BC4", x"0BB9", x"0BAE", x"0BA3", x"0B97", x"0B8C", x"0B81", x"0B76",
   x"0B6A", x"0B5F", x"0B53", x"0B48", x"0B3D", x"0B31", x"0B26", x"0B1A",
   x"0B0E", x"0B03", x"0AF7", x"0AEB", x"0AE0", x"0AD4", x"0AC8", x"0ABC",
   x"0AB1", x"0AA5", x"0A99", x"0A8D", x"0A81", x"0A75", x"0A69", x"0A5D",
   x"0A51", x"0A45", x"0A39", x"0A2D", x"0A21", x"0A15", x"0A09", x"09FD",
   x"09F0", x"09E4", x"09D8", x"09CC", x"09C0", x"09B3", x"09A7", x"099B",
   x"098E", x"0982", x"0976", x"0969", x"095D", x"0951", x"0944", x"0938",
   x"092B", x"091F", x"0912", x"0906", x"08FA", x"08ED", x"08E1", x"08D4",
   x"08C8", x"08BB", x"08AF", x"08A2", x"0896", x"0889", x"087D", x"0870",
   x"0863", x"0857", x"084A", x"083E", x"0831", x"0825", x"0818", x"080C",
   x"07FF", x"07F2", x"07E6", x"07D9", x"07CD", x"07C0", x"07B4", x"07A7",
   x"079B", x"078E", x"0781", x"0775", x"0768", x"075C", x"074F", x"0743",
   x"0736", x"072A", x"071D", x"0711", x"0704", x"06F8", x"06EC", x"06DF",
   x"06D3", x"06C6", x"06BA", x"06AD", x"06A1", x"0695", x"0688", x"067C",
   x"0670", x"0663", x"0657", x"064B", x"063E", x"0632", x"0626", x"061A",
   x"060E", x"0601", x"05F5", x"05E9", x"05DD", x"05D1", x"05C5", x"05B9",
   x"05AD", x"05A1", x"0595", x"0589", x"057D", x"0571", x"0565", x"0559",
   x"054D", x"0542", x"0536", x"052A", x"051E", x"0513", x"0507", x"04FB",
   x"04F0", x"04E4", x"04D8", x"04CD", x"04C1", x"04B6", x"04AB", x"049F",
   x"0494", x"0488", x"047D", x"0472", x"0467", x"045B", x"0450", x"0445",
   x"043A", x"042F", x"0424", x"0419", x"040E", x"0403", x"03F8", x"03ED",
   x"03E3", x"03D8", x"13CD", x"03C2", x"03B8", x"03AD", x"03A3", x"0398",
   x"038E", x"0383", x"0379", x"036F", x"0364", x"035A", x"0350", x"0346",
   x"133C", x"0332", x"0328", x"031E", x"0314", x"030A", x"0300", x"02F6",
   x"02EC", x"02E3", x"02D9", x"02CF", x"02C6", x"02BC", x"12B3", x"02AA",
   x"02A0", x"0297", x"028E", x"0285", x"027C", x"0272", x"0269", x"0260",
   x"0258", x"024F", x"0246", x"023D", x"1234", x"022C", x"0223", x"021B",
   x"0212", x"020A", x"0202", x"01F9", x"01F1", x"01E9", x"01E1", x"01D9",
   x"01D1", x"01C9", x"11C1", x"01B9", x"01B1", x"01AA", x"01A2", x"019A",
   x"0193", x"018B", x"0184", x"017D", x"0175", x"016E", x"0167", x"0160",
   x"1159", x"0152", x"014B", x"0144", x"013E", x"0137", x"0130", x"012A",
   x"0123", x"011D", x"0116", x"0110", x"010A", x"0104", x"10FE", x"00F8",
   x"00F2", x"00EC", x"00E6", x"00E0", x"00DB", x"00D5", x"00CF", x"00CA",
   x"00C5", x"00BF", x"00BA", x"00B5", x"10B0", x"00AB", x"00A6", x"00A1",
   x"009C", x"0097", x"0092", x"008E", x"0089", x"0085", x"0080", x"007C",
   x"0078", x"0073", x"106F", x"006B", x"0067", x"0063", x"0060", x"005C",
   x"0058", x"0055", x"0051", x"004E", x"004A", x"0047", x"0044", x"0040",
   x"103D", x"003A", x"0037", x"0035", x"0032", x"002F", x"002C", x"002A",
   x"0027", x"0025", x"0023", x"0020", x"001E", x"001C", x"101A", x"0018",
   x"0016", x"0014", x"0013", x"0011", x"000F", x"000E", x"000C", x"000B",
   x"000A", x"0009", x"0008", x"0007", x"1006", x"0005", x"0004", x"0003",
   x"0002", x"0002", x"0001", x"0001", x"0001", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"1000", x"0000", x"0001", x"0001", x"0001", x"0002",
   x"0002", x"0003", x"0004", x"0005", x"0006", x"0007", x"0008", x"0009",
   x"100A", x"000B", x"000C", x"000E", x"000F", x"0011", x"0013", x"0014",
   x"0016", x"0018", x"001A", x"001C", x"001E", x"0020", x"1023", x"0025",
   x"0027", x"002A", x"002C", x"002F", x"0032", x"0035", x"0037", x"003A",
   x"003D", x"0040", x"0044", x"0047", x"104A", x"004E", x"0051", x"0055",
   x"0058", x"005C", x"0060", x"0063", x"0067", x"006B", x"006F", x"0073",
   x"0078", x"007C", x"1080", x"0085", x"0089", x"008E", x"0092", x"0097",
   x"009C", x"00A1", x"00A6", x"00AB", x"00B0", x"00B5", x"00BA", x"00BF",
   x"10C5", x"00CA", x"00CF", x"00D5", x"00DB", x"00E0", x"00E6", x"00EC",
   x"00F2", x"00F8", x"00FE", x"0104", x"010A", x"0110", x"1116", x"011D",
   x"0123", x"012A", x"0130", x"0137", x"013E", x"0144", x"014B", x"0152",
   x"0159", x"0160", x"0167", x"016E", x"1175", x"017D", x"0184", x"018B",
   x"0193", x"019A", x"01A2", x"01AA", x"01B1", x"01B9", x"01C1", x"01C9",
   x"01D1", x"01D9", x"11E1", x"01E9", x"01F1", x"01F9", x"0202", x"020A",
   x"0212", x"021B", x"0223", x"022C", x"0234", x"023D", x"0246", x"024F",
   x"1258", x"0260", x"0269", x"0272", x"027C", x"0285", x"028E", x"0297",
   x"02A0", x"02AA", x"02B3", x"02BC", x"02C6", x"02CF", x"12D9", x"02E3",
   x"02EC", x"02F6", x"0300", x"030A", x"0314", x"031E", x"0328", x"0332",
   x"033C", x"0346", x"0350", x"035A", x"1364", x"036F", x"2379", x"0383",
   x"038E", x"0398", x"03A3", x"03AD", x"03B8", x"03C2", x"03CD", x"03D8",
   x"03E3", x"03ED", x"03F8", x"0403", x"040E", x"0419", x"0424", x"042F",
   x"043A", x"0445", x"0450", x"045B", x"0467", x"0472", x"047D", x"0488",
   x"0494", x"049F", x"04AB", x"04B6", x"04C1", x"04CD", x"04D8", x"04E4",
   x"04F0", x"04FB", x"0507", x"0513", x"051E", x"052A", x"0536", x"0542",
   x"054D", x"0559", x"0565", x"0571", x"057D", x"0589", x"0595", x"05A1",
   x"05AD", x"05B9", x"05C5", x"05D1", x"05DD", x"05E9", x"05F5", x"0601",
   x"060E", x"061A", x"0626", x"0632", x"063E", x"064B", x"0657", x"0663",
   x"0670", x"067C", x"0688", x"0695", x"06A1", x"06AD", x"06BA", x"06C6",
   x"06D3", x"06DF", x"06EC", x"06F8", x"0704", x"0711", x"071D", x"072A",
   x"0736", x"0743", x"074F", x"075C", x"0768", x"0775", x"0781", x"078E",
   x"079B", x"07A7", x"07B4", x"07C0", x"07CD", x"07D9", x"07E6", x"07F2"
);

signal daddra: std_logic_vector(9 downto 0);
signal daddrb: std_logic_vector(9 downto 0);

begin
   awaveram: process (clk)
   begin
      if (clk'event and clk = '1') then
         if (wea = '1') then
            RAM(conv_integer(addra)) <= dina;
         end if;
         daddra <= addra;
         daddrb <= addrb;
      end if; -- clk 
   end process;

   douta <= RAM(conv_integer(daddra));
   doutb <= RAM(conv_integer(daddrb));
end;
