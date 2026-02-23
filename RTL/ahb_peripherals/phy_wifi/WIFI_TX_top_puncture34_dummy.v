/*
======================================================================================
				Standard   : WIFI
				Block name : Dummy Puncturer 
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_puncture34_dummy
(
	clk,
	reset,
	valid_in,
	enable,
	data_in,
	valid_out,
	finished,
	data_out
);
	//============================================================================
	input clk;
	input reset;
	input valid_in;
	input enable;
	input data_in;    
	output valid_out;
	output finished;
	output data_out; 
	//============================================================================
	assign data_out 	= data_in;
	assign valid_out	= valid_in;
	assign finished		= enable;
	//============================================================================
endmodule
