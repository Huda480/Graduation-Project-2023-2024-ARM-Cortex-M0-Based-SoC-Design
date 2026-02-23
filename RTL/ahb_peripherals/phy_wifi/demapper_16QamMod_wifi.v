/*
======================================================================================
				Standard   : WIFI
				Block name : 16QAM deMapper
======================================================================================
*/
//====================================================================================
module demapper_16QamMod_wifi
(
	clk,
	reset,
	valid_in,
	data_in_real,
	data_in_imag,
	data_out,
	valid_out
);
	//============================================================================	
	input clk;
	input reset;
	input valid_in;
	input [11:0] data_in_real;
	input [11:0] data_in_imag;
	output [3:0] data_out;
	output valid_out;
	//============================================================================	
	reg [3:0] data_out;		
	reg valid_out_1;
	reg [8:0] data_real;
	reg [8:0] data_imag;	
	//============================================================================	
	always@(posedge clk or negedge reset)
	begin
		//====================================================================
		if(!reset)
		begin
			data_out	 	<= 0;
			valid_out_1 	<= 0;
			data_real		<= 0;
			data_imag		<= 0;
		end
		//====================================================================
		else
		begin
			//============================================================
			if (valid_in)
			begin
				//============================================================		
				data_real		<= data_in_real[ 0 +: 9];
				data_imag		<= data_in_imag[ 0 +: 9];
				//============================================================		
				if ($signed(data_in_real[11 -: 9]) < 0 && $signed(data_in_imag[11 -: 9]) < 0)
				begin
					if ($unsigned(data_real) < 'd188 && $unsigned(data_imag) < 'd188)
					begin
						data_out 		<= 4'b0000;
						valid_out_1 	<= 1;
					end			 
					else if ($unsigned(data_real) < 'd188 && $unsigned(data_imag) >= 'd188)
					begin
						data_out 		<= 4'b0001;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) >= 'd188 && $unsigned(data_imag) < 'd188)
					begin
						data_out 		<= 4'b0100;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) >= 'd188 && $unsigned(data_imag) >= 'd188)
					begin
						data_out 		<= 4'b0101;
						valid_out_1 	<= 1;
					end			 		 
				end			 
				//============================================================
				else if ($signed(data_in_real[11 -: 9]) < 0 && $signed(data_in_imag[11 -: 9]) >= 0)
				begin
					if ($unsigned(data_real) < 188 && $unsigned(data_imag) >= 324)
					begin
						data_out 		<= 4'b0010;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) < 188 && $unsigned(data_imag) < 324)
					begin
						data_out 		<= 4'b0011;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) >= 188 && $unsigned(data_imag) >= 324)
					begin
						data_out 		<= 4'b0110;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) >= 188 && $unsigned(data_imag) < 324)
					begin
						data_out 		<= 4'b0111;
						valid_out_1 	<= 1;
					end			 		 
				end
				//============================================================
				else if ($signed(data_in_real[11 -: 9]) >= 0 && $signed(data_in_imag[11 -: 9]) >= 0)
				begin
					if ($unsigned(data_real) >= 324 && $unsigned(data_imag) >= 324)
					begin
						data_out 		<= 4'b1010;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) >= 324 && $unsigned(data_imag) < 324)
					begin
						data_out 		<= 4'b1011;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) < 324 && $unsigned(data_imag) >= 324)
					begin
						data_out 		<= 4'b1110;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) < 324 && $unsigned(data_imag) < 324)
					begin
						data_out 		<= 4'b1111;
						valid_out_1 	<= 1;
					end			 		 
				end			 		 
				//============================================================
				else if ($signed(data_in_real[11 -: 9]) >= 0 && $signed(data_in_imag[11 -: 9]) < 0)
				begin
					if ($unsigned(data_real) >= 324 && $unsigned(data_imag) < 188)
					begin
						data_out 		<= 4'b1000;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) >= 324 && $unsigned(data_imag) >= 188)
					begin
						data_out 		<= 4'b1001;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) < 324 && $unsigned(data_imag) < 188)
					begin
						data_out 		<= 4'b1100;
						valid_out_1 	<= 1;
					end			 		 
					else if ($unsigned(data_real) < 324 && $unsigned(data_imag) >= 188)
					begin
						data_out 		<= 4'b1101;
						valid_out_1 	<= 1;
					end			 		 
				end			 		 
				//============================================================
			end
			//============================================================
			else
			begin
				data_out 		<= 0;
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