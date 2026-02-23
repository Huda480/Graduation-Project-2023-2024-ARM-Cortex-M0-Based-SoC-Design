/*
======================================================================================
				Standard   : Bluetooth 
				Block name : CRC + FIFO
				Modified By: Ahmed Nagy
======================================================================================
*/
//====================================================================================
module top_controlled_crc_bluetooth_ble
(
	input clk,
	input reset,
	input enable,
	input valid_in,
	input data_in,
	input [7:0] uap_dci,
	output finished,
	output valid_out,
	output data_out,
	output flag,
	output[13:0] num_after_crc
);
	//============================================================================
	// wire [13:0] add_wr;
	// wire [13:0] add_re;
	// wire re;
	wire data_out_fifo;
	wire valid_out_fifo;
	//============================================================================
	dummy_fifo_ble #(12,1,4096) fifo
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
	top_crc_bluetooth_ble  crc_bluetooth
	(
		.clk(clk),
		.reset(reset),
		.valid_in(valid_out_fifo),
		.data_bit(data_out_fifo),
		.uap_dci(uap_dci),
		.data_out(data_out),
		.valid_out(valid_out),
		.num_after_crc(num_after_crc),
		.flag(flag)
	);
	//============================================================================
endmodule
