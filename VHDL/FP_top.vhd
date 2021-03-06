library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity floating_point_top is
port (	
		A: 		in std_logic_vector(31 downto 0);
		B:  	in std_logic_vector(31 downto 0);
		sel: 	in std_logic;
		C:     out std_logic_vector(31 downto 0));
end floating_point_top;

architecture FP_arch of floating_point_top is
component floating_point_adder is
port (	
		A: 		in std_logic_vector(31 downto 0);
		B:  	in std_logic_vector(31 downto 0);
		C:     out std_logic_vector(31 downto 0));
end component;

component floating_point_mul is
port (	
		A: 		in std_logic_vector(31 downto 0);
		B:  	in std_logic_vector(31 downto 0);
		C:     out std_logic_vector(31 downto 0));
end component;


signal A_in: std_logic_vector(31 downto 0);
signal B_in: std_logic_vector(31 downto 0);
signal C_add: std_logic_vector(31 downto 0);
signal C_mul: std_logic_vector(31 downto 0);

begin
A_in <= A;
B_in <= B;

C <= C_mul when sel = '1' else C_add;
-- FP OPS: 	0 - ADD
--			1 - MUL
MULT: 	floating_point_mul port map (A_in, B_in, C_mul);
ADDER: 	floating_point_adder port map (A_in, B_in, C_add);


end FP_arch;