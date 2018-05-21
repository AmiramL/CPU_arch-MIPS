library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

entity SHIFT_top is 
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);
		cnt:		in std_logic_vector(5 downto 0);
		Right_Left: in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end SHIFT_top;

architecture SHIFT_top_arch of SHIFT_top is
component Nbit_SHIFT1 
	generic (N: integer :=8);
	port(
		a: 				in std_logic_vector(N-1 downto 0);  
		Right_Left, En: in std_logic;
		o: 				out std_logic_vector(N-1 downto 0));
end component;
component Nbit_SHIFT2 
	generic (N: integer :=8);
	port(
		a: 				in std_logic_vector(N-1 downto 0);  
		Right_Left, En: in std_logic;
		o: 				out std_logic_vector(N-1 downto 0));
end component;
component Nbit_SHIFT4 
	generic (N: integer :=8);
	port(
		a: 				in std_logic_vector(N-1 downto 0);  
		Right_Left, En: in std_logic;
		o: 				out std_logic_vector(N-1 downto 0));
end component;
component Nbit_SHIFT8 
	generic (N: integer :=8);
	port(
		a: 				in std_logic_vector(N-1 downto 0);  
		Right_Left, En: in std_logic;
		o: 				out std_logic_vector(N-1 downto 0));
end component;
component Nbit_SHIFT16 
	generic (N: integer :=8);
	port(
		a: 				in std_logic_vector(N-1 downto 0);  
		Right_Left, En: in std_logic;
		o: 				out std_logic_vector(N-1 downto 0));
end component;

signal wires0: 	std_logic_vector(N-1 downto 0);
signal wires1: 	std_logic_vector(N-1 downto 0);
signal wires2: 	std_logic_vector(N-1 downto 0);
signal wires3: 	std_logic_vector(N-1 downto 0);
signal wires4: 	std_logic_vector(N-1 downto 0) := (others => '0');

begin
	
	

	BIT0: Nbit_SHIFT1 
	      generic map (N)
	      port map (a, Right_Left, cnt(0), wires0);

	
	BIT1: Nbit_SHIFT2
	      generic map (N)
	      port map ( wires0, Right_Left, cnt(1), wires1 );

	
	BIT2: Nbit_SHIFT4 
			  generic map (N)
			  port map ( wires1, Right_Left, cnt(2), wires2);
	
	BIT3: Nbit_SHIFT8 
			  generic map (N)
			  port map ( wires2, Right_Left, cnt(3), wires3);
	
				

		
	process(wires3, cnt)
	begin
	if cnt(5) = '1' or cnt(4) = '1' then
		o <= (others => '0');
	elsif N <= 16 then
		o <= wires3;
	end if;
	end process;
			
end SHIFT_top_arch;	
		
		
			