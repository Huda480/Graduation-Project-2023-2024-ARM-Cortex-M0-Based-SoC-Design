/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Bluetooth Chain Top
======================================================================================
*/
//====================================================================================
`define uap             8'b0
//`define payload_size    16'd4264
//`define header_size     16'd126
`define FEC_enable      1'b1
`define CRC_enable      1'b1
//====================================================================================
module tx_rx_bt_ble #(parameter AD=12, DATA=32, MEM=1024,RE_IM_AD=13, RE_IM_SIZE=12, RE_IM_MEM=8192)
(
    hclk,
    clk_6945_KHz,
    clk_3472_KHz,
	reset,
	hsize,
	htrans,
    hwdata,
    hrdata,
    write_en_mem,
    read_en_mem,
    mem_address,
    tx_irq,
    rx_irq,
    mode,
    enable_chain,
    tx_irq_en,
    rx_irq_en,
    rx_irq_clear,
    tx_irq_clear,
    dma_mode,
    dma_ack,
    tx_dma_ack,
    chain_clr_tx_irq,
    chain_clr_rx_irq,
    rx_dma_req,
    tx_dma_req,
    fifo_rd_pntr,
    fifo_empty,
    w_done_flag,
    
    tx_irq_pulse,
    valid_out_tx,
    data_out_tx_re,
    data_out_tx_im,
    header_mapper_data_in_count,
    payload_mapper_data_in_count,
    
    valid_out_mem_re,
    data_out_tx_re_to_rx,
    valid_out_mem_im,
    data_out_tx_im_to_rx,
    
    payload_size,
    header_size,
    tx_dma_done,
    rx_dma_done
);
//===============================================================================
input  wire hclk;
input  wire clk_6945_KHz;
input  wire clk_3472_KHz;
input  wire reset;	
input  wire [2:0] hsize;
input  wire [1:0] htrans;
input  wire [DATA-1:0] hwdata;
input  wire enable_chain;
input  wire tx_irq_en;
input  wire rx_irq_en;
input  wire rx_irq_clear;
input  wire tx_irq_clear;
input  wire write_en_mem;
input  wire read_en_mem;
input  wire [AD-3:0] mem_address;
input  wire mode;
input  wire dma_mode;
input  wire dma_ack;
output wire chain_clr_tx_irq;
output wire chain_clr_rx_irq;
output wire [DATA-1:0] hrdata;
output wire tx_irq;
output wire rx_irq;
output wire rx_dma_req;
output wire [AD-5:0] fifo_rd_pntr;
input tx_dma_ack;
output tx_dma_req;
output fifo_empty;
output w_done_flag;

//TX Interface with INTERMEDIATE RAM
output tx_irq_pulse;
output valid_out_tx;
output [RE_IM_SIZE-1:0] data_out_tx_re;
output [RE_IM_SIZE-1:0] data_out_tx_im;
output [11:0] header_mapper_data_in_count;
output [11:0] payload_mapper_data_in_count;
//RX Interface with INTERMEDIATE RAM
input valid_out_mem_re;
input [RE_IM_SIZE-1:0] data_out_tx_re_to_rx;
input valid_out_mem_im;
input [RE_IM_SIZE-1:0] data_out_tx_im_to_rx;


input [15:0] payload_size;
input [15:0] header_size;

input tx_dma_done;
input rx_dma_done;
//============================================================================
(* keep_hierarchy = "yes" *)
top_chain_bluetooth_ble #(AD, DATA,MEM,RE_IM_AD, RE_IM_SIZE, RE_IM_MEM) txrx (
    .hclk(hclk),
    .clk_3472_KHz(clk_3472_KHz),
    .clk_6945_KHz(clk_6945_KHz),
    .reset(reset),
    .UAP(`uap),
    .payload_size(payload_size),
    .header_size(header_size),
    .FEC_enable(`FEC_enable),
    .CRC_enable(`CRC_enable),
    .hsize(hsize),
    .htrans(htrans),
    .hwdata(hwdata),
    .hrdata(hrdata),
    .read_en_mem(read_en_mem),
    .write_en_mem(write_en_mem),
    .mem_address(mem_address),
    .rx_irq(rx_irq),
    .tx_irq(tx_irq),
    .enable_chain(enable_chain),
    .mode(mode),
    .tx_irq_en(tx_irq_en), 
    .rx_irq_en(rx_irq_en),
    .tx_irq_clear(tx_irq_clear), 
    .dma_mode(dma_mode),
    .dma_ack(dma_ack),
    .tx_dma_ack(tx_dma_ack),
    .chain_clr_tx_irq(chain_clr_tx_irq),
    .chain_clr_rx_irq(chain_clr_rx_irq),
    .rx_irq_clear(rx_irq_clear),
    .rx_dma_req(rx_dma_req),
    .tx_dma_req(tx_dma_req),
    .fifo_rd_pntr(fifo_rd_pntr),
    .fifo_empty(fifo_empty),
    .w_done_flag(w_done_flag),
    
    .tx_irq_pulse(tx_irq_pulse),
    .valid_out_tx(valid_out_tx),
    .data_out_tx_re(data_out_tx_re),
    .data_out_tx_im(data_out_tx_im),
    .header_mapper_data_in_count(header_mapper_data_in_count),
    .payload_mapper_data_in_count(payload_mapper_data_in_count),
    
    .valid_out_mem_re(valid_out_mem_re),
    .data_out_tx_re_to_rx(data_out_tx_re_to_rx),
    .valid_out_mem_im(valid_out_mem_im),
    .data_out_tx_im_to_rx(data_out_tx_im_to_rx),

    .tx_dma_done(tx_dma_done),
    .rx_dma_done(rx_dma_done)
    );
//============================================================================    
endmodule
