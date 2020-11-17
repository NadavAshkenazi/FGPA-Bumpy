

// a module used to generate the shot trajectory.  

module	shootLogic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic shootStart,
					input logic	[10:0] bumpyTopLeftX,
					input logic [10:0] bumpyTopLeftY,
					input logic 	shootCollision,
					
					
					output	logic	shootEnable,					
					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY
					
);



parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED = 20;
parameter int Y_ACCEL = 0;

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


int notFirstTimeFlag;




always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		notFirstTimeFlag <= 1'b0;
		shootEnable <= 1'b0;
		topLeftX_FixedPoint <= 0;
		topLeftY_FixedPoint <= 0;
	end 		
	else begin				
		if (shootStart) begin
			if (!notFirstTimeFlag) begin
				notFirstTimeFlag <= 1'b1;
				topLeftX_FixedPoint	<= bumpyTopLeftX * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<= bumpyTopLeftY * FIXED_POINT_MULTIPLIER;
				shootEnable <= 1'b1;
			end
		
			else begin
					if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second
						Yspeed	<= Yspeed + Y_ACCEL;
						topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; 
						topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed; 
					end
			end
		end			
		if (shootCollision) begin // hit something
			shootEnable <= 1'b0;
		end			
	end
end



//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    

endmodule



