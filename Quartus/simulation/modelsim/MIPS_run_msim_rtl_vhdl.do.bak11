transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/dff_en.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/dff.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/Ndff_en.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/Ndff.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/BCD.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/DELAY_REG.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/WBACK.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/IFETCH.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/IDECODE.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/Floating_point_mul.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/Floating_point_adder.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/FP_top.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/EXECUTE.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/DMEMORY.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/CONTROL.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/VHDL/MIPS.vhd}

vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/Quartus/../tb/mips_tester_struct.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/CPU_arch-MIPS/Quartus/../tb/mips_tb_struct.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  MIPS_tb

add wave *
view structure
view signals
run 20 us
