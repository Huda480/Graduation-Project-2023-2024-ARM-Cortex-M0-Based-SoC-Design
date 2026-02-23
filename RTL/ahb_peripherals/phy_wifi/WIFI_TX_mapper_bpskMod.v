/*
======================================================================================
				Standard   : WIFI
				Block name : BPSK Mapper
======================================================================================
*/
//====================================================================================
module WIFI_TX_mapper_bpskMod
(
	clk,
	reset,
	valid_in,
	data_in,
	valid_out,
	data_out_real,
	data_out_imag
);
	//============================================================================	
	input clk;
	input reset;
	input valid_in;
	input data_in;
	output valid_out;
	output [11:0] data_out_real;
	output [11:0] data_out_imag;
	//============================================================================	
	reg valid_out_1;
	(* dont_touch = "true" *)  reg [11:0] data_out_real;
	(* dont_touch = "true" *)  reg [11:0] data_out_imag;		
	//============================================================================	
	always@(posedge clk or negedge reset)
	begin
		//====================================================================
		if(!reset)
		begin
			data_out_real 	<= 0;
			data_out_imag 	<= 0;
			valid_out_1 	<= 0;
		end
		//====================================================================
		else
		begin
			//============================================================
			if (valid_in)
			begin
				case (data_in)
					0:
					begin
						data_out_real	<= 12'b111000000000;
						data_out_imag 	<= 0;
						valid_out_1 	<= 1;
					end			 
					1:
					begin
						
						data_out_real	<= 12'b001000000000;
						data_out_imag 	<= 0;
						valid_out_1 	<= 1;
					end
					default:
					begin
						data_out_real 	<= 0;
						data_out_imag 	<= 0;
						valid_out_1 	<= 0;
					end
				endcase
			end
			//============================================================
			else
			begin
				data_out_real 	<= 0;
				data_out_imag 	<= 0;
				valid_out_1 	<= 0;
			end
			//============================================================
		end
		//====================================================================
	end
	//============================================================================
	assign valid_out = valid_out_1;
	//============================================================================
endmodule
