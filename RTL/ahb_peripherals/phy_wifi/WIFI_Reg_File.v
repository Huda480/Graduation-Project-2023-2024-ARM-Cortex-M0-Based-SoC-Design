`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 22.05.2024 21:00:51
// Module Name: WIFI_Reg_File
//////////////////////////////////////////////////////////////////////////////////
module WIFI_Reg_File #(parameter DATA_WIDTH = 32, DEPTH_REG = 4, ADDR_AHB = 12  ) (
	input 								clk, reset,
	input 								wren_reg, rden_reg,
	input 		[ADDR_AHB - 1 : 0] 		Rdaddr_reg,
	input 		[ADDR_AHB - 1 : 0] 		Wraddr_reg,
	input 		[DATA_WIDTH - 1 : 0] 	Reg_data_input,
    input 								clear_tx , clear_rx,
	output 								mode,
	output 								clear_Tx_irq,
 	output 								clear_Rx_irq,
	output 								enable,
	output 								dma_mode,
	output 								en_Rx_irq,
	output 								en_Tx_irq,
	output 		[DATA_WIDTH - 1 : 0] 	data_size,
	output reg 	[DATA_WIDTH - 1 : 0] 	Reg_data_output
	);

reg [DATA_WIDTH - 1 :0] Mem [DEPTH_REG - 1:0] ;
reg [ADDR_AHB - 1 : 0] Wraddr_reg_reg;
reg wren_reg_reg;

always @(posedge clk or negedge reset) 
begin
	if (~reset) 
	begin 
    	Wraddr_reg_reg 	<= 0;
    	wren_reg_reg 	<= 0;
	end
	else 
	begin
     	Wraddr_reg_reg 	<= Wraddr_reg;
     	wren_reg_reg 	<= wren_reg;
	end
end

always @(posedge clk or negedge reset)
begin
	if(!reset) 
	begin
   		Reg_data_output <= 0;
   		Mem[0]          <= 0;
   		Mem[1]          <= 0;
   		Mem[2]          <= 0;
   		Mem[3]          <= 32'd4056;
   		
   	end
   	else 
	begin
   		if (clear_tx) Mem[2][0] <= 0;
   		if (clear_rx) Mem[2][1] <= 0;
		if(wren_reg_reg) 
		begin
			Mem[Wraddr_reg_reg] <= Reg_data_input;
		end
		else if (rden_reg) 
		begin
			Reg_data_output 	<= Mem[Rdaddr_reg];
		end
   end
 end 

 assign enable = 		 Mem[0][0];
 assign mode = 			 Mem[0][1];
 assign dma_mode = 		 Mem[0][2];
 assign en_Tx_irq =  	 Mem[1][0];
 assign en_Rx_irq =  	 Mem[1][1];
 assign clear_Tx_irq =   Mem[2][0];
 assign clear_Rx_irq =   Mem[2][1];
 assign data_size =  	 Mem[3];

 endmodule	