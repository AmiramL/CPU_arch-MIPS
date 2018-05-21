library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nbit_mux2 is 
generic ( N: integer := 8);
port (	i_0: in std_logic_vector(N-1 downto 0); 
		i_1: in std_logic_vector(N-1 downto 0); 
		s: in std_logic; 
		o: out std_logic_vector(N-1 downto 0));
end Nbit_mux2;

architecture Nbit_mux_behavioral of Nbit_mux2 is 
begin
	 o <= i_0 when s = '0' else i_1;
end Nbit_mux_behavioral;
