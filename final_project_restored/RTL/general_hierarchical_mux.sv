

module	general_hierarchical_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					
					
					input		logic	DrawingRequest0,
					input 	logic [10:0] object_offsetX0,
					input 	logic [10:0] object_offsetY0,
					input		logic	[7:0] RGB0,
					
					input		logic	DrawingRequest1,
					input 	logic [10:0] object_offsetX1,
					input 	logic [10:0] object_offsetY1,
					input		logic	[7:0] RGB1, 
					
		
					input		logic	DrawingRequest2,
					input 	logic [10:0] object_offsetX2,
					input 	logic [10:0] object_offsetY2,
					input		logic	[7:0] RGB2, 

									
					input		logic	DrawingRequest3,
					input 	logic [10:0] object_offsetX3,
					input 	logic [10:0] object_offsetY3,
					input		logic	[7:0] RGB3,
				
					input		logic	DrawingRequest4,
					input 	logic [10:0] object_offsetX4,
					input 	logic [10:0] object_offsetY4,
					input		logic	[7:0] RGB4, 
					
		
					input		logic	DrawingRequest5,
					input 	logic [10:0] object_offsetX5,
					input 	logic [10:0] object_offsetY5,
					input		logic	[7:0] RGB5, 

									
					input		logic	DrawingRequest6,
					input 	logic [10:0] object_offsetX6,
					input 	logic [10:0] object_offsetY6,
					input		logic	[7:0] RGB6,
					
					input		logic	DrawingRequest7,
					input 	logic [10:0] object_offsetX7,
					input 	logic [10:0] object_offsetY7,
					input		logic	[7:0] RGB7, 

					
					output   logic [10:0] offsetX_out,
					output 	logic [10:0] offsetY_out,
					output 	logic DrawingRequest,
					output 	logic [7:0]RGBout,
					output  	logic [2:0] req_ID,
					
					output	logic [7:0] surprises_reqs
					

);


assign DrawingRequest = (DrawingRequest0 || DrawingRequest1 || DrawingRequest2 || DrawingRequest3 || DrawingRequest4 || DrawingRequest5 || DrawingRequest6
		|| DrawingRequest7);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBout	<= 8'b0;
			surprises_reqs <= 8'b00000000;
	end
	else begin
		if (DrawingRequest0 == 1'b1) begin
			RGBout <= RGB0 ; //last priority
			offsetX_out <= object_offsetX0;
			offsetY_out <= object_offsetY0;
			req_ID <= 0;
			surprises_reqs <= 8'b00000001;
		end

		else if (DrawingRequest1 == 1'b1 ) begin
			RGBout <= RGB1;  //first priority 
			offsetX_out <= object_offsetX1;
			offsetY_out <= object_offsetY1;
			req_ID <= 1;
			surprises_reqs <= 8'b00000010;
		end
			
		else if (DrawingRequest2 == 1'b1) begin
			RGBout <= RGB2; //second priority
			offsetX_out <= object_offsetX2;
			offsetY_out <= object_offsetY2;
			req_ID <= 2;
			surprises_reqs <= 8'b00000100;
		end
			
		else if (DrawingRequest3 == 1'b1) begin
			RGBout <= RGB3 ;
			offsetX_out <= object_offsetX3;
			offsetY_out <= object_offsetY3;
			req_ID <= 3;
			surprises_reqs <= 8'b00001000;
		end
			
		else if (DrawingRequest4 == 1'b1) begin
			RGBout <= RGB4;
			offsetX_out <= object_offsetX4;
			offsetY_out <= object_offsetY4;
			req_ID <= 4;
			surprises_reqs <= 8'b00010000;
		end
		
		else if (DrawingRequest5 == 1'b1) begin
			RGBout <= RGB5 ;
			offsetX_out <= object_offsetX5;
			offsetY_out <= object_offsetY5;
			req_ID <= 5;
			surprises_reqs <= 8'b00100000;
		end
			
		else if (DrawingRequest6 == 1'b1) begin
			RGBout <= RGB6;
			offsetX_out <= object_offsetX6;
			offsetY_out <= object_offsetY6;
			req_ID <= 6;
			surprises_reqs <= 8'b01000000;
		end
			
		else if (DrawingRequest7 == 1'b1) begin
			RGBout <= RGB7 ; 
			offsetX_out <= object_offsetX7;
			offsetY_out <= object_offsetY7;
			req_ID <= 7;
			surprises_reqs <= 8'b10000000;
		end
	end  
end

endmodule


