/*
======================================================================================
				Standard   : WIFI
				Block name : 16QAM Mapper
======================================================================================
*/
//====================================================================================
module WIFI_TX_mapper_16QamMod
(
	clk,
	reset,
	valid_in,
	data_in,
	valid_out,
	data_out_real,
	data_out_imag
);
	//============================================================================	
	input clk;
	input reset;
	input valid_in;
	input [3:0] data_in;
	output valid_out;
	output [11:0] data_out_real;
	output [11:0] data_out_imag;
	//============================================================================	
	reg valid_out_1;
	reg [11:0] data_out_real;
	reg [11:0] data_out_imag;		
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
					4'b0000:
					begin
						data_out_real	<= 12'b111000011010;
						data_out_imag 	<= 12'b111000011010;
						valid_out_1 	<= 1;
					end			 
					4'b0001:
					begin
						
						data_out_real	<= 12'b111000011010;
						data_out_imag 	<= 12'b111101011110;
						valid_out_1 	<= 1;
					end
					4'b0010:
					begin
						data_out_real	<= 12'b111000011010;
						data_out_imag 	<= 12'b000111100110;
						valid_out_1 	<= 1;
					end			 
					4'b0011:
					begin
						data_out_real	<= 12'b111000011010;
						data_out_imag 	<= 12'b000010100010;
						valid_out_1 	<= 1;
					end			 
					4'b0100:
					begin
						data_out_real	<= 12'b111101011110;
						data_out_imag 	<= 12'b111000011010;
						valid_out_1 	<= 1;
					end			 
					4'b0101:
					begin
						data_out_real	<= 12'b111101011110;
						data_out_imag 	<= 12'b111101011110;
						valid_out_1 	<= 1;
					end			 
					4'b0110:
					begin
						data_out_real	<= 12'b111101011110;
						data_out_imag 	<= 12'b000111100110;
						valid_out_1 	<= 1;
					end			 
					4'b0111:
					begin
						data_out_real	<= 12'b111101011110;
						data_out_imag 	<= 12'b000010100010;
						valid_out_1 	<= 1;
					end			 
					4'b1000:
					begin
						data_out_real	<= 12'b000111100110;
						data_out_imag 	<= 12'b111000011010;
						valid_out_1 	<= 1;
					end			 
					4'b1001:
					begin
						data_out_real	<= 12'b000111100110;
						data_out_imag 	<= 12'b111101011110;
						valid_out_1 	<= 1;
					end			 
					4'b1010:
					begin
						data_out_real	<= 12'b000111100110;
						data_out_imag 	<= 12'b000111100110;
						valid_out_1 	<= 1;
					end			 
					4'b1011:
					begin
						data_out_real	<= 12'b000111100110;
						data_out_imag 	<= 12'b000010100010;
						valid_out_1 	<= 1;
					end			 
					4'b1100:
					begin
						data_out_real	<= 12'b000010100010;
						data_out_imag 	<= 12'b111000011010;
						valid_out_1 	<= 1;
					end			 
					4'b1101:
					begin
						data_out_real	<= 12'b000010100010;
						data_out_imag 	<= 12'b111101011110;
						valid_out_1 	<= 1;
					end			 
					4'b1110:
					begin
						data_out_real	<= 12'b000010100010;
						data_out_imag 	<= 12'b000111100110;
						valid_out_1 	<= 1;
					end			 
					4'b1111:
					begin
						data_out_real	<= 12'b000010100010;
						data_out_imag 	<= 12'b000010100010;
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
