// ============================================================
// TESTBENCH - RISC-V MONOCICLO
// ------------------------------------------------------------
// Testbench minimalista para simulación en GTKWave.
// Genera el reloj, instancia el procesador y guarda
// las señales principales en un archivo .vcd
// ============================================================

`timescale 1ns/1ps

module riscv_tb;

  // ============================
  // Señales del testbench
  // ============================
  logic clk;

  // ============================
  // Instancia del procesador
  // ============================
  RISCV dut (
    .clk(clk)
  );

  // ============================
  // Generador de reloj
  // ============================
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // periodo = 10ns (100 MHz)
  end

  // ============================
  // Control de simulación
  // ============================
  initial begin
    // Archivo de salida para GTKWave
    $dumpfile("riscv.vcd");
    $dumpvars(0, riscv_tb);

    // Duración de simulación (ajustable)
   #5000;  // 5 microsegundos
    $finish;
  end

endmodule
