/*
======================================================================================
				Standard   :    Bluetooth 
				Block name :    Register File
				Created By :    Abdulrahman Galal & Habiba Hassan
				Last Modified:  27/7/2024
======================================================================================
*/

module Register_File_ble #(parameter AD = 2, DEPTH = 4, WIDTH = 32) (
	clk, 
	reset, 
	read_en, 
	write_en, 
	address,
	ahb_data_in,
	chain_clr_tx_irq,
	chain_clr_rx_irq,
	data_out,
	enable,
	mode,
	dma_mode,
	tx_irq_en, 
	rx_irq_en,
	tx_irq_clear, 
	rx_irq_clear,
	
	payload_size,
	header_size
	);

	input clk, reset;
	input read_en, write_en;
	input [AD-1:0] address;
	input [WIDTH-1:0] ahb_data_in;
	input chain_clr_tx_irq;
	input chain_clr_rx_irq;
	output reg  [WIDTH-1:0] data_out;
	output reg enable;
	output reg mode; //Tx or Rx 
	output reg dma_mode;
	output reg tx_irq_en, rx_irq_en;
	output reg tx_irq_clear, rx_irq_clear;
	
	output reg [15:0] payload_size;
    output reg [15:0] header_size;
    
reg [WIDTH-1:0] mem[DEPTH-1:0];
reg write_en_reg;
reg [AD-1:0] address_reg;



always @(posedge clk or negedge reset) begin
	if (~reset) begin
		enable 	<= 1'b0;
		mode 	<= 1'b0;
		dma_mode <= 1'b0;
		tx_irq_en <= 1'b0;
		rx_irq_en <= 1'b0; 
		tx_irq_clear <= 1'b0;
		rx_irq_clear <= 1'b0;
		
		payload_size <= 0;
		header_size <= 0;
	end
	else begin

		enable <= mem[0][0];
		mode <= mem[0][1];
		dma_mode <= mem[0][2];
		tx_irq_en <= mem[1][0];
		rx_irq_en <= mem[1][1];
		//write-only regs
		tx_irq_clear <= mem[2][0];
		rx_irq_clear <= mem[2][1];
		
		payload_size <= mem[3][15:0];
		header_size <= mem[3][31:16];
		
	end
end
always @(posedge clk or negedge reset) begin
	if (~reset) begin
		data_out <= 0;
		mem[0] <= 0;
		mem[1] <= 0;
		mem[2] <= 0;
		mem[3][15:0] <= 4264;
		mem[3][31:16] <= 126;
	end
	else begin
	    if (chain_clr_tx_irq) mem[2][0] <= 1'b0;
		if (chain_clr_rx_irq) mem[2][1] <= 1'b0;
		if (write_en_reg) begin
			mem[address_reg] <= ahb_data_in;
		end
		else if(read_en) begin
			data_out <= mem[address];
		end
	end
end

always @(posedge clk or negedge reset) begin
	if (~reset) begin
		write_en_reg <= 0;
    	address_reg <= 0;
	end
	else begin
		write_en_reg <= write_en;
    	address_reg <= address;
	end
end

endmodule