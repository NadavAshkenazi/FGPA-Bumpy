
module	obstacles_logic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 

					input logic collision,  
					input logic	SHP_shootObstacle,
					input logic obstacle_req,
					input	logic	[3:0] HitEdgeCode, //one bit per edge 

					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY,
					output logic enable_obstacle
);


// a module used to generate the obstacle trajectory.  

parameter int INITIAL_X = 0;
parameter int INITIAL_Y = 0;
parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED = 20;
parameter int Y_ACCEL = -10;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	X_NO_MOVEMENT	= 	0;
const int	Y_FIXED_MOVEMENT	= 	150;
const int 	JUMP_SPEEDX = 100;
const int 	JUMP_SPEEDY = 150;
const int	bracketOffset = 30;


int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation x Axis speed 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		Xspeed	<= INITIAL_X_SPEED;

	else 	begin
			
				
			// colision Calcultaion 
			
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  	
		
		if (((topLeftX <= bracketOffset) || (collision && HitEdgeCode [3] == 1)) && (Xspeed < 0))  
				Xspeed <= -Xspeed;
				
		if (((topLeftX >= 639 - (bracketOffset+64)) || (collision && HitEdgeCode [1] == 1)) &&  (Xspeed > 0))
				Xspeed <= -Xspeed;
				

				
					
	end
end

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation Y Axis speed using gravity


always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;

	end 
				
	else begin				
		// colision Calcultaion 
				
							
		if (((topLeftY <= bracketOffset) || (collision && (HitEdgeCode [2] == 1))) && (Yspeed <= 0)) begin // hit top border or top of a step  
			Yspeed <= -Yspeed;
		end				
		
		if (((topLeftY >= (479 - (bracketOffset+8))) || (collision && (HitEdgeCode [0] == 1))) &&  (Yspeed >= 0)) begin // hit bottom border or bottom of a step
			Yspeed <= -Yspeed;
		end
		

					
	end
end

//////////--------------------------------------------------------------------------------------------------------------=

// position calculate 

always_ff@(posedge clk or negedge resetN) begin
	if(!resetN)	begin
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; 
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed; 
		end
	end
end

// ----------disappear calculation--------------

logic delayOne;
logic delayTwo;

always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin 
		enable_obstacle <= 1'b1;
		delayOne <= resetN;
		delayTwo <= delayOne;
	end 	
	else begin	
		delayOne <= resetN;
		delayTwo <= delayOne;	
		if (SHP_shootObstacle && obstacle_req && delayTwo)
			enable_obstacle <= 1'b0;	
	end
end




//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule




