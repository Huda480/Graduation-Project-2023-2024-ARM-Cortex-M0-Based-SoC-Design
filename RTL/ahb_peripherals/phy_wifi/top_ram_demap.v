module top_ram_demap	#(parameter DEMAPPER=16)
(
	clk,
	clk_output,
	clk_decoder,
	reset,
	re,
	we,
	valid_out,
	data_in,
	data_out
);
	//======================================================================================
	input 			clk;
	input			clk_output;
	input           clk_decoder;
	input 			reset;
	input 			re;
	input			we;
	input 		 	data_in;
	output 			valid_out;
	output 			data_out;
	//======================================================================================
	generate 
		case(DEMAPPER)
			2:
			begin
				ram_demap #(14,1,16384) ram_bpsk
				(
					.clk(clk),
					.reset(reset),
					.re(re),
					.we(we),
					.data_in(data_in),
					.data_out(data_out),
					.valid_out(valid_out)
				);
			end
			4:
			begin
				ram_demap #(14,1,16384) ram_qpsk
				(
					.clk(clk_output),
					.reset(reset),
					.re(re),
					.we(we),
					.data_in(data_in),
					.data_out(data_out),
					.valid_out(valid_out)
				);
			end
			16:
			begin
				ram_demap #(14,1,16384) ram_16qam
				(
					.clk(clk_decoder),
					.reset(reset),
					.re(re),
					.we(we),
					.data_in(data_in),
					.data_out(data_out),
					.valid_out(valid_out)
				);
			end
		endcase
	endgenerate
	//============================================================================	
endmodule