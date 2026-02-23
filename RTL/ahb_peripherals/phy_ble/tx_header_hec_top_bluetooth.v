/*
======================================================================================
				Standard   : Bluetooth 
				Block name : HEC
				Modified By: Ahmed Nagy
======================================================================================
*/
//====================================================================================
module top_hec_bluetooth_ble
(
	clk,
	reset,
	valid_in,
	data_bit,
	uap_dci,
	data_out,
	valid_out,
	num_after_hec,
	flag
);
	//============================================================================
	input clk;
	input reset;
	input valid_in;      
	input data_bit; 
	input [7:0] uap_dci;	
	output reg data_out; 
	output reg valid_out; 
	output reg flag;
	output reg [13:0] num_after_hec; 
	//============================================================================
	parameter Length 	= 8;
	parameter IDLE 		= 2'b00;
	parameter GENERATE_hec 	= 2'b01;
	parameter OUT_hec 	= 2'b10;
	//============================================================================
	wire [Length-1 :0] hec_reg;
	reg [13:0] Input_Counter;
	reg [1:0] state;
	reg [13:0] count; 
	reg clear; 
	reg valid_in_temp;
	reg delayed_data;
	//============================================================================
	hec8_bluetooth_ble hec_generator8
	(
		.clk(clk),
		.reset(reset),
		.data_in(delayed_data),
		.uap_dci(uap_dci),
		.valid_in(valid_in_temp),	 
		.clear_reg(clear),
		.hec_reg(hec_reg)
	); 
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if(!reset) 
		begin
			state 		<= IDLE;
			flag 		<= 0;
			clear 		<= 1; 
			data_out        <= 1'bz;
			valid_in_temp 	<= 0;
		end
		//====================================================================
		else 
		begin
			//============================================================
			delayed_data <= data_bit;
			//============================================================
			case(state)
				//====================================================
				IDLE: 
				begin 
					valid_out 		<= 0;
					data_out        <= 1'bz;
					Input_Counter   <= 0;
					count 			<= Length; 
					clear 			<= 0; 
					valid_in_temp   <= 0;

					if(valid_in)
					begin
						valid_in_temp 	<= 1'b1;
						Input_Counter	<= Input_Counter+1;
						data_out 		<= delayed_data; 
						state 			<= GENERATE_hec; 
					end										
				end
				//====================================================
				GENERATE_hec: 
				begin
					data_out 		<= delayed_data; 
					valid_out 		<= 1; 
					Input_Counter				<= Input_Counter+1;

					if(valid_in==1'b0) 
					begin
						state 			<= OUT_hec; 
						valid_in_temp	<= 0;
					end	
				end
				//====================================================
				OUT_hec: 
				begin
					count 			<= count-1'b1;
					flag 			<= 1;
					num_after_hec 	<= Input_Counter + Length-1;
					data_out 		<= hec_reg[count-8'd1];

					if(count == 1'b0)
					begin
						clear 		<= 1; 
						count 		<= 0;
						flag		<= 0;
						state 		<= IDLE; 
						valid_out 	<= 0; 
					end
				end
				//====================================================
			endcase
			//============================================================
		end
		//====================================================================
	end		
	//============================================================================
endmodule
