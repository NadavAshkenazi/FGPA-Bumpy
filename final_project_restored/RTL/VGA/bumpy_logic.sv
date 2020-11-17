

module	bumpy_logic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	jumpLeftN, //jumps left if pushed 
					input	logic	jumpRightN, //jumps left if pushed	
					input logic jumpUpN,		//jumps up if pushed 
					input logic singleHitPulse,  //collision if bumpy hits an object
					input	logic	[3:0] HitEdgeCode, //one bit per edge 

					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED = 20;
parameter int Y_ACCEL = -10;


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
//  calculation x Axis speed 

logic flag_jumpLeftOnce;
logic flag_jumpRightOnce;


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		Xspeed	<= INITIAL_X_SPEED;
		flag_jumpLeftOnce <= 1'b1;
		flag_jumpRightOnce = 1'b1;		
	end 
	else 	begin
	
	
	// colision Calcultaion 
			
	//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
	//there is one bit per edge, in the corner two bits are set  


		
		if (((topLeftX <= bracketOffset) || (singleHitPulse && HitEdgeCode [3] == 1)) && (Xspeed < 0))  
				Xspeed <= -Xspeed;
				
		else if (((topLeftX >= 639 - (bracketOffset+32)) || (singleHitPulse && HitEdgeCode [1] == 1)) &&  (Xspeed > 0))
				Xspeed <= -Xspeed;
				
		else if ((topLeftY >= 479 - (bracketOffset+32)) || (singleHitPulse && HitEdgeCode [0] == 1 ))  // hit bottom border or top of a step 
				Xspeed <= NO_MOVEMENT;
			
	
// for perpetual motion	
//		else if(!jumpLeftN && (singleHitPulse == 1'b0) && (HitEdgeCode [0] == 0) &&  (HitEdgeCode [3] == 0)) begin //jumping if not colliding with the side borders
//			Xspeed <= -JUMP_SPEEDX;
//		end
		
//		else if(!jumpRightN && (singleHitPulse == 1'b0) && (HitEdgeCode [0] == 0) && HitEdgeCode [1] == 0)) begin
//			Xspeed <= JUMP_SPEEDX;
//		end

		else begin
		
			if (!jumpLeftN) begin
				flag_jumpRightOnce = 1'b1;
				if ((singleHitPulse == 1'b0) && (HitEdgeCode [0] == 0) &&  (HitEdgeCode [3] == 0)) begin
					if (flag_jumpLeftOnce == 1'b1) begin 
						Xspeed <= -JUMP_SPEEDX;
						flag_jumpLeftOnce = 1'b0;
					end				
				end	
			end
			else if (!jumpRightN) begin
				flag_jumpLeftOnce <=1'b0;
				if ((singleHitPulse == 1'b0) && (HitEdgeCode [0] == 0) && (HitEdgeCode [1] == 0)) begin
					if (flag_jumpRightOnce == 1'b1) begin 
					Xspeed <= JUMP_SPEEDX;
					flag_jumpRightOnce = 1'b0;
					end					
				end
			end
			else begin
				flag_jumpRightOnce = 1'b1;
				flag_jumpLeftOnce = 1'b1;
				Xspeed <= Xspeed;
			end
			
		end
	end
end

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation Y Axis speed using gravity

logic flag_jumpUpOnce;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		flag_jumpUpOnce = 1'b1;
	end 
	else begin
	
		// colision Calcultaion 
			
		//hit bit map has  one bit per edge:  Left-Top-Right-Bottom	 

	
						
		if (((topLeftY <= bracketOffset) || (singleHitPulse && (HitEdgeCode [2] == 1))) && (Yspeed <= 0)) begin // hit top border or bottom of a step  
			Yspeed <= -Yspeed;
		end				
		
		else if (((topLeftY >= (479 - (bracketOffset+32))) || (singleHitPulse && (HitEdgeCode [0] == 1))) &&  (Yspeed >= 0)) begin // hit bottom border or top of a step
			if (Yspeed >= 500) begin //  while moving doun
				Yspeed <= - (Yspeed / 2);
			end
			else if ((Yspeed <= 500) && (Yspeed > 0)) begin
					Yspeed <= -Y_FIXED_MOVEMENT;
			end
		end

		else if (startOfFrame == 1'b1) begin
				Yspeed <= Yspeed  - Y_ACCEL ; // deAccelerate : slow the speed down every clock tick	
		end
		
		else if (!jumpUpN) begin
			if (flag_jumpUpOnce == 1'b1) begin 
				Yspeed <= Yspeed - JUMP_SPEEDY;
				flag_jumpUpOnce = 1'b0;
			end
		end
		
		else begin
				flag_jumpUpOnce = 1'b1;
				Yspeed <= Yspeed;
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

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule




