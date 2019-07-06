
logic reset;
enum logic[2:0] {sem_cartao,com_cartao,digito1,digito2,recebe_dinheiro,explode} estado;
logic[6:4] codigo;
logic[2:0] num_tentativas;
logic colocou_cartao;
logic dinheiro;
logic destroi;
always_comb begin
	codigo <= SWI[6:4];
	reset <= SWI[0];
	colocou_cartao <= SWI[1];
end
always_ff @(posedge clk_2) begin
	if(reset) begin
		dinheiro <= 0;
		destroi <= 0;
		num_tentativas <= 0;
		estado <= sem_cartao;
	end
	else begin
		unique case (estado)
			sem_cartao: begin
			if(colocou_cartao) begin
				estado <= com_cartao;
				end
			end
			com_cartao: begin
				if(codigo[6:4]) begin
				estado <= digito1;
				end
				else if(codigo[6:5] || codigo[6:6]) num_tentativas <= num_tentativas + 1;
				if(num_tentativas > 4 ) estado <= explode;
			end
			digito1: begin
				if(codigo[6:5]) begin
				estado <= digito2;	
				end
				else if (!codigo[6:4] || codigo[6:6])num_tentativas <= num_tentativas + 1;
				if(num_tentativas > 4 ) estado <= explode;
				end
			digito2:begin
				if(codigo[6:6]) begin
				estado <= recebe_dinheiro;	
				end
				else if( !codigo[6:4] || !codigo[6:5])num_tentativas <= num_tentativas + 1;
				if(num_tentativas > 4 ) estado <= explode;
			end
			recebe_dinheiro:begin
				dinheiro <= 1;	
			end
			explode:begin
				destroi <= 1;	
			end
		endcase
		
	end
end

always_comb begin
	LED[0] <= dinheiro;
	LED[1] <= destroi;
	LED[7] <= clk_2;
	
end
