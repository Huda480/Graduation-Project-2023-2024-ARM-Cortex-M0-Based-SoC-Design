/*
======================================================================================
				Standard   : WIFI
				Block name : IFFT controller
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_ifft_controller#(parameter TYPE=16)
(
	clk,
	clk_div,
	reset,
	sym_re,
	sym_im,
	valid_in,
	ifft_start,
	last_symbol,
	valid_out,
	sample_real,
	sample_im,
	preample_st,
	enable,
	mapper_ready
);
	//===============================================================================	
	localparam SAMPLE_WIDTH= 12;
	input clk;
	input clk_div;
	input reset;
	input [SAMPLE_WIDTH-1:0] sym_re;
	input [SAMPLE_WIDTH-1:0] sym_im;
	input valid_in;
	input ifft_start;
	input last_symbol;
	input mapper_ready;
	output valid_out;
	output [SAMPLE_WIDTH-1:0] sample_real;
	output [SAMPLE_WIDTH-1:0] sample_im;	
	output preample_st;
	output enable;	
	//===============================================================================	
	generate
		case(TYPE)
			2:
			begin
				(* keep_hierarchy = "yes" *) 
				WIFI_IFFT_Controller_2 ifft_module 
				(
					.clk(clk), 
					.clk_div(clk_div), 
					.reset(reset), 
					.sym_re(sym_re),
					.sym_im(sym_im), 
					.valid_in(valid_in), 
					.ifft_start(ifft_start),
					.last_symbol(last_symbol), 
					.valid_out(valid_out), 
					.sample_real(sample_real), 
					.sample_im(sample_im), 
					.preample_st(preample_st), 
					.enable(enable),
					.mapper_ready(mapper_ready)
				);
			end
			4:
			begin
				(* keep_hierarchy = "yes" *) 
				WIFI_IFFT_Controller_4 ifft_module 
				(
					.clk(clk), 
					.clk_div(clk_div), 
					.reset(reset), 
					.sym_re(sym_re),
					.sym_im(sym_im), 
					.valid_in(valid_in), 
					.ifft_start(ifft_start),
					.last_symbol(last_symbol), 
					.valid_out(valid_out), 
					.sample_real(sample_real), 
					.sample_im(sample_im), 
					.preample_st(preample_st), 
					.enable(enable),
					.mapper_ready(mapper_ready)
				);
			end
			16:
			begin
				(* keep_hierarchy = "yes" *) 
				WIFI_IFFT_Controller_16 ifft_module 
				(
					.clk(clk), 
					.clk_div(clk_div), 
					.reset(reset), 
					.sym_re(sym_re),
					.sym_im(sym_im), 
					.valid_in(valid_in), 
					.ifft_start(ifft_start),
					.last_symbol(last_symbol), 
					.valid_out(valid_out), 
					.sample_real(sample_real), 
					.sample_im(sample_im), 
					.preample_st(preample_st), 
					.enable(enable),
					.mapper_ready(mapper_ready)
				);
			end
		endcase
	endgenerate
	//===============================================================================	
endmodule
