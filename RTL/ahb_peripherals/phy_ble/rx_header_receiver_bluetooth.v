/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Header Receiver Chain
				Created By : Eslam Elnader
======================================================================================
*/
module top_receiver_bt_header_ble
(
    clk,
    clk_fast,
    reset,
    data_in_re,
    data_in_im,
    valid_in,
    UAP,
    n_bits,
    data_out,
    header_error_flag,
    valid_out
);
//--------------------------------------------------------------------
input clk;
input clk_fast;
input reset;
input valid_in;
input [11:0] data_in_re;
input [11:0] data_in_im;
input [7:0] UAP;
input [15:0] n_bits;
output valid_out;
output data_out;
output header_error_flag;
//--------------------------------------------------------------------
// Demapper
wire data_out_demapper;
wire valid_out_demapper;
// Decoder
wire data_out_decoder;
wire valid_out_decoder;
// DeWhitening
wire data_out_dewhitening;
wire valid_out_dewhitening;
wire finished_out_dewhitening;
// DeCRC
//--------------------------------------------------------------------
// Demapper
(* keep_hierarchy = "yes" *) 
QPSK_demapper_ble header_demapper
(
    .clk(clk),
    .clk_fast(clk_fast),
    .reset(reset),
    .valid_in(valid_in),
    .data_in_re(data_in_re),
    .data_in_im(data_in_im),
    .valid_out(valid_out_demapper),
    .data_out(data_out_demapper)
);
//--------------------------------------------------------------------
// Decoder
(* keep_hierarchy = "yes" *) 
repetition_code_decoder_ble header_decoder
(
    .clk(clk_fast),
    .reset(reset),
    .valid_in(valid_out_demapper),
    .data_in(data_out_demapper),
    .enable(1'b1),
    .valid_out(valid_out_decoder),
    .data_out(data_out_decoder),
    .finished()
);
//--------------------------------------------------------------------
// DeWhitening
(* keep_hierarchy = "yes" *) 
whitening_ble header_DeWhitening
(
    .clk(clk_fast),
    .reset(reset),
    .valid_in(valid_out_decoder),
    .data_in(data_out_decoder),
    .enable(1'b1),
    //Edited: 5/6/2024
    .int_D(6'd0),
    .valid_out(valid_out_dewhitening),
    .data_out(data_out_dewhitening),
    .finished(finished_out_dewhitening)
);
//--------------------------------------------------------------------
// DeHEC
(* keep_hierarchy = "yes" *) 
top_controlled_dehec_bluetooth_ble header_dehec
(
	.clk(clk_fast),
	.reset(reset),
	.enable(1'b1),
	.valid_in(valid_out_dewhitening),
	.data_in(data_out_dewhitening),
	.uap_dci(UAP),
	.n_bits(n_bits),
	.finished(),
	.valid_out(valid_out),
	.data_out(data_out),
	.flag(),
	.remainder(header_error_flag),
	.num_after_hec()
);
endmodule
