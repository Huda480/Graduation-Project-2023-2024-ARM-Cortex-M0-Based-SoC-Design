/*
======================================================================================
				Standard   : Bluetooth 
				Block name : HEC + FIFO
				Modified By: Ahmed Nagy
======================================================================================
*/
//====================================================================================
module top_controlled_hec_bluetooth_ble
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
	output[13:0] num_after_hec
);
	//============================================================================
	// wire [13:0] add_wr;
	// wire [13:0] add_re;
	// wire re;
	wire data_out_fifo;
	wire valid_out_fifo;
	//============================================================================
	dummy_fifo_ble fifo
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
	top_hec_bluetooth_ble hec_bluetooth
	(
		.clk(clk),
		.reset(reset),
		.valid_in(valid_out_fifo),
		.data_bit(data_out_fifo),
		.uap_dci(uap_dci),
		.data_out(data_out),
		.valid_out(valid_out),
		.num_after_hec(num_after_hec),
		.flag(flag)
	);
	//============================================================================
endmodule
