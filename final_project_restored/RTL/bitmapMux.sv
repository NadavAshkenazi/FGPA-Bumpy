

module	bitmapMux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic [1:0] levelCode,
					
					
					input		logic	DrawingRequest0,
					input		logic	[7:0] RGB0,
					
					input		logic	DrawingRequest1,
					input		logic	[7:0] RGB1, 
					
					output 	logic drawingRequest_out,
					output	logic [7:0] RGBout,
					output	logic	levelTwoFlag //debug
					

);


localparam 	LEVEL_ONE = 2'b00;
localparam	LEVEL_TWO = 2'b01;
//logic	levelTwoFlag;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBout	<= 8'b0;
			drawingRequest_out <= 1'b0;
			levelTwoFlag <= 1'b0;
	end
	else begin
		if (levelCode == LEVEL_ONE) begin
			RGBout <= RGB0 ; 
			drawingRequest_out <= DrawingRequest0;
			levelTwoFlag <= 1'b0;
		end

		else if (levelCode == LEVEL_TWO) begin
			RGBout <= RGB1 ; 
			drawingRequest_out <= DrawingRequest1;
			levelTwoFlag <= 1'b1;
		end
		else if (levelTwoFlag) begin
			RGBout <= RGB1 ; 
			drawingRequest_out <= DrawingRequest1;
			levelTwoFlag <= 1'b1;		
		end
		else begin
			RGBout <= RGB0 ; 
			drawingRequest_out <= DrawingRequest0;
			levelTwoFlag <= 1'b0;
		end
	end  
end


//
//always_comb
//begin
//	if(!resetN) begin
//			RGBout	= 8'b0;
//			drawingRequest_out = 1'b0;
//	end
//	else begin
//		if (levelCode == LEVEL_ONE) begin
//			RGBout = RGB0; 
//		end
//		else if (levelCode == LEVEL_TWO) begin
//			RGBout = RGB1; 
//		end
//		else begin
//			RGBout = RGBout;
//		end
//	end  
//end

endmodule


