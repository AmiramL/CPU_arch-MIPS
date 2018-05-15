-- ====================================================================
--
--	File Name:		DELAY_REG.vhd
--	Description:	registers to delay signals for pipeline
--					
--
--	Date:			11/05/2018
--	Editors:		Amiram Lifshitz & Amit Biran
--		
-- ====================================================================	

		
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY DELAY_REG IS
	generic ( 	N : integer := 1; 	-- Bus width
				M : integer := 1 );	-- Nuber of cycles to delay >= 2
	PORT( 	reset, clock				: IN 	STD_LOGIC; 
			data_in					: IN 	STD_LOGIC_VECTOR( N-1 downto 0 );
			data_out					: OUT 	STD_LOGIC_VECTOR( N-1 downto 0 ) );

END DELAY_REG;

architecture behave of DELAY_REG is
	
	COMPONENT Ndff
		 GENERIC ( N: integer := 8);
		 PORT (	d					: in std_logic_vector(N-1 downto 0);
				clk					: in std_logic;
				rst					: in std_logic;
				q					: out std_logic_vector(N-1 downto 0) );
	END COMPONENT;
	
	signal middle: std_logic_vector ( (M)*N - 1 downto 0 );

	
	
	begin
	
	data_out <= middle( (M) * N - 1 downto (M-1) * N );
	REG_ARRAY: for i in 0 to M-1 generate
	
		first: if i = 0 generate
			REG0: Ndff
					generic map (N)
					port map ( 	d  	=> data_in,
								clk => clock,
								rst => reset,
								q	=> middle(N-1 downto 0) );
		end generate first;
		
		rest: if i > 0 generate
			REGi: Ndff
					generic map (N)
					port map ( 	d  	=> middle( i*N-1 downto (i-1)*N ),
								clk => clock,
								rst => reset,
								q	=> middle( (i+1)*N-1 downto (i)*N) );
		end generate rest;

	end generate REG_ARRAY;

end behave;
	
	
	
	
	
	