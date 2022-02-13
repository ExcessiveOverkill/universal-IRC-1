library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Created from twid.bin
-- On  8/28/2014

entity twidrom is
	port (
	addra: in std_logic_vector(9 downto 0);
	addrb: in std_logic_vector(9 downto 0);
	clk: in std_logic;
	dina: in std_logic_vector(15 downto 0);
	douta: out std_logic_vector(15 downto 0);
	doutb: out std_logic_vector(15 downto 0);
	wea: in std_logic);
end twidrom;

architecture syn of twidrom is
   type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
   signal RAM : ram_type := 
   (
   x"0000", x"0000", x"0000", x"6026", x"01AA", x"B002", x"7003", x"200B",
   x"0000", x"0000", x"101F", x"B003", x"7001", x"B093", x"0980", x"A08F",
   x"301F", x"7000", x"0900", x"B000", x"7094", x"C081", x"B094", x"7093",
   x"A091", x"301D", x"7002", x"B580", x"101F", x"7580", x"B002", x"6021",
   x"1006", x"7022", x"B060", x"7023", x"B061", x"1800", x"0100", x"B080",
   x"B094", x"B000", x"01FF", x"B082", x"0101", x"B081", x"B08A", x"0102",
   x"B08B", x"0104", x"B08C", x"0108", x"B08D", x"0110", x"B08E", x"0120",
   x"B08F", x"0140", x"B090", x"0180", x"B091", x"1800", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
   x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"ABCD"
);

signal daddra: std_logic_vector(9 downto 0);
signal daddrb: std_logic_vector(9 downto 0);

begin
   atwidrom: process (clk)
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