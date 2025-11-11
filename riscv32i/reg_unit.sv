module REG_UNIT(

    input logic [4:0] rs1,
    input logic [4:0] rs2,

    input logic [4:0] rd,
    input logic [31:0] DataWr,
    input logic RUWr,

    input logic clk,

    output logic [31:0] RU_rs1,
    output logic [31:0] RU_rs2
);
    logic [31:0] ru [31:0];

    initial begin
        ru[2] = 32'b1000000000;
    end

    assign RU_rs1 = (rs1 == 5'b00000) ? 32'd0 : ru[rs1];
    assign RU_rs2 = (rs2 == 5'b00000) ? 32'd0 : ru[rs2];

    always @(posedge clk) begin
        if (RUWr && rd != 5'b00000) begin
            ru[rd] <= DataWr;
        end
    end
endmodule
