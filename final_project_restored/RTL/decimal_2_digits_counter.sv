// (c) Technion IIT, Department of Electrical Engineering 2018 
// Alex Grinshpun Sept 2019

// Kobi Dekel Jul 2020
// This module shows an example for how to build hierarchy-integrated module from generic module  
// Here we take two 4bit in/out decimal_down_counter and use them to build 8bit in/out 
// decimal_2_digits_counter ( 4bit x 2 binary ) each 4 bit output can be connected to BCD27Seg 
// module and feed 7Seg. The lower 4 bit relate to the units(ones),and the higher 4 bit relate 
// to the Tens.      


module decimal_2_digits_counter
	(
	input  logic clk, 
	input  logic resetN,
	input  logic ena, 
	input  logic ena_cnt, 
	input  logic loadN,
	input	 logic startOfFrame,
	input  logic [7:0] Data_init,
	output logic [7:0] Count_out,
	output logic tc,
	output logic eightSecPulse,
	output logic twoSecPulse,
	output logic fourSecPulse
   );
	
	logic tc_ones ;
	logic tc_tens ;
	
	
// units (Ones) 
	decimal_down_counter ones_counter(
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena), 
		.ena_cnt(ena_cnt) ,  
	.loadN(loadN), 
		
		.datain(Data_init[3:0]),
		
		.count(Count_out[3:0]),
		.tc(tc_ones)
	);

	
// Tens
	decimal_down_counter tens_counter( 
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena), 
		.ena_cnt(tc_ones & ena_cnt),
		.loadN(loadN), 
		
		.datain(Data_init[7:4]),
		
		.count(Count_out[7:4]),
		.tc(tc_tens)	
	);

	 

logic flag;
logic flagOnes;
logic	flagTens;

logic resetNTemp;
logic resetNTempTest;
logic tcOnesTemp;
logic tcTensTemp;

//----------tc delay--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flagOnes	<= 1'b0;
		tcOnesTemp <= 1'b0 ; 
	end 
	else begin 
			tcOnesTemp <= 1'b0 ; // default 
			if (tc_ones  && (flagOnes == 1'b0)) begin 
				flagOnes	<= 1'b1; // to enter only once 
				tcOnesTemp <= 1'b1 ; 
			end 
			else if (!tc_ones)
				flagOnes	<= 1'b0; 
	end 
end

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flagTens	<= 1'b0;
		tcTensTemp <= 1'b0 ; 
	end 
	else begin 
			tcTensTemp <= 1'b0 ; // default 
			if (tc_tens  && (flagTens == 1'b0)) begin 
				flagTens	<= 1'b1; // to enter only once 
				tcTensTemp <= 1'b1 ; 
			end 
			else if (!tc_tens)
				flagTens	<= 1'b0; 
	end 
end


//-----------------------------------
 always_ff@(posedge clk or negedge resetN) begin
	if(!resetN)
	begin 
		flag <= 1'b0;
		tc <= 1'b0 ; 
		resetNTemp <= resetN;
		resetNTempTest <= resetNTemp;
	end 
	else begin
			resetNTemp <= resetN;
			resetNTempTest <= resetNTemp;
			tc <= 1'b0 ; // default 
			if (tcOnesTemp && tc_tens	&& resetNTempTest &&(flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				tc <= 1'b1 ; 
			end 
			else if (!tcOnesTemp || !tc_tens)
				flag	<= 1'b0; 
	end 

end

//-----------------------------------

int pulseFlag;
 always_ff@(posedge clk or negedge resetN) begin
	if(!resetN)
	begin 
		pulseFlag <= 1'b0;
		eightSecPulse <= 1'b0;
	end 
	else begin
		if (Count_out[1] && !pulseFlag) begin
			eightSecPulse <= 1'b1;
			pulseFlag <= 1'b1;
		end
		
		else if (!Count_out[1]) begin
			pulseFlag <= 1'b0;
			eightSecPulse <= 1'b0;
		end
		
		else if (pulseFlag) begin
			eightSecPulse <= 1'b0;
		end
		
		else begin
			pulseFlag <= 1'b0;
			eightSecPulse <= 1'b0;
		end
	end 

end


int twoSecPulseFlag;
 always_ff@(posedge clk or negedge resetN) begin
	if(!resetN)
	begin 
		twoSecPulseFlag <= 1'b0;
		twoSecPulse <= 1'b0;
	end 
	else begin
		if (Count_out[0] && !twoSecPulseFlag) begin
			twoSecPulse <= 1'b1;
			twoSecPulseFlag <= 1'b1;
		end
		
		else if (!Count_out[0]) begin
			twoSecPulseFlag <= 1'b0;
			twoSecPulse <= 1'b0;
		end
		
		else if (twoSecPulseFlag) begin
			twoSecPulse <= 1'b0;
		end
		
		else begin
			twoSecPulseFlag <= 1'b0;
			twoSecPulse <= 1'b0;
		end
	end 

end



int fourSecPulseFlag;
 always_ff@(posedge clk or negedge resetN) begin
	if(!resetN)
	begin 
		fourSecPulseFlag <= 1'b0;
		fourSecPulse <= 1'b0;
	end 
	else begin
		if (Count_out[0] && !fourSecPulseFlag) begin
			fourSecPulse <= 1'b1;
			fourSecPulseFlag <= 1'b1;
		end
		
		else if (!Count_out[0]) begin
			fourSecPulseFlag <= 1'b0;
			fourSecPulse <= 1'b0;
		end
		
		else if (fourSecPulseFlag) begin
			fourSecPulse <= 1'b0;
		end
		
		else begin
			fourSecPulseFlag <= 1'b0;
			fourSecPulse <= 1'b0;
		end
	end 

end



endmodule
