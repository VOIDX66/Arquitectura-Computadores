// ============================================================
// RISC-V MONOCICLO - INSTRUCTION MEMORY
// ------------------------------------------------------------
// Memoria de solo lectura (ROM) de instrucciones.
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

  // Memoria de 256 palabras de 32 bits (1 KB)
  logic [31:0] memory [0:255];

  // Lectura combinacional (ROM)
  assign Instruction = memory[Address[31:2]];

  // ============================================================
  // Inicialización desde archivo externo
  // ============================================================
  // Formato del archivo:
  //   - Una instrucción por línea, en hexadecimal.
  //   - Ejemplo (program.mem):
  //       00000093  // addi x1, x0, 0
  //       00100113  // addi x2, x0, 1
  //       002081B3  // add  x3, x1, x2
  // ============================================================

  initial begin
    static string filename = "program.mem";
    integer fd;
    integer i;
    reg [31:0] value;

    fd = $fopen(filename, "r");
    if (fd) begin
      $display("Inicializando Instruction Memory desde %s ...", filename);
      i = 0;
      // Leer línea a línea sin usar $readmemh
      while (!$feof(fd) && i < 256) begin
        void'($fscanf(fd, "%h\n", value));
        memory[i] = value;
        i++;
      end
      $fclose(fd);
      $display("Instruction Memory cargada correctamente (%0d palabras).", i);
    end else begin
      $display("No se encontró %s, se inicializa vacía.", filename);
    end
  end



endmodule
