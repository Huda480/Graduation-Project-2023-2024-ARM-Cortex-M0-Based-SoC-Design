/*
======================================================================================
				Standard   :    Bluetooth 
				Block name :    Data Slicer
				Created By :    Habiba Hassan
				Last Modified:  11/7/2024
======================================================================================
*/

`define SEQ 2'b11
`define NON_SEQ 2'b10
module data_slicer_ble #(parameter AD =10)(
		clk, 
		reset, 
		wenable, 
		renable, 
		hsize, 
		htrans, 
		haddr,
	 	hwdata_ahb, 
	 	fifo_read_data, 
	 	fifo_read_en, 
	 	fifo_write_en_out, 
	 	fifo_address_out, 
	 	hrdata_ahb, 
	 	fifo_write_data_out
	 	);

//-----------------------------------------------------------
input clk, reset;
input wenable;
input renable; 
input [2:0] hsize;
input [1:0] htrans;
input [AD-1:0] haddr;
input [31:0] hwdata_ahb;
input [31:0] fifo_read_data;
output reg fifo_read_en;
output wire fifo_write_en_out;
output wire [AD-3:0] fifo_address_out;
output wire [31:0] fifo_write_data_out;
output reg [31:0] hrdata_ahb;
//-----------------------------------------------------------

 /*Importing Packages*/
//import transfers::*;

//-----------------------------------------------------------
(*DONT_TOUCH="yes"*) reg [AD-1:0] haddr_reg;
reg wenable_reg;
reg [31:0] fifo_write_data;
reg fifo_write_en;
(*DONT_TOUCH="yes"*) reg [AD-3:0] fifo_address;
reg [2:0] hsize_reg;
reg [1:0] htrans_reg;
//-----------------------------------------------------------
assign fifo_address_out = fifo_address;
assign fifo_write_data_out = fifo_write_data;
assign fifo_write_en_out = fifo_write_en;
//-----------------------------------------------------------
always @(posedge clk or negedge reset) begin
	if (~reset) begin
		wenable_reg           <=0;
		haddr_reg             <=0;
		hsize_reg             <=0;
		htrans_reg            <=0;
	end
	else begin
		wenable_reg           <= wenable;
		haddr_reg             <= haddr;
		hsize_reg             <= hsize;
		htrans_reg            <= htrans;
	end
end
//-----------------------------------------------------------
always @(*) begin

        fifo_address = 0;
		fifo_write_en = 0;
		hrdata_ahb = 0;
		fifo_write_data = 0;
		fifo_read_en = 0;
/*
    if(~reset) begin
		fifo_address = 0;
		fifo_write_en = 0;
		hrdata_ahb = 0;
		fifo_write_data = 0;
		fifo_read_en = 0;
	end 

	else begin
*/
	if  (wenable_reg) begin
		fifo_write_en = 1'b0;
		fifo_address = haddr_reg[AD-1:2];
			if ((htrans_reg == `SEQ) || (htrans_reg == `NON_SEQ)) begin
				case (hsize_reg)
					3'd0: begin //Byte
						case (haddr_reg[1:0])
							2'b00: begin
								fifo_write_data[7:0] = hwdata_ahb[7:0];
								fifo_write_en = 1'b0;
							end
							2'b01: begin
								fifo_write_data[15:8] = hwdata_ahb[15:8];
								fifo_write_en = 1'b0;	
							end
							2'b10: begin
								fifo_write_data[23:16] = hwdata_ahb[23:16];
								fifo_write_en = 1'b0;
							end
							2'b11: begin
								fifo_write_data[31:24] = hwdata_ahb[31:24];
								fifo_write_en = 1'b1; //completed the word? start writing in mem
							end
						endcase
					end
					3'd1: begin //Halfword
						case (haddr_reg[1])
							1'b0: begin
								fifo_write_data[15:0] = hwdata_ahb[15:0];
								fifo_write_en = 1'b0;
							end
							1'b1: begin
								fifo_write_data[31:16] = hwdata_ahb[31:16];
								fifo_write_en = 1'b1; 
							end
						endcase
					end
					default: begin //word
					fifo_write_data = 	hwdata_ahb;
					fifo_write_en = 1'b1;
					end
				endcase
	
			end
	end
	else if (renable) begin
		fifo_write_en = 1'b0;
		fifo_address = haddr[AD-1:2];
		fifo_read_en = 1'b1;
		
	end
	else begin
		fifo_read_en = 1'b0;
		fifo_write_en = 1'b0;
	end
	
	if ((htrans_reg == `SEQ) || (htrans_reg == `NON_SEQ)) begin
				case (hsize_reg)
					3'd0: begin //Byte
						case (haddr_reg[1:0])
							2'b00: begin
								hrdata_ahb = fifo_read_data[7:0];
							end
							2'b01: begin
								hrdata_ahb = fifo_read_data[15:8];
							end
							2'b10: begin
								hrdata_ahb = fifo_read_data[23:16];
							end
							2'b11: begin
								hrdata_ahb = fifo_read_data[31:24];
							end
						endcase
					end
					3'd1: begin //Halfword
					    case (haddr_reg[1])
							1'b0: begin
								hrdata_ahb = fifo_read_data[15:0];
							end
							1'b1: begin
								hrdata_ahb = fifo_read_data[31:16];
							end
						endcase
					end
					default: begin //word
						hrdata_ahb = fifo_read_data;
					end
				endcase
	
			end
end
//end
endmodule
