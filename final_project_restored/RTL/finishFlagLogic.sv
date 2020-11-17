

//controlls the appearence of the finish flag
module	finishFlagLogic	(	
 
					input	logic	clk,
					input	logic	resetN,

					input logic [1:0] levelCode,
					input logic [3:0] score,
					
					output	flagEnable
);



//////////--------------------------------------------------------------------------------------------------------------=


localparam LEVEL_ONE = 2'b00;
localparam LEVEL_TWO = 2'b01;


always_comb begin
	if(!resetN)	begin
		flagEnable <= 1'b0;	
	end
	else begin
		if (score >= 4 && levelCode == LEVEL_ONE) begin
			flagEnable <= 1'b1;
		end
		else if (score >= 6 && levelCode == LEVEL_TWO) begin
			flagEnable <= 1'b1;
		end		
		else begin
			flagEnable <= 1'b0;;
		end
	end
end

endmodule




