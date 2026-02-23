/*
======================================================================================
				Standard   : WIFI
				Block name : DEMapper
======================================================================================
*/
//====================================================================================
module top_demapper_wifi #(parameter DEMAPPER=2)
(
	clk,
	clk_output,
	clk_decoder,
	reset,
	valid_in,
	data_in_real,
	data_in_imag,
	valid_out,
	data_out
);
	//============================================================================	
	input clk;
	input clk_output;
	input clk_decoder;
	input reset;
	input valid_in;
	input [11:0] data_in_real;
	input [11:0] data_in_imag;
	output valid_out;
	output data_out;
	//============================================================================	
	wire piso_valid_in;
	wire [1:0] piso_in_qpsk;
	wire [3:0] piso_in_16qam;
	//============================================================================	
	generate 
		case(DEMAPPER)
			2:
			begin
				demapper_bpskMod_wifi DEMAPPER 
				(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in),
					.data_in_real(data_in_real),
					.data_in_imag(data_in_imag),
					.data_out(data_out),
					.valid_out(valid_out)
				);
			end
			4:
			begin
				demapper_qpskMod_wifi DEMAPPER 
				(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in),
					.data_in_real(data_in_real),
					.data_in_imag(data_in_imag),
					.valid_out(piso_valid_in),
					.data_out(piso_in_qpsk)
				);
				WIFI_RX_sipo_qpskMod piso 
				(
					.clk(clk_output),
					.reset(reset),
					.valid_in(piso_valid_in),
					.data_in(piso_in_qpsk),
					.valid_out(valid_out),
					.data_out(data_out)
				);
			end
			16:
			begin
				demapper_16QamMod_wifi DEMAPPER 
				(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in),
					.data_in_real(data_in_real),
					.data_in_imag(data_in_imag),
					.data_out(piso_in_16qam),
					.valid_out(piso_valid_in)
				);
				WIFI_RX_sipo_16QamMod piso 
				(
					.clk(clk_decoder),
					.reset(reset),
					.valid_in(piso_valid_in),
					.data_in(piso_in_16qam),
					.valid_out(valid_out),
					.data_out(data_out)
				);
			end
		endcase
	endgenerate
	//============================================================================	
endmodule