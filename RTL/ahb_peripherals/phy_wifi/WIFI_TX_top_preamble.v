/*
=========================================================================================
				Standard :	WIFI
				Block name :	Preamble
=========================================================================================
*/
//=======================================================================================
`timescale 1ns / 1ps
//=======================================================================================
module WIFI_TX_top_preamble 
(
	valid_in,
	clk,
	valid_out,
	pre_re,
	pre_im,
	done,
	reset,
	enable_ifft
);
	//===============================================================================	
	input valid_in;
	input clk;
	input reset;
	output [11:0] pre_re;
	output [11:0] pre_im;
	output valid_out;
	output done;
	output enable_ifft;
	//===============================================================================	
	wire valid_out_L;
	wire valid_out_S;
	wire done_L;
	wire done_S;
	wire [11:0] pre_re_L;
	wire [11:0] pre_im_L;
	wire [11:0] pre_re_S;
	wire [11:0] pre_im_S;
	//===============================================================================	
	WIFI_TX_short_preabmle S 
	(
		valid_in,
		clk,
		valid_out_S,
		pre_re_S,
		pre_im_S,
		done_S,
		reset,
		enable_ifft
	);
	//===============================================================================	
	WIFI_TX_long_preabmle L 
	(
		done_S,
		clk,
		valid_out_L,
		pre_re_L,
		pre_im_L,
		done,
		reset
	);
	//===============================================================================	
	assign valid_out= valid_out_L | valid_out_S;
	assign pre_re= valid_out_L ? pre_re_L : valid_out_S ? pre_re_S : 12'b0;
	assign pre_im= valid_out_L ? pre_im_L : valid_out_S ? pre_im_S: 12'b0;
	//===============================================================================	
endmodule
