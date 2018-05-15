library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ndff is
generic ( N: integer := 8);
port (	
		d: 	  		in std_logic_vector(N-1 downto 0);
		clk:		in std_logic;
		rst:		in std_logic;
		q: 			out std_logic_vector(N-1 downto 0));
end Ndff;

architecture Ndff_struct of Ndff is
component dffi 
	port(
		d,clk,rst: 		in std_logic;  
		q: 				out std_logic);
end component;
signal reset: std_logic;
begin
	reset <= rst;
	REG_GEN: for i in 0 to N-1 generate
	DFFx: dffi port map (d(i), clk, reset, q(i));
	end generate REG_GEN;
end Ndff_struct;
