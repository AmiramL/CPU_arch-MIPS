library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE IEEE.std_logic_arith.ALL;

entity TB_DELAY is
end TB_DELAY;

architecture test of TB_DELAY is

signal clk:			std_logic;
signal data_in:      std_logic_vector( 1 downto 1);
signal data_out:     std_logic_vector( 1 downto 1);
signal data_out2:     std_logic_vector( 1 downto 1);
signal data_out3:     std_logic_vector( 1 downto 1);
signal reset:        std_logic;


begin


CLK_PROCESS: process
begin
	clk <= '0';
while (0 = 0) loop
  wait for 5 ns;
	clk <= '1';
	wait for 3 ns;
	clk <= '0';
end loop;
end process;

DELAY_REG_DUT: entity work.DELAY_REG
	generic map (1,2)
	port map(	
		reset,clk,data_in,data_out
		);
		
DELAY_REG_DUT2: entity work.DELAY_REG
	generic map (1,3)
	port map(	
		reset,clk,data_in,data_out2
		);
DELAY_REG_DUT3: entity work.DELAY_REG
	generic map (1,1)
	port map(	
		reset,clk,data_in,data_out3
		);
		
simulation : process 
begin
data_in <= "0";
reset <= '1';
wait for 2 ns;
reset <= '0';
data_in <= "1";
wait;
end process simulation;		
		
		end test;