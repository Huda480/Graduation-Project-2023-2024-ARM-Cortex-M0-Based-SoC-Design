/*
======================================================================================
				Standard   : WIFI
				Block name : Dummy FIFO + Puncturer 
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_puncture34controllerd
(
	clk,
	reset,
	valid_in,
	enable,
	data_in,
	valid_out,
	finished,
	data_out
);
	//============================================================================
	input clk;
	input reset;
	input valid_in;
	input enable;
	input data_in;    
	output valid_out;
	output finished;
	output data_out; 
	//============================================================================
	wire data_out_fifo;
	wire valid_out_fifo;
	//============================================================================
	WIFI_TX_dummy_fifo_pun fifo
	(
		.clk(clk),
		.reset(reset),
		.re(enable),
		.we(valid_in),
		.data_in(data_in),
		.data_out(data_out_fifo),
		.valid_out(valid_out_fifo),
		.finished(finished)
	);
	//============================================================================
	WIFI_TX_top_puncture34 puncture 
	(
		.clk(clk), 
		.reset(reset), 
		.valid_in(valid_out_fifo), 
		.data_in(data_out_fifo), 
		.valid_out(valid_out), 
		.data_out(data_out)
	);
	//============================================================================
endmodule
