module	heartSurpriseBitMap	(	
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
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h45, 8'h44, 8'h45, 8'h6D, 8'hBA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6D, 8'h44, 8'h64, 8'h64, 8'h64, 8'h8D, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h40, 8'hC4, 8'hC4, 8'hC4, 8'h84, 8'h20, 8'h72, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h49, 8'h60, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'h84, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hBA, 8'h44, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'h40, 8'h49, 8'hFF, 8'hFF, 8'h6D, 8'h60, 8'hC4, 8'hC4, 8'hE8, 8'hE8, 8'hC4, 8'hC4, 8'h80, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hA4, 8'hE8, 8'hE8, 8'hE8, 8'hED, 8'hED, 8'hED, 8'hE8, 8'h64, 8'h6D, 8'hB6, 8'h40, 8'hC4, 8'hC4, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'hA4, 8'h45, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h44, 8'hE4, 8'hE8, 8'hE8, 8'hED, 8'hED, 8'hE9, 8'hE9, 8'hE8, 8'hE8, 8'h44, 8'h24, 8'hA4, 8'hC4, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h44, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h64, 8'hE8, 8'hE8, 8'hED, 8'hED, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h40, 8'hC4, 8'hC4, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h60, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h84, 8'hE8, 8'hE9, 8'hED, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hA4, 8'hC4, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h64, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h84, 8'hE8, 8'hE9, 8'hED, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h64, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h84, 8'hE8, 8'hE9, 8'hED, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h64, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h64, 8'hE8, 8'hE9, 8'hED, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'hA4, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hBA, 8'h64, 8'hE8, 8'hE8, 8'hE9, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE4, 8'hD1, 8'hB6, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h60, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h45, 8'hC4, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE4, 8'hD2, 8'hD6, 8'hC4, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'hC4, 8'h44, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h84, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE4, 8'hCD, 8'hD6, 8'hDA, 8'hDB, 8'hD6, 8'hAD, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h84, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h44, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hCD, 8'hD6, 8'hDA, 8'hDB, 8'hD6, 8'hB1, 8'hE4, 8'hE8, 8'hE8, 8'hC4, 8'hC4, 8'h44, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h72, 8'h40, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE4, 8'hD2, 8'hD6, 8'hC4, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h60, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h64, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE4, 8'hD2, 8'hB2, 8'hE4, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'hA4, 8'h45, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h49, 8'h64, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'hA4, 8'h44, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h64, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'hC4, 8'h40, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h64, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'hC4, 8'h40, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h84, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'h84, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h24, 8'hA4, 8'hE8, 8'hE8, 8'hE8, 8'hC4, 8'hA4, 8'h44, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hBA, 8'h24, 8'hC4, 8'hE8, 8'hC4, 8'hC4, 8'h64, 8'h96, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h40, 8'hC4, 8'hC4, 8'hA4, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h72, 8'h44, 8'hC4, 8'h44, 8'hBA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h60, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h00, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h24, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
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
