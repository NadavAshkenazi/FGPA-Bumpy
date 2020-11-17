
//reloads 8 more shots to the stack.
module	reloadController(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	[7:0] shootEnable,


					output logic SHP_reload
					
					
					
);

//////////--------------------------------------------------------------------------------------------------------------=

logic flag_lastShot;

//----------single last shot detect --------------
always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin 
		SHP_reload <= 1'b0 ; 
		flag_lastShot <= 1'b0;
	end 
	else begin
		if (shootEnable[7] == 1) begin
			flag_lastShot <= 1'b1;
		end 
		else if (flag_lastShot) begin
			SHP_reload <= 1'b1;
			flag_lastShot <= 1'b0;
		end
		else begin
			SHP_reload <= 1'b0;
			flag_lastShot <= 1'b0;
		end
	end 
end




endmodule




