/*
======================================================================================
				Standard   : Bluetooth 
				Block name : HEC 8
				Modified By: Ahmed Nagy
======================================================================================
*/
//====================================================================================
module hec8_bluetooth_ble  #(parameter HEC_LEGNTH=8)
(
	clk,
	reset,
	data_in,
	uap_dci,
	valid_in,
	clear_reg,
	hec_reg
);
	//============================================================================
	input clk;            
	input reset;          
	input data_in;             
	input valid_in; 
	input [7:0] uap_dci;
	input clear_reg;	
	output reg[HEC_LEGNTH-1:0] hec_reg;
	//============================================================================
	parameter IDLE 		= 1'b0; 
	parameter generate_hec 	= 1'b1; 
	//============================================================================
	reg state;
	wire [HEC_LEGNTH-1:0] hec_enc;
	//============================================================================
	always @(posedge clk or negedge reset) 
	begin
		//====================================================================
		if(!reset) 
		begin
			hec_reg[0] <= uap_dci[7];
			hec_reg[1] <= uap_dci[6];
			hec_reg[2] <= uap_dci[5];
			hec_reg[3] <= uap_dci[4];
			hec_reg[4] <= uap_dci[3];
			hec_reg[5] <= uap_dci[2];
			hec_reg[6] <= uap_dci[1];
			hec_reg[7] <= uap_dci[0];
			
			state <= IDLE;
		end
		//====================================================================
		else	
		begin
			//============================================================
			case(state)
				//====================================================
				IDLE: 
				begin
					if(valid_in)
					begin
						hec_reg <= hec_enc; 
						state 	<= generate_hec;
					end
					else if(clear_reg)
					begin
						hec_reg[0] <= uap_dci[7];
						hec_reg[1] <= uap_dci[6];
						hec_reg[2] <= uap_dci[5];
						hec_reg[3] <= uap_dci[4];
						hec_reg[4] <= uap_dci[3];
						hec_reg[5] <= uap_dci[2];
						hec_reg[6] <= uap_dci[1];
						hec_reg[7] <= uap_dci[0];
					end
				end
				//====================================================
				generate_hec: 
				begin
					if(valid_in==1'b0)
						state 	<= IDLE;
					else 
						hec_reg <= hec_enc; 
				end
				//====================================================
			endcase
			//============================================================
		end
		//====================================================================
	end
	//============================================================================
	assign hec_enc[0] 	= hec_reg[7]^data_in;
	assign hec_enc[1] 	= hec_reg[0]^hec_reg[7]^data_in;
	assign hec_enc[2] 	= hec_reg[1]^hec_reg[7]^data_in;
	assign hec_enc[3] 	= hec_reg[2];
	assign hec_enc[4] 	= hec_reg[3];
	assign hec_enc[5]   = hec_reg[4]^hec_reg[7]^data_in;
	assign hec_enc[6]   = hec_reg[5];
	assign hec_enc[7] 	= hec_reg[6]^hec_reg[7]^data_in;	
	//============================================================================
endmodule
