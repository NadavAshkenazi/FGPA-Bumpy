

module	level_fsm	(	
 
					input	logic	clk,
					input	logic	resetN,

					input logic	gameOver,
					input	logic finishFlag,

					output logic levelUp,
					output logic [1:0] levelCode
					
);

//////////--------------------------------------------------------------------------------------------------------------=


enum logic [2:0] {first_lvl_st, second_lvl_st,win_st, game_over_st} present_state, next_state;
logic [1:0] code = 2'b00;

logic delayOne;
logic delayTwo;
logic levelUpTemp;

// state register
always_ff @(posedge clk, negedge resetN) begin
		if (!resetN) begin
			present_state <= first_lvl_st;
			levelCode <= 2'b00;
			delayOne <= 2'b00;
			delayTwo <= 2'b00;
			levelUp <= 1'b0;
		end
		else begin
			present_state <= next_state;
			levelCode <= code;
			delayOne <= resetN;
			delayTwo <= delayOne;
			levelUp <= levelUpTemp;
		end
end
			
			
// next state logic
always_comb 
begin
	if (!resetN) begin
		next_state = first_lvl_st;
		code = 2'b00;
		levelUpTemp = 1'b0;
	end
	else begin
		case (present_state)
			first_lvl_st:
				if (gameOver && delayTwo) begin 
					next_state = game_over_st;
					code = 2'b11;
					levelUpTemp = 1'b0;
				end
				else if (finishFlag && delayTwo) begin
					next_state = second_lvl_st;
					code = 2'b01;
					levelUpTemp = 1'b1;
				end
				else begin
					next_state = present_state;
					code = 2'b00;
					levelUpTemp = 1'b0;
				end
			second_lvl_st:
				if (gameOver && delayTwo) begin 
					next_state = game_over_st;
					code = 2'b11;
					levelUpTemp = 1'b0;
				end
				else if (finishFlag && delayTwo) begin
					next_state = win_st;
					code = 2'b10;
					levelUpTemp = 1'b0;
				end
				else begin
					next_state = present_state;
					code = 2'b01;
					levelUpTemp = 1'b0;
				end
			win_st:
				if (!resetN) begin
					next_state = first_lvl_st;
					code = 2'b00;
					levelUpTemp = 1'b0;
				end
				else begin
					next_state = present_state;
					code = 2'b10;	
					levelUpTemp = 1'b0;
				end
			game_over_st:
				if (!resetN) begin
					next_state = first_lvl_st;
					code = 2'b00;
					levelUpTemp = 1'b0;
				end 
				else begin
					next_state = present_state;
					code = 2'b11;
					levelUpTemp = 1'b0;
				end
			default begin
					next_state = present_state;
					code = 2'b00;
					levelUpTemp = 1'b0;
			end
		endcase
	end
end

endmodule




