library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ndff_en is
generic ( N: integer := 8);
port (	
		d: 	  		in std_logic_vector(N-1 downto 0);
		clk:		in std_logic;
		en:			in std_logic;
		rst:		in std_logic;
		q: 			out std_logic_vector(N-1 downto 0));
end Ndff_en;

architecture Ndff_struct of Ndff_en is
component dff_en 
	port(
		d,clk,en,rst: 		in std_logic;  
		q: 				out std_logic);
end component;
signal reset: std_logic;
begin
	reset <= rst;
	REG_GEN: for i in 0 to N-1 generate
	DFFx: dff_en port map (d(i), clk, en, reset, q(i));
	end generate REG_GEN;
end Ndff_struct;