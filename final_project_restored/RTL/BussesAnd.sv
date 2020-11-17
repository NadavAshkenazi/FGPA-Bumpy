

module	BussesAnd	(	
 
					input	logic	[7:0] in1,
					input	logic	[7:0] in2,
					input logic enable,


					output logic [7:0] out
		
					
					
					
);

//////////--------------------------------------------------------------------------------------------------------------=

logic [7:0] enableTemp;

assign enableTemp[0] = enable;
assign enableTemp[1] = enable;
assign enableTemp[2] = enable;
assign enableTemp[3] = enable;
assign enableTemp[4] = enable;
assign enableTemp[5] = enable;
assign enableTemp[6] = enable;
assign enableTemp[7] = enable;


assign out = (in1 & in2 & enableTemp); //to check

endmodule




