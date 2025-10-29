module IMM_GEN(
    input  logic [24:0] Instr,     // Instrucción sin opcode (bits [31:7])
    input  logic [2:0]  ImmSrc,    // Selecciona tipo de inmediato
    output logic [31:0] ImmExt
);

    logic [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

    // --- Mapeo de inmediatos basado en la imagen ---
    // La entrada Instr[24:0] corresponde a los bits [31:7] de la instrucción
 
    // I-type: Imm[11:0] = Instr[31:20]
    // Signo: Instr[31] -> Instr[24]
    // Datos: Instr[30:20] -> Instr[23:13]
    assign imm_i = {{20{Instr[24]}}, Instr[24:13]};

    // S-type: Imm[11:5] = Instr[31:25], Imm[4:0] = Instr[11:7]
    // Signo: Instr[31] -> Instr[24]
    // Datos: Instr[30:25] -> Instr[23:18]
    // Datos: Instr[11:7] -> Instr[4:0]
    assign imm_s = {{20{Instr[24]}}, Instr[23:18], Instr[4:0]};

    // B-type: Imm[12,10:5] = Instr[31:25], Imm[4:1,11] = Instr[11:7]
    // Signo: Instr[31] -> Instr[24] (Imm[12])
    // Datos: Instr[7] -> Instr[0] (Imm[11])
    // Datos: Instr[30:25] -> Instr[23:18] (Imm[10:5])
    // Datos: Instr[11:8] -> Instr[4:1] (Imm[4:1])
    assign imm_b = {{19{Instr[24]}}, Instr[24], Instr[0], 
                    Instr[23:18], Instr[4:1], 1'b0};

    // U-type: Imm[31:12] = Instr[31:12]
    // Datos: Instr[31:12] -> Instr[24:5]
    assign imm_u = {Instr[24:5], 12'b0};

    // J-type: Imm[20,10:1,11,19:12]
    // Signo: Instr[31] -> Instr[24] (Imm[20])
    // Datos: Instr[19:12] -> Instr[12:5] (Imm[19:12])
    // Datos: Instr[20] -> Instr[13] (Imm[11])
    // Datos: Instr[30:21] -> Instr[23:14] (Imm[10:1])
    assign imm_j = {{11{Instr[24]}}, Instr[24], Instr[12:5], 
                    Instr[13], Instr[23:14], 1'b0};

    // Multiplexor final (sin cambios)
    assign ImmExt = (ImmSrc == 3'b000) ? imm_i :
                    (ImmSrc == 3'b001) ? imm_s :
                    (ImmSrc == 3'b101) ? imm_b :
                    (ImmSrc == 3'b010) ? imm_u :
                    (ImmSrc == 3'b110) ? imm_j :
                    32'd0;

endmodule