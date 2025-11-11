// ============================================================
// RISC-V MONOCICLO - PROGRAM COUNTER (PC)
// ------------------------------------------------------------
// Contador de programa simple sin señal de reset.
// Cada flanco positivo de reloj actualiza PC con NextPC.
// ============================================================

module PC (
  input  logic        clk,       // reloj del sistema
  input  logic [31:0] NextPC,    // próximo valor de PC
  output logic [31:0] PC         // valor actual del PC
);
  initial PC = 0;
  always_ff @(posedge clk) begin
    PC <= NextPC;
  end

endmodule