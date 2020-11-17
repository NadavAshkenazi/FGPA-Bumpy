
// controlls the shooting mechanism
module	shootController(	
					input		logic	clk,
					input		logic	resetN,
					input		logic	shootN,

					
					output	logic	[7:0] enable_all
);

logic [7:0] enable;
int counter;
logic flag_shoot_once;



//////////--------------------------------------------------------------------------------------------------------------=

//logic outOfAmmoFlag;


always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin
		enable	<=	8'b0;		
		enable_all	<=	8'b0;
		counter <= 0;
		flag_shoot_once <= 1'b0;
	end
	else begin 

			enable_all <= enable;
			if (flag_shoot_once == 1'b0 && !shootN) begin //identify shootN for first time since press
				counter <= counter + 1;
				flag_shoot_once <= 1'b1;
			end
			else if (shootN) begin //user stopped pressing
				flag_shoot_once <= 1'b0;
			end
			else begin //user still pressing
				flag_shoot_once <= 1'b1;
			end
				case (counter) 
					1:	begin
								enable <= 8'b00000001;
						end
					2:	begin
								enable <= 8'b00000011;
						end
					3:	begin
								enable <= 8'b00000111;
						end
					4:	begin
								enable <= 8'b00001111;
						end
					5:	begin
								enable <= 8'b00011111;
						end
					6:	begin
								enable <= 8'b00111111;
						end
					7:	begin
								enable <= 8'b01111111;
						end
					8:	begin
								enable <= 8'b11111111;
						end
						
					default begin
						enable <= enable;
					end
				endcase
//		end	
	end
end
endmodule 