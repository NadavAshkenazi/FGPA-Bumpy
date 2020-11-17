
//module to select between sound modules
module	soundMux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic [1:0] levelCode,
					input		logic	enableSound,
					
					
					input		logic	enable_out0,
					input		logic	[3:0] tone0,
					
					input		logic	enable_out1,
					input		logic	[3:0] tone1,
					
					output 	logic enable_out,
					output	logic [3:0] tone
					

);


logic flag;
localparam 	WIN = 2'b10;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			enable_out <= enable_out0;
			tone <= tone0;
			flag <= 1'b0;
	end
	else if (enableSound) begin
		if (levelCode == WIN) begin
			enable_out <= enable_out1;
			tone <= tone1;
			flag <= 1'b1;
		end
		else begin
			enable_out <= enable_out0;
			tone <= tone0;
			flag <= 1'b0;
		end
	end

	else begin
		enable_out <= enable_out0;
		tone <= tone0;
		flag <= 1'b0;
	end
end




endmodule


