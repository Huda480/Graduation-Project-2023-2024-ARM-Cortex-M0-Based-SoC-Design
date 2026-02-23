`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 07/03/2024 01:26:15 PM
// Module Name: WIFI_Data_Slicing
//////////////////////////////////////////////////////////////////////////////////
`define NON_SEQ 2'b10 
`define SEQ 2'b11

module WIFI_Data_Slicing #(parameter  DATA_WIDTH = 32, ADDR_SLIC = 10, ADDR_FIFO = 8) (
    input 							clk,reset,
    input 							write_enable,
    input 							read_enable,
    input 		[2:0] 				hsize,
	input 		[1:0] 				htrans,
	input 		[DATA_WIDTH - 1 :0] hwdata_ahb,
	input 		[DATA_WIDTH - 1 :0] wifi_rx_data,
	input 		[ADDR_SLIC - 1 :0] 	haddress,
	output wire [ADDR_FIFO - 1 :0] 	address_fifo,
	output wire 					fifo_wren, //write enable 
	output reg  					fifo_rden,
	output reg  [DATA_WIDTH - 1 :0] 		hrdata_ahb,
	output wire [DATA_WIDTH - 1 :0] 		wifi_tx_data
    );
//=======================================================================
						reg 					write_enable_reg;
(*DONT_TOUCH="yes"*) 	reg [ADDR_SLIC - 1 :0] 	haddress_reg;
						reg [2:0] 				hsize_reg;
						reg [1:0] 				htrans_reg;
(*DONT_TOUCH="yes"*) 	reg [ADDR_FIFO - 1 :0] 	address_fifo_reg;
						reg [DATA_WIDTH - 1 :0] wifi_tx_data_reg;
						reg 					fifo_wren_reg;
						reg [ADDR_FIFO - 1 :0] 	address_reg ;
						reg [DATA_WIDTH - 1 :0] hrdata_ahb_comb;
						reg						read_enable_reg;
//=======================================================================
assign address_fifo = address_fifo_reg;
assign wifi_tx_data = wifi_tx_data_reg;
assign fifo_wren 	= fifo_wren_reg;
//=======================================================================

always @(posedge clk or negedge reset) begin
if(~reset) begin
    write_enable_reg	<=0;
    haddress_reg 		<=0;
	hsize_reg           <=0;
	htrans_reg          <=0;
	read_enable_reg		<=0;
end
else begin
    write_enable_reg 	<= write_enable;
    haddress_reg 		<= haddress;
	hsize_reg			<= hsize;
	htrans_reg			<= htrans;
	read_enable_reg     <= read_enable;
end
end
//=======================================================================
//always @(*) begin
always_comb begin
		address_fifo_reg = 0;
		fifo_wren_reg = 0;
		hrdata_ahb_comb = 0;
		wifi_tx_data_reg = 0;
		fifo_rden = 0;
		if(write_enable_reg) begin
		address_fifo_reg = haddress_reg[9:2];
		 fifo_wren_reg = 1'b0; 
			if ((htrans_reg == `NON_SEQ) || (htrans_reg == `SEQ) ) begin 
				case(hsize_reg) 
				3'd0: begin
	              case(haddress_reg[1:0]) 
	                2'b00: begin
	                  wifi_tx_data_reg[7:0] = hwdata_ahb[7:0];
	                  fifo_wren_reg = 1'b0; 
	             	end
	                2'b01: begin
	                  wifi_tx_data_reg[15:8] = hwdata_ahb[15:8];
	                  fifo_wren_reg = 1'b0; 
	                end
	                2'b10: begin
	                  wifi_tx_data_reg[23:16] = hwdata_ahb[23:16];
	                  fifo_wren_reg = 1'b0; 
	                end
	                2'b11: begin
	                wifi_tx_data_reg[31:24] = hwdata_ahb[31:24];
	      			fifo_wren_reg = 1'b1; 
	                end
	              endcase
	          end 
          	3'd1: begin
	            case(haddress_reg[1]) 
	                1'b0: begin
	                  wifi_tx_data_reg[15:0] = hwdata_ahb[15:0];
	                  fifo_wren_reg = 1'b0; 
                	end
	                1'b1: begin
	                  wifi_tx_data_reg[31:16] = hwdata_ahb[31:16];
	                  fifo_wren_reg = 1'b1; 
	                end
              endcase
          end
          	default: begin
	           wifi_tx_data_reg = hwdata_ahb;
	           fifo_wren_reg = 1'b1; 
	          end
			endcase
			end
		end
		else if (read_enable_reg) begin
		fifo_wren_reg = 1'b0;
		address_fifo_reg = haddress_reg[9:2];
			if ((htrans_reg == `NON_SEQ) || (htrans_reg == `SEQ) ) begin 
				case(hsize_reg)
					3'd0: begin
					 fifo_rden = 1'b1; 
		              case(haddress_reg[1:0])
		                2'b00: begin
		                  hrdata_ahb_comb = wifi_rx_data[7:0];
		                end
		                2'b01: begin
		                  hrdata_ahb_comb = wifi_rx_data[15:8];
		                end
		                2'b10: begin
		                  hrdata_ahb_comb = wifi_rx_data[23:16];
		                end
		                2'b11: begin
		                  hrdata_ahb_comb = wifi_rx_data[31:24];
		                end
		              endcase
	          end 
          	3'd1: begin
          	fifo_rden = 1'b1; 
	            case(haddress_reg[1])
                1'b0: begin
                  hrdata_ahb_comb = wifi_rx_data[15:0];
                end
                1'b1: begin
                  hrdata_ahb_comb = wifi_rx_data[31:16];
                end
              endcase
          end
          	default: begin
				fifo_rden = 1'b1; 
	            hrdata_ahb_comb = wifi_rx_data;
	          end
		endcase	

	end
	end
	else begin
		 fifo_rden = 1'b0;
		 fifo_wren_reg = 1'b0;
		 address_fifo_reg = address_reg;
	end 
	//	end

	end  
	
	always@(posedge clk or negedge reset)begin
		if (~reset) begin
			address_reg <= 0;
			
		end 
		else if(write_enable_reg || read_enable) begin
			address_reg <= address_fifo_reg;
		end
	end
always_comb
begin
	hrdata_ahb=hrdata_ahb_comb;
end
	
endmodule
