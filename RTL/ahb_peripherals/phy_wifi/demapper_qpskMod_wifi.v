/*
======================================================================================
				Standard   : WIFI
				Block name : QPSK deMapper
======================================================================================
*/
//====================================================================================
module demapper_qpskMod_wifi
(
	clk,
	reset,
	valid_in,
	data_in_real,
	data_in_imag,
	valid_out,
	data_out
);
	//============================================================================	
	input clk;
	input reset;
	input valid_in;
	input [11:0] data_in_real;
	input [11:0] data_in_imag;
	output valid_out;
	output [1:0] data_out;
	//============================================================================	
	reg valid_out_1;
	reg [1:0] data_out;
	//============================================================================	
	always@(posedge clk or negedge reset)
	begin
		//====================================================================
		if(!reset)
		begin
			valid_out_1 	<= 0;
			data_out 		<= 0;
		end
		//====================================================================
		else
		begin
			//============================================================
			if (valid_in)
			begin
				if ($signed(data_in_real[11 -: 9]) < 0 && $signed(data_in_imag[11 -: 9]) < 0)
				begin
					data_out 		<= 2'b00;
					valid_out_1 	<= 1;
				end			 
				else if ($signed(data_in_real[11 -: 9]) < 0 && $signed(data_in_imag[11 -: 9]) >= 0)
				begin
					data_out 		<= 2'b01;
					valid_out_1 	<= 1;
				end			 
				else if ($signed(data_in_real[11 -: 9]) >= 0 && $signed(data_in_imag[11 -: 9]) < 0)
				begin
					data_out 		<= 2'b10;
					valid_out_1 	<= 1;
				end			 
				else if ($signed(data_in_real[11 -: 9]) >= 0 && $signed(data_in_imag[11 -: 9]) >= 0)
				begin
					data_out 		<= 2'b11;
					valid_out_1 	<= 1;
				end
			end
			//============================================================
			else
			begin
				data_out	 	<= 0;
				valid_out_1 	<= 0;
			end
			//============================================================
		end
		//====================================================================
	end
	//============================================================================
	assign valid_out = valid_out_1;
	//============================================================================
endmodule