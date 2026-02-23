/*
=========================================================================================
				Standard :	WIFI
				Block name :	FIFO+Encoder
=========================================================================================
*/
//=======================================================================================
module WIFI_TX_top_convo
(
	input clk,
	input clk_out,
	input reset,
	input valid_in,
	input enable,
	input data_in,
	output valid_out,
	output finished,
	output data_out
 );
	//===============================================================================	
	wire data_out_fifo;
	wire valid_out_fifo;
	//===============================================================================	
	dummy_fifo fifo 
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
	//===============================================================================	
	WIFI_TX_topmodule_convolutionHalf encoder 
	(
		.clk_in(clk),
		.clk_out(clk_out),
		.reset(reset),
		.valid_in(valid_out_fifo),
		.data_in(data_out_fifo),
		.valid_out(valid_out),
		.data_out(data_out)
	);
	//===============================================================================	
endmodule
