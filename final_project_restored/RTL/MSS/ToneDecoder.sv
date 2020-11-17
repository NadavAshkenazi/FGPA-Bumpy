/// (c) Technion IIT, Department of Electrical Engineering 2019 
//-- This module  generate the correet prescaler tones for a single ocatave 

//-- Dudy Feb 12 2019 

module	ToneDecoder	(	
					input	logic [3:0] tone, 
					output	logic [9:0]	preScaleValue
		);

logic [15:0] [9:0]	preScaleValueTable = { 

// old notes

//10'h2EA,   // decimal =746.55      Hz =261.62  do   = C
//10'h2C0,   // decimal =704.64      Hz =277.18  doD
//10'h299,   // decimal =665.09      Hz =293.66  re	 = D
//10'h273,   // decimal =627.77      Hz =311.12  reD
//10'h250,   // decimal =592.53      Hz =329.62  mi	 = E
//10'h22F,   // decimal =559.28      Hz =349.22  fa	 = F
//10'h20F,   // decimal =527.87      Hz =370  faD
//10'h1F2,   // decimal =498.24      Hz =392  sol		 = G
//10'h1D6,   // decimal =470.29      Hz =415.3  solD
//10'h1BB,   // decimal =443.89      Hz =440  La		= A
//10'h1a3,   // decimal =418.98      Hz =466.16  laD
//10'h18b} ; // decimal =395.46      Hz =493.88  si	= B
////10'h345,   // decimal =837.96      Hz =233.08  laD
////10'h316} ; // decimal =790.93      Hz =246.94  si 


//new notes

10'h1BB, // decimal =443.89   	Hz =440    		La = A
10'h18b, // decimal =395.46      Hz =493.88  	si	= B
10'h175, // decimal =373.44 		HZ =523.2511	do = C
10'h14C, // decimal =332.72		HZ =587.33		re = D
10'h128, // decimal =296.28		HZ =659.2551	mi = E
10'h117, // decimal =279.63		HZ =698.457		fa = F
10'hF9, // 	decimal =249.125		HZ =783.9909	sol = G
10'hDD, // 	decimal =221.94		HZ =880.0000	la = A2

//old notes

10'h2EA,   // decimal =746.55      Hz =261.62  do   = C
10'h2C0,   // decimal =704.64      Hz =277.18  doD
10'h299,   // decimal =665.09      Hz =293.66  re	 = D
10'h273,   // decimal =627.77      Hz =311.12  reD
10'h250,   // decimal =592.53      Hz =329.62  mi	 = E
10'h22F,   // decimal =559.28      Hz =349.22  fa	 = F
10'h20F,   // decimal =527.87      Hz =370  faD
10'h1F2};   // decimal =498.24      Hz =392  sol		 = G


assign 	preScaleValue = preScaleValueTable [tone] ; 

endmodule


