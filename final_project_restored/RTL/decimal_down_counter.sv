// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements a down counter 9 to 0 with enable and loadN data
// and count and tc outputs
// Alex Grinshpun

module decimal_down_counter
	(
	input logic clk,
	input logic resetN,
	input logic ena,
	input logic ena_cnt,
	input logic loadN, 
	input logic [3:0] datain,
	output logic [3:0] count,
	output logic tc
   );

// Down counter
always_ff @(posedge clk or negedge resetN)
  begin
	
	if ( !resetN )	begin // Asynchronic reset
				count <= 4'b0;
			end
      else if (loadN == 0)	begin		// Synchronic logic	
				count <= datain;	
			end
		else if ((ena ==  0) || (ena_cnt ==0)) begin
				count <= count;
			end
		else if (count ==0) begin
				count <= 4'h9;
			end
		else begin
				count <= count-1;
			end
				
	end //always
	
	logic out;
	
//	nor nor1 (out, count[0], count[1], count[2], count[3], !resetN);
//	
//	// Asynchronic tc
//	assign tc = out;

logic flag = 1'b0;

 always_comb begin
	
	if (!count[0] && !count[1] && !count[2] && !count[3] && (resetN == 1'b1) && !flag)
		tc = 1'b1;
		
	else
		tc = 1'b0;
	
end

//logic flag;
//
// always_comb begin
// 
//	if (!resetN)
//		flag = 1'b0;
//	
//	else if (!count[0] && !count[1] && !count[2] && !count[3] && !flag) begin
//		tc = 1'b1;
//		flag = 1'b1;
//	end
//	else if (flag) begin
//		flag = 1'b1;
//		tc = 1'b0;
//	end
//	else begin
//		flag = 1'b0;
//		tc = 1'b0;
//	end
//	
//end
			
					
endmodule
