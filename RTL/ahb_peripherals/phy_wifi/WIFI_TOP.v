`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date: 22.05.2024 21:00:51
// Design Name: 
// Module Name: WIFI_TOP

//////////////////////////////////////////////////////////////////////////////////

module WIFI_TOP 
#(
    parameter 
    PUNCTURER = 0, INTERLEAVER = 96 , MAPPER = 4,                       //WIFI parameters
    DATA_WIDTH = 32, DEPTH_REG = 4, DEPTH_FIFO = 128, ADDR_AHB = 12, ADDR_SLIC = 10, ADDR_FIFO=8, offset = 'h10
)
(
    //==================   HCLK,RESET   ==================//
    HCLK, 
    reset,
    //==================       WIFI     ==================//
    clk_100_MHz,
    clk_50_MHz,
    clk_20_MHz_WIFI,
    data_out_real,
	data_out_imag,
    //================== AHB Interface  ==================//
    write_enable, 
    read_enable, 
    hsize, 
    htrans,
    hwdata_ahb,
    haddress,
    hrdata_ahb,
    //================== DMA Interface  ==================//
    DMA_WRITE_DONE,
    DMA_READ_DONE,
    DMA_WRITE_ACK,
    DMA_READ_ACK,
    DMA_WRITE_REQ,
    DMA_READ_REQ,
    //================== IRQ Interface  ==================//
    Tx_irq,
    mode,
    fifo_full,
    rx_irq
);
//==================   HCLK,RESET   ==================//
input                           HCLK, reset;
//==================    WIFI        ==================//
input                           clk_100_MHz, clk_50_MHz, clk_20_MHz_WIFI;
output [11:0] data_out_real;
output [11:0] data_out_imag;
output mode;
//================== AHB Interface  ==================//
input                           write_enable, read_enable;
input       [2:0]               hsize;
input       [1:0]               htrans;
input       [DATA_WIDTH - 1 :0] hwdata_ahb;
output      [DATA_WIDTH - 1 :0] hrdata_ahb;
input       [ADDR_AHB - 1 :0]   haddress;
//================== DMA Interface  ==================//
input                           DMA_WRITE_DONE;
input                           DMA_READ_DONE;
input                           DMA_WRITE_ACK;
input                           DMA_READ_ACK;
output reg                      DMA_WRITE_REQ;
output reg                      DMA_READ_REQ;
//================== IRQ Interface  ==================//
output                          Tx_irq, rx_irq;
output                          fifo_full;

//====================================================//
wire                        clear_tx , clear_rx;
wire                        clear_tx_sync,clear_rx_sync;
//====================================================//
wire                        wren_reg, wren_mem, rden_reg, rden_mem;
wire [ADDR_SLIC - 1 :0]     addr_mem;
wire [ADDR_AHB - 1 :0]      addr_reg;
//====================================================//
wire [DATA_WIDTH - 1 :0]    wifi_rx_data, wifi_tx_data;
wire [ADDR_FIFO - 1 :0]     address_fifo;
wire                        fifo_wren, fifo_rden;
//====================================================//
wire                        enable, dma_mode;
wire                        clear_Tx_irq, clear_Rx_irq, en_Rx_irq , en_Tx_irq;
wire [DATA_WIDTH - 1 :0]    data_size;
//====================================================//
wire [DATA_WIDTH - 1 :0]    data_in_tx, data_out_rx;
wire [DATA_WIDTH - 1 :0]    R_Data_ahb;
wire                        tx_valid_out, rx_valid_out;
wire                        fifo_empty;
//====================================================//
wire done_PISO, start_rd_pulse, done, re_ram;
//====================================================//
wire                        tx_valid_pul, rx_valid_pul;
reg                         tx_valid, rx_valid;
reg                         write_ack_reg, read_ack_reg;
//============================================================================
(* keep_hierarchy = "yes" *)
BIT_SYNC BIT_SYNC_tx_irq (
    .CLK(HCLK),
    .RST(reset),
    .ASYNC(clear_tx),
    .SYNC(clear_tx_sync)
);
//============================================================================
(* keep_hierarchy = "yes" *)
BIT_SYNC BIT_SYNC_rx_irq (
    .CLK(HCLK),
    .RST(reset),
    .ASYNC(clear_rx),
    .SYNC(clear_rx_sync)
);
//============================================================================
(* keep_hierarchy = "yes" *)
WIFI_Addr_Decode #(ADDR_AHB, ADDR_SLIC, offset) addr_decode_inist (
    .HADDR(haddress), 
    .write_enable(write_enable),
    .read_enable(read_enable),
    .rden_reg(rden_reg),
    .rden_mem(rden_mem),
    .wren_reg(wren_reg),
    .wren_mem(wren_mem),
    .addr_mem(addr_mem),
    .addr_reg(addr_reg)
); 

//============================================================================
(* keep_hierarchy = "yes" *) 
WIFI_Data_Slicing #(DATA_WIDTH, ADDR_SLIC, ADDR_FIFO ) data_slicing_inist (
    .clk(HCLK),
    .reset(reset),
    .write_enable(wren_mem),
    .read_enable(rden_mem),
    .hsize(hsize),
    .htrans(htrans),
    .hwdata_ahb(hwdata_ahb),
    .wifi_rx_data(R_Data_ahb),
    .haddress(addr_mem),
    .address_fifo(address_fifo),
    .fifo_wren(fifo_wren),
    .fifo_rden(fifo_rden),
    .hrdata_ahb(hrdata_ahb),
    .wifi_tx_data(wifi_tx_data)
 );
//============================================================================
(* keep_hierarchy = "yes" *)       
WIFI_Reg_File #(DATA_WIDTH, DEPTH_REG, ADDR_AHB ) RegFile_inist (
    .clk(HCLK), 
    .reset(reset),
    .wren_reg(wren_reg), 
    .rden_reg(rden_reg),
    .Rdaddr_reg(addr_reg),
    .Wraddr_reg(addr_reg),
    .Reg_data_input (hwdata_ahb),
    .clear_tx(clear_tx_sync), 
    .clear_rx(clear_rx_sync),
    .mode(mode),
    .clear_Tx_irq(clear_Tx_irq),
    .clear_Rx_irq(clear_Rx_irq),
    .enable(enable),
    .dma_mode(dma_mode),
    .en_Tx_irq(en_Tx_irq),
    .en_Rx_irq(en_Rx_irq),
    .data_size(data_size),
    .Reg_data_output()
);
//============================================================================
(* keep_hierarchy = "yes" *)
shared_mem_top #(ADDR_FIFO, DATA_WIDTH, DEPTH_FIFO) shared_memory (
    .mode(mode),
    .reset(reset),
    .hclk(HCLK),
    .fifo_address(address_fifo),
    .fifo_write_en(fifo_wren),
    .fifo_read_en(fifo_rden),
    .fifo_input_from_slicer(wifi_tx_data),
    .fifo_out_to_slicer(wifi_rx_data),
    .clk_read(clk_50_MHz),
    .re(re_ram),
    .data_size(data_size),
    .tx_irq(tx_valid_out),
    .data_out(data_in_tx),  
    .clk_write(clk_50_MHz),
    .we(rx_valid_out),
    .data_in(data_out_rx),
    .R_Data_ahb(R_Data_ahb),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty)
);
//============================================================================
(* keep_hierarchy = "yes" *)    
WIFI_TX_TOP #(PUNCTURER,INTERLEAVER,MAPPER, DATA_WIDTH) tx
(
    .clk_input(clk_50_MHz),
    .clk_encoder(clk_100_MHz),
    .clk_ifft(clk_20_MHz_WIFI), 
    .reset(reset), 
    .data_in(data_in_tx), 
    .valid_in(fifo_wren),
    .data_size(data_size), 
    .clear_Tx_irq(clear_Tx_irq),
    .en_Tx_irq(en_Tx_irq), 
    .valid_out(tx_valid_out),
    .data_out_re(data_out_real),
    .data_out_im(data_out_imag),
    .done_PISO(done_PISO),
    .start_rd_pulse(start_rd_pulse),
    .done(done),
    .Tx_irq(Tx_irq),
    .clear_tx(clear_tx)
);

//============================================================================
(* keep_hierarchy = "yes" *)
WIFI_RX_TOP #(PUNCTURER,INTERLEAVER,MAPPER, DATA_WIDTH) rx
(
    .clk_output(clk_50_MHz),
    .clk_decoder(clk_100_MHz),
    .clk_fft(clk_20_MHz_WIFI),
    .reset(reset),
    .valid_in(tx_valid_out),
    .data_in_re(data_out_real),
    .data_in_im(data_out_imag),
    .rx_irq(rx_irq),
    .clear_Rx_irq(clear_Rx_irq),
    .en_Rx_irq(en_Rx_irq),
    .data_out(data_out_rx),
    .valid_out(rx_valid_out),
    .clear_rx(clear_rx)
);
//============================================================================
always @(posedge HCLK or negedge reset) 
begin
    if(!reset)
    begin
        tx_valid <= 1'b1;
    end
    else
    begin
        tx_valid <= tx_valid_out;
    end
end

assign tx_valid_pul = (tx_valid & !tx_valid_out) ? 'b1 : 'b0;

always @(posedge HCLK or negedge reset) 
begin
	if(!reset)
    begin
        write_ack_reg <= 1'b0;
    end
	else if (DMA_WRITE_ACK)
    begin
        write_ack_reg <= 1'b1;
    end
    else if (DMA_WRITE_DONE) 
    begin
        write_ack_reg <= 1'b0;
    end	
end

always @(posedge HCLK or negedge reset) 
begin
	if(!reset)
    begin
        DMA_WRITE_REQ <= 1'b0;
    end
	else if (write_ack_reg)
    begin
        DMA_WRITE_REQ <= 1'b0;
    end
    else if (dma_mode && !tx_valid_out) 
    begin
        DMA_WRITE_REQ <= 1'b1;
    end	
end
//------------------------------------------------------------

always @(posedge HCLK or negedge reset) 
begin
    if(!reset)
    begin
        rx_valid <= 1'b0;
    end
    else
    begin
        rx_valid <= rx_valid_out;
    end
end

assign rx_valid_pul = (!rx_valid & rx_valid_out) ? 'b1 : 'b0;

always @(posedge HCLK or negedge reset) 
begin
	if(!reset)
    begin
        read_ack_reg <= 1'b0;
    end
	else if (DMA_READ_ACK)
    begin
        read_ack_reg <= 1'b1;
    end
    else if (DMA_READ_DONE) 
    begin
        read_ack_reg <= 1'b0;
    end	
end

always @(posedge HCLK or negedge reset) 
begin
	if(!reset)
    begin
        DMA_READ_REQ <= 1'b0;
    end
	else if (read_ack_reg)
    begin
        DMA_READ_REQ <= 1'b0;
    end
    else if (dma_mode && rx_valid_pul) 
    begin
        DMA_READ_REQ <= 1'b1;
    end	
end

//============================================================================
    //When TX is reading from FIFO to chain
    assign re_ram = start_rd_pulse | done_PISO & done ;


endmodule