/*
======================================================================================
				Standard   : WIFI
				Block name : Puncturer FIFO controller
======================================================================================
*/
//====================================================================================
module WIFI_TX_control_puncture34
(
	clk,
	reset,
	valid_in,
	data_in,
	we,
	re,
	data_out
);
	//============================================================================
	input clk;
	input reset;
	input valid_in;
	input data_in;
	output we;
	output re;
	output data_out;
	//============================================================================
	reg we;
	reg re;
	reg data_out;
	reg [15:0] counter_clkin;
	reg [15:0] counter_clkout;
	reg [2:0] pattern_counter;
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if (!reset)
		begin
			we				<= 0;
			data_out			<= 0;
			counter_clkin			<= 0;
			pattern_counter			<= 0;
			re				<= 0;
			counter_clkout			<= 0;
		end
		//====================================================================
		else
		begin
			if (valid_in)
			begin
				if (counter_clkin < 48)
				begin
					we			<= 1; 
					data_out		<= data_in; 
					counter_clkin		<= counter_clkin+1;
				end
				else
				begin
					if (pattern_counter==5) 
						pattern_counter	<= 0; 
					else 
						pattern_counter	<= pattern_counter+1;
					if (pattern_counter==3 || pattern_counter==4) 
						we		<= 0;
					else 
					begin  
						we		<= 1; 
						data_out	<= data_in; 
						counter_clkin	<= counter_clkin+1; 
					end
				end
			end
			//============================================================
			else
			begin
				we				<= 0;
				pattern_counter			<= 0;

				if (counter_clkout==0 )
				begin
					counter_clkout		<= counter_clkin;
					re			<= 0;
				end
				//====================================================
				else
				begin
					counter_clkin		<= 0;
					counter_clkout		<= counter_clkout-1;
					re			<= 1;
				end
				//====================================================
			end
			//============================================================
		end
		//====================================================================
	end
	//============================================================================
endmodule
