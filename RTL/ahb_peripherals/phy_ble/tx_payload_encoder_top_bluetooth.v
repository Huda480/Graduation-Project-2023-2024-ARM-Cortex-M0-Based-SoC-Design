/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Top Encoder
				Created By : Eslam Elnader
======================================================================================
*/
module top_controlled_encoder_ble
(
    clk,
    reset,
    data_in,
    valid_in,
    n_bits,
    enable,
    valid_out,
    data_out,
    finished
);
//----------------------------------------------------------------------------
input clk;
input reset;
input data_in;
input valid_in;
input [15:0] n_bits;
input enable;
output valid_out;
output data_out;
output finished;
//----------------------------------------------------------------------------
wire [9:0] n_blocks;
wire data_out_segmentation;
wire valid_out_segmentation;
wire data_out_hamming;
wire valid_out_hamming;
wire finished_hamming;
//----------------------------------------------------------------------------
Block_Segmentation_ble  Encoder_segmentation
(
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .valid_in(valid_in),
    .required_block_size(5'd10),
    .enable(enable & finished_hamming),
    .n_bits(n_bits),
    .n_blocks(n_blocks),
    .data_out(data_out_segmentation),
    .valid_out(valid_out_segmentation)
);
//----------------------------------------------------------------------------
hamming_encoder_ble hamming_block_encoder
(
    .clk(clk),
    .reset(reset),
    .data_in(data_out_segmentation),
    .valid_in(valid_out_segmentation),
    .valid_out(valid_out_hamming),
    .data_out(data_out_hamming),
    .finished(finished_hamming)
);
//----------------------------------------------------------------------------
CBC_ble encoder_concat
(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_out_hamming),
    .data_in(data_out_hamming),
    .n_blocks(n_blocks),
    .valid_out(valid_out),
    .data_out(data_out)
);
//----------------------------------------------------------------------------
finish_generator_ble finished_signal
(
	.clk(clk),
	.reset(reset),
	.we(valid_in),
	.valid_out(valid_out),
	.finished(finished)
);
//------------------------------------------------------------------------------
endmodule
