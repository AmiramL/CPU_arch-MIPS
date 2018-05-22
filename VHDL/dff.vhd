library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE iEEE.std_logic_arith.ALL;

entity dffi is
port (	
		d: 	  		in std_logic;
		clk:		in std_logic;
		rst:		in std_logic;
		q: 			out std_logic);
end dffi;

architecture dff_behavioral of dffi is

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				q <= '0';
			else 
				q <= d;
			end if;
		end if;
	end process;	
end dff_behavioral;