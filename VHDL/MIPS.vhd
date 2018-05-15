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
        		Add_result 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); --change the pc if there was a branch
        		Branch 				: IN 	STD_LOGIC;                     --tells if to ignore branch or not
        		Zero 				: IN 	STD_LOGIC;
        		PC_out 				: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		clock,reset 		: IN 	STD_LOGIC );
	END COMPONENT; 

	COMPONENT Idecode
 	     PORT(	read_data_1 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data_2 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		Instruction 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		RegWrite			: IN 	STD_LOGIC;
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
	
	COMPONENT WBACK 
	port ( 	ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemtoReg 	: IN 	STD_LOGIC );
	END COMPONENT;
	
	COMPONENT Ndff
		 GENERIC ( N: integer := 8);
		 PORT (	d					: in std_logic_vector(N-1 downto 0);
				clk					: in std_logic;
				rst					: in std_logic;
				q					: out std_logic_vector(N-1 downto 0) );
	END COMPONENT;
	
	COMPONENT DELAY_REG
	generic ( 	N : integer := 1; 	-- Bus width
				M : integer := 1 );	-- Nuber of cycles to delay
	PORT( 	reset, clock				: IN 	STD_LOGIC; 
			data_in						: IN 	STD_LOGIC_VECTOR( N-1 downto 0 );
			data_out					: OUT 	STD_LOGIC_VECTOR( N-1 downto 0 ) );

	END COMPONENT;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL write_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_2EXE : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_2EXE : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2WB 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_extend_2EXE : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_Result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_Result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_Result_int 	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_Result_int 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_Result_2WB 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
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
	SIGNAL ALUSrc_reg       : STD_LOGIC;
	SIGNAL MemtoReg_reg		: STD_LOGIC;
	SIGNAL MemRead_reg		: STD_LOGIC;
	SIGNAL MemWrite_reg		: STD_LOGIC;
	SIGNAL ALUop_reg		: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ALUSrc_reg2delay 		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemtoReg_reg2delay		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemRead_reg2delay		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemWrite_reg2delay		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL ALUSrc_delay2reg 		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemtoReg_delay2reg		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemRead_delay2reg		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemWrite_delay2reg		: STD_LOGIC_VECTOR( 0 downto 0 );

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
					
					
   ALUSrc_reg2delay(0) 	 <= ALUSrc_reg;
   MemtoReg_reg2delay(0) <= MemtoReg_reg;
   MemRead_reg2delay(0)	 <= MemRead_reg;
   MemWrite_reg2delay(0) <= MemWrite_reg;
   
   ALUSrc			 	 <= ALUSrc_delay2reg(0);
   MemtoReg				 <= MemtoReg_delay2reg(0);
   MemRead				 <= MemRead_delay2reg(0);
   MemWrite				 <= MemWrite_delay2reg(0);
   
   
   IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction_2ID,
    	    	PC_plus_4_out 	=> PC_plus_4,
				Add_result 		=> Add_result,
				Branch 			=> Branch,
				Zero 			=> Zero,
				PC_out 			=> PC,        		
				clock 			=> clock,  
				reset 			=> reset );
				
   IF2ID_instruction: Ndff
    GENERIC MAP ( N => 32)
	PORT MAP (	d 				=> Instruction_2ID,
				clk				=> clock,
				rst				=> reset,
				q				=> Instruction );
				

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1_2EXE,
        		read_data_2 	=> read_data_2_2EXE,
        		Instruction 	=> Instruction,
        		write_data 		=> write_data,
				RegWrite 		=> RegWrite,
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
				ALUSrc 			=> ALUSrc_reg,--changed
				MemtoReg 		=> MemtoReg_reg,--changed
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead_reg, -- changed
				MemWrite 		=> MemWrite_reg,    --changed
				Branch 			=> Branch,
				ALUop 			=> ALUop_reg, -- chagned
                clock 			=> clock,
				reset 			=> reset );
	
	DELAY_ALU_SRC: DELAY_REG
	GENERIC MAP ( N => 1, M=>1 )
	PORT MAP (
				reset => reset,
				clock =>clock,
				data_in => ALUSrc_reg2delay,  --make signal
				data_out => ALUSrc_delay2reg
	);
	
	DELAY_MEM_TO_REG: DELAY_REG
	GENERIC MAP ( N => 1, M=>3 )
	PORT MAP (
				reset => reset,
				clock =>clock,
				data_in => MemtoReg_reg2delay,  --make signal
				data_out => MemtoReg_delay2reg
	);
	
	DELAY_MEM_READ: DELAY_REG
	GENERIC MAP ( N => 1, M=>2 )
	PORT MAP (
				reset => reset,
				clock =>clock,
				data_in => MemRead_reg2delay,  --make signal
				data_out => MemRead_delay2reg
	);
		DELAY_MEM_WRITE: DELAY_REG
	GENERIC MAP ( N => 1, M=>2 )
	PORT MAP (
				reset => reset,
				clock =>clock,
				data_in => MemWrite_reg2delay,  --make signal
				data_out => MemWrite_delay2reg
	);
	
		DELAY_ALU_OP: DELAY_REG
	GENERIC MAP ( N => 2, M=>1 )
	PORT MAP (
				reset => reset,
				clock =>clock,
				data_in => ALUop_reg,  --make signal
				data_out => ALUop
	);
	

   
   
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
	PORT MAP (	read_data 		=> read_data_2WB,
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
	PORT MAP (	d 				=> read_data_2WB,
				clk				=> clock,
				rst				=> reset,
				q				=> read_data );
				
   ALU_RES_2WB: Ndff
    GENERIC MAP ( N => 32 )
	PORT MAP (	d 				=> ALU_Result,
				clk				=> clock,
				rst				=> reset,
				q				=> ALU_Result_2WB );
   W_BACK: WBACK
	PORT MAP ( 	ALU_result		=> ALU_Result_2WB,
				read_data		=> read_data,
				write_data		=> write_data,
				MemtoReg		=> MemtoReg );
	
END structure;

