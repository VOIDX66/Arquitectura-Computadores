# ============================================================
# RISC-V MONOCICLO - Makefile
# ------------------------------------------------------------
# Comandos:
#   make          -> compila y simula
#   make view     -> abre GTKWave
#   make clean    -> borra temporales
# ============================================================

# Archivos fuente
SRC = \
  riscv_tb.sv \
  riscv.sv \
  pc.sv \
  instruction_memory.sv \
  control_unit.sv \
  imm_gen.sv \
  reg_unit.sv \
  alu.sv \
  data_memory.sv \
  branch_unit.sv

# Archivos de salida
OUT = riscv_tb.vvp
VCD = riscv.vcd

# Simulador
IVERILOG = iverilog -g2012
VVP = vvp
GTK = gtkwave

# ============================================================
# Targets principales
# ============================================================

# Compila y simula
all: $(OUT)
	@echo "🚀 Ejecutando simulación..."
	$(VVP) $(OUT)

# Compilación
$(OUT): $(SRC)
	@echo "🛠️  Compilando proyecto..."
	$(IVERILOG) -o $(OUT) $(SRC)

# Abrir GTKWave
view:
	@echo "👀 Abriendo GTKWave..."
	$(GTK) $(VCD) &

# Limpiar archivos generados
clean:
	@echo "🧹 Limpiando archivos temporales..."
	rm -f $(OUT) $(VCD)

.PHONY: all view clean
