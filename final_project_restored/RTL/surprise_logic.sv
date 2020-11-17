//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module	surprise_logic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic enable_in,
					input logic [10:0] initial_x,
					input logic [10:0] initial_y,
					input logic surpriseCollision,
					input	logic	[3:0] HitEdgeCode, //one bit per edge
					
					
					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY,
					output	 logic enable_out
					
);


// a module used to generate the obstacle trajectory.  

parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED = 20;
parameter int Y_ACCEL = 0;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	NO_MOVEMENT	= 	0;
const int	Y_FIXED_MOVEMENT	= 	150;
const int 	JUMP_SPEEDX = 100;
const int 	JUMP_SPEEDY = 150;
const int	bracketOffset = 30;


int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;



//////////--------------------------------------------------------------------------------------------------------------=
//  calculation Y Axis speed using gravity


always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;

	end 
				
	else begin				
		// colision Calcultaion 			
							
		if ((surpriseCollision) && (HitEdgeCode [0] == 1) &&  (Yspeed >= 0)) begin // hit bottom border or bottom of a step
			Yspeed <= NO_MOVEMENT;
		end

					
	end
end

//////////--------------------------------------------------------------------------------------------------------------=

// position calculate 

always_ff@(posedge clk or negedge resetN) begin
	if(!resetN)	begin
		if (enable_in) begin
			topLeftX_FixedPoint	<= initial_x * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint	<= initial_y * FIXED_POINT_MULTIPLIER;
		end
	end
	
	
	else begin
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; 
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed; 
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    
assign 	enable_out = enable_in;	

endmodule




