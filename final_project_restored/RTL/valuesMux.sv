

module	valuesMux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic [1:0] levelCode,
					
					
					input		logic	topLeftX0[87:0],
					input		logic	topLeftY0[87:0],
					input		logic	width0[87:0],					
					input		logic	height0[87:0],					
					input		logic	color0[63:0],
					input		logic	enable0[7:0],
					
					
					input		logic	topLeftX1[87:0],
					input		logic	topLeftY1[87:0],
					input		logic	width1[87:0],					
					input		logic	height1[87:0],					
					input		logic	color1[63:0],
					input		logic	enable1[7:0],

					



					output		logic	topLeftX_out[87:0],
					output		logic	topLeftY_out[87:0],
					output		logic	width_out[87:0],					
					output		logic	height_out[87:0],					
					output		logic	color_out[63:0],
					output		logic	enable_out[7:0],
					
					
					output	logic	levelTwoFlag //debug
					

);


localparam 	LEVEL_ONE = 2'b00;
localparam	LEVEL_TWO = 2'b01;
//logic	levelTwoFlag;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			topLeftX_out <= topLeftX0;
			topLeftY_out <= topLeftY0;
			width_out <= width0;
			height_out <= height0;
			color_out <= color0;
			enable_out <= enable0;
			levelTwoFlag <= 1'b0;
	end
	else begin
		if (levelCode == LEVEL_ONE) begin
			topLeftX_out <= topLeftX0;
			topLeftY_out <= topLeftY0;
			width_out <= width0;
			height_out <= height0;
			color_out <= color0;
			enable_out <= enable0;
			levelTwoFlag <= 1'b0;
		end

		else if (levelCode == LEVEL_TWO) begin
			topLeftX_out <= topLeftX1;
			topLeftY_out <= topLeftY1;
			width_out <= width1;
			height_out <= height1;
			color_out <= color1;
			enable_out <= enable1;
			levelTwoFlag <= 1'b1;
		end
		else if (levelTwoFlag) begin
			topLeftX_out <= topLeftX1;
			topLeftY_out <= topLeftY1;
			width_out <= width1;
			height_out <= height1;
			color_out <= color1;
			enable_out <= enable1;
			levelTwoFlag <= 1'b1;		
		end
		else begin
			topLeftX_out <= topLeftX0;
			topLeftY_out <= topLeftY0;
			width_out <= width0;
			height_out <= height0;
			color_out <= color0;
			enable_out <= enable0;
			levelTwoFlag <= 1'b0;
		end
	end  
end

endmodule


