						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	  PORT(	read_data_1			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ); --BRanch 
			bubble_out			: IN 	STD_LOGIC;
			bubble_data			: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 			: IN 	STD_LOGIC;
			RegDst 				: IN 	STD_LOGIC;
			Sign_extend 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result  		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 ) ;--BRanch 
			Zero 				: OUT	STD_LOGIC;
			clock,reset			: IN 	STD_LOGIC );
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	-- for write registers address
	COMPONENT DELAY_REG
	generic ( 	N : integer := 1; 	-- Bus width
				M : integer := 1 );	-- Nuber of cycles to delay
	PORT( 	reset, clock				: IN 	STD_LOGIC; 
			data_in						: IN 	STD_LOGIC_VECTOR( N-1 downto 0 );
			data_out					: OUT 	STD_LOGIC_VECTOR( N-1 downto 0 ) );
	END COMPONENT;
	
	COMPONENT Ndff 
	generic ( N: integer := 8);
	port (	
			d: 	  		in std_logic_vector(N-1 downto 0);
			clk:		in std_logic;
			rst:		in std_logic;
			q: 			out std_logic_vector(N-1 downto 0));
	end COMPONENT;
	
	SIGNAL register_array				: register_file;
	SIGNAL write_register_address 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	
	SIGNAL read_data_2_int				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_int				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	SIGNAL write_register_address_2delay: STD_LOGIC_VECTOR( 4 DOWNTO 0 );--amiram's change
	
	SIGNAL Branch_Add 					: STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- Branch
	
	SIGNAL last_instruction				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL last_opcode					: STD_LOGIC_VECTOR( 5  DOWNTO 0 );
	SIGNAL last_Rd						: STD_LOGIC_VECTOR( 4  DOWNTO 0 );
	
	SIGNAL last_2_instruction			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL last_2_opcode				: STD_LOGIC_VECTOR( 5  DOWNTO 0 );
	SIGNAL last_2_Rd					: STD_LOGIC_VECTOR( 4  DOWNTO 0 );
	SIGNAL last_ALU_result				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	SIGNAl last_2_Rd_bubble			    : STD_LOGIC_VECTOR( 4  DOWNTO 0 );

BEGIN
	read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
   	write_register_address_1	<= Instruction( 15 DOWNTO 11 );
   	write_register_address_0 	<= Instruction( 20 DOWNTO 16 );
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
	
	
	-----------------------======================================
					-- Read Register 1 Operation
	read_data_1 <= read_data_1_int;
					-- Read Register 2 Operation		 
	read_data_2 <= read_data_2_int;
				  
	--===========================================================
		--internal signals for zero calculation
		
		
		
	read_data_1_int <= 	bubble_data	WHEN bubble_out = '1' AND last_2_Rd_bubble = read_register_1_address
							  ELSE ALU_result WHEN last_opcode = "000000" AND last_Rd = read_register_1_address
							  ELSE last_ALU_result WHEN last_2_opcode = "000000" AND last_2_Rd = read_register_1_address
							  ELSE write_data WHEN read_register_1_address = write_register_address
							  ELSE register_array( CONV_INTEGER( read_register_1_address ) );
					-- Read Register 2 Operation		 
	read_data_2_int <= bubble_data	WHEN bubble_out = '1' AND last_2_Rd_bubble = read_register_2_address
							  ELSE ALU_result WHEN last_opcode = "000000" AND last_Rd = read_register_2_address
							  ELSE last_ALU_result WHEN last_2_opcode = "000000" AND last_2_Rd = read_register_2_address
							  ELSE write_data WHEN read_register_2_address = write_register_address
							  ELSE register_array( CONV_INTEGER( read_register_2_address ) );
							  
	
	--============================================================
				  
					-- Mux for Register Write Address
    	write_register_address_2delay <= write_register_address_1 
			WHEN RegDst = '1'  			ELSE write_register_address_0;
					-- Mux to bypass data memory for Rformat instructions
	--write_data <= ALU_result( 31 DOWNTO 0 ) 
			--WHEN ( MemtoReg = '0' ) 	ELSE read_data;
					-- Sign Extend 16-bits to 32-bits
    	Sign_extend <= X"0000" & Instruction_immediate_value
		WHEN Instruction_immediate_value(15) = '0'
		ELSE	X"FFFF" & Instruction_immediate_value;
	--=================================================================
	--Branch hazards
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Instruction_immediate_value( 7 DOWNTO 0 ) ;
	Add_result 	<= Branch_Add( 7 DOWNTO 0 );	

	PROCESS (read_data_1_int, read_data_2_int)
	begin
		if CONV_INTEGER( read_data_1_int ) = CONV_INTEGER( read_data_2_int ) then
			zero <= '1';
		else
			zero <= '0';
		end if;
	end PROCESS;	
	
	--==============================================================
	-- Our change!!!!!!!!!!
	WRITE_REG_ADD_DELAY: DELAY_REG
				generic map ( N => 5, M => 3 )
				port map (	reset => reset,
							clock => clock,
							data_in => write_register_address_2delay,
							data_out => write_register_address 
							);
	--==============================================================
	LAST_COMMAND: Ndff
				generic map ( 32 )
				port map ( 	d 	=> Instruction,
							clk => clock,
							rst => reset,
							q	=> last_instruction );

	last_opcode <= last_instruction( 31 DOWNTO 26 );
	last_Rd		<= last_instruction( 15 DOWNTO 11 );
	--==============================================================
	LAST_ALU_RES: Ndff
				generic map ( 32 )
				port map ( 	d 	=> ALU_result,
							clk => clock,
							rst => reset,
							q	=> last_ALU_result );
	
	last_2_COMMAND: Ndff
				generic map ( 32 )
				port map ( 	d 	=> last_instruction,
							clk => clock,
							rst => reset,
							q	=> last_2_instruction );

	last_2_opcode <= last_2_instruction( 31 DOWNTO 26 );
	last_2_Rd	  <= last_2_instruction( 15 DOWNTO 11 );
	last_2_Rd_bubble <= last_2_instruction( 20 DOWNTO 16 );
	--==============================================================
	

PROCESS
	BEGIN
		WAIT UNTIL clock'EVENT AND clock = '1';
		IF reset = '1' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
  		ELSIF RegWrite = '1' AND write_register_address /= 0 THEN
		      register_array( CONV_INTEGER( write_register_address)) <= write_data;
		END IF;
	END PROCESS;
END behavior;


