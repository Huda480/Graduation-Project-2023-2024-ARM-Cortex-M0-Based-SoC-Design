/*
======================================================================================
				Standard   : Bluetooth 
				Block name : CRC 16
				Modified By: Ahmed Nagy
======================================================================================
*/
//====================================================================================
module decrc16_bluetooth_ble  #(parameter CRC_LEGNTH=16)
(
	clk,
	reset,
	data_in,
	uap_dci,
	valid_in,
	clear_reg,
	crc_reg
);
	//============================================================================
	input clk;            
	input reset;          
	input data_in;             
	input valid_in; 
	input [7:0] uap_dci;
	input clear_reg;	
	output reg[CRC_LEGNTH-1:0] crc_reg;
	//============================================================================
	parameter IDLE 		= 1'b0; 
	parameter generate_crc 	= 1'b1; 
	//============================================================================
	reg state;
	wire [CRC_LEGNTH-1:0] crc_enc;
	//============================================================================
	always @(posedge clk or negedge reset) 
	begin
		//====================================================================
		if(!reset) 
		begin
			crc_reg[0] <= uap_dci[7];
			crc_reg[1] <= uap_dci[6];
			crc_reg[2] <= uap_dci[5];
			crc_reg[3] <= uap_dci[4];
			crc_reg[4] <= uap_dci[3];
			crc_reg[5] <= uap_dci[2];
			crc_reg[6] <= uap_dci[1];
			crc_reg[7] <= uap_dci[0];
			crc_reg[15:8] <= 8'h00;
			
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
						crc_reg <= crc_enc; 
						state 	<= generate_crc;
					end
					else if(clear_reg)
					begin
						crc_reg[0] <= uap_dci[7];
						crc_reg[1] <= uap_dci[6];
						crc_reg[2] <= uap_dci[5];
						crc_reg[3] <= uap_dci[4];
						crc_reg[4] <= uap_dci[3];
						crc_reg[5] <= uap_dci[2];
						crc_reg[6] <= uap_dci[1];
						crc_reg[7] <= uap_dci[0];
						crc_reg[15:8] <= 8'h00;
					end
				end
				//====================================================
				generate_crc: 
				begin
					if(valid_in==1'b0)
						state 	<= IDLE;
					else 
						crc_reg <= crc_enc; 
				end
				//====================================================
			endcase
			//============================================================
		end
		//====================================================================
	end
	//============================================================================
	assign crc_enc[0] 	= crc_reg[15]^data_in;
	assign crc_enc[1] 	= crc_reg[0];
	assign crc_enc[2] 	= crc_reg[1];
	assign crc_enc[3] 	= crc_reg[2];
	assign crc_enc[4] 	= crc_reg[3];
	assign crc_enc[5]   = crc_reg[4]^crc_reg[15]^data_in;
	assign crc_enc[6]   = crc_reg[5];
	assign crc_enc[7] 	= crc_reg[6];	
	assign crc_enc[8] 	= crc_reg[7];
	assign crc_enc[9] 	= crc_reg[8];
	assign crc_enc[10] 	= crc_reg[9];
	assign crc_enc[11] 	= crc_reg[10];
	assign crc_enc[12] 	= crc_reg[11]^crc_reg[15]^data_in;
	assign crc_enc[13] 	= crc_reg[12];
	assign crc_enc[14] 	= crc_reg[13];
	assign crc_enc[15] 	= crc_reg[14];
	//============================================================================
endmodule
