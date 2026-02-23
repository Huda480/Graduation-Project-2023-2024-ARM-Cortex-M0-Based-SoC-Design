/*
=========================================================================================
				Standard   :	WIFI
				Block name :	Top Deinterleaver
=========================================================================================
*/
//=======================================================================================
module top_deinterleaver_wifi #(parameter INTERLEAVER = 96)
(

	clk,
	reset,
	enable,
	valid_in,
	data_in,
	data_out,
	valid_out,
	finished
);
	//===============================================================================
	input clk;
	input reset;
	input enable;
	input valid_in;
	input data_in;
	(* dont_touch = "yes" *) output finished;
	output valid_out;
	output data_out; 
	//===============================================================================
	generate
		case (INTERLEAVER)
			48:
			begin
				top_deinterleaver48_wifi top_deinterleaver48_wifi
				(
					.clk(clk),
					.reset(reset),
					.enable(enable),
					.valid_in(valid_in),
					.data_in(data_in),
					.data_out(data_out),
					.valid_out(valid_out),
					.finished(finished)
				);
			end	
			96:
			begin
				top_deinterleaver96_wifi top_deinterleaver96_wifi
				(
					.clk(clk),
					.reset(reset),
					.enable(enable),
					.valid_in(valid_in),
					.data_in(data_in),
					.data_out(data_out),
					.valid_out(valid_out),
					.finished(finished)
				);
			end	
			192:
			begin
				top_deinterleaver192_wifi top_deinterleaver192_wifi
				(
					.clk(clk),
					.reset(reset),
					.enable(enable),
					.valid_in(valid_in),
					.data_in(data_in),
					.data_out(data_out),
					.valid_out(valid_out),
					.finished(finished)
				);
			end	
		endcase
	endgenerate
	//===============================================================================
endmodule
