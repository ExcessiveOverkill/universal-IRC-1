
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity dmdrqlogic is
	generic (
				ndrqs : integer );
    port ( 	clk : in  std_logic;
				ibus : in  std_logic_vector (31 downto 0);
				obus : out  std_logic_vector (31 downto 0);
				loadmode : in  std_logic;
				readmode : in  std_logic;
				drqsources : in  std_logic_vector (ndrqs-1 downto 0);
				dreqout : out  std_logic;
				demandmode : out  std_logic);
end dmdrqlogic;

architecture Behavioral of dmdrqlogic is
constant zeromask: std_logic_vector (ndrqs-1 downto 0) := (others => '0');
signal modereg: std_logic_vector (31 downto 0);
alias mask: std_logic_vector (ndrqs-1 downto 0) is modereg(ndrqs+15 downto 16);	-- 16 max
alias enable: std_logic is modereg(0);
signal drq: std_logic; 
begin
	admdrq: process(clk,drqsources,readmode,mask, modereg)
	begin
		if rising_edge(clk) then
			if loadmode = '1' then
				modereg <= ibus;
			end if;
		end if;
		if (mask and drqsources) /= 0 then
			drq <= enable;
		else
			drq <= '0';
		end if;	
		demandmode <= enable;
		obus <= (others => 'Z');
		if readmode = '1' then
			obus(31 downto 16) <= modereg(31 downto 16);
			obus(0) <= modereg(0);
			obus(1) <= drq;
			obus(15 downto 2) <= (others => '0');
		end if;	
		dreqout <= drq;
	end process;				
end Behavioral;

