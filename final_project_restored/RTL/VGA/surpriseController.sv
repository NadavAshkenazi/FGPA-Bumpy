

//controlls the movment logic of a single surprise
module	surpriseController(	
					input		logic	clk,
					input		logic	resetN,
					input		logic	bumpyDrawingRequest,
					input		logic	surpriseDrawingRequest,
					input		logic [2:0] req_ID,
					input		logic	SHP_bumpySurprise,
					input		logic	[7:0] surprise_bus,
					
					output	logic	[7:0] enable_all
);

logic [7:0] enable;
logic delayOne;
logic delayTwo;



//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		enable	<=	8'b11111111;		
		enable_all	<=	8'b11111111;		
		delayOne <= resetN;
		delayTwo <= delayOne;
	end
	else begin 
		delayOne <= resetN;
		delayTwo <= delayOne;
		enable_all <= enable;
		if (SHP_bumpySurprise && delayTwo) begin
			case (surprise_bus) 
				8'b00000001:	begin
							enable <= (enable & 8'b11111110);
						end
				8'b00000010:	begin
							enable <= (enable & 8'b11111101);
						end
				8'b00000100:	begin
							enable <= (enable & 8'b11111011);
						end
				8'b00001000:	begin
							enable <= (enable & 8'b11110111);
						end
				8'b00010000:	begin
							enable <= (enable & 8'b11101111);
						end
				8'b00100000:	begin
							enable <= (enable & 8'b11011111);
						end
				8'b01000000:	begin
							enable <= (enable & 8'b10111111);
						end	
				8'b10000000:	begin
							enable <= (enable & 8'b01111111);
						end
				default begin
					enable <= enable;
				end
			endcase
			
		end
	end
end 
endmodule 