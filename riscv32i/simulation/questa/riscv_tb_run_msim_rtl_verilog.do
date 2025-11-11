transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/reg_unit.sv}
vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/branch_unit.sv}
vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/imm_gen.sv}
vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/pc.sv}
vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/alu.sv}
vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/riscv.sv}
vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/control_unit.sv}
vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/data_memory.sv}
vlog -sv -work work +incdir+/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i {/home/void/Documentos/Github/Arquitectura-Computadores/riscv32i/instruction_memory.sv}

