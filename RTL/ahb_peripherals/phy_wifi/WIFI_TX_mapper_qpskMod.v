/*
======================================================================================
				Standard   : WIFI
				Block name : QPSK Mapper
======================================================================================
*/
//====================================================================================
module WIFI_TX_mapper_qpskMod
(
	clk,
	reset,
	valid_in,
	data_in,
	valid_out,
	data_out_real,
	data_out_imag
);
	input clk;
	input reset;
	input valid_in;
	input [1:0] data_in;
	output valid_out;
	output [11:0] data_out_real;
	output [11:0] data_out_imag;
	reg valid_out_1;
	(* dont_touch = "true" *) reg [11:0] data_out_real;
	
	(* dont_touch = "true" *) reg [11:0] data_out_imag;		
	//============================================================================	
	always@(posedge clk or negedge reset)
	begin
		//====================================================================
		if(!reset)
		begin
			data_out_real 	<= 0;
			data_out_imag 	<= 0;
			valid_out_1 	<= 0;
		end
		//====================================================================
		else
		begin
			//============================================================
			if (valid_in)
			begin
				case (data_in)
					2'b00:
					begin
						data_out_real 	<= 12'b111010010110;
						data_out_imag	<= 12'b111010010110;
						valid_out_1 	<= 1;
					end			 
					2'b01:
					begin
						data_out_real 	<= 12'b111010010110;
						data_out_imag	<= 12'b000101101010;
						valid_out_1 	<= 1;
					end			 
					2'b10:
					begin
						data_out_real 	<= 12'b000101101010;
						data_out_imag	<= 12'b111010010110;
						valid_out_1 	<= 1;
					end			 
					2'b11:
					begin
						data_out_real 	<= 12'b000101101010;
						data_out_imag	<= 12'b000101101010;
						valid_out_1 	<= 1;
					end			 
					default:
					begin
						data_out_real 	<= 0;
						data_out_imag 	<= 0;
						valid_out_1 	<= 0;
					end
				endcase
			end
			//============================================================
			else
			begin
				data_out_real 	<= 0;
				data_out_imag 	<= 0;
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
