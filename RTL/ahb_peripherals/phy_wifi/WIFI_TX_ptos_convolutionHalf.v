/*
=========================================================================================
				Standard :	WIFI
				Block name :	P/S
=========================================================================================
*/
//=======================================================================================
module WIFI_TX_ptos_convolutionHalf
(
	clk,
	reset,
	valid_in,
	data_in,
	valid_out,
	data_out
);
	//===============================================================================	
	input clk;		
	input reset;		
	input valid_in;		
	input [1:0] data_in; 	
	output data_out;	
	output valid_out; 	
	//===============================================================================	
	reg valid_out;
	reg data_out;
	reg flag; 
	//===============================================================================	
	always @(posedge clk or negedge reset)
	begin
		if (!reset) 
		begin
			valid_out	<= 0;
			data_out	<= 0;
			flag		<= 0;
		end
		else 
		begin
			valid_out 	<= valid_in;

			if (flag) 	data_out <= data_in[0];
			else		data_out <= data_in[1];

			if (valid_in)	flag <=!flag;
		end
	end
	//===============================================================================	
endmodule
