parameter NINSTR_BITS = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NINSTR_BITS-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  parameter INICIO = 0, COPIANDO = 1, ENTUPIDA = 2, SEM_PAPEL = 3;
  logic[2:0] estado_atual;
  logic[1:0] quantidade, contador_copiadas;
  logic reset, copiar, papel, fora, tampa;

  logic saida, falta, entupida;

  always_comb begin
    reset <= SWI[7];
    copiar <= SWI[0];
    quantidade <= SWI[2:1];
    papel <= SWI[4];
    fora <= SWI[5];
    tampa <= SWI[6];
    estado_atual <= INICIO;
    contador_copiadas <= 0;
    saida <= 0;
    falta <= 0;
    entupida <= 0;
  end

  always_ff @(posedge clk_2 or posedge reset) begin
    if (reset) begin
      estado_atual = INICIO;
      contador_copiadas = 0;
    end
    else begin
      unique case(estado_atual)
        INICIO: begin
          if (copiar && quantidade > 0) begin
            contador_copiadas = quantidade;
            estado_atual = COPIANDO;
          end
        end
        COPIANDO: begin
          if (contador_copiadas > 0) begin
            saida = 1;
            if (!papel) begin
              saida = 0;
              falta = 1;
              estado_atual = SEM_PAPEL;
            end
            else if (fora) begin
              saida = 0;
              entupida = 1;
              estado_atual = ENTUPIDA;
            end
            else if (!tampa) contador_copiadas = contador_copiadas - 1;
          end
          else begin
            saida = 0;
            estado_atual = INICIO;
          end
        end
        ENTUPIDA: begin
          if (tampa && !fora) begin
            entupida = 0;
            estado_atual = COPIANDO;
          end
        end
        SEM_PAPEL: begin
          if (papel) begin
            saida = 1;
            falta = 0;
            estado_atual = COPIANDO;
          end
        end
      endcase
    end
  end

  always_comb begin
    LED[7] <= clk_2;

    LED[0] <= saida;
    LED[1] <= falta;
    LED[2] <= entupida;

    unique case(estado_atual)
      INICIO: SEG[6:0] <= 7'b0111111;
      COPIANDO: SEG[6:0] <= 7'b0000110;
      ENTUPIDA: SEG[6:0] <= 7'b1011011;
      SEM_PAPEL: SEG[6:0] <= 7'b1001111;
    endcase
  end

endmodule
