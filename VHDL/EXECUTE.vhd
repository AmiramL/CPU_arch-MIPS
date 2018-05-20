--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Execute IS
	PORT(	Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC;
			--Zero 			: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			--Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			--PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC );
END Execute;

ARCHITECTURE behavior OF Execute IS

COMPONENT floating_point_top
port (	
		A: 		in std_logic_vector(31 downto 0);
		B:  	in std_logic_vector(31 downto 0);
		sel: 	in std_logic;
		C:     out std_logic_vector(31 downto 0));
end COMPONENT;

SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl				: STD_LOGIC_VECTOR( 2 DOWNTO 0 );

SIGNAL C_FP					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL B_FP					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL FP_sel				: STD_LOGIC;

BEGIN
	Ainput <= Read_data_1;
						-- ALU input mux
	Binput <= Read_data_2 
		WHEN ( ALUSrc = '0' ) 
  		ELSE  Sign_extend( 31 DOWNTO 0 );
						-- Generate ALU control bits
	ALU_ctl( 0 ) <= ( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1 );
	ALU_ctl( 1 ) <= ( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) );
	ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 );
						-- Generate Zero Flag
	--Zero <= '1' 
	--	WHEN ( ALU_output_mux( 31 DOWNTO 0 ) = X"00000000"  )
	--	ELSE '0';    
						-- Select ALU output        
	ALU_result <= X"0000000" & B"000"  & ALU_output_mux( 31 ) 
		WHEN  ALU_ctl = "111" 
		ELSE  	ALU_output_mux( 31 DOWNTO 0 );
						-- Adder to compute Branch Address
	--Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
	--	Add_result 	<= Branch_Add( 7 DOWNTO 0 );

PROCESS ( ALU_ctl, Ainput, Binput, C_FP )
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
						FP_sel <= '0';
						-- ALU performs ALUresult = A_input OR B_input
     	WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						FP_sel <= '0';
						-- ALU performs ALUresult = A_input + B_input
	 	WHEN "010" 	=>	ALU_output_mux 	<= Ainput + Binput;
						FP_sel <= '0';
						-- ALU performs MULF
 	 	WHEN "011" 	=>	ALU_output_mux <= C_FP;
						FP_sel <= '1';
						-- ALU performs ADDF
 	 	WHEN "100" 	=>	ALU_output_mux 	<= C_FP;
						FP_sel <= '0';
						-- ALU performs SUBF
 	 	WHEN "101" 	=>	ALU_output_mux 	<= C_FP;
						FP_sel <= '0';
						-- ALU performs ALUresult = A_input -B_input
 	 	WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;
						FP_sel <= '0';
						-- ALU performs SLT
  	 	WHEN "111" 	=>	ALU_output_mux 	<= Ainput - Binput ;
						FP_sel <= '0';
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
						FP_sel <= '0';
  	END CASE;
  END PROCESS;
  
  FP_inst : floating_point_top
		port map(	A 	=> Ainput,
					B 	=> B_FP,
					sel => FP_sel,
					C 	=> C_FP );
	
  B_FP(31) <= not Binput(31) WHEN ALU_ctl = "101" ELSE Binput(31);
  B_FP( 30 DOWNTO 0 ) <= Binput( 30 DOWNTO 0 );
  
END behavior;

