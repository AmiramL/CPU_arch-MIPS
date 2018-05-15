-- ====================================================================
--
--	File Name:		MIPS.vhd
--	Description:	Pipelined MIPS Top level 
--					
--
--	Date:			11/05/2018
--	Editors:		Amiram Lifshitz & Amit Biran
--		
-- ====================================================================	
		-- Top Level Structural Model for MIPS Processor Core
		-- With pipeline
		
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS

	PORT( 	reset, clock				: IN 	STD_LOGIC; 
			LEDR						: OUT 	STD_LOGIC_VECTOR( 9 downto 0 );
			LEDG						: OUT 	STD_LOGIC_VECTOR( 7 downto 0 );
			Seven_Seg0					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg1					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg2					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			Seven_Seg3					: OUT 	STD_LOGIC_VECTOR( 6 downto 0 );
			SW							: IN 	STD_LOGIC_VECTOR( 9 downto 0 );
			KEY							: IN 	STD_LOGIC_VECTOR( 3 downto 0 );
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, Zero_out, Memwrite_out, 
		Regwrite_out					: OUT 	STD_LOGIC );
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

	COMPONENT Ifetch
   	     PORT(	Instruction			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		PC_plus_4_out 		: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		Add_result 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		Branch 				: IN 	STD_LOGIC;
        		Zero 				: IN 	STD_LOGIC;
        		PC_out 				: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		clock,reset 		: IN 	STD_LOGIC );
	END COMPONENT; 

	COMPONENT Idecode
 	     PORT(	read_data_1 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data_2 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		Instruction 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		ALU_result 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		RegWrite, MemtoReg 	: IN 	STD_LOGIC;
        		RegDst 				: IN 	STD_LOGIC;
        		Sign_extend 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT control
	     PORT( 	Opcode 				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
             	RegDst 				: OUT 	STD_LOGIC;
             	ALUSrc 				: OUT 	STD_LOGIC;
             	MemtoReg 			: OUT 	STD_LOGIC;
             	RegWrite 			: OUT 	STD_LOGIC;
             	MemRead 			: OUT 	STD_LOGIC;
             	MemWrite 			: OUT 	STD_LOGIC;
             	Branch 				: OUT 	STD_LOGIC;
             	ALUop 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
             	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
   	     PORT(	Read_data_1 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Read_data_2 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Sign_Extend 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Function_opcode		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
               	ALUOp 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
               	ALUSrc 				: IN 	STD_LOGIC;
               	Zero 				: OUT	STD_LOGIC;
               	ALU_Result 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Add_Result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
               	PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
               	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT dmemory
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
	END COMPONENT;
	
	COMPONENT Ndff
		 GENERIC ( N: integer := 8);
		 PORT (	d					: in std_logic_vector(N-1 downto 0);
				clk					: in std_logic;
				rst					: in std_logic;
				q					: out std_logic_vector(N-1 downto 0) );
	END COMPONENT;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4_2EXE 	: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_2ID 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_2EXE : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_2EXE : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2ID 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_extend_2EXE : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_Result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_Result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_Result_int 	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_Result_int 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL RegDst 			: STD_LOGIC;
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_2ID	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= Instruction;
   ALU_result_out 	<= ALU_result;
   read_data_1_out 	<= read_data_1;
   read_data_2_out 	<= read_data_2;
   write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;
   Branch_out 		<= Branch;
   Zero_out 		<= Zero;
   RegWrite_out 	<= RegWrite;
   MemWrite_out 	<= MemWrite;	
					-- connect the 5 MIPS components   
   IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction_2ID,
    	    	PC_plus_4_out 	=> PC_plus_4_2EXE,
				Add_result 		=> Add_result,
				Branch 			=> Branch,
				Zero 			=> Zero,
				PC_out 			=> PC_2ID,        		
				clock 			=> clock,  
				reset 			=> reset );
				
   IF2ID_instruction: Ndff
    GENERIC MAP ( N => 32)
	PORT MAP (	d 				=> Instruction_2ID,
				clk				=> clock,
				rst				=> reset,
				q				=> Instruction );
   
   IF2ID_PC: Ndff
    GENERIC MAP ( N => 10)
	PORT MAP (	d 				=> PC_2ID,
				clk				=> clock,
				rst				=> reset,
				q				=> PC );
				
   IF2ID_PC_plus_4: Ndff
    GENERIC MAP ( N => 10)
	PORT MAP (	d 				=> PC_plus_4_2EXE,
				clk				=> clock,
				rst				=> reset,
				q				=> PC_plus_4 );

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1_2EXE,
        		read_data_2 	=> read_data_2_2EXE,
        		Instruction 	=> Instruction,
        		read_data 		=> read_data,
				ALU_result 		=> ALU_result,
				RegWrite 		=> RegWrite,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend_2EXE,
        		clock 			=> clock,  
				reset 			=> reset );
	
   ID2EXE_SIGN_EXTEND: Ndff
	GENERIC MAP ( N => 32 )
	PORT MAP (	d 				=> Sign_extend_2EXE,
				clk				=> clock,
				rst				=> reset,
				q				=> Sign_extend );
   ID2EXE_READ_DATA_1: Ndff
	GENERIC MAP ( N => 32 )
	PORT MAP (	d 				=> read_data_1_2EXE,
				clk				=> clock,
				rst				=> reset,
				q				=> read_data_1 );

   ID2EXE_READ_DATA_2: Ndff
	GENERIC MAP ( N => 32 )
	PORT MAP (	d 				=> read_data_2_2EXE,
				clk				=> clock,
				rst				=> reset,
				q				=> read_data_2 );

   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction( 31 DOWNTO 26 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				ALUop 			=> ALUop,
                clock 			=> clock,
				reset 			=> reset );

   
   
   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
                Function_opcode	=> Instruction( 5 DOWNTO 0 ),
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				Zero 			=> Zero,
                ALU_Result		=> ALU_Result_int,
				Add_Result 		=> Add_Result_int,
				PC_plus_4		=> PC_plus_4,
                Clock			=> clock,
				Reset			=> reset );
   
   EXE_ALU_RES: Ndff
    GENERIC MAP ( N => 32 )
	PORT MAP (	d 				=> ALU_Result_int,
				clk				=> clock,
				rst				=> reset,
				q				=> ALU_Result );
   EXE_ADD_RES: Ndff
    GENERIC MAP ( N => 8 )
	PORT MAP (	d 				=> Add_Result_int,
				clk				=> clock,
				rst				=> reset,
				q				=> Add_Result );

   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data_2ID,
				address 		=> ALU_Result (10 DOWNTO 2),--jump memory address by 4
				write_data 		=> read_data_2,
				MemRead 		=> MemRead, 
				Memwrite 		=> MemWrite, 
				LEDR			=> LEDR,
				LEDG			=> LEDG,
				Seven_Seg0		=> Seven_Seg0,
				Seven_Seg1		=> Seven_Seg1,
				Seven_Seg2		=> Seven_Seg2,
				Seven_Seg3		=> Seven_Seg3,
				SW				=> SW,
				KEY 			=> KEY,
                clock 			=> clock,  
				reset 			=> reset );
				
   READ_DATE_reg: Ndff
    GENERIC MAP ( N => 32 )
	PORT MAP (	d 				=> read_data_2ID,
				clk				=> clock,
				rst				=> reset,
				q				=> read_data );
	
END structure;

