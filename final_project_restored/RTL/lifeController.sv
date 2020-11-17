
// controlls the life array at the top of the screen
module	lifeController	(	
 
					input	logic	clk,
					input	logic	resetN,

					input logic SHP_bumpyHeart,
					input logic	timeUp,
					input logic levelUp,
					input logic enable,
					input	logic SHP_bumpyObstacle,
					input	logic SHP_bumpyCovid,


					output logic resetTimer,
					output logic [2:0] enableLives,
					output logic gameOver
					
					
					
);

//////////--------------------------------------------------------------------------------------------------------------=


int livesCount = 3;
logic delayOne;
logic delayTwo;
logic levelUpDelay;

always_ff @(posedge clk, negedge resetN) begin
		if (!resetN) begin
			resetTimer <= 1'b1;
			livesCount <= 3;
			gameOver	<= 1'b0;
			delayOne <= resetN;
			delayTwo <= delayOne;
			levelUpDelay <= 1'b0;
		end
		else begin
		delayOne <= resetN;
		delayTwo <= delayOne;
		levelUpDelay <= levelUp;
			if (enable) begin
				if ((timeUp || ((SHP_bumpyObstacle || SHP_bumpyCovid) && delayTwo && !levelUpDelay)) && (livesCount > 0)) begin 
					if (livesCount == 1) begin 
						gameOver <= 1'b1;
					end				
					livesCount <= livesCount - 1;
					resetTimer <= 1'b1;			
				end
				else if (levelUp) begin
					if (livesCount < 3) begin
						livesCount <= livesCount + 1;
					end
					resetTimer <= 1'b1;
				end 
				
				else if (SHP_bumpyHeart && (livesCount < 3)) begin
					livesCount <= livesCount + 1;
					resetTimer <= 1'b0;
				end
				else begin
					resetTimer <= 1'b0;
					livesCount <= livesCount;
					gameOver		<= 1'b0;
				end
			end
		end
end
			
always_ff @(posedge clk, negedge resetN) begin
		if (!resetN) begin
		enableLives <= 3'b111;
		end
		else begin
			if (livesCount == 3)
				enableLives <= 3'b111;
			else if(livesCount == 2)
				enableLives <= 3'b011;
			else if(livesCount == 1)
				enableLives <= 3'b001;
			else if (livesCount == 0)
				enableLives <= 3'b000;
		end
end



endmodule




