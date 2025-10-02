module ALU(
    input logic signed [31:0] A,
    input logic signed [31:0] B,

    input logic [3:0] ALUOp,

    output logic signed [31:0] ALURes = 0
);

    always @*begin
        case(ALUOp)
            4'b0000 : ALURes = A + B;
            4'b1000 : ALURes = A - B;
            4'b0001 : ALURes = A << B;
            4'b0010 : ALURes = A < B;
            4'b0011 : ALURes = $unsigned(A) < $unsigned(B);
            4'b0100 : ALURes = A ^ B;
            4'b0101 : ALURes = A >> B;
            4'b1101 : ALURes = A >>> B;
            4'b0110 : ALURes = A | B;
            4'b0111 : ALURes = A & B;
            4'b1001 : ALURes = B;
        endcase
    end
endmodule
