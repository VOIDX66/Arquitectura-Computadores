// ============================================================
// RISC-V MONOCICLO - UNIDAD DE CONTROL PRINCIPAL
// ------------------------------------------------------------
// Genera las señales de control para el datapath monociclo.
// Las señales siguen EXACTAMENTE los nombres y codificaciones
// definidas por el diseño del usuario (Jaider).
// ------------------------------------------------------------
// NextPCSrc es responsabilidad de la Branch Unit (no se maneja aquí).
// ============================================================

module CONTROL_UNIT (
  input  logic [6:0] opcode,
  input  logic [2:0] funct3,
  input  logic [6:0] funct7,

  // --- Señales de control ---
  output logic        RUWr,           // 1 = escribir registro destino
  output logic [1:0]  RUDataWrSrc,    // 00=ALURes, 01=DataMem, 10=PC+4
  output logic        DMWr,           // 1 = escribir en memoria de datos
  output logic [2:0]  DMCtrl,         // control tamaño/signed (B/H/W)
  output logic        ALUASrc,        // 0=rs1, 1=PC
  output logic        ALUBSrc,        // 0=rs2, 1=ImmExt
  output logic [3:0]  ALUOp,          // operación ALU (códigos definidos)
  output logic [2:0]  ImmSrc,         // tipo de inmediato (I,S,B,U,J)
  output logic [4:0]  BrOp            // operación branch (entrada a Branch Unit)
);

  // ------------------------------------------------------------
  // Defaults
  // ------------------------------------------------------------
  always_comb begin
    RUWr         = 1'b0;
    RUDataWrSrc  = 2'b00;
    DMWr         = 1'b0;
    DMCtrl       = 3'b000;
    ALUASrc      = 1'b0;
    ALUBSrc      = 1'b0;
    ALUOp        = 4'b0000;
    ImmSrc       = 3'b000;
    BrOp         = 5'b00000;

    case (opcode)
      // =========================================================
      // R-TYPE (0110011)
      // =========================================================
      7'b0110011: begin
        RUWr        = 1'b1;
        RUDataWrSrc = 2'b00;
        ALUASrc     = 1'b0;
        ALUBSrc     = 1'b0;
        ImmSrc      = 3'b000;
        BrOp        = 5'b00000;

        case (funct3)
          3'b000: ALUOp = (funct7 == 7'b0100000) ? 4'b1000 : 4'b0000; // sub/add
          3'b001: ALUOp = 4'b0001; // sll
          3'b010: ALUOp = 4'b0010; // slt
          3'b011: ALUOp = 4'b0011; // sltu
          3'b100: ALUOp = 4'b0100; // xor
          3'b101: ALUOp = (funct7 == 7'b0100000) ? 4'b1101 : 4'b0101; // sra/srl
          3'b110: ALUOp = 4'b0110; // or
          3'b111: ALUOp = 4'b0111; // and
          default: ALUOp = 4'b0000;
        endcase
      end

      // =========================================================
      // I-TYPE (0010011)
      // =========================================================
      7'b0010011: begin
        RUWr        = 1'b1;
        RUDataWrSrc = 2'b00;   // resultado de ALU
        DMWr        = 1'b0;
        ALUASrc     = 1'b0;    // rs1
        ALUBSrc     = 1'b1;    // inmediato extendido
        ImmSrc      = 3'b000;  // tipo I
        BrOp        = 5'b00000;

        // Operación según funct3 / funct7 (para shifts)
        case (funct3)
          3'b000: ALUOp = 4'b0000; // ADDI
          3'b010: ALUOp = 4'b0010; // SLTI
          3'b011: ALUOp = 4'b0011; // SLTIU
          3'b100: ALUOp = 4'b0100; // XORI
          3'b110: ALUOp = 4'b0110; // ORI
          3'b111: ALUOp = 4'b0111; // ANDI
          3'b001: ALUOp = 4'b0001; // SLLI (funct7 = 0000000)
          3'b101: ALUOp = (funct7 == 7'b0100000) ? 4'b1101 : 4'b0101; // SRAI/SRLI
          default: ALUOp = 4'b0000;
        endcase
      end

      // =========================================================
      // LOAD (0000011)
      // =========================================================
      7'b0000011: begin
        RUWr        = 1'b1;
        RUDataWrSrc = 2'b01; // DataMem
        DMWr        = 1'b0;
        ALUASrc     = 1'b0;
        ALUBSrc     = 1'b1; // ImmExt
        ALUOp       = 4'b0000; // A + imm
        ImmSrc      = 3'b000; // tipo I
        BrOp        = 5'b00000;

        case (funct3)
          3'b000: DMCtrl = 3'b000; // LB
          3'b001: DMCtrl = 3'b001; // LH
          3'b010: DMCtrl = 3'b010; // LW
          3'b100: DMCtrl = 3'b100; // LBU
          3'b101: DMCtrl = 3'b101; // LHU
          default: DMCtrl = 3'b010;
        endcase
      end

      // =========================================================
      // STORE (0100011)
      // =========================================================
      7'b0100011: begin
        RUWr        = 1'b0;
        DMWr        = 1'b1;
        ALUASrc     = 1'b0;
        ALUBSrc     = 1'b1;
        ALUOp       = 4'b0000;
        ImmSrc      = 3'b001; // tipo S
        BrOp        = 5'b00000;

        case (funct3)
          3'b000: DMCtrl = 3'b000; // SB
          3'b001: DMCtrl = 3'b001; // SH
          3'b010: DMCtrl = 3'b010; // SW
          default: DMCtrl = 3'b010;
        endcase
      end

      // =========================================================
      // BRANCH (1100011)
      // =========================================================
      7'b1100011: begin
        RUWr        = 1'b0;
        DMWr        = 1'b0;
        ALUASrc     = 1'b1;
        ALUBSrc     = 1'b1;
        ALUOp       = 4'b0000; // A - B
        ImmSrc      = 3'b101; // tipo B

        // BrOp codificado (NextPCSrc lo decide Branch Unit)
        case (funct3)
          3'b000: BrOp = 5'b01000; // beq
          3'b001: BrOp = 5'b01001; // bne
          3'b100: BrOp = 5'b01100; // blt
          3'b101: BrOp = 5'b01101; // bge
          3'b110: BrOp = 5'b01110; // bltu
          3'b111: BrOp = 5'b01111; // bgeu
          default: BrOp = 5'b00000;
        endcase
      end

      // =========================================================
      // JUMP (1101111) JAL
      // =========================================================
      7'b1101111: begin
        RUWr        = 1'b1;
        RUDataWrSrc = 2'b10; // PC+4
        ALUASrc     = 1'b1; //Address
        ALUBSrc     = 1'b1; // Inmediato
        ImmSrc      = 3'b110; // tipo J
        ALUOp       = 4'b0000;
        DMWr        = 1'b0;
        DMCtrl      = 3'b000;
        BrOp        = 5'b10000; // salto incondicional (manejado por Branch Unit)
      end

      // =========================================================
      // JALR (1100111)
      // =========================================================
      7'b1100111: begin
        RUWr        = 1'b1;
        RUDataWrSrc = 2'b10; // PC+4
        ALUASrc     = 1'b0;
        ALUBSrc     = 1'b1; // ImmExt
        ImmSrc      = 3'b000; // tipo I
        ALUOp       = 4'b0000; // A + imm
        BrOp        = 5'b10000; // salto incondicional
      end

      // =========================================================
      // LUI (0110111)
      // =========================================================
      7'b0110111: begin
        RUWr        = 1'b1;
        RUDataWrSrc = 2'b00; // ALURes
        ALUASrc     = 1'b0;
        ALUBSrc     = 1'b1;
        ImmSrc      = 3'b010; // tipo U
        ALUOp       = 4'b0000; // A + imm (A=0 en datapath)
        BrOp        = 5'b00000;
      end

      // =========================================================
      // AUIPC (0010111)
      // =========================================================
      7'b0010111: begin
        RUWr        = 1'b1;
        RUDataWrSrc = 2'b00;
        ALUASrc     = 1'b1; // PC
        ALUBSrc     = 1'b1; // ImmExt
        ImmSrc      = 3'b010; // tipo U
        ALUOp       = 4'b0000; // PC + imm
        BrOp        = 5'b00000;
      end

      // =========================================================
      // DEFAULT (NOP)
      // =========================================================
      default: begin
        // valores por defecto
      end
    endcase
  end
endmodule
