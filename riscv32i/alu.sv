// ============================================================
// RISC-V MONOCICLO – ALU
// ============================================================

module ALU(
    input  logic signed [31:0] A,
    input  logic signed [31:0] B,
    input  logic        [3:0]  ALUOp,
    output logic signed [31:0] ALURes
);

    always_comb begin
        ALURes = 32'b0;  // valor por defecto (evita latches)

        case (ALUOp)
            4'b0000 : ALURes = A + B;                           // ADD
            4'b1000 : ALURes = A - B;                           // SUB
            4'b0001 : ALURes = A <<  $unsigned(B[4:0]);         // SLL
            4'b0010 : ALURes = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT
            4'b0011 : ALURes = ($unsigned(A) < $unsigned(B)) ? 32'd1 : 32'd0; // SLTU
            4'b0100 : ALURes = A ^ B;                           // XOR
            4'b0101 : ALURes = A >>  $unsigned(B[4:0]);         // SRL
            4'b1101 : ALURes = A >>> $unsigned(B[4:0]);         // SRA
            4'b0110 : ALURes = A | B;                           // OR
            4'b0111 : ALURes = A & B;                           // AND
            4'b1001 : ALURes = B;                               // LUI / bypass
            default : ALURes = 32'b0;                           // default (sin latch)
        endcase
    end
endmodule
