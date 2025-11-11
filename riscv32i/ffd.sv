/* Sincronizacion de las señales en los modulos en los que se va a escribir algo en memoria */
module FFD(
    input logic clk,
    input logic reset, // Siempre que este en 1 la salida de Q será cero

    input logic d,

    output logic q,
    output logic q_n
);
    always @(posedge clk) begin
        if(reset)
            q <= 1'b0;
        else
            q <= d;
    end

    assign q_n = ~q;

endmodule
