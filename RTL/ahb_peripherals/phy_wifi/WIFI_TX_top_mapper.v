/*
======================================================================================
				Standard   : WIFI
				Block name : Mapper
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_mapper #(parameter MAPPER=4)
(
	clk,
	reset,
	valid_in,
	data_in,
	valid_out,
	data_out_real,
	data_out_imag
);
	//============================================================================	
	input clk;
	input reset;
	input valid_in;
	input data_in;
	output valid_out;
	output [11:0] data_out_real;
	output [11:0] data_out_imag;
	//============================================================================	
	wire sipo_valid_out;
	wire [1:0] sipo_out_qpsk;
	wire [3:0] sipo_out_16qam;
	//============================================================================	
	generate 
		case(MAPPER)
			2:
			begin
				WIFI_TX_mapper_bpskMod mapper 
				(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in),
					.data_in(data_in),
					.valid_out(valid_out),
					.data_out_real(data_out_real),
					.data_out_imag(data_out_imag)
				);
			end
			4:
			begin
				WIFI_TX_sipo_qpskMod sipo 
				(
					.clk(clk),
					.din(data_in),
					.rst(reset),
					.valid_in(valid_in),
					.valid_out(sipo_valid_out),
					.dout(sipo_out_qpsk)
				);
				WIFI_TX_mapper_qpskMod mapper 
				(
					.clk(clk),
					.reset(reset),
					.valid_in(sipo_valid_out),
					.data_in(sipo_out_qpsk),
					.valid_out(valid_out),
					.data_out_real(data_out_real),
					.data_out_imag(data_out_imag)
				);
			end
			16:
			begin
				WIFI_TX_sipo_16QamMod sipo 
				(
					.clk(clk),
					.din(data_in),
					.rst(reset),
					.valid_in(valid_in),
					.valid_out(sipo_valid_out),
					.dout(sipo_out_16qam)
				);
				WIFI_TX_mapper_16QamMod mapper 
				(
					.clk(clk),
					.reset(reset),
					.valid_in(sipo_valid_out),
					.data_in(sipo_out_16qam),
					.valid_out(valid_out),
					.data_out_real(data_out_real),
					.data_out_imag(data_out_imag)
				);
			end
		endcase
	endgenerate
	//============================================================================	
endmodule

