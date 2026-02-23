/*
=========================================================================================
				Standard: 	WIFI
				Block name:	Scrambler
=========================================================================================
*/
//=======================================================================================
module top_deScrambler_wifi 
(
	input clk,
	input reset,
	input data_in,
	input valid_in,
	output reg valid_out,
	output reg data_out
);
	//===============================================================================	
	reg [4:0] header_length;
	reg [6:0] data_reg;
	reg [11:0] data_length;
	reg [15:0] counter;
	reg valid_out1,data_out1;
	//===============================================================================	
	always @ (posedge clk or negedge reset) 
	begin
		//=======================================================================
		if (reset == 0) 
		begin
			valid_out 	<= 1'b0;
			data_out 	<= 1'b0;
			data_reg 	<= 7'b1111111;
			header_length 	<= 5'd0;
			data_length 	<= 12'd0;
			counter 	<= 12'd0;
		end
		//=======================================================================
		else 
		begin
			//$display($time," out=",data_out);
			//$display($time," v_out=",valid_out);
			//===============================================================
			if (valid_in == 1) 
			begin
				//=======================================================
				if (header_length < 24) 
				begin
					if (header_length > 4 && header_length < 17) 
					begin
						data_length 		<= data_length >> 1;
						data_length [11] 	<= data_in;
					end

					data_out 	<= data_in;
					valid_out 	<= 1'b1;
					header_length 	<= header_length +1'b1;
				end
				//=======================================================
				else 
				begin
					if (counter < ((data_length*8) + 16 )) 
					begin
						valid_out 	<= 1'b1;
						data_out 	<= data_reg[6] ^ data_reg[3] ^ data_in;
						data_reg 	<= {data_reg[5:0], (data_reg[6] ^ data_reg[3])};
						counter 	<= counter + 1'd1;
					end
					else if (counter < ((data_length*8) + 22 )) 
					begin
						valid_out	<= 1'b1;
						data_out 	<= 1'b0;
						counter 	<= counter + 1'd1;
					end
					else 
					begin
						data_out 	<= data_in;
						valid_out 	<= 1'b1;
					end
				end
			end
			//===============================================================
			else 
			begin
				valid_out 	<= 1'b0;
				data_reg	<= 7'b1111111;
				header_length	<= 5'd0;
				data_length 	<= 12'd0;
				counter 	<= 12'd0;
			end
			//===============================================================
		end
		//=======================================================================
		//valid_out<=valid_out;
		//data_out<=data_out;
	end
	//===============================================================================	
endmodule
