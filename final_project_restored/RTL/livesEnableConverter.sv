

module	livesEnableConverter	(	
 
					input	logic	clk,
					input	logic	resetN,

					input logic [1:0] liveCount,
					output logic [7:0] enableLives
					
					
);

//////////--------------------------------------------------------------------------------------------------------------=




always_ff @(posedge clk, negedge resetN) begin
		if (!resetN) begin
		enableLives <= 8'b00000111;
		end
		else begin
			if (liveCount == 2'b11)
				enableLives <= 8'b00000111;
			else if(liveCount == 2'b10)
				enableLives <= 8'b00000011;
			else if(liveCount == 2'b01)
				enableLives <= 8'b00000001;
			else	
				enableLives <= 8'b00000000;
		end
end

endmodule
			
			




