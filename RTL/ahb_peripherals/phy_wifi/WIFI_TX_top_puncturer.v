/*
======================================================================================
				Standard   : WIFI
				Block name : Top Puncturer 
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_puncturer #(parameter PUNCTURER=0)
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
	input clk;
	input reset;
	input enable;
	input valid_in;
	input data_in;    
	output valid_out;
	output data_out; 
	output finished;
	//============================================================================
	generate
		case(PUNCTURER)
			0:
			begin
				(* keep_hierarchy = "yes" *) 
				WIFI_TX_top_puncture34_dummy puncture34
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
				WIFI_TX_top_puncture34controllerd puncture34
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
	//============================================================================
endmodule
