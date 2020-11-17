

//calculate the score when hitting objects
module	score_logic	(	
 
					input	logic	clk,
					input	logic	resetN,

					input logic SHP_bumpyDiamond,
					input	logic SHP_bumpyCollision,
					output logic [3:0] score
);



//////////--------------------------------------------------------------------------------------------------------------=
//  calculate score 

logic delayOne;
logic delayTwo;

always_ff@(posedge clk or negedge resetN) begin
	if(!resetN)	begin
		score = 4'b0;
		delayOne <= resetN;
		delayTwo <= delayOne;
	end
	else begin
		delayOne <= resetN;
		delayTwo <= delayOne;
		if (SHP_bumpyDiamond && delayTwo) begin		
				score <= score + 1;

		end		
		else begin
			score <= score;
		end
	end
end



endmodule




