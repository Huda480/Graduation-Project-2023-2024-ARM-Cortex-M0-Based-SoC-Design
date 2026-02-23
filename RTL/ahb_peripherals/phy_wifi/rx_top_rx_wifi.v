/*
=========================================================================================
				Standard   :	WIFI
				Block name :	Rx top level
=========================================================================================
*/
//=======================================================================================
module top_rx_wifi #(parameter DEPUNCTURER=0, DEINTERLEAVER=96 , DEMAPPER=4)
(
	clk_output,
	clk_decoder,
	clk_fft,
	reset,
	valid_in,
	data_in_real,
	data_in_imag,
	valid_out,
	data_out
);
	//===============================================================================	
	input clk_output;
(* dont_touch = "yes" *) input clk_decoder;
	input clk_fft;
	input reset;
	input valid_in;
	input [11:0]data_in_real;
	input [11:0]data_in_imag;
	output valid_out;
	output  data_out;
	//===============================================================================
	wire deinterleaver_finish;
	wire deinterleaver_valid_out;
	wire deinterleaver_data_out;
	wire depuncturer_finish;
	wire depuncturer_valid_out;
	wire depuncturer_data_out;
	wire decoder_finish;
	wire [11:0] data_out_real_demap;
	wire [11:0] data_out_imag_demap;
	wire [11:0] data_out_re;
	wire [11:0] data_out_im;
	wire valid_out_fft;
	wire valid_out_packet;
	wire last_symbol;
	wire fft_stop;
	wire [5:0]special_index;
	wire data_out_demap;
	wire valid_out_demap;
	wire valid_descrampler_decoder;
	wire data_out_decoder;
	wire enable_decoder;
	//===============================================================================
	(* keep_hierarchy = "yes" *) 
	packet_divider packet_div
	(
		.clk(clk_fft),
		.valid_in(valid_in),
		.reset(reset),
		.data_in_re(data_in_real),
		.data_in_im(data_in_imag),
		.data_out_re(data_out_re),
		.data_out_im(data_out_im),
		.valid_out(valid_out_packet),
		.last_symbol(last_symbol)
	);
	//===============================================================================
	(* keep_hierarchy = "yes" *) 
	fft_controller #(12, 6) control_fft
	(
		.clk(clk_fft),
		.reset(reset),
		.data_in_real(data_out_re),
		.data_in_imag(data_out_im),
		.valid_in(valid_out_packet),
		.last_symbol(last_symbol),
		.data_out_real(data_out_real_demap),
		.data_out_imag(data_out_imag_demap),
		.special_index(special_index),
		.valid_out(valid_out_fft)
	);
	//===============================================================================
	(* keep_hierarchy = "yes" *) 
	top_demap demapper
	(
		.clk(clk_fft),
		.clk_output(clk_output),
		.clk_decoder(clk_decoder),
		.reset(reset),
		.valid_in(valid_out_fft),
		.valid_out(valid_out_demap),
		.data_in_real(data_out_real_demap),
		.data_in_imag(data_out_imag_demap),
		.data_out(data_out_demap),
		.last_symbol(last_symbol),
		.special_index(special_index)
	);
	//===============================================================================
	(* keep_hierarchy = "yes" *) 
	top_deinterleaver_wifi #(DEINTERLEAVER) deinterleaver
	(
		.clk(clk_output),
		.reset(reset),
		.enable(depuncturer_finish),
		.data_in(data_out_demap),
		.valid_in(valid_out_demap),
		.finished(deinterleaver_finish),
		.data_out(deinterleaver_data_out),
		.valid_out(deinterleaver_valid_out)
	);	
	//===============================================================================
	(* keep_hierarchy = "yes" *) 
	top_depuncturer_wifi #(DEPUNCTURER) depuncturer
	(
		.clk(clk_output),
		.reset(reset),
		.enable(decoder_finish),
		.valid_in(deinterleaver_valid_out),
		.data_in(deinterleaver_data_out),
		.valid_out(depuncturer_valid_out),
		.data_out(depuncturer_data_out),
		.finished(depuncturer_finish)
	);
	//===============================================================================
	(* keep_hierarchy = "yes" *) 
	top_controlled_viterbi_wifi decoder
	(
		.clk(clk_output), 
		.RESET(reset),
		.valid_in(depuncturer_valid_out),
		.data_in(depuncturer_data_out),
		.enable(enable_decoder),
		.data_out(data_out_decoder),
		.valid_out(valid_descrampler_decoder),
		.finished(decoder_finish)
	);
	//===============================================================================
	(* keep_hierarchy = "yes" *) 
	(* DONT_TOUCH = "yes" *)
	topcontrolled_descrambler_wifi descrambler
    (
        .clk(clk_output),
        .reset(reset),
        .valid_in(valid_descrampler_decoder),
        .enable(1'b1),
        .data_in(data_out_decoder),  
        .valid_out(valid_out),
        .finished(enable_decoder),
        .data_out(data_out)
    );
	//===============================================================================
endmodule	
