

module score_counter 
	(
   // Input, Output Ports
   input logic clk, 
   input logic resetN,
   input logic loadN,
	input logic [7:0] init,
   input logic enable,
	input logic	[7:0] addValue,
   output logic [7:0] count 
   );

 	int countOnes;
	int countTens;
	assign count =  {countOnes , countTens} ; 
 
   always_ff @( posedge clk , negedge resetN ) begin
      if ( !resetN ) begin // Asynchronic reset
			countOnes <= 4'b0000;
			countTens <= 4'b0000;

		end
		
		else if (enable) begin
			if (!loadN) begin
				countOnes <= init[3:0];
				countTens <= init [7:4];
			end
			else  begin
				if	(countOnes + addValue[3:0] > 9) begin
					countOnes <= countOnes + addValue[3:0] - 10;
					countTens <= count[7:4] + addValue[7:4] +1;
				end
				else begin
					countOnes <= countOnes + addValue[3:0];
					countTens <= count[7:4] + addValue[7:4];
				end
			end
		end
		else begin 
			countOnes <= countOnes;
			countTens <=countTens;	
		end
   end // always
	 
endmodule

