-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	PORT(	SIGNAL Instruction_out 	: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			SIGNAL Pre_Instruction	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			SIGNAL bubble_out		: OUT	STD_LOGIC;
        	SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	SIGNAL Branch 			: IN 	STD_LOGIC;
			SIGNAL Zero 			: IN 	STD_LOGIC;
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL clock, reset 	: IN 	STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4 	 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL next_PC, Mem_Addr : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Branch_taken		 : STD_LOGIC;
	SIGNAL Instruction		 : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Last_Op	 		 : STD_LOGIC_VECTOR( 5  DOWNTO 0 );
	
	SIGNAL bubble			 : STD_LOGIC;
	SIGNAL Rs,Rt,Rd_L		 : STD_LOGIC_VECTOR( 4 downto 0 );
	SIGNAL Op	 		 	 : STD_LOGIC_VECTOR( 5  DOWNTO 0 );
	
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => 8,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "../CODE/program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 		=> Instruction );
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
						-- send address to inst. memory address register
		Mem_Addr <= Next_PC;
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
						-- Mux to select Branch Address or PC + 4        
		Next_PC  <= X"00" WHEN Reset = '1' ELSE
			Add_result  WHEN ( ( Branch = '1' ) AND ( Zero = '1' ) ) ELSE
			PC( 9 DOWNTO 2 )	WHEN bubble = '1'
			ELSE   PC_plus_4( 9 DOWNTO 2 );
			
		Branch_taken <= ( Branch AND Zero ) OR bubble;
		Instruction_out <= Instruction WHEN Branch_taken = '0'
									ELSE X"00000000";
		
		Last_Op <= Pre_Instruction( 31 DOWNTO 26 );
		Rs <= Instruction( 25 DOWNTO 21 );
		Rt <= Instruction( 20 DOWNTO 16 );
		Rd_L <= Pre_Instruction( 20 DOWNTO 16 );
		Op <= Instruction( 31 DOWNTO 26 );
		
		bubble <= '1' WHEN Last_Op = "100011" AND Op = "000000" AND ( Rs = Rd_L OR Rt = Rd_L )
					ELSE '0';
		
		
		bubble_out <= bubble;
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;
END behavior;


