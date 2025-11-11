// ============================================================
// RISC-V MONOCICLO - DATA MEMORY
// ------------------------------------------------------------
// Memoria de datos con escritura SINCRÓNICA (con reloj)
// y lectura COMBINACIONAL (sin reloj).
// ============================================================

module DATA_MEMORY (
  input  logic        clk,     // <<<--- 1. AÑADIR LA ENTRADA DE RELOJ
  input  logic [31:0] Address,
  input  logic [31:0] DataWr,
  input  logic        DMWr,
  input  logic [2:0]  DMCtrl,
  output logic [31:0] DataRd
);

  // Memoria de 256 palabras (1 KB)
  logic [31:0] memory [0:255];

  // Índice por palabra (Address / 4)
  logic [7:0] word_index;
  assign word_index = Address[31:2];

  // ============================================================
  // Escritura sincrónica (CORREGIDA)
  // ============================================================
  always_ff @(posedge clk) begin   // <<<--- 2. DISPARAR CON EL RELOJ
    if (DMWr) begin                // <<<--- 3. USAR DMWr COMO ENABLE
      case (DMCtrl)
        3'b000, 3'b100: begin // Byte
          memory[word_index][(Address[1:0]*8)+:8] <= DataWr[7:0];
        end

        3'b001, 3'b101: begin // Halfword
          memory[word_index][(Address[1]*16)+:16] <= DataWr[15:0];
        end

        3'b010: begin // Word
          memory[word_index] <= DataWr;
        end
      endcase
    end
  end

  // ============================================================
  // Lectura combinacional (Sin cambios, esto estaba bien)
  // ============================================================
  logic [31:0] temp_word;
  assign temp_word = memory[word_index];

  always @(*) begin
    case (DMCtrl)
      3'b000: DataRd = {{24{temp_word[(Address[1:0]*8+7)]}}, temp_word[(Address[1:0]*8)+:8]};  // Byte (signed)
      3'b001: DataRd = {{16{temp_word[(Address[1]*16+15)]}}, temp_word[(Address[1]*16)+:16]}; // Halfword (signed)
      3'b010: DataRd = temp_word;                                                              // Word
      3'b100: DataRd = {24'b0, temp_word[(Address[1:0]*8)+:8]};                               // Byte (unsigned)
      3'b101: DataRd = {16'b0, temp_word[(Address[1]*16)+:16]};                               // Halfword (unsigned)
      default: DataRd = 32'b0;
    endcase
  end

  // ============================================================
  // Inicialización (Sin cambios)
  // ============================================================
  initial begin
    static string filename = "data.mem";
    integer fd;
    integer i;
    reg [31:0] value;

    fd = $fopen(filename, "r");
    if (fd) begin
      $display("Inicializando Data Memory desde %s ...", filename);
      i = 0;
      // Leer línea a línea sin usar $readmemh
      while (!$feof(fd) && i < 256) begin
        void'($fscanf(fd, "%h\n", value));
        memory[i] = value;
        i++;
      end
      $fclose(fd);
      $display("Data Memory cargada correctamente (%0d palabras).", i);
    end else begin
      $display("No se encontró %s, se inicializa vacía.", filename);
    end
  end

endmodule