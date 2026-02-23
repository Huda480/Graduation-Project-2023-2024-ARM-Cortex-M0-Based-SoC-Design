/*
======================================================================================
				Standard   : WIFI
				Block name : Puncturer controller + Puncturer FIFO
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_puncture34
(
	clk,
	reset,
	valid_in,
	data_in,
	valid_out,
	data_out
);
	//============================================================================
	input clk;
	input reset;
	input valid_in;
	input data_in;
	output valid_out;
	output data_out;
	//============================================================================
	wire re;
	wire we;
	wire data_write;
	//============================================================================
	WIFI_TX_control_puncture34 control
	(
		.clk(clk),
		.reset(reset),
		.valid_in(valid_in),
		.data_in(data_in),
		.we(we),
		.re(re),
		.data_out(data_write)
	);
	//============================================================================
	WIFI_TX_puncturer_fifo fifo
	(
		.clk(clk),
		.reset(reset),
		.re(re),
		.we(we),
		.data_in(data_write),
		.data_out(data_out),
		.valid_out(valid_out)
	);
	//============================================================================
endmodule
