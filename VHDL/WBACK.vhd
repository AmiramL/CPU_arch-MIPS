-- ====================================================================
--
--	File Name:		WBACK.vhd
--	Description:	Write back stage of pipeline
--					
--
--	Date:			11/05/2018
--	Editors:		Amiram Lifshitz & Amit Biran
--		
-- ====================================================================	

		
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY WBACK IS
	port ( 	ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemtoReg 	: IN 	STD_LOGIC );
END WBACK;

ARCHITECTURE behavior OF WBACK IS

BEGIN
						-- Mux to bypass data memory for Rformat instructions
	write_data <= ALU_result( 31 DOWNTO 0 ) 
			WHEN ( MemtoReg = '0' ) 	ELSE read_data;

END behavior;
			