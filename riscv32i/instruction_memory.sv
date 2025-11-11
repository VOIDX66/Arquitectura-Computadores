// ============================================================
// RISC-V MONOCICLO - INSTRUCTION MEMORY
// ------------------------------------------------------------
// Memoria de solo lectura (ROM) de instrucciones.
// Sintetizable en FPGA (usa $readmemh para inicializar).
//
// Entradas:
//   Address      -> dirección del PC (en bytes)
// Salidas:
//   Instruction  -> instrucción leída (32 bits)
//
// Convención:
//   - Cada instrucción ocupa 4 bytes (32 bits).
//   - Address[31:2] se usa como índice porque las
//     instrucciones están alineadas a 4 bytes.
// ============================================================

module INSTRUCTION_MEMORY (
  input  logic [31:0] Address,        // dirección del PC
  output logic [31:0] Instruction     // instrucción leída
);

  // Memoria ROM de 256 palabras (1 KB)
  logic [31:0] memory [0:255];

  // Inicialización desde archivo externo (sintetizable)
  // El archivo debe estar incluido en el proyecto Quartus.
  initial begin
    $readmemh("program.hex", memory);
  end

  // Lectura combinacional (ROM)
  assign Instruction = memory[Address[31:2]];

endmodule
