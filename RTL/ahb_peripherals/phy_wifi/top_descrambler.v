/*
=========================================================================================
                                Standard :      WIFI
                                Block name :    FIFO+Scrambler
=========================================================================================
*/
//=======================================================================================
module topcontrolled_descrambler_wifi
(
	input clk,
	input reset,
	input valid_in,
	(* dont_touch = "yes" *) input enable,
	input data_in,  
	output valid_out,
	output finished,
	output data_out
);
	//============================================================================
	wire data_out_fifo;
	wire valid_out_fifo;
	//============================================================================
	dummy_fifo_descrambler fifo_descrambler 
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
	top_deScrambler_wifi descrambler
	(
		.clk(clk),
		.reset(reset),
		.data_in(data_out_fifo),
		.valid_in(valid_out_fifo),
		.valid_out(valid_out),
		.data_out(data_out) 
	); 
	//============================================================================
endmodule
