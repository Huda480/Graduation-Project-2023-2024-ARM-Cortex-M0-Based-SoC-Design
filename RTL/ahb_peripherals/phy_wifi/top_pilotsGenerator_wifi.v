/*
======================================================================================
				Standard   : WIFI
				Block name : Pilot generator
======================================================================================
*/
//====================================================================================
(* keep_hierarchy = "yes" *) 
module top_pilotsGenerator_wifi
(
	clk,
	reset,
	enable,
	valid_out,
	data_out
);
	//============================================================================
	input clk;
	input reset;
	input enable;
	output valid_out;
	output [11:0] data_out;
	//============================================================================
	reg valid_out;
	reg [11:0] data_out;
	reg rom_read_en;
	reg [6:0] rom_address;
	wire rom_output_data;
	//============================================================================
	reg [2:0] counter1;
	reg [6:0] counter2;
	//============================================================================
	rom_pilotsGenerator_wifi rom
	(
		.address(counter2),
		.read_enable(rom_read_en),
		.data_out(rom_output_data)
	);
	//============================================================================
	always@(posedge clk or negedge reset) 
	begin
		//====================================================================
		if(!reset)
		begin
			rom_address 	<= 0;
			counter1	<= 0;
			counter2 	<= 0;
			rom_read_en 	<= 1;
			valid_out 	<= 0;
			data_out[8:0] 	<= 0;
		end
		//====================================================================
		else if(enable == 1 && counter1 <= 2 && counter2 != 128) 
		begin
			rom_address 	<= counter2;
			counter1 	<= counter1 + 1;
			valid_out	<= 1;

			if(rom_output_data == 1)	data_out[11:9] 	<= -1;
			else				data_out[11:9] 	<= 1;
		end
		//====================================================================
		else if(enable == 1 && counter1 == 3 && counter2 != 128) 
		begin
			counter2 	<= counter2 + 1;
			counter1 	<= 0;
			valid_out	<= 1;

			if(rom_output_data == 1)	data_out[11:9] <= 1;
			else				data_out[11:9] <= -1;
		end
		//====================================================================
		else if(counter2 == 127) 
		begin
			rom_address 	<= 0;
			counter1 	<= 0;
			counter2 	<= 0;
			rom_read_en 	<= 1;
			valid_out 	<= 0;

			if(rom_output_data == 1)	data_out[8:0] <= 1;
			else				data_out[8:0] <= -1;
		end
		//====================================================================
		else	valid_out	<= 0;
		//====================================================================
	end
	//============================================================================
endmodule
