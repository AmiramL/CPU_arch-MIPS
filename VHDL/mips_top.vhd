LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;




entity mips_top is
port( 	reset, clock					: IN 	STD_LOGIC; 
			LEDR						: OUT 	STD_LOGIC_VECTOR( 9 downto 0 );
			LEDG						: OUT 	STD_LOGIC_VECTOR( 7 downto 0 );
			Seven_Seg0					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg1					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg2					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg3					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			SW							: IN 	STD_LOGIC_VECTOR( 8 downto 0 );
			KEY							: IN 	STD_LOGIC_VECTOR( 3 downto 0 ));
end mips_top;


ARCHITECTURE struct OF mips_top IS


signal clock_mips : STD_LOGIC;





      COMPONENT MIPS
   PORT (
			reset, clock				: IN 	STD_LOGIC; 
			LEDR						: OUT 	STD_LOGIC_VECTOR( 9 downto 0 );
			LEDG						: OUT 	STD_LOGIC_VECTOR( 7 downto 0 );
			Seven_Seg0					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg1					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg2					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg3					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			SW							: IN 	STD_LOGIC_VECTOR( 8 downto 0 );
			KEY							: IN 	STD_LOGIC_VECTOR( 3 downto 0 ) );
			
   END COMPONENT;
	  
	  	COMPONENT pll is
	port(
	inclk0:	IN STD_LOGIC :='0';
			c0 : OUT STD_LOGIC
	);
	end COMPONENT;
	
	begin
	
	
	
	pll1:pll
	port map(
		inclk0 => clock,
		c0 =>clock_mips
	);
	
	  U_0 : MIPS
      PORT MAP (
         reset           => reset,
         clock           => clock_mips,
          LEDR			 => LEDR,
          LEDG	 => LEDG,
          Seven_Seg0 => Seven_Seg0,
          Seven_Seg1 => Seven_Seg1,
          Seven_Seg2 => Seven_Seg2,
          Seven_Seg3 => Seven_Seg3,
          SW	 => SW,
          KEY	 => KEY
      );
	  end struct;

