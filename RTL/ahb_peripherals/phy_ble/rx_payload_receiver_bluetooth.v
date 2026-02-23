/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Payload Receiver Chain
				Created By : Eslam Elnader
======================================================================================
*/
module top_receiver_bt_payload_ble
(
    clk,
    clk_fast,
    reset,
    UAP,
    data_in_re,
    data_in_im,
    valid_in,
    n_bits,
    FEC_enable,
    CRC_enable,
    data_out,
    payload_error_flag,
    valid_out,
    //Edited: 26/6/2024
    finished_decrc
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
input FEC_enable;
input CRC_enable;
output valid_out;
output payload_error_flag;
output data_out;
output finished_decrc;
//--------------------------------------------------------------------
// Demapper
wire data_out_demapper;
wire valid_out_demapper;
// Decoder
wire [15:0] n_bits_decoder;
wire data_out_decoder;
wire valid_out_decoder;
wire data_out_decoder_block;
wire valid_out_decoder_block;
wire decoded;
// DeWhitening
wire data_out_dewhitening;
wire valid_out_dewhitening;
wire finished_out_dewhitening;
// DeCRC
wire payload_error_flag_crc;
wire data_out_decrc;
wire valid_out_decrc;
wire finished_decrc;
//--------------------------------------------------------------------
// Demapper
//Edited:Abdulrahman 10/6/2024
//(* keep_hierarchy = "yes" *) 
(*DONT_TOUCH="yes"*)
QPSK_demapper_ble payload_demapper
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
assign n_bits_decoder = (CRC_enable==1'b1)? n_bits+16'd16 : n_bits;
//--------------------------------------------------------------------
// Decoder
(* keep_hierarchy = "yes" *) 
top_controlled_decoder_ble payload_decoder
(
    .clk(clk_fast),
    .reset(reset),
    .data_in(data_out_demapper),
    .valid_in(valid_out_demapper),
    .n_bits(n_bits_decoder),
    .enable(1'b1),
    .valid_out(valid_out_decoder_block),
    .data_out(data_out_decoder_block),
    .decoded(decoded),
    .finished()
);
assign data_out_decoder  =(FEC_enable==1'b1)? data_out_decoder_block : data_out_demapper;
assign valid_out_decoder =(FEC_enable==1'b1)? valid_out_decoder_block : valid_out_demapper;
//--------------------------------------------------------------------
// DeWhitening
(* keep_hierarchy = "yes" *) 
whitening_ble payload_DeWhitening
(
    .clk(clk_fast),
    .reset(reset),
    .valid_in(valid_out_decoder),
    .data_in(data_out_decoder),
    .enable(1'b1),
    .int_D(6'd0),
    .valid_out(valid_out_dewhitening),
    .data_out(data_out_dewhitening),
    .finished(finished_out_dewhitening)
);
//--------------------------------------------------------------------
// DeCRC
(* keep_hierarchy = "yes" *) 
top_controlled_decrc_bluetooth_ble payload_decrc
(
	.clk(clk_fast),
	.reset(reset),
	.enable(1'b1),
	.valid_in(valid_out_dewhitening),
	.data_in(data_out_dewhitening),
	.uap_dci(UAP),
	.n_bits(n_bits),
	.finished(),
	.valid_out(valid_out_decrc),
	.data_out(data_out_decrc),
	.flag(finished_decrc),
	.remainder(payload_error_flag_crc),
	.num_after_crc()
);
assign data_out   = (CRC_enable==1'b1)? data_out_decrc:data_out_dewhitening; 
assign valid_out  = (CRC_enable==1'b1)? valid_out_decrc:valid_out_dewhitening;
//--------------------------------------------------------------------
assign payload_error_flag=payload_error_flag_crc | decoded;
//--------------------------------------------------------------------
endmodule
