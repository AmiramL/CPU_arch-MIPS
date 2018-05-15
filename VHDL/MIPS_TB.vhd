library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE IEEE.std_logic_arith.ALL;

entity TB_MIPS is
end TB_MIPS;

architecture test of TB_MIPS is

signal clock:		std_logic;
signal reset:       std_logic;
signal LEDR,SW:     std_logic_vector( 9 downto 0);
signal LEDG:      	std_logic_vector( 7 downto 0);
signal KEY:      	std_logic_vector( 3 downto 0);
signal Seven_Seg0,Seven_Seg1,Seven_Seg2,Seven_Seg3 : std_logic_vector( 6 downto 0);

signal		PC								: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
signal 		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
			Instruction_out					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
signal 		Branch_out, Zero_out, Memwrite_out, 
signal 		Regwrite_out					: STD_LOGIC;





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

	DELAY_REG_DUT: entity work.MIPS
		port map(	
			reset, clk,
			LEDR, LEDG,
			Seven_Seg0, Seven_Seg1, Seven_Seg2, Seven_Seg3, SW, KEY,
			PC, ALU_result_out, read_data_1_out, read_data_2_out, write_data_out, Instruction_out,
			Branch_out, Zero_out, Memwrite_out, Regwrite_out
			);
		

		
	simulation : process 
	begin
	
		
	wait;
	end process simulation;		
		
end test;