library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nbit_SHIFT1 is --shift one bit Left/Right
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		Right_Left: in std_logic;
		En:		 	in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end Nbit_SHIFT1;

architecture SHIFT1_arch_behavioral of Nbit_SHIFT1 is
begin	
				--Right_Left = 1 => shift Right
				--Right_Left = 0 => shift Left
		process (Right_Left, En, a)
		begin
			if En = '1' then
				if Right_Left = '1' then
					o(N-1) <= '0';
					o(N-2 downto 0) <= a(N-1 downto 1);
				else
					o(0) <= '0';
					o(N-1 downto 1) <= a(N-2 downto 0);
				end if;
			else
				o <= a;
			end if;
		end process;
end SHIFT1_arch_behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nbit_SHIFT2 is --shift one bit Left/Right
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		Right_Left: in std_logic;
		En:		 	in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end Nbit_SHIFT2;

architecture SHIFT2_arch_behavioral of Nbit_SHIFT2 is
begin	
				--Right_Left = 1 => shift Right
				--Right_Left = 0 => shift Left
		process (Right_Left, En, a)
		begin
			if En = '1' then
				if Right_Left = '1' then
					o(N-1 downto N-2) <= "00";
					o(N-3 downto 0) <= a(N-1 downto 2);
				else
					o(1 downto 0) <= "00";
					o(N-1 downto 2) <= a(N-3 downto 0);
				end if;
			else
				o <= a;
			end if;
		end process;
end SHIFT2_arch_behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nbit_SHIFT4 is --shift one bit Left/Right
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		Right_Left: in std_logic;
		En:		 	in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end Nbit_SHIFT4;

architecture SHIFT4_arch_behavioral of Nbit_SHIFT4 is
begin	
				--Right_Left = 1 => shift Right
				--Right_Left = 0 => shift Left
		process (Right_Left, En, a)
		begin
			if En = '1' then
				if Right_Left = '1' then
					o(N-1 downto N-4) <= X"0";
					o(N-5 downto 0) <= a(N-1 downto 4);
				else
					o(3 downto 0) <= X"0";
					o(N-1 downto 4) <= a(N-5 downto 0);
				end if;
			else
				o <= a;
			end if;
		end process;
end SHIFT4_arch_behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nbit_SHIFT8 is --shift one bit Left/Right
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		Right_Left: in std_logic;
		En:		 	in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end Nbit_SHIFT8;

architecture SHIFT8_arch_behavioral of Nbit_SHIFT8 is
begin	
				--Right_Left = 1 => shift Right
				--Right_Left = 0 => shift Left
		process (Right_Left, En, a)
		begin
			if En = '1' then
				if N > 8 then
					if Right_Left = '1' then
						o(N-1 downto N-8) <= X"00";
						o(N-9 downto 0) <= a(N-1 downto 8);
					else
						o(7 downto 0) <= X"00";
						o(N-1 downto 8) <= a(N-9 downto 0);
					end if;
				else
					o <= (others => '0');
				end if;
			else
				o <= a;
			end if;
		end process;
end SHIFT8_arch_behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nbit_SHIFT16 is --shift one bit Left/Right
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		Right_Left: in std_logic;
		En:		 	in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end Nbit_SHIFT16;

architecture SHIFT16_arch_behavioral of Nbit_SHIFT16 is
begin	
				--Right_Left = 1 => shift Right
				--Right_Left = 0 => shift Left
		process (Right_Left, En, a)
		begin
			if En = '1' then
				if N > 16 then
					if Right_Left = '1' then
						o(N-1 downto N-16) <= X"0000";
						o(N-17 downto 0) <= a(N-1 downto 16);
					else
						o(15 downto 0) <= X"0000";
						o(N-1 downto 16) <= a(N-17 downto 0);
					end if;
				else
					o <= (others => '0');
				end if;
			else
				o <= a;
			end if;
		end process;
end SHIFT16_arch_behavioral;