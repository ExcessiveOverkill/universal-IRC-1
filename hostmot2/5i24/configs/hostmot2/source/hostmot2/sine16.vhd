library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Created from 16bitsin.bin
-- On 2/22/2010
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
entity sine16 is
	port (
	addr: in std_logic_vector(9 downto 0);
	clk: in std_logic;
	din: in std_logic_vector(15 downto 0);
	dout: out std_logic_vector(15 downto 0);
	we: in std_logic);
end sine16;

architecture syn of sine16 is
   type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
   signal RAM : ram_type := 
   (
   x"0000", x"00C9", x"0192", x"025B", x"0324", x"03ED", x"04B6", x"057F",
   x"0648", x"0711", x"07D9", x"08A2", x"096A", x"0A33", x"0AFB", x"0BC4",
   x"0C8C", x"0D54", x"0E1C", x"0EE3", x"0FAB", x"1072", x"113A", x"1201",
   x"12C8", x"138F", x"1455", x"151C", x"15E2", x"16A8", x"176E", x"1833",
   x"18F9", x"19BE", x"1A82", x"1B47", x"1C0B", x"1CCF", x"1D93", x"1E57",
   x"1F1A", x"1FDD", x"209F", x"2161", x"2223", x"22E5", x"23A6", x"2467",
   x"2528", x"25E8", x"26A8", x"2767", x"2826", x"28E5", x"29A3", x"2A61",
   x"2B1F", x"2BDC", x"2C99", x"2D55", x"2E11", x"2ECC", x"2F87", x"3041",
   x"30FB", x"31B5", x"326E", x"3326", x"33DF", x"3496", x"354D", x"3604",
   x"36BA", x"376F", x"3824", x"38D9", x"398C", x"3A40", x"3AF2", x"3BA5",
   x"3C56", x"3D07", x"3DB8", x"3E68", x"3F17", x"3FC5", x"4073", x"4121",
   x"41CE", x"427A", x"4325", x"43D0", x"447A", x"4524", x"45CD", x"4675",
   x"471C", x"47C3", x"4869", x"490F", x"49B4", x"4A58", x"4AFB", x"4B9D",
   x"4C3F", x"4CE0", x"4D81", x"4E20", x"4EBF", x"4F5D", x"4FFB", x"5097",
   x"5133", x"51CE", x"5268", x"5302", x"539B", x"5432", x"54C9", x"5560",
   x"55F5", x"568A", x"571D", x"57B0", x"5842", x"58D3", x"5964", x"59F3",
   x"5A82", x"5B0F", x"5B9C", x"5C28", x"5CB3", x"5D3E", x"5DC7", x"5E4F",
   x"5ED7", x"5F5D", x"5FE3", x"6068", x"60EB", x"616E", x"61F0", x"6271",
   x"62F1", x"6370", x"63EE", x"646C", x"64E8", x"6563", x"65DD", x"6656",
   x"66CF", x"6746", x"67BC", x"6832", x"68A6", x"6919", x"698B", x"69FD",
   x"6A6D", x"6ADC", x"6B4A", x"6BB7", x"6C23", x"6C8E", x"6CF8", x"6D61",
   x"6DC9", x"6E30", x"6E96", x"6EFB", x"6F5E", x"6FC1", x"7022", x"7083",
   x"70E2", x"7140", x"719D", x"71F9", x"7254", x"72AE", x"7307", x"735E",
   x"73B5", x"740A", x"745F", x"74B2", x"7504", x"7555", x"75A5", x"75F3",
   x"7641", x"768D", x"76D8", x"7722", x"776B", x"77B3", x"77FA", x"783F",
   x"7884", x"78C7", x"7909", x"794A", x"7989", x"79C8", x"7A05", x"7A41",
   x"7A7C", x"7AB6", x"7AEE", x"7B26", x"7B5C", x"7B91", x"7BC5", x"7BF8",
   x"7C29", x"7C59", x"7C88", x"7CB6", x"7CE3", x"7D0E", x"7D39", x"7D62",
   x"7D89", x"7DB0", x"7DD5", x"7DFA", x"7E1D", x"7E3E", x"7E5F", x"7E7E",
   x"7E9C", x"7EB9", x"7ED5", x"7EEF", x"7F09", x"7F21", x"7F37", x"7F4D",
   x"7F61", x"7F74", x"7F86", x"7F97", x"7FA6", x"7FB4", x"7FC1", x"7FCD",
   x"7FD8", x"7FE1", x"7FE9", x"7FF0", x"7FF5", x"7FF9", x"7FFD", x"7FFE",
   x"7FFF", x"7FFE", x"7FFD", x"7FF9", x"7FF5", x"7FF0", x"7FE9", x"7FE1",
   x"7FD8", x"7FCD", x"7FC1", x"7FB4", x"7FA6", x"7F97", x"7F86", x"7F74",
   x"7F61", x"7F4D", x"7F37", x"7F21", x"7F09", x"7EEF", x"7ED5", x"7EB9",
   x"7E9C", x"7E7E", x"7E5F", x"7E3E", x"7E1D", x"7DFA", x"7DD5", x"7DB0",
   x"7D89", x"7D62", x"7D39", x"7D0E", x"7CE3", x"7CB6", x"7C88", x"7C59",
   x"7C29", x"7BF8", x"7BC5", x"7B91", x"7B5C", x"7B26", x"7AEE", x"7AB6",
   x"7A7C", x"7A41", x"7A05", x"79C8", x"7989", x"794A", x"7909", x"78C7",
   x"7884", x"783F", x"77FA", x"77B3", x"776B", x"7722", x"76D8", x"768D",
   x"7641", x"75F3", x"75A5", x"7555", x"7504", x"74B2", x"745F", x"740A",
   x"73B5", x"735E", x"7307", x"72AE", x"7254", x"71F9", x"719D", x"7140",
   x"70E2", x"7083", x"7022", x"6FC1", x"6F5E", x"6EFB", x"6E96", x"6E30",
   x"6DC9", x"6D61", x"6CF8", x"6C8E", x"6C23", x"6BB7", x"6B4A", x"6ADC",
   x"6A6D", x"69FD", x"698B", x"6919", x"68A6", x"6832", x"67BC", x"6746",
   x"66CF", x"6656", x"65DD", x"6563", x"64E8", x"646C", x"63EE", x"6370",
   x"62F1", x"6271", x"61F0", x"616E", x"60EB", x"6068", x"5FE3", x"5F5D",
   x"5ED7", x"5E4F", x"5DC7", x"5D3E", x"5CB3", x"5C28", x"5B9C", x"5B0F",
   x"5A82", x"59F3", x"5964", x"58D3", x"5842", x"57B0", x"571D", x"568A",
   x"55F5", x"5560", x"54C9", x"5432", x"539B", x"5302", x"5268", x"51CE",
   x"5133", x"5097", x"4FFB", x"4F5D", x"4EBF", x"4E20", x"4D81", x"4CE0",
   x"4C3F", x"4B9D", x"4AFB", x"4A58", x"49B4", x"490F", x"4869", x"47C3",
   x"471C", x"4675", x"45CD", x"4524", x"447A", x"43D0", x"4325", x"427A",
   x"41CE", x"4121", x"4073", x"3FC5", x"3F17", x"3E68", x"3DB8", x"3D07",
   x"3C56", x"3BA5", x"3AF2", x"3A40", x"398C", x"38D9", x"3824", x"376F",
   x"36BA", x"3604", x"354D", x"3496", x"33DF", x"3326", x"326E", x"31B5",
   x"30FB", x"3041", x"2F87", x"2ECC", x"2E11", x"2D55", x"2C99", x"2BDC",
   x"2B1F", x"2A61", x"29A3", x"28E5", x"2826", x"2767", x"26A8", x"25E8",
   x"2528", x"2467", x"23A6", x"22E5", x"2223", x"2161", x"209F", x"1FDD",
   x"1F1A", x"1E57", x"1D93", x"1CCF", x"1C0B", x"1B47", x"1A82", x"19BE",
   x"18F9", x"1833", x"176E", x"16A8", x"15E2", x"151C", x"1455", x"138F",
   x"12C8", x"1201", x"113A", x"1072", x"0FAB", x"0EE3", x"0E1C", x"0D54",
   x"0C8C", x"0BC4", x"0AFB", x"0A33", x"096A", x"08A2", x"07D9", x"0711",
   x"0648", x"057F", x"04B6", x"03ED", x"0324", x"025B", x"0192", x"00C9",
   x"0000", x"FF37", x"FE6E", x"FDA5", x"FCDC", x"FC13", x"FB4A", x"FA81",
   x"F9B8", x"F8EF", x"F827", x"F75E", x"F696", x"F5CD", x"F505", x"F43C",
   x"F374", x"F2AC", x"F1E4", x"F11D", x"F055", x"EF8E", x"EEC6", x"EDFF",
   x"ED38", x"EC71", x"EBAB", x"EAE4", x"EA1E", x"E958", x"E892", x"E7CD",
   x"E707", x"E642", x"E57E", x"E4B9", x"E3F5", x"E331", x"E26D", x"E1A9",
   x"E0E6", x"E023", x"DF61", x"DE9F", x"DDDD", x"DD1B", x"DC5A", x"DB99",
   x"DAD8", x"DA18", x"D958", x"D899", x"D7DA", x"D71B", x"D65D", x"D59F",
   x"D4E1", x"D424", x"D367", x"D2AB", x"D1EF", x"D134", x"D079", x"CFBF",
   x"CF05", x"CE4B", x"CD92", x"CCDA", x"CC21", x"CB6A", x"CAB3", x"C9FC",
   x"C946", x"C891", x"C7DC", x"C727", x"C674", x"C5C0", x"C50E", x"C45B",
   x"C3AA", x"C2F9", x"C248", x"C198", x"C0E9", x"C03B", x"BF8D", x"BEDF",
   x"BE32", x"BD86", x"BCDB", x"BC30", x"BB86", x"BADC", x"BA33", x"B98B",
   x"B8E4", x"B83D", x"B797", x"B6F1", x"B64C", x"B5A8", x"B505", x"B463",
   x"B3C1", x"B320", x"B27F", x"B1E0", x"B141", x"B0A3", x"B005", x"AF69",
   x"AECD", x"AE32", x"AD98", x"ACFE", x"AC65", x"ABCE", x"AB37", x"AAA0",
   x"AA0B", x"A976", x"A8E3", x"A850", x"A7BE", x"A72D", x"A69C", x"A60D",
   x"A57E", x"A4F1", x"A464", x"A3D8", x"A34D", x"A2C2", x"A239", x"A1B1",
   x"A129", x"A0A3", x"A01D", x"9F98", x"9F15", x"9E92", x"9E10", x"9D8F",
   x"9D0F", x"9C90", x"9C12", x"9B94", x"9B18", x"9A9D", x"9A23", x"99AA",
   x"9931", x"98BA", x"9844", x"97CE", x"975A", x"96E7", x"9675", x"9603",
   x"9593", x"9524", x"94B6", x"9449", x"93DD", x"9372", x"9308", x"929F",
   x"9237", x"91D0", x"916A", x"9105", x"90A2", x"903F", x"8FDE", x"8F7D",
   x"8F1E", x"8EC0", x"8E63", x"8E07", x"8DAC", x"8D52", x"8CF9", x"8CA2",
   x"8C4B", x"8BF6", x"8BA1", x"8B4E", x"8AFC", x"8AAB", x"8A5B", x"8A0D",
   x"89BF", x"8973", x"8928", x"88DE", x"8895", x"884D", x"8806", x"87C1",
   x"877C", x"8739", x"86F7", x"86B6", x"8677", x"8638", x"85FB", x"85BF",
   x"8584", x"854A", x"8512", x"84DA", x"84A4", x"846F", x"843B", x"8408",
   x"83D7", x"83A7", x"8378", x"834A", x"831D", x"82F2", x"82C7", x"829E",
   x"8277", x"8250", x"822B", x"8206", x"81E3", x"81C2", x"81A1", x"8182",
   x"8164", x"8147", x"812B", x"8111", x"80F7", x"80DF", x"80C9", x"80B3",
   x"809F", x"808C", x"807A", x"8069", x"805A", x"804C", x"803F", x"8033",
   x"8028", x"801F", x"8017", x"8010", x"800B", x"8007", x"8003", x"8002",
   x"8001", x"8002", x"8003", x"8007", x"800B", x"8010", x"8017", x"801F",
   x"8028", x"8033", x"803F", x"804C", x"805A", x"8069", x"807A", x"808C",
   x"809F", x"80B3", x"80C9", x"80DF", x"80F7", x"8111", x"812B", x"8147",
   x"8164", x"8182", x"81A1", x"81C2", x"81E3", x"8206", x"822B", x"8250",
   x"8277", x"829E", x"82C7", x"82F2", x"831D", x"834A", x"8378", x"83A7",
   x"83D7", x"8408", x"843B", x"846F", x"84A4", x"84DA", x"8512", x"854A",
   x"8584", x"85BF", x"85FB", x"8638", x"8677", x"86B6", x"86F7", x"8739",
   x"877C", x"87C1", x"8806", x"884D", x"8895", x"88DE", x"8928", x"8973",
   x"89BF", x"8A0D", x"8A5B", x"8AAB", x"8AFC", x"8B4E", x"8BA1", x"8BF6",
   x"8C4B", x"8CA2", x"8CF9", x"8D52", x"8DAC", x"8E07", x"8E63", x"8EC0",
   x"8F1E", x"8F7D", x"8FDE", x"903F", x"90A2", x"9105", x"916A", x"91D0",
   x"9237", x"929F", x"9308", x"9372", x"93DD", x"9449", x"94B6", x"9524",
   x"9593", x"9603", x"9675", x"96E7", x"975A", x"97CE", x"9844", x"98BA",
   x"9931", x"99AA", x"9A23", x"9A9D", x"9B18", x"9B94", x"9C12", x"9C90",
   x"9D0F", x"9D8F", x"9E10", x"9E92", x"9F15", x"9F98", x"A01D", x"A0A3",
   x"A129", x"A1B1", x"A239", x"A2C2", x"A34D", x"A3D8", x"A464", x"A4F1",
   x"A57E", x"A60D", x"A69C", x"A72D", x"A7BE", x"A850", x"A8E3", x"A976",
   x"AA0B", x"AAA0", x"AB37", x"ABCE", x"AC65", x"ACFE", x"AD98", x"AE32",
   x"AECD", x"AF69", x"B005", x"B0A3", x"B141", x"B1E0", x"B27F", x"B320",
   x"B3C1", x"B463", x"B505", x"B5A8", x"B64C", x"B6F1", x"B797", x"B83D",
   x"B8E4", x"B98B", x"BA33", x"BADC", x"BB86", x"BC30", x"BCDB", x"BD86",
   x"BE32", x"BEDF", x"BF8D", x"C03B", x"C0E9", x"C198", x"C248", x"C2F9",
   x"C3AA", x"C45B", x"C50E", x"C5C0", x"C674", x"C727", x"C7DC", x"C891",
   x"C946", x"C9FC", x"CAB3", x"CB6A", x"CC21", x"CCDA", x"CD92", x"CE4B",
   x"CF05", x"CFBF", x"D079", x"D134", x"D1EF", x"D2AB", x"D367", x"D424",
   x"D4E1", x"D59F", x"D65D", x"D71B", x"D7DA", x"D899", x"D958", x"DA18",
   x"DAD8", x"DB99", x"DC5A", x"DD1B", x"DDDD", x"DE9F", x"DF61", x"E023",
   x"E0E6", x"E1A9", x"E26D", x"E331", x"E3F5", x"E4B9", x"E57E", x"E642",
   x"E707", x"E7CD", x"E892", x"E958", x"EA1E", x"EAE4", x"EBAB", x"EC71",
   x"ED38", x"EDFF", x"EEC6", x"EF8E", x"F055", x"F11D", x"F1E4", x"F2AC",
   x"F374", x"F43C", x"F505", x"F5CD", x"F696", x"F75E", x"F827", x"F8EF",
   x"F9B8", x"FA81", x"FB4A", x"FC13", x"FCDC", x"FDA5", x"FE6E", x"FF37"
);

signal daddr: std_logic_vector(9 downto 0);

begin
   asine16: process (clk)
   begin
      if (clk'event and clk = '1') then
         if (we = '1') then
            RAM(conv_integer(addr)) <= din;
         end if;
         daddr <= addr;
      end if; -- clk 
   end process;

   dout <= RAM(conv_integer(daddr));
end;
