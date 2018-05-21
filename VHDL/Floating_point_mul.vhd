library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

entity floating_point_mul is
port (	
		A: 		in std_logic_vector(31 downto 0);
		B:  	in std_logic_vector(31 downto 0);
		C:     out std_logic_vector(31 downto 0));
end floating_point_mul;

architecture FP_mul of floating_point_mul is

component Nbit_add_sub is 
generic ( N: integer := 8);
port( 	a: in std_logic_vector(2*N-1 downto 0);
			b: in std_logic_vector(2*N-1 downto 0);
			sub: in std_logic;
			res: out std_logic_vector(2*N-1 downto 0)
		); 
end component;

component Nbit_SHIFT 
	generic (N: integer :=8);
	port(
		a: 				in std_logic_vector(N-1 downto 0);  
		Right_Left, En: in std_logic;
		o: 				out std_logic_vector(N-1 downto 0));
end component;



signal zeros: std_logic_vector(9 downto 0);
signal A_man: std_logic_vector(23 downto 0 );
signal B_man: std_logic_vector(23 downto 0 );
signal mantisa2norm: std_logic_vector (47 downto 0 );
signal the_zero: std_logic;


signal A_exp: std_logic_vector(8 downto 0 );
signal B_exp: std_logic_vector(8 downto 0 );





begin


	A_man(22 downto 0) <= A(22 downto 0);
	A_man(23) <= '1';
	B_man(22 downto 0) <= B(22 downto 0);
	B_man(23) <= '1';
	A_exp(7 downto 0) <= A(30 downto 23);
	A_exp(8) <= '0';
	B_exp(7 downto 0) <= B(30 downto 23);
	B_exp(8) <= '0';
	
	
	
	
	process(A,B, A_exp, B_exp, mantisa2norm, A_man, B_man)
	begin
	C(31) <= A(31) XOR B(31);
	mantisa2norm <= conv_std_logic_vector((unsigned(A_man) * unsigned(B_man)),48);
	if (conv_integer(unsigned(A_exp) + unsigned(B_exp))) < 128 then --enderflow
			if conv_integer(unsigned(A_exp) + unsigned(B_exp)) = 127 then
				C(30 downto 23) <= X"00";
				C(22 downto 0) <= mantisa2norm(47 downto 25);
			else
				C(30 downto 0) <= (others => '0');
			end if;
	elsif (conv_integer(unsigned(A_exp) + unsigned(B_exp))) > 381 then --overflow
		C(30 downto 0) <= (others => '1');
	else
		if mantisa2norm(47) = '1' then
			C(30 downto 23) <= conv_std_logic_vector(unsigned(A_exp) + unsigned(B_exp) - 126, 8);
			C(22 downto 0) <= mantisa2norm(46 downto 24);
		else 
			C(30 downto 23) <= conv_std_logic_vector(unsigned(A_exp) + unsigned(B_exp) - 127, 8);
			C(22 downto 0) <= mantisa2norm(45 downto 23);
			end if;
	end if;
	end process;
end FP_mul; 
		
	