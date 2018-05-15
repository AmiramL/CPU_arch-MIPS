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
			Seven_Seg0			: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg1  		: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg2			: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg3			: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			SW					: IN 	STD_LOGIC_VECTOR( 9 downto 0 );
			KEY					: IN 	STD_LOGIC_VECTOR( 3 downto 0 );
            clock,reset			: IN 	STD_LOGIC );
END dmemory;

ARCHITECTURE behavior OF dmemory IS

COMPONENT BCD 
port ( 	Binary: 	in  std_logic_vector(3 downto 0);
		En:			in  std_logic;
		Hex_out:	out std_logic_vector(6 downto 0));
end COMPONENT;

SIGNAL write_clock : STD_LOGIC;

SIGNAL the_one,the_zero,ssg_en,led_en,buttons_switches_en,memwrite_en : STD_LOGIC;
SIGNAL the_one_add	:	STD_LOGIC_VECTOR ( 0 downto 0 );

SIGNAL buttons_switches : STD_LOGIC_VECTOR ( 31 downto 0 );
signal LEDS_MAP 		: STD_LOGIC_VECTOR ( 31 downto 0 );
SIGNAL SEVEN_SEG_MAP	: STD_LOGIC_VECTOR ( 31 downto 0 );
SIGNAL mem_read_data	: STD_LOGIC_VECTOR ( 31 downto 0 );


BEGIN
	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => 8,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "dmemory.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => memwrite_en,
		clock0 => write_clock,
		address_a => address,
		data_a => write_data,
		q_a => mem_read_data	);
		
	
	the_one  <= '1';
	the_one_add <= "1";
	the_zero <= '0';
	
	buttons_switches( 3  DOWNTO 0 ) <= KEY ;
	buttons_switches( 17 DOWNTO 8 ) <= SW;
	LEDG <= LEDS_MAP(  7 DOWNTO 0 );
	LEDR <= LEDS_MAP( 17 DOWNTO 8 );
	
	
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
		wren_a => the_zero,
		rden_a => buttons_switches_en,
		clock0 => write_clock,
		address_a => the_one_add,
		data_a => write_data,
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
		wren_a => led_en,
		rden_a => the_one,
		clock0 => write_clock,
		address_a => the_one_add,
		data_a => write_data,
		q_a => LEDS_MAP	);
		
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
		wren_a => ssg_en,
		rden_a => the_one,
		clock0 => the_one,
		address_a => the_one_add,
		data_a => write_data,
		q_a => SEVEN_SEG_MAP	);
		
		
		-- Load memory address register with write clock.
		write_clock <= NOT clock;
		
	BCD0: BCD
	PORT MAP (
		Binary 	=> SEVEN_SEG_MAP( 3 downto 0 ),
		En 		=> the_one,
		Hex_out => Seven_Seg0 );
	BCD1: BCD
	PORT MAP (
		Binary 	=> SEVEN_SEG_MAP( 7 downto 4 ),
		En 		=> the_one,
		Hex_out => Seven_Seg1 );
	
	BCD2: BCD
	PORT MAP (
		Binary 	=> SEVEN_SEG_MAP( 11 downto 8 ),
		En 		=> the_one,
		Hex_out => Seven_Seg2 );		
	
	BCD3: BCD
	PORT MAP (
		Binary 	=> SEVEN_SEG_MAP( 15 downto 12 ),
		En 		=> the_one,
		Hex_out => Seven_Seg3 );
	
		
	PROCESS(address, SEVEN_SEG_MAP, LEDS_MAP, buttons_switches, mem_read_data, Memwrite)
	BEGIN
		if address(8) = '0' then
			memwrite_en <= Memwrite;
			ssg_en <= '0';
			led_en <= '0';
			buttons_switches_en <= '0';
			read_data <= mem_read_data;
		else
			memwrite_en <= '0';
			CASE address( 7 downto 0 ) IS
				WHEN X"00" =>	ssg_en <= '1'; 
								led_en <= '0';
								buttons_switches_en <= '0';
								read_data <= SEVEN_SEG_MAP;
				WHEN X"01" =>	ssg_en <= '0';
								led_en <= '1';
								buttons_switches_en <= '0';
								read_data <= LEDS_MAP;
				WHEN X"02" =>	ssg_en <= '0';
								led_en <= '0';
								buttons_switches_en <= '1';
								read_data <= buttons_switches;
				WHEN OTHERS =>  ssg_en <= '0';
								led_en <= '0';
								buttons_switches_en <= '0';
								read_data <= (others => '0');
			END CASE;
		END if;
	END PROCESS;
	
END behavior;

