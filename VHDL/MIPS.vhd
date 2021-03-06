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
			SW							: IN 	STD_LOGIC_VECTOR( 8 downto 0 );
			KEY							: IN 	STD_LOGIC_VECTOR( 3 downto 0 ) );
		-- Output important signals to pins for easy display in Simulator
		--PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		--ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	--Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		--Branch_out, Zero_out, Memwrite_out, 
		--Regwrite_out					: OUT 	STD_LOGIC );
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

--	COMPONENT pll is
--	port(
--	inclk0:	IN STD_LOGIC :='0';
--			c0 : OUT STD_LOGIC
--	);
--	end COMPONENT;

	COMPONENT Ifetch
   	     PORT(	Instruction_out		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Pre_Instruction		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		PC_plus_4_out 		: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				bubble_out			: OUT	STD_LOGIC;
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
				PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				bubble_out			: IN  	STD_LOGIC;
				bubble_data			: IN    STD_LOGIC_VECTOR( 31 DOWNTO 0);
        		RegWrite			: IN 	STD_LOGIC;
        		RegDst 				: IN 	STD_LOGIC;
        		Sign_extend 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_result  		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Add_Result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 ) ;--BRanch 
				Zero 				: OUT 	STD_LOGIC;
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
               	--Zero 				: OUT	STD_LOGIC;
               	ALU_Result 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	--Add_Result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
               	--PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
               	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT dmemory
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
	
	COMPONENT BCD 
	port ( 	Binary: 	in  std_logic_vector(3 downto 0);
			En:			in  std_logic;
			Hex_out:	out std_logic_vector(6 downto 0));
	end COMPONENT;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC_plus_4_2ID 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := X"00000000" ;
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
	SIGNAL RegWrite_reg     : STD_LOGIC;  -- added by amit
	
	SIGNAL ALUop_reg		: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ALUSrc_reg2delay 		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemtoReg_reg2delay		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemRead_reg2delay		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemWrite_reg2delay		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL RegWrite_reg2delay		: STD_LOGIC_VECTOR( 0 downto 0 );
	
	SIGNAL ALUSrc_delay2reg 		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemtoReg_delay2reg		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemRead_delay2reg		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL MemWrite_delay2reg		: STD_LOGIC_VECTOR( 0 downto 0 );
	SIGNAL RegWrite_delay2reg		: STD_LOGIC_VECTOR( 0 downto 0 );--added by amit
	SIGNAL Function_opcode_delay	: STD_LOGIC_VECTOR(5 downto 0);--added by amit
	
	SIGNAL bubble_delay				: STD_LOGIC_VECTOR (0 downto 0);--amit
	SIGNAL bubble_in_decode			: STD_LOGIC_VECTOR	(0 downto 0);
	
	SIGNAL mem_write_data			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Branch_taken				: std_logic;
	
	SIGNAL KEY_in					: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL SW_in					: STD_LOGIC_VECTOR( 8 DOWNTO 0 );
	SIGNAL ssg0_out					: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL ssg1_out					: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL ssg2_out					: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL ssg3_out					: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL Seven_Seg				: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL LEDG_out					: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL LEDR_out					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	
	signal the_one						: STD_LOGIC;
	
	signal the_zero						:STD_LOGIC;
	--signals for compilation
	SIGNAL PC			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	signal seg_signal_0 : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	signal seg_signal_1 : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	signal seg_signal_2 : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	signal seg_signal_3 : STD_LOGIC_VECTOR( 6 DOWNTO 0 );

BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
--   Instruction_out 	<= Instruction;
--   ALU_result_out 	<= ALU_result;
--   read_data_1_out 	<= read_data_1;
--   read_data_2_out 	<= read_data_2;
--   write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;
--   Branch_out 		<= Branch;
--   Zero_out 		<= Zero;
--   RegWrite_out 	<= RegWrite;
--   MemWrite_out 	<= MemWrite;	
					-- connect the 5 MIPS components   
					
-- Conversions: STD_LOGIC_VECTOR( 0 downto 0 ) <===> STD_LOGIC		
--	For Generic Delay Component			
   ALUSrc_reg2delay(0) 	 <= ALUSrc_reg;
   MemtoReg_reg2delay(0) <= MemtoReg_reg;
   MemRead_reg2delay(0)	 <= MemRead_reg;
   MemWrite_reg2delay(0) <= MemWrite_reg;
   RegWrite_reg2delay(0) <= RegWrite_reg;--added by amit
   
   ALUSrc			 	 <= ALUSrc_delay2reg(0);
   MemtoReg				 <= MemtoReg_delay2reg(0);
   MemRead				 <= MemRead_delay2reg(0);
   MemWrite				 <= MemWrite_delay2reg(0);
   RegWrite				 <= RegWrite_delay2reg(0);--added by amit
   
	the_one <= '1';
    the_zero <= '0';
   
   Seven_Seg0 <= seg_signal_0;--ssg0_out;
   Seven_Seg1 <= seg_signal_1;--ssg1_out;
   Seven_Seg2 <= seg_signal_2;--ssg2_out;
   Seven_Seg3 <= seg_signal_3;--ssg3_out;

   LEDG		  <= LEDG_out;
   LEDR		  <= LEDR_out;
   KEY_in 	  <= KEY;
   SW_in 	  <= SW;
   
 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-- 
--~~~~~~~~~~~~~~~~~~~ MIPS Components ~~~~~~~~~~~~~~~~~~~--  
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

	--pll1:pll
	--port map(
	--inclk0 => clock0,
	--c0 =>clock
	--);
  ---------------------------------------------------------
   IFE : Ifetch
	PORT MAP (	Instruction_out => Instruction_2ID,
				Pre_Instruction => Instruction,
    	    	PC_plus_4_out 	=> PC_plus_4_2ID(9 DOWNTO 0),
				bubble_out		=> bubble_delay(0),
				Add_result 		=> Add_result,
				Branch 			=> Branch,
				Zero 			=> Zero,
				PC_out 			=> PC,        		
				clock 			=> clock,  
				reset 			=> reset );
					

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1_2EXE,
        		read_data_2 	=> read_data_2_2EXE,
        		Instruction 	=> Instruction,
				write_data 		=> write_data,
				PC_plus_4  		=> PC_plus_4,
				bubble_out		=> bubble_in_decode(0),
				bubble_data		=> read_data_2WB,
				RegWrite 		=> RegWrite,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend_2EXE,
				ALU_result		=> ALU_Result_int,
				Add_Result 		=> Add_Result,
				Zero 			=> Zero,
        		clock 			=> clock,				
				reset 			=> reset );
				

   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction( 31 DOWNTO 26 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc_reg,
				MemtoReg 		=> MemtoReg_reg,
				RegWrite 		=> RegWrite_reg,
				MemRead 		=> MemRead_reg, 
				MemWrite 		=> MemWrite_reg,    
				Branch 			=> Branch,
				ALUop 			=> ALUop_reg,
                clock 			=> clock,
				reset 			=> reset );

  
   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
                Function_opcode => Function_opcode_delay(5 DOWNTO 0),
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				ALU_Result		=> ALU_Result_int,
				Clock			=> clock,
				Reset			=> reset );
   

   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data_2WB,
				address 		=> ALU_Result (10 DOWNTO 2),
				write_data 		=> mem_write_data,
				MemRead 		=> MemRead, 
				Memwrite 		=> MemWrite, 
				LEDR			=> LEDR_out,
				LEDG			=> LEDG_out,
				Seven_Seg		=> Seven_Seg,
				SW				=> SW_in,
				KEY 			=> KEY_in,
                clock 			=> clock,  
				reset 			=> reset );
				

   W_BACK: WBACK
	PORT MAP ( 	ALU_result		=> ALU_Result_2WB,
				read_data		=> read_data,
				write_data		=> write_data,
				MemtoReg		=> MemtoReg );
	
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-- 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-- 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-- 	
	
	
--~~~~~~~~~~~~~~~~~ Pipeline Registers ~~~~~~~~~~~~~~~~~--


--========================seven_segement================================
  seg_signal_reg0: Ndff
    GENERIC MAP ( N => 7 )
	PORT MAP (	d 			=> ssg0_out,
				clk			=> clock,
				rst			=> reset,
				q			=> seg_signal_0 ); --goes to Idecode & control too
				
  seg_signal_reg1: Ndff
    GENERIC MAP ( N => 7 )
	PORT MAP (	d 			=> ssg1_out,
				clk			=> clock,
				rst			=> reset,
				q			=> seg_signal_1 ); --goes to Idecode & control too
				
  seg_signal_reg2: Ndff
    GENERIC MAP ( N => 7 )
	PORT MAP (	d 			=> ssg2_out,
				clk			=> clock,
				rst			=> reset,
				q			=> seg_signal_2 ); --goes to Idecode & control too

  seg_signal_reg3: Ndff
    GENERIC MAP ( N => 7 )
	PORT MAP (	d 			=> ssg3_out,
				clk			=> clock,
				rst			=> reset,
				q			=> seg_signal_3 ); --goes to Idecode & control too				
--========================================================
				
--======================================================--
--==================== IFetch Input ====================--
--======================================================--
	
   IF2ID_instruction: Ndff
    GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> Instruction_2ID,
				clk			=> clock,
				rst			=> reset,
				q			=> Instruction ); --goes to Idecode & control too
				
   PC_PLUS_4_2ID_REG: Ndff
    GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> PC_plus_4_2ID,
				clk			=> clock,
				rst			=> reset,
				q			=> PC_plus_4 );
				
--======================================================--				
--==================== Decode Input ====================--
--======================================================--

   DELAY_BUBBLE: DELAY_REG
	GENERIC MAP ( N => 1 , M => 2 )
	PORT MAP (
				reset 		=> reset,
				clock 		=> clock,
				data_in 	=> bubble_delay, 
				data_out 	=> bubble_in_decode );
				
   DELAY_REG_WRITE: DELAY_REG
	GENERIC MAP ( N => 1 , M => 3 )
	PORT MAP (
				reset 		=> reset,
				clock 		=> clock,
				data_in 	=> RegWrite_reg2delay, 
				data_out 	=> RegWrite_delay2reg ); -- RegWrite
	
--======================================================--
--=================== Execute Input ====================--
--======================================================--

   ID2EXE_SIGN_EXTEND: Ndff
	GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> Sign_extend_2EXE,
				clk			=> clock,
				rst			=> reset,
				q			=> Sign_extend );
   ID2EXE_READ_DATA_1: Ndff
	GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> read_data_1_2EXE,
				clk			=> clock,
				rst			=> reset,
				q			=> read_data_1 );

   ID2EXE_READ_DATA_2: Ndff
	GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> read_data_2_2EXE,
				clk			=> clock,
				rst			=> reset,
				q			=> read_data_2 );
				
   DELAY_ALU_OP: DELAY_REG
	GENERIC MAP ( N => 2 , M => 1 )
	PORT MAP (
				reset 		=> reset,
				clock 		=> clock,
				data_in 	=> ALUop_reg, 
				data_out 	=> ALUop );
				
   DELAY_FUNCTION_OPCODE: DELAY_REG
	GENERIC MAP ( N => 6 , M => 1 )
	PORT MAP (
				reset 		=> reset,
				clock 		=> clock,
				data_in 	=> Instruction(5 downto 0), 
				data_out 	=> Function_opcode_delay );	

   DELAY_ALU_SRC: DELAY_REG
	GENERIC MAP ( N => 1 , M => 1 )
	PORT MAP (
				reset 	  	=> reset,
				clock 	  	=> clock,
				data_in   	=> ALUSrc_reg2delay,  
				data_out  	=> ALUSrc_delay2reg ); -- ALUsrc				
				
--======================================================--				
--=================== Dmemory Input ====================--
--======================================================--

   EXE_ALU_RES: Ndff
    GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> ALU_Result_int,
				clk			=> clock,
				rst			=> reset,
				q			=> ALU_Result );

	DELAY_MEM_READ: DELAY_REG
	GENERIC MAP ( N => 1, M=>2 )
	PORT MAP (
				reset 		=> reset,
				clock 		=> clock,
				data_in 	=> MemRead_reg2delay,  
				data_out 	=> MemRead_delay2reg ); --MemRead

   DELAY_MEM_WRITE: DELAY_REG
	GENERIC MAP ( N => 1 , M => 2 )
	PORT MAP (
				reset 		=> reset,
				clock 		=> clock,
				data_in 	=> MemWrite_reg2delay,  
				data_out 	=> MemWrite_delay2reg ); -- MemWrite

   ID2MEM_READ_DATA_2: Ndff
	GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> read_data_2,
				clk			=> clock,
				rst			=> reset,
				q			=> mem_write_data );

--======================================================--				
--================== WriteBack Input ===================--
--======================================================--

   READ_DATE_reg: Ndff
    GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> read_data_2WB,
				clk			=> clock,
				rst			=> reset,
				q			=> read_data );

   ALU_RES_2WB: Ndff
    GENERIC MAP ( N => 32 )
	PORT MAP (	d 			=> ALU_Result,
				clk			=> clock,
				rst			=> reset,
				q			=> ALU_Result_2WB );
				
   DELAY_MEM_TO_REG: DELAY_REG
	GENERIC MAP ( N => 1 , M => 3 )
	PORT MAP (
				reset 		=> reset,
				clock 		=> clock,
				data_in 	=> MemtoReg_reg2delay, 
				data_out 	=> MemtoReg_delay2reg ); -- MemtoReg				
				
--======================================================--
--======================================================--
--======================================================--

	BCD0: BCD
	PORT MAP (
		Binary 	=> Seven_Seg( 3 downto 0 ),
		En 		=> the_one,
		Hex_out => ssg0_out );
	BCD1: BCD
	PORT MAP (
		Binary 	=> Seven_Seg( 7 downto 4 ),
		En 		=> the_one,
		Hex_out => ssg1_out );
	
	BCD2: BCD
	PORT MAP (
		Binary 	=> Seven_Seg( 11 downto 8 ),
		En 		=> the_one,
		Hex_out => ssg2_out );		
	
	BCD3: BCD
	PORT MAP (
		Binary 	=> Seven_Seg( 15 downto 12 ),
		En 		=> the_one,
		Hex_out => ssg3_out );

END structure;

