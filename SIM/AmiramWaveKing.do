onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IFE/clock
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IFE/reset
add wave -noupdate -expand -group Fetch -radix hexadecimal /mips_tb/U_0/IFE/Instruction
add wave -noupdate -expand -group Fetch -radix hexadecimal /mips_tb/U_0/IFE/PC
add wave -noupdate -expand -group Fetch -radix hexadecimal /mips_tb/U_0/IFE/PC_plus_4
add wave -noupdate -expand -group Fetch -radix hexadecimal /mips_tb/U_0/IFE/Mem_Addr
add wave -noupdate -group {Rs+Immediate value} -radix hexadecimal /mips_tb/U_0/ID/read_data_1
add wave -noupdate -group {Rs+Immediate value} -radix hexadecimal /mips_tb/U_0/ID/read_register_1_address
add wave -noupdate -group {Rs+Immediate value} -radix hexadecimal /mips_tb/U_0/ID/Instruction_immediate_value
add wave -noupdate -group {Rs+Immediate value} -radix hexadecimal /mips_tb/U_0/ID/Sign_extend
add wave -noupdate -group {Rd write destination} -radix hexadecimal /mips_tb/U_0/ID/write_register_address
add wave -noupdate -group {Rd write destination} -radix hexadecimal /mips_tb/U_0/ID/write_data
add wave -noupdate -group {Rd write destination} -radix hexadecimal /mips_tb/U_0/ID/read_register_2_address
add wave -noupdate -radix hexadecimal -childformat {{/mips_tb/U_0/ID/register_array(0) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(1) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(2) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(3) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(4) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(5) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(6) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(7) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(8) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9) -radix hexadecimal -childformat {{/mips_tb/U_0/ID/register_array(9)(31) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(30) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(29) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(28) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(27) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(26) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(25) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(24) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(23) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(22) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(21) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(20) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(19) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(18) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(17) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(16) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(15) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(14) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(13) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(12) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(11) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(10) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(9) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(8) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(7) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(6) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(5) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(4) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(3) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(2) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(1) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(0) -radix hexadecimal}}} {/mips_tb/U_0/ID/register_array(10) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(11) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(12) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(13) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(14) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(15) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(16) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(17) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(18) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(19) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(20) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(21) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(22) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(23) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(24) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(25) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(26) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(27) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(28) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(29) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(30) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(31) -radix hexadecimal}} -expand -subitemconfig {/mips_tb/U_0/ID/register_array(0) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(1) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(2) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(3) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(4) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(5) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(6) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(7) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(8) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9) {-height 15 -radix hexadecimal -childformat {{/mips_tb/U_0/ID/register_array(9)(31) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(30) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(29) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(28) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(27) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(26) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(25) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(24) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(23) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(22) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(21) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(20) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(19) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(18) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(17) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(16) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(15) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(14) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(13) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(12) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(11) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(10) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(9) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(8) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(7) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(6) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(5) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(4) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(3) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(2) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(1) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9)(0) -radix hexadecimal}}} /mips_tb/U_0/ID/register_array(9)(31) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(30) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(29) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(28) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(27) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(26) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(25) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(24) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(23) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(22) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(21) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(20) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(19) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(18) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(17) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(16) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(15) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(14) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(13) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(12) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(11) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(10) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(9) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(8) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(7) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(6) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(5) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(4) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(3) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(2) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(1) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9)(0) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(10) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(11) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(12) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(13) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(14) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(15) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(16) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(17) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(18) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(19) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(20) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(21) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(22) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(23) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(24) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(25) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(26) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(27) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(28) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(29) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(30) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(31) {-height 15 -radix hexadecimal}} /mips_tb/U_0/ID/register_array
add wave -noupdate -expand -group Execute -radix hexadecimal /mips_tb/U_0/EXE/Read_data_1
add wave -noupdate -expand -group Execute -radix hexadecimal /mips_tb/U_0/EXE/Sign_extend
add wave -noupdate -expand -group Execute -radix hexadecimal /mips_tb/U_0/EXE/ALU_Result
add wave -noupdate -expand -group Execute -radix hexadecimal /mips_tb/U_0/EXE/Ainput
add wave -noupdate -expand -group Execute -radix hexadecimal /mips_tb/U_0/EXE/Binput
add wave -noupdate -group Mem -radix hexadecimal /mips_tb/U_0/MEM/read_data
add wave -noupdate -group Mem -radix hexadecimal /mips_tb/U_0/MEM/address
add wave -noupdate -group Mem -radix hexadecimal /mips_tb/U_0/MEM/MemRead
add wave -noupdate -group Mem -radix hexadecimal /mips_tb/U_0/MEM/write_clock
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/Opcode
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/RegDst
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/ALUSrc
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/MemtoReg
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/RegWrite
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/MemRead
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/MemWrite
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/Branch
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/ALUop
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/clock
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/reset
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/R_format
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/Lw
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/Sw
add wave -noupdate -group {Control Signals} -radix hexadecimal /mips_tb/U_0/CTL/Beq
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/read_data_1
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/read_data_2
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/Instruction
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/write_data
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/PC_plus_4
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/RegWrite
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/RegDst
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/Sign_extend
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/ALU_result
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/Add_Result
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/Zero
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/clock
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/reset
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/register_array
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/write_register_address
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/read_register_1_address
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/read_register_2_address
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/write_register_address_1
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/write_register_address_0
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/Instruction_immediate_value
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/read_data_2_int
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/read_data_1_int
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/write_register_address_2delay
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/Branch_Add
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/last_instruction
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/last_opcode
add wave -noupdate -group IDecode -radix hexadecimal /mips_tb/U_0/ID/last_Rd
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Instruction_out
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Pre_Instruction
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/PC_plus_4_out
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Add_result
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Branch
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Zero
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/PC_out
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/clock
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/reset
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/PC
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/PC_plus_4
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/next_PC
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Mem_Addr
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Branch_taken
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Instruction
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Last_Op
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/bubble
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Rs
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Rt
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Rd_L
add wave -noupdate -expand -group IFetch -radix hexadecimal /mips_tb/U_0/IFE/Op
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1950000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 320
configure wave -valuecolwidth 62
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {803100 ps}
