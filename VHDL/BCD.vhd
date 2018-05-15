library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BCD is
port ( 	Binary: 	in  std_logic_vector(3 downto 0);
		En:			in  std_logic;
		Hex_out:	out std_logic_vector(6 downto 0));
end BCD;


architecture BCD_arch of BCD is

signal Hex: std_logic_vector(6 downto 0);

begin
	Hex_out <= not Hex;
	Bin_to_Hex: process(Binary,En)
	begin
		if En = '1' then
			case Binary is
				when X"0" => Hex <= "0111111";
				when X"1" => Hex <= "0000110";
				when X"2" => Hex <= "1011011";
				when X"3" => Hex <= "1001111";
				when X"4" => Hex <= "1100110";
				when X"5" => Hex <= "1101101";
				when X"6" => Hex <= "1111101";
				when X"7" => Hex <= "0000111";
				when X"8" => Hex <= "1111111";
				when X"9" => Hex <= "1101111";
				when X"A" => Hex <= "1110111";
				when X"B" => Hex <= "1111100";
				when X"C" => Hex <= "0111001";
				when X"D" => Hex <= "1011110";
				when X"E" => Hex <= "1111001";
				when X"F" => Hex <= "1110001";
				when others => Hex <= "0000000";
			end case;
		else
			Hex <= "0000000";
		end if;
	end process Bin_to_Hex;
end BCD_arch;