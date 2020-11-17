module	LEGOBGDBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output	logic	[3:0] HitEdgeCode //one bit per edge 
 ) ;



localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  


localparam  int OBJECT_HEIGHT_Y = 32;
localparam  int OBJECT_WIDTH_X = 32;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'hE8, 8'hEC, 8'hEC, 8'hEC, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hEC, 8'hE8, 8'hEC, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'h95, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99 },
{8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hED, 8'hED, 8'hED, 8'hE8, 8'hE8, 8'hE8, 8'hEC, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'h95, 8'h99, 8'h99, 8'h95, 8'h99, 8'hB9, 8'h99, 8'h95, 8'h95, 8'h95 },
{8'hE8, 8'hEC, 8'hC8, 8'hCD, 8'hED, 8'hED, 8'hED, 8'hF1, 8'hEC, 8'hE8, 8'hEC, 8'hF9, 8'hF9, 8'hF5, 8'hD5, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF8, 8'hD9, 8'h95, 8'h99, 8'h95, 8'h95, 8'hB9, 8'hB9, 8'hB9, 8'hB9, 8'h95, 8'h95 },
{8'hEC, 8'hC8, 8'hC8, 8'hEC, 8'hE8, 8'hE8, 8'hE8, 8'hED, 8'hED, 8'hE8, 8'hEC, 8'hF9, 8'hF5, 8'hD4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'h99, 8'h95, 8'h75, 8'h99, 8'h95, 8'h95, 8'h95, 8'hB9, 8'hB9, 8'h95 },
{8'hEC, 8'hC8, 8'hC8, 8'hEC, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hED, 8'hE8, 8'hEC, 8'hF9, 8'hD0, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'h99, 8'h70, 8'h95, 8'h99, 8'h99, 8'h95, 8'h99, 8'h95, 8'hB9, 8'h99 },
{8'hEC, 8'hC8, 8'hC8, 8'hEC, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hED, 8'hE8, 8'hEC, 8'hF9, 8'hD0, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'h95, 8'h50, 8'h95, 8'h99, 8'h95, 8'h95, 8'h95, 8'h95, 8'h99, 8'h95 },
{8'hEC, 8'hC8, 8'hC8, 8'hEC, 8'hE8, 8'hE8, 8'hE8, 8'hEC, 8'hC8, 8'hE8, 8'hEC, 8'hF9, 8'hD0, 8'hD0, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF5, 8'hF9, 8'hD9, 8'h95, 8'h50, 8'h70, 8'h99, 8'h99, 8'h95, 8'h95, 8'h99, 8'h95, 8'h95 },
{8'hE8, 8'hC8, 8'hA4, 8'hC8, 8'hE8, 8'hEC, 8'hE8, 8'hC8, 8'hC8, 8'hE8, 8'hEC, 8'hF9, 8'hD4, 8'hAC, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hD4, 8'hD4, 8'hF9, 8'hD9, 8'h95, 8'h74, 8'h4C, 8'h75, 8'h99, 8'h99, 8'h99, 8'h95, 8'h95, 8'h99 },
{8'hE8, 8'hE8, 8'hC8, 8'hA4, 8'hA4, 8'hC8, 8'hC8, 8'hC8, 8'hE8, 8'hE8, 8'hEC, 8'hF9, 8'hF5, 8'hD0, 8'hAC, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'hF9, 8'hF9, 8'hD9, 8'h95, 8'h95, 8'h70, 8'h4C, 8'h50, 8'h70, 8'h50, 8'h70, 8'h95, 8'h95 },
{8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hC8, 8'hC8, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hEC, 8'hF9, 8'hF9, 8'hF9, 8'hD4, 8'hD0, 8'hD0, 8'hD4, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'h95, 8'h99, 8'h95, 8'h75, 8'h70, 8'h70, 8'h75, 8'h99, 8'h99, 8'h95 },
{8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hF0, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hD5, 8'h95, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99, 8'h95, 8'h95 },
{8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF5, 8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hEC, 8'hE8, 8'hE8, 8'hEC, 8'hEC, 8'hE8, 8'hD0, 8'h99, 8'h95, 8'h99, 8'h99, 8'h99, 8'h95, 8'h95, 8'h99, 8'h95, 8'h95 },
{8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE8, 8'hE8, 8'hEC, 8'hE8, 8'hED, 8'hED, 8'hED, 8'hE8, 8'hE8, 8'hE8, 8'hCC, 8'h99, 8'h99, 8'h99, 8'h95, 8'h99, 8'hB9, 8'hB9, 8'h95, 8'h95, 8'h95 },
{8'hF9, 8'hF9, 8'hD5, 8'hD5, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE8, 8'hE8, 8'hC8, 8'hCD, 8'hED, 8'hED, 8'hED, 8'hF1, 8'hEC, 8'hE8, 8'hCC, 8'h99, 8'h99, 8'h95, 8'h95, 8'h99, 8'hB9, 8'hB9, 8'hB9, 8'h95, 8'h95 },
{8'hF9, 8'hF5, 8'hD4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE8, 8'hC8, 8'hC8, 8'hEC, 8'hE8, 8'hE8, 8'hE8, 8'hED, 8'hED, 8'hE8, 8'hCC, 8'h99, 8'h95, 8'h75, 8'h99, 8'h95, 8'h95, 8'h95, 8'hB9, 8'hB9, 8'h95 },
{8'hF9, 8'hD0, 8'hF5, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF5, 8'hE8, 8'hC8, 8'hC8, 8'hEC, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hED, 8'hE8, 8'hCC, 8'h99, 8'h70, 8'h95, 8'h99, 8'h99, 8'h95, 8'h99, 8'h95, 8'hB9, 8'h95 },
{8'hF9, 8'hD0, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF5, 8'hE8, 8'hC8, 8'hC8, 8'hEC, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hED, 8'hE8, 8'hCC, 8'h99, 8'h50, 8'h95, 8'h99, 8'h95, 8'h95, 8'h99, 8'h99, 8'h99, 8'h95 },
{8'hF9, 8'hD0, 8'hD0, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF5, 8'hF9, 8'hF5, 8'hE8, 8'hC8, 8'hC8, 8'hEC, 8'hE8, 8'hE8, 8'hEC, 8'hEC, 8'hC8, 8'hE8, 8'hCC, 8'h99, 8'h50, 8'h70, 8'h99, 8'h99, 8'h99, 8'h99, 8'h99, 8'h95, 8'h99 },
{8'hF9, 8'hD4, 8'hAC, 8'hD4, 8'hF9, 8'hF9, 8'hF9, 8'hD4, 8'hD4, 8'hF9, 8'hF5, 8'hE8, 8'hC8, 8'hA4, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hC8, 8'hE8, 8'hCC, 8'h99, 8'h74, 8'h4C, 8'h74, 8'h99, 8'h99, 8'h95, 8'h74, 8'h95, 8'h99 },
{8'hF9, 8'hF9, 8'hD0, 8'hAC, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'hF9, 8'hF9, 8'hF5, 8'hE8, 8'hE8, 8'hC8, 8'hA4, 8'hA4, 8'hA4, 8'hC4, 8'hC8, 8'hEC, 8'hE8, 8'hCC, 8'h99, 8'h95, 8'h70, 8'h4C, 8'h50, 8'h50, 8'h50, 8'h74, 8'h99, 8'h95 },
{8'hF9, 8'hF9, 8'hF9, 8'hD4, 8'hD0, 8'hD0, 8'hD4, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hCC, 8'h99, 8'h99, 8'h99, 8'h94, 8'h74, 8'h74, 8'h95, 8'h99, 8'h99, 8'h99 },
{8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD5, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h75, 8'h75, 8'h75, 8'h75, 8'h75, 8'h75, 8'h75, 8'h75, 8'h75, 8'h75 },
{8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hB5, 8'h12, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h12, 8'h32, 8'h32, 8'h32, 8'h32, 8'h12, 8'h12, 8'h32, 8'h12, 8'h12, 8'h12, 8'h12, 8'h12, 8'h12, 8'h12 },
{8'hF9, 8'hF9, 8'hF9, 8'hF5, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF8, 8'hB5, 8'h12, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32 },
{8'hF9, 8'hF9, 8'hD4, 8'hF5, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hB5, 8'h12, 8'h32, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h32, 8'h56, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h32, 8'h57, 8'h32, 8'h32 },
{8'hF9, 8'hF5, 8'hD4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF8, 8'hB5, 8'h12, 8'h2E, 8'h2E, 8'h32, 8'h32, 8'h12, 8'h12, 8'h32, 8'h36, 8'h32, 8'h32, 8'h32, 8'h2E, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h12, 8'h32, 8'h36, 8'h32 },
{8'hF9, 8'hD0, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hB5, 8'h12, 8'h0E, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h0A, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32 },
{8'hF9, 8'hD0, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hB5, 8'h12, 8'h0A, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h0A, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32 },
{8'hF9, 8'hD0, 8'hD0, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hF8, 8'hB5, 8'h12, 8'h0A, 8'h0A, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h0A, 8'h0A, 8'h32, 8'h32, 8'h32, 8'h12, 8'h32, 8'h0E, 8'h32 },
{8'hF9, 8'hD4, 8'hAC, 8'hD0, 8'hF5, 8'hF9, 8'hF5, 8'hD4, 8'hD4, 8'hF8, 8'hB5, 8'h12, 8'h0E, 8'h09, 8'h0E, 8'h32, 8'h32, 8'h32, 8'h0E, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h0E, 8'h09, 8'h0E, 8'h32, 8'h32, 8'h32, 8'h0E, 8'h2E, 8'h32 },
{8'hF9, 8'hF9, 8'hD4, 8'hAC, 8'hAC, 8'hD0, 8'hD0, 8'hD4, 8'hF9, 8'hF8, 8'hB5, 8'h12, 8'h32, 8'h0E, 8'h09, 8'h09, 8'h0A, 8'h0A, 8'h2E, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h0E, 8'h09, 8'h09, 8'h0A, 8'h0A, 8'h2E, 8'h32, 8'h32 },
{8'hF9, 8'hF9, 8'hF9, 8'hF5, 8'hD4, 8'hD4, 8'hF5, 8'hF9, 8'hF9, 8'hF9, 8'hB5, 8'h12, 8'h32, 8'h32, 8'h32, 8'h0E, 8'h0E, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h32, 8'h0E, 8'h0E, 8'h32, 8'h32, 8'h32, 8'h32 }
};


//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  


logic [0:3] [0:3] [3:0] hit_colors = 
{16'hC446,     
 16'h8C62,    
 16'h8932,
 16'h9113};

 

// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		HitEdgeCode <= hit_colors[offsetY >> OBJECT_HEIGHT_Y_DIVIDER][offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  

	
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX];	 //regular
//			RGBout <= object_colors[(OBJECT_HEIGHT_Y-1) - offsetY][offsetX];	 //upsideDown
//			RGBout <=  {HitEdgeCode, 4'b0000 } ;  //get RGB from the colors table, option  for debug 
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule
