`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 07/07/2024 09:23:58 AM
// Module Name: WIFI_Addr_Decode
//////////////////////////////////////////////////////////////////////////////////
module WIFI_Addr_Decode #(parameter ADDR_AHB = 12 ,ADDR_SLIC = 10,offset = 'h10) (
	input 		[ADDR_AHB-1:0] 		HADDR,
	input 							write_enable, read_enable,
	output reg 						rden_reg,rden_mem,
	output reg 						wren_reg,wren_mem,
	output reg 	[ADDR_SLIC-1:0] 	addr_mem,
	output reg 	[ADDR_AHB-1:0] 		addr_reg
    );

always @(*) begin
 	if(HADDR >=0 && HADDR < 'h10) begin //&& HADDR < 'h10
 		addr_reg = HADDR[ADDR_AHB-1 : 2];
 		addr_mem = 0;
 		if(write_enable) begin
 			wren_reg = 1'b1;
 			rden_reg = 1'b0;
 			wren_mem = 1'b0;
			rden_mem = 1'b0;
 		end
 		else if (read_enable) begin
 			rden_reg = 1'b1;
 			wren_mem = 1'b0;
			rden_mem = 1'b0;
			wren_reg = 1'b0;
 		end
 		else begin
 			wren_reg = 1'b0;
			rden_reg = 1'b0;
			wren_mem = 1'b0;
			rden_mem = 1'b0;
 		end
 	end 
 	else begin
 		addr_mem = HADDR - offset ;
 		addr_reg = 0;
 		if(write_enable) begin
 			wren_mem = 1'b1;
 			rden_mem = 1'b0;
			wren_reg = 1'b0;
			rden_reg = 1'b0;
 		end
 		else if (read_enable) begin
 			rden_mem = 1'b1;
 			wren_mem = 1'b0;
 			wren_reg = 1'b0;
			rden_reg = 1'b0;
 		end
 		else begin
 			wren_mem = 1'b0;
			rden_mem = 1'b0;
			wren_reg = 1'b0;
			rden_reg = 1'b0;
 		end
 	end
end
endmodule

