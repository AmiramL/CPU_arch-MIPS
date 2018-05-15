-- ====================================================================
--
--	File Name:		GPIO.vhd
--	Description:	MIPS Memory & Memory Mapped IO
--					
--
--	Date:			11/05/2018
--	Designers:		Amiram Lifshitz & Amit Biran
--		
-- ====================================================================	
		--  GPIO module (implements the  Memory 
		--  Mapped IO for the MIPS computer)


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY gpio IS
	PORT(	LEDR				: OUT 	STD_LOGIC_VECTOR( 9 downto 0 );
			LEDG				: OUT 	STD_LOGIC_VECTOR( 7 downto 0 );
			Seven_Seg0:			: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg1:			: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg2:			: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg3:			: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			SW:					: IN 	STD_LOGIC_VECTOR( 9 downto 0 );
			KEY:				: IN 	STD_LOGIC_VECTOR( 3 downto 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC );
END gpio;

ARCHITECTURE behavior OF gpio IS
SIGNAL write_clock 		: STD_LOGIC;
SIGNAL the_one			: STD_LOGIC;
SIGNAL buttons_switches : STD_LOGIC_VECTOR ( 31 downto 0 );
signal leds_map			: STD_LOGIC_VECTOR ( 31 downto 0 );

BEGIN
	the_one <= '1';
	
	KEY  <= buttons_switches( 3  DOWNTO 0 );
	SW   <= buttons_switches( 17 DOWNTO 8 );
	LEDG <= leds_map(  7 DOWNTO 0 );
	LEDR <= leds_map( 17 DOWNTO 0 );
	
	PUSH_BUTTONS_AND_SWITCHES : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => 1,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => not the_one,
		rden_a => the_one,
		clock0 => write_clock,
		address_a => address,
		q_a => buttons_switches	);
	
	LEDS_MEM : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => 1,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => the_one,
		rden_a => the_one,
		clock0 => write_clock,
		address_a => address,
		q_a => leds_map	);
		
	SEVEN_SEG_MEM : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => 1,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => the_one,
		rden_a => the_one,
		clock0 => write_clock,
		address_a => address,
		q_a => LEDS	);
-- Load memory address register with write clock
		write_clock <= NOT clock;
END behavior;