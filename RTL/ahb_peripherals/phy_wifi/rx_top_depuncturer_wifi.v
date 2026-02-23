/*
======================================================================================
				Standard   : WIFI
				Block name : Top Puncturer 
======================================================================================
*/
//====================================================================================
module top_depuncturer_wifi #(parameter DEPUNCTURER=0)
(
	clk,
	reset,
	enable,
	valid_in,
	data_in,
	valid_out,
	data_out,
	finished
);
	//============================================================================
	(* dont_touch = "yes" *)  input clk;
	(* dont_touch = "yes" *)  input reset;
	input enable;
	input valid_in;
	input data_in;    
	output valid_out;
	output data_out; 
	output finished;
	//============================================================================
	generate
		case(DEPUNCTURER)
			0:
			begin
				(* keep_hierarchy = "yes" *) 
				top_depuncture34_dummy_wifi puncture34
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
			1:
			begin
				(* keep_hierarchy = "yes" *) 
				top_depuncture34_wifi puncture34
				(
					.clk(clk), 
					.reset(reset), 
					//.enable(enable), 
					.valid_in(valid_in), 
					.data_in(data_in), 
					.data_out(data_out), 
					.valid_out(valid_out)//,
					//.finished(finished)
				);
			end
		endcase
	endgenerate
	//============================================================================
endmodule
