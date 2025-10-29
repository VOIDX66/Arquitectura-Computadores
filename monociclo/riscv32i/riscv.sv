// ============================================================
// RISC-V MONOCICLO - TOP LEVEL
// ------------------------------------------------------------
// Integra todos los módulos del procesador:
//   - PC
//   - Instruction Memory
//   - Control Unit
//   - ImmGen
//   - ALU
//   - Data Memory
//   - Branch Unit
//   - Unidad de Registros (RU)
// ============================================================

module RISCV (
  input  logic clk    // reloj principal del sistema
);

  // =======================
  // 1. Señales internas
  // =======================
  logic [31:0] PC, NextPC, PCplus4;
  logic [31:0] Instruction;
  logic [31:0] ImmExt;
  logic [31:0] DataRs1, DataRs2;
  logic [31:0] ALURes, DataRd;
  logic [31:0] RUDataWr;

  // Señales de control
  logic        RUWr;            // Write enable de registros
  logic [1:0]  RUDataWrSrc;     // Fuente de escritura
  logic        ALUASrc, ALUBSrc;
  logic [3:0]  ALUOp;
  logic [2:0]  ImmSrc;
  logic [4:0]  BrOp;
  logic        DMWr;
  logic [2:0]  DMCtrl;
  logic        NextPCSrc;

  // =======================
  // 2. PROGRAM COUNTER
  // =======================
  PC PCU (
    .clk(clk),
    .NextPC(NextPC),
    .PC(PC)
  );

  // =======================
  // 3. INSTRUCTION MEMORY
  // =======================
  INSTRUCTION_MEMORY IMEM (
    .Address(PC),
    .Instruction(Instruction)
  );

  // =======================
  // 4. CONTROL UNIT
  // =======================
  CONTROL_UNIT CU (
    .opcode(Instruction[6:0]),
    .funct3(Instruction[14:12]),
    .funct7(Instruction[31:25]),
    .RUWr(RUWr),
    .RUDataWrSrc(RUDataWrSrc),
    .DMWr(DMWr),
    .DMCtrl(DMCtrl),
    .ALUASrc(ALUASrc),
    .ALUBSrc(ALUBSrc),
    .ALUOp(ALUOp),
    .ImmSrc(ImmSrc),
    .BrOp(BrOp)
  );

  // =======================
  // 5. IMMGEN
  // =======================
  IMM_GEN IMM (
    .Instr(Instruction[31:7]),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
  );

  // =======================
  // 6. REGISTERS UNIT
  // =======================
  REG_UNIT RU (
    .clk(clk),
    .RUWr(RUWr),
    .rs1(Instruction[19:15]),
    .rs2(Instruction[24:20]),
    .rd(Instruction[11:7]),
    .DataWr(RUDataWr),
    .RU_rs1(DataRs1),
    .RU_rs2(DataRs2)
  );

  // =======================
  // 7. ALU INPUT MUXES
  // =======================
  logic [31:0] ALU_A, ALU_B;
  assign ALU_A = (ALUASrc) ? PC : DataRs1;
  assign ALU_B = (ALUBSrc) ? ImmExt : DataRs2;

  // =======================
  // 8. ALU
  // =======================
  ALU ALU (
    .A(ALU_A),
    .B(ALU_B),
    .ALUOp(ALUOp),
    .ALURes(ALURes)
  );

  // =======================
  // 9. DATA MEMORY
  // =======================
  DATA_MEMORY DMEM (
    .clk(clk),
    .Address(ALURes),
    .DataWr(DataRs2),
    .DMWr(DMWr),
    .DMCtrl(DMCtrl),
    .DataRd(DataRd)
  );

  // =======================
  // 10. BRANCH UNIT
  // =======================
  BRANCH_UNIT BU (
    .rs1(DataRs1),
    .rs2(DataRs2),
    .BrOp(BrOp),
    .NextPCSrc(NextPCSrc)
  );

  // =======================
  // 11. RUDATA WRITEBACK MUX
  // =======================
  always @(*) begin
    case (RUDataWrSrc)
      2'b00: RUDataWr = ALURes;   // Resultado de ALU
      2'b01: RUDataWr = DataRd;   // Lectura de Data Memory
      2'b10: RUDataWr = PCplus4;  // Retorno (jal / jalr)
      default: RUDataWr = 32'b0;
    endcase
  end

  // =======================
  // 12. NEXT PC LOGIC
  // =======================
  assign PCplus4 = PC + 32'd4;
  assign NextPC  = (NextPCSrc) ? ALURes : PCplus4;

endmodule
