

module	bitmapFourMux	(	
					input		logic	clk,
					input		logic	resetN,
					input		logic [1:0] levelCode,
					
					
					input		logic	DrawingRequest0,
					input		logic	[7:0] RGB0,
					
					input		logic	DrawingRequest1,
					input		logic	[7:0] RGB1,

					input		logic	DrawingRequest2,
					input		logic	[7:0] RGB2,

					input		logic	DrawingRequest3,
					input		logic	[7:0] RGB3,					
					
					output 	logic drawingRequest_out,
					output	logic [7:0] RGBout
					

);

localparam 	LEVEL_ONE = 2'b00;
localparam	LEVEL_TWO = 2'b01;
localparam	WIN = 2'b10;
localparam	GAME_OVER = 2'b11;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBout	<= 8'b0;
			drawingRequest_out <= 1'b0;
	end
	else begin
		if (levelCode == LEVEL_ONE) begin
			RGBout <= RGB0; 
			drawingRequest_out <= DrawingRequest0;
		end

		else if (levelCode == LEVEL_TWO) begin
			RGBout <= RGB1; 
			drawingRequest_out <= DrawingRequest1;
		end
		
		else if (levelCode == WIN) begin
			RGBout <= RGB2; 
			drawingRequest_out <= DrawingRequest2;
		end
		
		else if (levelCode == GAME_OVER) begin
			RGBout <= RGB3; 
			drawingRequest_out <= DrawingRequest3;
		end
		else begin
			RGBout <= RGB0 ; 
			drawingRequest_out <= DrawingRequest0;
		end
	end  
end

endmodule


