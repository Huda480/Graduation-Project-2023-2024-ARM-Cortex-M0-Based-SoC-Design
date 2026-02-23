/*
======================================================================================
				Standard   : WIFI
				Block name : QPSK PISO deMapper
======================================================================================
*/
//====================================================================================
module WIFI_RX_sipo_qpskMod
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
	output valid_out; 	
	output data_out;	
	//===============================================================================	
	reg valid_out;
	reg data_out;
	reg [1:0] count_clk;
	//===============================================================================	
	always @(posedge clk or negedge reset)
	begin
		if (!reset) 
		begin
			valid_out	<= 0;
			data_out	<= 0;
			count_clk	<= 2'b00;
		end
		//===============================================================================
		else 
		begin
			if (valid_in)
			begin
				if (count_clk == 0)
				begin
					valid_out 	<= 1;
					data_out	<= data_in[1];
					count_clk 	<= count_clk + 1'b1;
				end
				//===============================================================================
				else if(count_clk == 1)
				begin
					valid_out 	<= 1;
					data_out	<= data_in[0];
					count_clk 	<= 0;
				end
			end
			else			
			begin
				valid_out 	<= 0;
				data_out	<= 0;
				count_clk	<= 2'b00;
			end // end else of valid in
		end // end else of reset
	end  // end always
	//===============================================================================	
endmodule
