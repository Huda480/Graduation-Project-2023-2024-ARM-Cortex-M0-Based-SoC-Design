module top_demap
(
	clk,			// 40ns (25:15)
	clk_output,		// 20ns
	clk_decoder,	// 10ns
	reset,
	valid_in,
	valid_out,
	data_in_real,
	data_in_imag,
	data_out,
	last_symbol,
	special_index
);
	//======================================================================================
	input 			clk;
	input			clk_output;
	input           clk_decoder;
	input 			reset;
	input 			valid_in;
	(* dont_touch = "yes" *) input [11:0] 	data_in_real;
	(* dont_touch = "yes" *) input [11:0] 	data_in_imag;
	input 			last_symbol;
	input [5:0]		special_index;
	output 			valid_out;
	output 			data_out;
	//======================================================================================
	wire			valid_out_stack_demap;
	wire			valid_out_demap;
	wire			data_out_demap;
	(* dont_touch = "yes" *) wire [11:0]		data_real_inout;
	(* dont_touch = "yes" *) wire [11:0]		data_imag_inout;
	wire            stop_flag;
	//======================================================================================
	(* keep_hierarchy = "yes" *)
	stack_controller	stack_control
	(
		.clk(clk),
		.reset(reset),
		.valid_in(valid_in),
	 	.special_index(special_index),
	 	.last_symbol(last_symbol),
	 	.data_in_real(data_in_real),
	 	.data_in_imag(data_in_imag),
	 	.valid_out(valid_out_stack_demap),
	 	.data_out_real(data_real_inout),
	 	.stop_flag(stop_flag),
	 	.data_out_imag(data_imag_inout)
	);
	
	(* keep_hierarchy = "yes" *)
	top_demapper_wifi #(4) demapper
	(
		.clk(clk),
		.clk_output(clk_output),
		.clk_decoder(clk_decoder),
		.reset(reset),
		.valid_in(valid_out_stack_demap),
		.data_in_real(data_real_inout),
		.data_in_imag(data_imag_inout),
		.valid_out(valid_out_demap),
		.data_out(data_out_demap)
	);
	
	(* keep_hierarchy = "yes" *)
	top_ram_demap	#(4) ram_demapper
	(
		.clk(clk),
		.clk_output(clk_output),
		.clk_decoder(clk_decoder),
		.reset(reset),
		.re(stop_flag),
		.we(valid_out_demap),
		.valid_out(valid_out),
		.data_in(data_out_demap),
		.data_out(data_out)
	);
	endmodule