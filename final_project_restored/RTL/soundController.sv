

module	soundController	(	
 
					input	logic	clk,
					input	logic	resetN,
					input   logic enableSound,
					input   logic twoSecPulse,


					input logic	timeUp,
					input logic levelUp,
					input logic SHP_bumpyHeart,
					input logic SHP_bumpyDiamond,
					input	logic SHP_bumpyObstacle,
					input	logic SHP_bumpyCovid,
					input logic gameOver,
					input logic shoot,

					
					output logic enable_out,
					output logic [3:0] tone
					
					
					
);

//////////--------------------------------------------------------------------------------------------------------------=



logic timeFlag;
always_ff @(posedge clk, negedge resetN) begin
		if (!resetN) begin
			tone <= 0;
			enable_out <= 1'b1;
		end
		
		else begin
			if (enableSound) begin
				if (timeUp || SHP_bumpyObstacle || SHP_bumpyCovid) begin
					tone <= 1;
					enable_out <= 1'b1;
				end
				else if (levelUp) begin
					tone <= 2;
					enable_out <= 1'b1;
				end
				
				else if (gameOver) begin
					tone <= 3;
					enable_out <= 1'b1;
				end
				
				else if (SHP_bumpyHeart) begin
					tone <= 4;
					enable_out <= 1'b1;
				end
				else if (SHP_bumpyDiamond) begin
					tone <= 5;
					enable_out <= 1'b1;
				end

				else if (shoot) begin
					tone <= 6;
					enable_out <= 1'b1;
				end	


			end
				if (twoSecPulse && enable_out) begin
					enable_out <= 1'b0;
				end
		end

end
			

//end

endmodule




