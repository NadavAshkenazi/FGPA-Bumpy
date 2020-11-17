

module	clockBitmapMux	(	
					input		logic	clk,
					input		logic	resetN,	
					input		logic	startOfFrame,					

					
					input		logic	DrawingRequest0,
					input		logic	[7:0] RGB0,
					input		logic	[3:0] HitEdgeCode0, //one bit per edge 

					
					input		logic	DrawingRequest1,
					input		logic	[7:0] RGB1,
					input		logic	[3:0] HitEdgeCode1, //one bit per edge 


					input		logic	DrawingRequest2,
					input		logic	[7:0] RGB2,
					input		logic	[3:0] HitEdgeCode2, //one bit per edge 

					input		logic	DrawingRequest3,
					input		logic	[7:0] RGB3,					
					input		logic	[3:0] HitEdgeCode3, //one bit per edge 
					
					output 	logic drawingRequest_out,
					output	logic [7:0] RGBout,
					output	logic	[3:0] HitEdgeCode //one bit per edge 

					

);

int counter;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBout	<= 8'b0;
			drawingRequest_out <= 1'b0;
			counter <= 0;
			HitEdgeCode <= 0;
	end
	else begin
		if (startOfFrame) begin
			case (counter)
			
				0: begin
					RGBout <= RGB0; 
					drawingRequest_out <= DrawingRequest0;
					HitEdgeCode <= HitEdgeCode0;
					counter <= counter + 1;
				end
				
				1: begin
					RGBout <= RGB1; 
					drawingRequest_out <= DrawingRequest1;
					HitEdgeCode <= HitEdgeCode1;
					counter <= counter + 1;
				end
				
				2: begin
					RGBout <= RGB2; 
					drawingRequest_out <= DrawingRequest2;
					HitEdgeCode <= HitEdgeCode2;
					counter <= counter + 1;
				end
				
				2: begin
					RGBout <= 3; 
					drawingRequest_out <= DrawingRequest3;
					HitEdgeCode <= HitEdgeCode3;
					counter <= 0;
				end
				
				default begin
					RGBout <= RGB0; 
					drawingRequest_out <= DrawingRequest0;
					HitEdgeCode <= HitEdgeCode0;
					counter <= 0;
				end
			endcase
		end
	end
	
end

endmodule

