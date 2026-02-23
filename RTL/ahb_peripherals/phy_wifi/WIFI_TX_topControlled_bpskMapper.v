/*
=========================================================================================
				Standard :	WIFI
				Block name :	Mapper + Mapper FIFO
=========================================================================================
*/
//=======================================================================================
module WIFI_TX_topControlled_bpskMapper#(parameter MAPPER=4)
(
	input clk,
	input reset,
	input enable,
	input valid_in,
	input data_in,   
	output finished,
	output valid_out,
	output [11:0] mod_out_re,
	output [11:0] mod_out_im,
	output last_sym,
	output re_out
);
	//===============================================================================	
	wire re_o;
	wire data_out_fifo;
	wire valid_out_fifo;
	//===============================================================================	
	assign re_out = re_o;
	//===============================================================================	
	WIFI_TX_mapper_fifo fifo
	(
		.clk(clk),
		.reset(reset),
		.re(enable),
		.we(valid_in),
		.data_in(data_in),
		.data_out(data_out_fifo),
		.valid_out(valid_out_fifo),
		.finished(finished),
		.last_sym(last_sym),
		.re_out(re_o)	
	);
	//===============================================================================	
	WIFI_TX_top_mapper #(MAPPER) mapper
	(
		.clk(clk),
		.reset(reset),
		.valid_in(valid_out_fifo),
		.data_in(data_out_fifo),
		.valid_out(valid_out),
		.data_out_real(mod_out_re),
		.data_out_imag(mod_out_im)
	);	
	//===============================================================================	
endmodule
