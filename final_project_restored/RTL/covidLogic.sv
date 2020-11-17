//controls the logic of a single covid object
module	covidLogic(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input 	logic dripStart,
					input 	logic	[10:0] enemyTopLeftX,
					input 	logic [10:0] enemyTopLeftY,
					input 	logic covidDisapper,
					input 	logic SHP_covidCollision,
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					
					
					output	logic	dripEnable,					
					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY
					
);


// a module used to generate the obstacle trajectory.  

parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 40;
parameter int Y_ACCEL = 3;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;
//int initial_x , initial_y;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	NO_MOVEMENT	= 	0;
const int	Y_FIXED_MOVEMENT	= 	150;
const int	bracketOffset = 30;



int notFirstTimeFlag;


always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		notFirstTimeFlag <= 1'b0;
		dripEnable <= 1'b0;
		topLeftX_FixedPoint <= 0;
		topLeftY_FixedPoint <= 0;
	end 		
	else begin				
		if (dripStart) begin
			if (!notFirstTimeFlag) begin
				notFirstTimeFlag <= 1'b1;
				topLeftX_FixedPoint	<= enemyTopLeftX * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<= enemyTopLeftY * FIXED_POINT_MULTIPLIER;
				dripEnable <= 1'b1;
			end
		
		
			
			else begin
				if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second
					Yspeed	<= Yspeed + Y_ACCEL;
				end
				else if (((topLeftX <= bracketOffset) || (SHP_covidCollision && HitEdgeCode [3] == 1)) && (Xspeed < 0)) begin //jumping right at collision
					Xspeed <= Y_FIXED_MOVEMENT;
				end
				
				else if (((topLeftX >= 639 - (bracketOffset+32)) || (SHP_covidCollision && HitEdgeCode [1] == 1)) &&  (Xspeed > 0)) begin //jumping left at collision
					Xspeed <= -Y_FIXED_MOVEMENT;
				end
				
				else if ((topLeftY <= bracketOffset) ||(SHP_covidCollision && (HitEdgeCode [2] == 1)) && (Yspeed <= 0)) begin //jumping up at collision  
					Yspeed <= -Yspeed;
					
				end				
				else if (((topLeftY >= (479 - (bracketOffset+32))) || (SHP_covidCollision && (HitEdgeCode [0] == 1))) &&  (Yspeed >= 0)) begin 
					if (Yspeed >= 500) begin //  while moving doWn
						Yspeed <= - (Yspeed / 2);
					end
					else if ((Yspeed <= 500) && (Yspeed > 0)) begin
						Yspeed <= -Y_FIXED_MOVEMENT;
					end
				end
			end
			
			
		end	
		
		
		if ((startOfFrame == 1'b1) && notFirstTimeFlag) begin
			topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; 
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed; 
		end
		
		if (covidDisapper) begin // hit something
			dripEnable <= 1'b0;
		end			
	end
end






//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    

endmodule



