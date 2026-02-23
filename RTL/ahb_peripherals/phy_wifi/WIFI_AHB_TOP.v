`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2024 10:23:19 AM
// Design Name: 
// Module Name: WIFI_AHB_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module WIFI_AHB_TOP #(parameter 
    PUNCTURER = 0, INTERLEAVER = 96 , MAPPER = 4,                       //WIFI parameters
    DATA_WIDTH = 32, DEPTH_REG = 4, DEPTH_FIFO = 128, ADDR_AHB = 12, ADDR_SLIC = 10, ADDR_FIFO=8, offset = 'h10)(
    input HCLK,
    input clk_100_MHz,
    input clk_50_MHz,
    input clk_20_MHz_WIFI,
    input reset,
    input HWRITE, HSEL,HREADY,
    input [DATA_WIDTH - 1:0] HADDR, HWDATA,
    input [1:0] HTRANS,
    input [2:0] HBURST, HSIZE,
    output [DATA_WIDTH - 1:0] HRDATA,
    output  HRESP, HREADYOUT,
    input   DMA_WRITE_DONE,
    input   DMA_READ_DONE,
    input   DMA_WRITE_ACK,
    input   DMA_READ_ACK,
    output  DMA_WRITE_REQ,
    output  DMA_READ_REQ,
    output rx_irq,Tx_irq
    );
//============================================================================

wire [2:0] data_size;
wire [1:0] data_trans;
wire [DATA_WIDTH-1:0] wifi_hwdata,wifi_hrdata;
wire [ADDR_AHB-1:0] wifi_address; 
wire write_enable, read_enable; 
wire fifo_full;
wire mode;
  
 //============================================================================
   (* keep_hierarchy = "yes" *)
AHB_Slave_wifi AHB_Slave_inist
(
	//AHB-Lite interface signals
	.HCLK(HCLK), 
	.HRESETn(reset), 
	.HWRITE(HWRITE), 
	.HSEL(HSEL),
	.HADDR(HADDR), 
	.HWDATA(HWDATA),
	.HTRANS(HTRANS),
	.HBURST(HBURST), 
	.HSIZE(HSIZE),
	.HRDATA(HRDATA),
	.HRESP(HRESP), 
	.HREADYOUT(HREADYOUT),
    .mode(mode),
	.wifi_hrdata(wifi_hrdata),
	.HREADY(HREADY), //////////////////needs to be checked
	.wifi_hwdata(wifi_hwdata), 
	.address(wifi_address),
	.renable(read_enable),
	.wenable(write_enable),
    .fifo_full(fifo_full),
	.data_size(data_size), 
	.burst_size(),
	.data_trans(data_trans)
);
 //============================================================================
   (* keep_hierarchy = "yes" *)   
WIFI_TOP #( PUNCTURER, INTERLEAVER, MAPPER, DATA_WIDTH, DEPTH_REG, DEPTH_FIFO, ADDR_AHB, ADDR_SLIC, ADDR_FIFO, offset) WIFI_TOP
(
    .HCLK(HCLK), 
    .reset(reset),
    .clk_100_MHz(clk_100_MHz),
    .clk_50_MHz(clk_50_MHz),
    .clk_20_MHz_WIFI(clk_20_MHz_WIFI),
    .data_out_real(data_out_real),
	.data_out_imag(data_out_imag),
    .mode(mode),
    .write_enable(write_enable), 
    .read_enable(read_enable), 
    .hsize(data_size), 
    .htrans(data_trans),
    .hwdata_ahb(wifi_hwdata),
    .haddress(wifi_address),
    .hrdata_ahb(wifi_hrdata),
    .fifo_full(fifo_full),
    .DMA_READ_ACK(DMA_READ_ACK),
	.DMA_READ_REQ(DMA_READ_REQ),
	.DMA_WRITE_ACK(DMA_WRITE_ACK),
	.DMA_WRITE_REQ(DMA_WRITE_REQ),
	.DMA_READ_DONE(DMA_READ_DONE),
	.DMA_WRITE_DONE(DMA_WRITE_DONE),
    .Tx_irq(Tx_irq),
    .rx_irq(rx_irq)
);

  
endmodule


