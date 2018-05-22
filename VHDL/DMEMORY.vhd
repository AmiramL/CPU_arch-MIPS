-- ====================================================================
--
--	File Name:		DMEMORY.vhd
--	Description:	MIPS Memory & Memory Mapped IO
--					
--
--	Date:			11/05/2018
--	Designers:		Amiram Lifshitz & Amit Biran
--		
-- ====================================================================	
		--  GPIO module (implements the  Memory 
		--  Mapped IO for the MIPS computer)
		--  Dmemory module (implements the data
		--  memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( 8 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
			LEDR				: OUT 	STD_LOGIC_VECTOR( 9 downto 0 );
			LEDG				: OUT 	STD_LOGIC_VECTOR( 7 downto 0 );
			Seven_Seg			: OUT 	STD_LOGIC_VECTOR( 15 downto 0 );
			SW					: IN 	STD_LOGIC_VECTOR( 8 downto 0 );
			KEY					: IN 	STD_LOGIC_VECTOR( 3 downto 0 );
            clock,reset			: IN 	STD_LOGIC );
END dmemory;

ARCHITECTURE behavior OF dmemory IS

COMPONENT Ndff_en 
generic ( N: integer := 8);
port (	
		d: 	  		in std_logic_vector(N-1 downto 0);
		clk:		in std_logic;
		en:			in std_logic;
		rst:		in std_logic;
		q: 			out std_logic_vector(N-1 downto 0));
end COMPONENT;



SIGNAL write_clock : STD_LOGIC;

SIGNAL the_one,ssg_en,led_en,memwrite_en : STD_LOGIC;

SIGNAL buttons_switches : STD_LOGIC_VECTOR ( 16 downto 0 );
SIGNAL buttons_data		: STD_LOGIC_VECTOR ( 16 downto 0 );
signal LEDS_MAP 		: STD_LOGIC_VECTOR ( 17 downto 0 );
SIGNAL SEVEN_SEG_MAP	: STD_LOGIC_VECTOR ( 15 downto 0 );
SIGNAL mem_read_data	: STD_LOGIC_VECTOR ( 31 downto 0 );

SIGNAL KEY_in					: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL SW_in					: STD_LOGIC_VECTOR( 8 DOWNTO 0 );
SIGNAL ssg0_out					: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
SIGNAL ssg1_out					: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
SIGNAL ssg2_out					: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
SIGNAL ssg3_out					: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
SIGNAL LEDG_out					: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL LEDR_out					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );


BEGIN
	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => 8,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "../CODE/dmemory.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => memwrite_en,
		clock0 => write_clock,
		address_a => address(7 downto 0),
		data_a => write_data,
		q_a => mem_read_data	);
		
	
	the_one  <= '1';
	
	Seven_Seg <= SEVEN_SEG_MAP;

    LEDG	   <= LEDG_out;
    LEDR	   <= LEDR_out;
    KEY_in 	   <= KEY;
    SW_in 	   <= SW;
	
	buttons_switches( 3  DOWNTO 0 ) <= KEY_in ;
	buttons_switches( 7  DOWNTO 4 ) <= (others => '0') ;
	buttons_switches( 16 DOWNTO 8 ) <= SW_in ;
	
	LEDG_out <= LEDS_MAP(  7 DOWNTO 0 );
	LEDR_out <= LEDS_MAP( 17 DOWNTO 8 );
	
	
	
	LEDREG: Ndff_en
			generic map ( 18 )
			port map(	d 	 => write_data( 17 downto 0 ),
						clk	 => write_clock,
						en	 => led_en,
						rst  => reset,
						q 	 => LEDS_MAP );
			
	SSG_REG: Ndff_en
			generic map ( 16 )
			port map(	d 	 => write_data( 15 downto 0 ),
						clk	 => write_clock,
						en	 => ssg_en,
						rst  => reset,
						q 	 => SEVEN_SEG_MAP );
	

	BUTTONS_REG: Ndff_en
			generic map ( 17 )
			port map(	d 	 => buttons_switches,
						clk	 => write_clock,
						en	 => the_one,
						rst  => reset,
						q 	 => buttons_data );

		
		
		-- Load memory address register with write clock.
		write_clock <= NOT clock;
		
	
	
	memwrite_en <= Memwrite when address(8) = '0' else '0';
	ssg_en <= Memwrite when address = B"1" & X"00" else '0';
	led_en <= Memwrite when address = B"1" & X"01" else '0';
	read_data <= mem_read_data when address(8) = '0' else
				 X"0000" & SEVEN_SEG_MAP   		when address =  B"1" & X"00" else
				 X"000" & B"00" & LEDS_MAP 		when address = B"1" & X"01"  else
				 X"000" & B"000" & buttons_data when address = B"1" & X"02"  else
				 X"00000000";
				 
				 


	
END behavior;

