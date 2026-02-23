/*
======================================================================================
				Standard   : WIFI
				Block name : Generic Interleaver
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_interleaver #(parameter TYPE=96)
(
	clk,
	reset,
	valid_in,
	data_in,
	enable,
	valid_out,
	data_out,
	finished
);
	//============================================================================
	input clk;
	input reset;
	input valid_in;
	input data_in;
	input enable;
	output valid_out;
	output data_out; 
	output finished;
	//============================================================================
	generate
		//====================================================================
		case(TYPE)
			48:
			begin
				WIFI_TX_top_interleaver48 int_48
				(
					.clk(clk),
					.reset(reset),
					.enable(enable),
					.valid_in(valid_in),
					.data_in(data_in),
					.valid_out(valid_out),
					.data_out(data_out),
					.finished(finished)
				);
			end
			96:
			begin
				WIFI_TX_top_interleaver96 int_96
				(
					.clk(clk),
					.reset(reset),
					.enable(enable),
					.valid_in(valid_in),
					.data_in(data_in),
					.valid_out(valid_out),
					.data_out(data_out),
					.finished(finished)
				);
			end
			192:
			begin
				WIFI_TX_top_interleaver192 int_192
				(
					.clk(clk),
					.reset(reset),
					.enable(enable),
					.valid_in(valid_in),
					.data_in(data_in),
					.valid_out(valid_out),
					.data_out(data_out),
					.finished(finished)
				);
			end
		endcase
		//====================================================================
	endgenerate
	//============================================================================
endmodule
