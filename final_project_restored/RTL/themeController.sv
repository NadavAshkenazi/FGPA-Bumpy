
//winning theme
module	themeController	(	
 
					input	logic	clk,
					input	logic	resetN,
					input   logic enableSound,
					input   logic twoSecPulse,
					input   logic fourSecPulse,
					input   logic eightSecPulse,

					input logic [1:0] levelCode,
		
					output logic enable_out,
					output logic [3:0] tone
					
					
					
);

//////////--------------------------------------------------------------------------------------------------------------=

//theme notes:
// E B C D C B A
// A C E D C B
// C D E C A A
//  D F A G F E
// C E D C B
// B C D E C A A


			


enum logic [3:0] {idle_st, A_ST, B_ST, C_ST, D_ST, E_ST, F_ST, G_ST} present_state, next_state;

parameter A = 0;
parameter B = 1;
parameter C = 2;
parameter D = 3;
parameter E = 4;
parameter F = 5;
parameter G = 6;
parameter A_TWO = 7;

localparam WIN = 2'b10;

logic enable_outTemp;
logic counterEnable;	
int counter;	
logic [3:0] toneTemp;


always_ff @(posedge clk, negedge resetN) begin
		if (!resetN) begin
			tone <= 0;
			enable_out <= 1'b0;
			counter <= 0;
		end
		else begin
			
			if (enableSound) begin
				case (counter) 	
					0: begin
						tone <= E;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 1;
						end
					1: begin
						tone <= B;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 2;
						end
					2: begin
						tone <= C;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 3;
						end
					3: begin
						tone <= D;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 4;
						end
					4: begin
						tone <= C;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 5;
						end
					5: begin
						tone <= B;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 6;
						end
					6: begin
						tone <= A;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 7;
						end
					7: begin
						tone <= A;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 8;
						end
					8: begin
						tone <= C;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 9;
						end
					9: begin
						tone <= E;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 10;
						end
					10: begin
						tone <= D;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 11;
						end
					11: begin
						tone <= C;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 12;
						end
					12: begin
						tone <= B;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 13;
						end
					13: begin
						tone <= B;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 14;
						end
					14: begin
						tone <= C;
						enable_out <= 1'b1;
						if (twoSecPulse)
							counter <= 15;
						end
					15: begin
						tone <= D;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 16;
						end
					16: begin
						tone <= E;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 17;
						end
					17: begin
						tone <= C;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 18;
						end
					18: begin
						tone <= A;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 19;
						end
					19: begin
						tone <= A;
						enable_out <= 1'b1;
						if (fourSecPulse)
							counter <= 20;
						end
				default begin
						enable_out <= 1'b0;
						end
				
				endcase
				
				end
			else begin
				enable_out <= 1'b0;
			end

		end
end




















// state register
//always_ff @(posedge clk, negedge resetN) begin
//		if (!resetN) begin
//			tone <= 0;
//			enable_out <= 1'b0;
//			present_state <= idle_st;
//			counter <= 0;
//		end
//		else begin
//			present_state <= next_state;
//			if (enableSound) begin
//				if (twoSecPulse && (counterEnable)) begin
//					counter <= counter + 1;
//					tone <= toneTemp;
//					enable_out <= enable_outTemp;
//				end
//			end
//			else begin
//				tone <= 0;
//				enable_out <= 1'b0;
//			end
//
//		end
//end


//// next state logic
//always_comb 
//begin
//	if (!resetN) begin
//		next_state = idle_st;
//		toneTemp = 0;
//		enable_outTemp = 1'b0;
//		counterEnable = 1'b0;
//	end
//	else begin
//		case (present_state)
//			idle_st: begin
//				toneTemp = 0;
//				enable_outTemp = 1'b0;
//				if (twoSecPulse && (levelCode == WIN)) begin
//					counterEnable = 1'b1;			
//					next_state = E_ST;
//				end
//				else begin
//					counterEnable = 1'b0;
//					next_state = idle_st;
//				end
//			end
//			A_ST: begin
//				counterEnable = 1'b1;			
//				toneTemp = A;
//				enable_outTemp = 1'b1;
//				if (twoSecPulse)  begin
//					case (counter)
//						7:
//							next_state = A_ST;
//						8:
//							next_state = C_ST;
//						18:
//							next_state = A_ST;
//						19: 
//							next_state = D_ST;
//						22:
//							next_state = G_ST;
//						default begin
//							next_state = A_ST;
//						end
//					endcase
//				end
//				else
//					next_state = A_ST;
//			end
//			B_ST: begin
//				counterEnable = 1'b1;			
//				toneTemp = B;
//				enable_outTemp = 1'b1;
//				if (twoSecPulse) 
//					case (counter)
//						2:
//							next_state = C_ST;
//						6:
//							next_state = A_ST;
//						13:
//							next_state = C_ST;
//						30:
//							next_state = B_ST;
//						31: 
//							next_state = C_ST;
//						36:
//							next_state = A_ST;
//						37: 
//							next_state = idle_st;
//						default begin
//							next_state = B_ST;
//						end						
//							
//					endcase
//				else
//					next_state = B_ST;
//			end
//			C_ST: begin
//				counterEnable = 1'b1;			
//				toneTemp = C;
//				enable_outTemp = 1'b1;
//				if (twoSecPulse) 
//					case (counter)
//						3:
//							next_state = D_ST;
//						5:
//						    next_state = B_ST;
//						9:
//							next_state = E_ST;
//						12:
//							next_state = B_ST;
//						14:
//							next_state = D_ST;
//						17:
//							next_state = A_ST;
//						26: 
//							next_state = E_ST;
//						29:
//							next_state = B_ST;
//						32:
//							next_state = D_ST;
//						35:
//							next_state = A_ST;
//						default begin
//							next_state = C_ST;
//						end
//						
//					endcase
//				else
//					next_state = C_ST;
//					
//			end
//			D_ST: begin
//				counterEnable = 1'b1;			
//				toneTemp = D;
//				enable_outTemp = 1'b1;
//				if (twoSecPulse) 
//					case (counter)
//						4:
//							next_state = C_ST;
//						11:
//							next_state = C_ST;
//						15:
//							next_state = E_ST;
//						20:
//							next_state = F_ST;
//						28:
//							next_state = C_ST;
//						33:
//							next_state = E_ST;
//						default begin
//							next_state = D_ST;
//						end
//							
//					endcase
//				else
//					next_state = D_ST;
//			end
//			E_ST: begin
//				counterEnable = 1'b1;			
//				toneTemp = E;
//				enable_outTemp = 1'b1;
//				if (twoSecPulse) 
//					case (counter)
//						1:
//							next_state = B_ST; 
//						10: 
//							next_state = D_ST;
//						16:
//							next_state = C_ST;
//						25:
//							next_state = C_ST;
//						27:
//							next_state = D_ST;
//						34:
//							next_state = C_ST;
//						default begin
//							next_state = E_ST;
//						end
//						
//					endcase
//				else
//					next_state = E_ST;
//			end
//			F_ST: begin
//				counterEnable = 1'b1;			
//				toneTemp = F;
//				enable_outTemp = 1'b1;
//				if (twoSecPulse) 
//					case (counter)
//						21: 
//							next_state = A_ST;
//						24:
//							next_state = E_ST;
//						default begin
//							next_state = F_ST;
//						end
//						
//					endcase
//				else
//					next_state = F_ST;
//			end
//			G_ST: begin
//				counterEnable = 1'b1;			
//				toneTemp = G;
//				enable_outTemp = 1'b1;
//				if (twoSecPulse) 
//					case (counter)
//						23:
//							next_state = F_ST;
//						default begin
//							next_state = G_ST;
//						end
//						
//					endcase
//				else
//					next_state = G_ST;					
//			end
//			
//			default begin
//				next_state = idle_st;
//			end
//		endcase
//	end
//end

endmodule





//end





