//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	objects_mux_all	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		// Bumpy 
					input		logic	bumpyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] bumpyRGB, 
					
		//floor
					input		logic	floorDrawingRequest, 
					input		logic	[7:0] floorRGB, 
					
		//time tens
					input 	logic timeTensDrawingRequest,
					input 	logic [7:0] timeTensRGB,
					
		//time tens
					input 	logic timeOnesDrawingRequest,
					input 	logic [7:0] timeOnesRGB,
					
		//obstacle - TEMP
					input 	logic obstacleDrawingRequest,
					input 	logic [7:0] obstacleRGB,
					
		//steps master
					input 	logic steps_masterDrawingRequest,
					input 	logic [7:0] steps_masterRGB,
		//diamonds
					input 	logic diamond_masterDrawingRequest,
					input 	logic [7:0] diamond_masterRGB,
		//hearts
					input 	logic heart_masterDrawingRequest,
					input 	logic [7:0] heart_masterRGB,	
		//lives
					input 	logic livesDrawingRequest,
					input 	logic [7:0] livesRGB,

		//score tens
					input 	logic scoreDrawingRequest,
					input 	logic [7:0] scoreRGB,
					
		//brackets
					input 	logic bracketsDrawingRequest,
					input 	logic [7:0] bracketsRGB,
				
		//brackets
					input 	logic finishFlagDrawingRequest,
					input 	logic [7:0] finishFlagRGB,	
					
		//shoot
					input 	logic shootDrawingRequest,
					input 	logic [7:0] shootRGB,	
					
		//levelSymbol
					input 	logic levelSymbolDrawingRequest,
					input 	logic [7:0] levelSymbolRGB,	
					
		//ceiling
					input 	logic ceilingDrawingRequest,
					input 	logic [7:0] ceilingRGB,
				
		//leftWall
					input 	logic leftWallDrawingRequest,
					input 	logic [7:0] leftWallRGB,	
				
		//rightWall
					input 	logic rightWallDrawingRequest,
					input 	logic [7:0] rightWallRGB,	
					
		//covid
					input 	logic covidDrawingRequest,
					input 	logic [7:0] covidRGB,	
				
		// background 
					input		logic	[7:0] backGroundRGB, 

					output	logic	[7:0] redOut, // full 24 bits color output
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
					
);

logic [7:0] tmpRGB;



assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};

//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (bumpyDrawingRequest == 1'b1 )   
			tmpRGB <= bumpyRGB;  //first priority 
			
		else if (floorDrawingRequest == 1'b1)
			tmpRGB <= floorRGB; //second priority
		
		else if (timeTensDrawingRequest == 1'b1)
			tmpRGB <= timeTensRGB;
			
		else if (timeOnesDrawingRequest == 1'b1)
			tmpRGB <= timeOnesRGB;
			
		else if (obstacleDrawingRequest == 1'b1)
			tmpRGB <= obstacleRGB;	
			
		else if (leftWallDrawingRequest == 1'b1) 
			tmpRGB <= leftWallRGB;
			
		else if (rightWallDrawingRequest == 1'b1) 
			tmpRGB <= rightWallRGB;
			
		else if (steps_masterDrawingRequest == 1'b1)
			tmpRGB <= steps_masterRGB;	
			
		else if (diamond_masterDrawingRequest == 1'b1)
			tmpRGB <= diamond_masterRGB;
			
		else if (heart_masterDrawingRequest == 1'b1)
			tmpRGB <= heart_masterRGB;
		
		else if (livesDrawingRequest == 1'b1)
			tmpRGB <= livesRGB;
		
		else if (scoreDrawingRequest == 1'b1)
			tmpRGB <= scoreRGB;
						
		else if (bracketsDrawingRequest == 1'b1)
			tmpRGB <= bracketsRGB;
			
		else if (finishFlagDrawingRequest == 1'b1)
			tmpRGB <= finishFlagRGB;
		
		else if (shootDrawingRequest == 1'b1) 
			tmpRGB <= shootRGB;
			
		else if (levelSymbolDrawingRequest == 1'b1) 
			tmpRGB <= levelSymbolRGB;
			
		else if (ceilingDrawingRequest == 1'b1) 
			tmpRGB <= ceilingRGB;
			
		else if (covidDrawingRequest == 1'b1) 
			tmpRGB <= covidRGB;
			
		else
			tmpRGB <= backGroundRGB ; // last priority 
		end ; 
	end

endmodule


