transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/dff.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/Ndff.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/BCD.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/DELAY_REG.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/IFETCH.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/IDECODE.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/EXECUTE.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/WBACK.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/DMEMORY.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/CONTROL.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/VHDL/MIPS.vhd}

vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/Quartus/../tb/mips_tester_struct.vhd}
vcom -93 -work work {C:/Users/amitb/Desktop/ass3/project_main/Quartus/../tb/mips_tb_struct.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  MIPS_tb

add wave *
view structure
view signals
run 20 us
