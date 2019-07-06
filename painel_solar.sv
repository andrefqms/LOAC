logic reset;
enum logic[3:0] {DESLIGADO,PAINEL_SOLAR,REDE_ELETRICA} estado;
logic[1:0] sol;
logic[3:0] cont;
always_comb begin
	reset <= SWI[0];
	sol <= SWI[1];
end
always_ff @(posedge clk_2) begin
	if(reset) begin
		estado <= DESLIGADO;
		cont <= 0;
	end
	else begin
		unique case(estado)
		DESLIGADO: begin
		if(sol && cont == 0) begin
			estado <= PAINEL_SOLAR;
		end
		else if(!sol) begin
			cont <= cont + 1;
		end
		else if(sol && cont == 2) begin
			estado <= PAINEL_SOLAR;
		end
		else if(sol && cont == 3) begin
			estado <= PAINEL_SOLAR;
		end
		if(cont > 3) estado <= REDE_ELETRICA;
		end
		PAINEL_SOLAR: begin
		if(cont == 0) begin	
			estado <= DESLIGADO;
		end
		else if(cont > 0) begin
			cont <= cont - 1;
		end
		end
		REDE_ELETRICA: begin
		if(sol) begin
		cont <= 0;
		estado <= PAINEL_SOLAR;
		end
		end
		endcase
	end
end
always_comb begin
	LED[0] <= (estado==REDE_ELETRICA);
	LED[1] <= (estado==PAINEL_SOLAR);
	SEG[7] <= clk_2;
	LED[2] <= (estado==DESLIGADO);
	LED[6:3] <= cont;
end

endmodule
