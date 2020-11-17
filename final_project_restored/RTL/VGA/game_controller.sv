
// emits pulses specifing collisions 


module	game_controller	(	
			input		logic	clk,
			input		logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Bumpy,
			input	logic	drawing_request_floor,
			input logic drawing_request_obstacle,
			input	logic	drawing_request_steps,
			input	logic	drawing_request_diamond,
			input	logic	drawing_request_heart,
			input	logic	drawing_request_finishFlag,
			input	logic	drawing_request_shoot,
			input	logic	drawing_request_ceiling,
			input	logic	drawing_request_leftWall,
			input	logic	drawing_request_rightWall,
			input	logic	drawing_request_covid,



			
			
			output logic collision, // active in case of collision between two objects
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			
			
			output logic SHP_bumpyDiamond,
			output logic SHP_bumpyHeart,
			output logic SHP_bumpyCollision,		
			output logic SHP_obstacleCollision, //temp
			output logic staticObjectReq,
			output logic SHP_bumpyFinishFlag,
			output logic SHP_shootCollision,
			output logic SHP_shootObstacle,
			output logic SHP_bumpyObstacle,
			output logic SHP_bumpyCovid,
			output logic SHP_covidCollision,
			output logic SHP_shootCovid


			

			
);

assign collision = (drawing_request_Bumpy + drawing_request_floor + drawing_request_obstacle + drawing_request_steps
							+ drawing_request_diamond + drawing_request_heart +drawing_request_finishFlag + drawing_request_shoot
							+ drawing_request_ceiling + drawing_request_leftWall + drawing_request_rightWall + drawing_request_covid >= 2) ? 1 : 0;



logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 
logic flag_SHP_bumpyDiamond;
logic flag_SHP_bumpyHeart;
logic flag_SHP_bumpyCollision;
logic flag_SHP_obstacleCollision;
logic flag_SHP_bumpyFinishFlag;
logic flag_SHP_shootCollision;
logic flag_SHP_shootObstacle;
logic flag_SHP_bumpyObstacle;
logic flag_SHP_bumpyCovid;
logic flag_SHP_covidCollision;
logic flag_SHP_shootCovid;





always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		staticObjectReq <= 1'b0;
	end 
	else begin 
		if (drawing_request_floor || drawing_request_steps 
				|| drawing_request_leftWall || drawing_request_rightWall) begin
			staticObjectReq <= 1'b1;
		end
		else begin
			staticObjectReq <= 1'b0;
		end
	
	end 
end

//----------single hit pulse--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time 
			if ( collision  && (flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1 ; 
			end ; 
	end 
end



//----------single hit SHP_bumpyDiamond--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_bumpyDiamond	<= 1'b0;
		SHP_bumpyDiamond <= 1'b0 ; 
	end 
	else begin 

			SHP_bumpyDiamond <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_bumpyDiamond = 1'b0 ; // reset for next time 
			if (drawing_request_Bumpy && drawing_request_diamond && (flag_SHP_bumpyDiamond == 1'b0)) begin 
				flag_SHP_bumpyDiamond	<= 1'b1; // to enter only once 
				SHP_bumpyDiamond <= 1'b1 ; 
			end ; 
	end 
end

//----------single hit SHP_bumpyHeart--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_bumpyHeart	<= 1'b0;
		SHP_bumpyHeart <= 1'b0 ; 
	end 
	else begin 

			SHP_bumpyHeart <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_bumpyHeart = 1'b0 ; // reset for next time 
			if (drawing_request_Bumpy && drawing_request_heart && (flag_SHP_bumpyHeart == 1'b0)) begin 
				flag_SHP_bumpyHeart	<= 1'b1; // to enter only once 
				SHP_bumpyHeart <= 1'b1 ; 
			end ; 
	end 
end


//----------single hit SHP_bumpyCollision--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_bumpyCollision	<= 1'b0;
		SHP_bumpyCollision <= 1'b0 ; 
	end 
	else begin 

			SHP_bumpyCollision <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_bumpyCollision = 1'b0 ; // reset for next time 
			if (collision && drawing_request_Bumpy && (!drawing_request_shoot) && (flag_SHP_bumpyCollision == 1'b0)) begin 
				flag_SHP_bumpyCollision	<= 1'b1; // to enter only once 
				SHP_bumpyCollision <= 1'b1 ; 
			end ; 
	end 
end



//----------single hit SHP_obstacleCollision--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_obstacleCollision	<= 1'b0;
		SHP_obstacleCollision <= 1'b0 ; 
	end 
	else begin 

			SHP_obstacleCollision <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_obstacleCollision = 1'b0 ; // reset for next time 
			if (collision && drawing_request_obstacle && (flag_SHP_obstacleCollision == 1'b0)) begin 
				flag_SHP_obstacleCollision	<= 1'b1; // to enter only once 
				SHP_obstacleCollision <= 1'b1 ; 
			end ; 
	end 
end

//----------single hit SHP_bumpyFinishFlag--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_bumpyFinishFlag <= 1'b0;
		SHP_bumpyFinishFlag <= 1'b0 ; 
	end 
	else begin 

			SHP_bumpyFinishFlag <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_bumpyFinishFlag = 1'b0 ; // reset for next time 
			if ( drawing_request_Bumpy && drawing_request_finishFlag && (flag_SHP_bumpyFinishFlag == 1'b0)) begin 
				flag_SHP_bumpyFinishFlag	<= 1'b1; // to enter only once 
				SHP_bumpyFinishFlag <= 1'b1 ; 
			end ; 
	end 
end


//----------single hit SHP_shootCollision--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_shootCollision <= 1'b0;
		SHP_shootCollision <= 1'b0 ; 
	end 
	else begin 

			SHP_shootCollision <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_shootCollision = 1'b0 ; // reset for next time 
			if ((!drawing_request_Bumpy) && collision && drawing_request_shoot && (flag_SHP_shootCollision == 1'b0)) begin 
				flag_SHP_shootCollision	<= 1'b1; // to enter only once 
				SHP_shootCollision <= 1'b1 ; 
			end ; 
	end 
end


//----------single hit SHP_shootObstacle--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_shootObstacle <= 1'b0;
		SHP_shootObstacle <= 1'b0 ; 
	end 
	else begin 

			SHP_shootObstacle <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_shootObstacle = 1'b0 ; // reset for next time 
			if ( drawing_request_shoot && drawing_request_obstacle && (flag_SHP_shootObstacle == 1'b0)) begin 
				flag_SHP_shootObstacle	<= 1'b1; // to enter only once 
				SHP_shootObstacle <= 1'b1 ; 
			end ; 
	end 
end

//----------single hit SHP_bumpyObstacle--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_bumpyObstacle <= 1'b0;
		SHP_bumpyObstacle <= 1'b0 ; 
	end 
	else begin 

			SHP_bumpyObstacle <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_bumpyObstacle = 1'b0 ; // reset for next time 
			if ( drawing_request_Bumpy && drawing_request_obstacle && (flag_SHP_bumpyObstacle == 1'b0)) begin 
				flag_SHP_bumpyObstacle	<= 1'b1; // to enter only once 
				SHP_bumpyObstacle <= 1'b1 ; 
			end ; 
	end 
end

//----------single hit SHP_bumpyCovid--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_bumpyCovid <= 1'b0;
		SHP_bumpyCovid <= 1'b0 ; 
	end 
	else begin 

			SHP_bumpyCovid <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_bumpyCovid = 1'b0 ; // reset for next time 
			if ( drawing_request_Bumpy && drawing_request_covid && (flag_SHP_bumpyCovid == 1'b0)) begin 
				flag_SHP_bumpyCovid	<= 1'b1; // to enter only once 
				SHP_bumpyCovid <= 1'b1 ; 
			end ; 
	end 
end

//----------single hit SHP_covidCollision--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_covidCollision <= 1'b0;
		SHP_covidCollision <= 1'b0 ; 
	end 
	else begin 

			SHP_covidCollision <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_covidCollision = 1'b0 ; // reset for next time 
			if ((!drawing_request_Bumpy) && collision && drawing_request_covid && (flag_SHP_covidCollision == 1'b0)) begin 
				flag_SHP_covidCollision	<= 1'b1; // to enter only once 
				SHP_covidCollision <= 1'b1 ; 
			end ; 
	end 
end

//----------single hit SHP_shootCovid--------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag_SHP_shootCovid <= 1'b0;
		SHP_shootCovid <= 1'b0 ; 
	end 
	else begin 

			SHP_shootCovid <= 1'b0 ; // default 
			if(startOfFrame) 
				flag_SHP_shootCovid = 1'b0 ; // reset for next time 
			if ( drawing_request_shoot && drawing_request_covid && (flag_SHP_shootCovid == 1'b0)) begin 
				flag_SHP_shootCovid	<= 1'b1; // to enter only once 
				SHP_shootCovid <= 1'b1 ; 
			end ; 
	end 
end




endmodule 
