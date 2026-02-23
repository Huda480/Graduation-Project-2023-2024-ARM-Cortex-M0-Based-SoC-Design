/*
======================================================================================
				Standard   : Bluetooth 
				Block name : CRC
				Modified By: Ahmed Nagy
======================================================================================
*/
//====================================================================================
module top_decrc_bluetooth_ble
(
	clk,
	reset,
	valid_in,
	data_bit,
	uap_dci,
	n_bits,
	data_out,
	valid_out,
	remainder,
	num_after_crc,
	flag
);
	//============================================================================
	input clk;
	input reset;
	input valid_in;      
	input data_bit; 
	input [7:0] uap_dci;
	input [15:0] n_bits;	
	output reg data_out; 
	output reg valid_out; 
	output reg remainder;
	output reg flag;
	output reg [13:0] num_after_crc; 
	//============================================================================
	parameter Length 	= 16;
	parameter IDLE 		= 2'b00;
	parameter GENERATE_CRC 	= 2'b01;
	parameter REM 	= 2'b10;
	//============================================================================
	wire [Length-1 :0] crc_reg;
	reg [13:0] Input_Counter;
	reg [1:0] state;
	//reg [13:0] count; 
	reg clear; 
	reg valid_in_temp;
	reg delayed_data;
	//============================================================================
	decrc16_bluetooth_ble decrc_generator16
	(
		.clk(clk),
		.reset(reset),
		.data_in(delayed_data),
		.uap_dci(uap_dci),
		.valid_in(valid_in_temp),	
		.clear_reg(clear),
		.crc_reg(crc_reg)
	); 
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if(!reset) 
		begin
			state 		     <= IDLE;
			flag 		     <= 0;
			clear 		     <= 1; 
			data_out         <= 1'b0;
			valid_in_temp 	 <= 0;
			remainder        <= 1'b0;
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
					data_out        <= 1'b0;
					Input_Counter   <= 0;
					//count 			<= Length; 
					clear 			<= 0; 
					valid_in_temp   <= 0;

					if(valid_in)
					begin
						valid_in_temp 	<= 1'b1;
						Input_Counter	<= Input_Counter+1;
						data_out 		<= delayed_data; 
						state 			<= GENERATE_CRC; 
					end										
				end
				//====================================================
				GENERATE_CRC: 
				begin
					data_out 		<= delayed_data; 
					if(Input_Counter <= n_bits)   
					   valid_out 		<= 1;
					else
					   valid_out        <= 0; 
					Input_Counter				<= Input_Counter+1;
					if(valid_in==1'b0) 
					begin
						state 			<= REM; 
						valid_in_temp	<= 0;
					end	
				end
				//====================================================
				REM: 
				begin
					//count 			<= count-1'b1;
					flag 			<= 1;
					num_after_crc 	<= Input_Counter + Length-1;
					if(crc_reg == 0)
						remainder   <= 0;
					else	
						remainder   <= 1;
						
					clear 		<= 1; 
					//count 		<= 0;
					//flag		<= 0;
					state 		<= IDLE; 
					valid_out 	<= 0; 
					//if(count == 1'b0)
					//begin
					//end
				end
				//====================================================
			endcase
			//============================================================
		end
		//====================================================================
	end		
	//============================================================================
endmodule
