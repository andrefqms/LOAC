
logic cancela_entrada, cancela_saida;
logic reset;
enum logic[2:0]{entrada_aberta,saida_aberta,cancelas_fechadas}estado_atual;

logic[3:0] num_carros;

always_comb begin
	cancela_entrada <= SWI[0];
	cancela_saida <= SWI[7];
	reset <= SWI[3];
end

always_ff @(posedge clk_2)begin
	if(reset)begin
		estado_atual <= cancelas_fechadas;
		num_carros <= 0;
	end
	else unique case(estado_atual)
		cancelas_fechadas: begin
			if(cancela_entrada && num_carros < 10) 
				estado_atual <= entrada_aberta;
			else if(cancela_saida && num_carros > 0)
				 estado_atual <= saida_aberta;
		end
		entrada_aberta: begin
			if(!cancela_entrada)begin
				 num_carros <= num_carros + 1;
				 estado_atual <= cancelas_fechadas;
			end
		end
		saida_aberta: begin
			if(!cancela_saida)begin
				num_carros <= num_carros -1;
				estado_atual <= cancelas_fechadas;
			end
		end
	endcase
end

always_comb begin
	LED[6:3]<=num_carros ;
	LED[0]<= (estado_atual == entrada_aberta);
	LED[1]<= (estado_atual == saida_aberta);
	LED[7]<=clk_2;
	
end
