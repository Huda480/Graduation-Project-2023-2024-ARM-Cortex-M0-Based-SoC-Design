/*
=========================================================================================
				Standard :	WIFI
				Block name :	Encoder+P/S
=========================================================================================
*/
//=======================================================================================
module WIFI_TX_topmodule_convolutionHalf
(
	clk_in,
	clk_out,
	reset,
	valid_in,
	valid_out,
	data_in,
	data_out
);
	//===============================================================================	
	input clk_in;  		
	input clk_out;		
	input reset;		
	input valid_in;		
	input data_in; 		
	output valid_out;	
	output data_out;	
	//===============================================================================	
	wire [1:0]parallel_out ;
	wire valid_out_convo;
	//===============================================================================	
	WIFI_TX_convolutionHalf a 
	(
		.clk(clk_in),
		.reset(reset),
		.valid_in(valid_in),
		.data_in(data_in),
		.valid_out(valid_out_convo),
		.data_out(parallel_out)
	);
	//===============================================================================	
	WIFI_TX_ptos_convolutionHalf b
	(
		.clk(clk_out),
		.reset(reset),
		.valid_in(valid_out_convo),
		.data_in(parallel_out),
		.valid_out(valid_out),
		.data_out(data_out)
	); 
	//===============================================================================	
endmodule 
