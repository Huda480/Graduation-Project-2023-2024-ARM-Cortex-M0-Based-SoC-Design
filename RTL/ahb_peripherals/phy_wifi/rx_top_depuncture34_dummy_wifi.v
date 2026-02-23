/*
======================================================================================
				Standard   : WIFI
				Block name : Dummy Depuncturer 
======================================================================================
*/
//====================================================================================
module top_depuncture34_dummy_wifi
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
