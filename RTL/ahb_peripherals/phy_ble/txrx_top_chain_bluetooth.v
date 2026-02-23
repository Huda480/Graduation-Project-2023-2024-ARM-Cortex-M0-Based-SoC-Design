/*
======================================================================================
				Standard   :    Bluetooth 
				Block name :    Bluetooth Chain Top
				Created By :    Eslam Elnader
				Last Modified:  30/7/2024
======================================================================================
*/
module top_chain_bluetooth_ble #(parameter AD=12, DATA=32, MEM=128,RE_IM_AD=13, RE_IM_SIZE=12, RE_IM_MEM=8192, OFFSET = 'h10, DEPTH=4, WIDTH=32)
(
    hclk,
    clk_3472_KHz,
    clk_6945_KHz,
    reset,
    UAP,
    payload_size,
    header_size,
    FEC_enable,
    CRC_enable,   
    hsize,
    htrans,
    hwdata,
    hrdata,
    write_en_mem,
    read_en_mem,
    mem_address,
    tx_irq,
    rx_irq,
    enable_chain,
    mode,
    tx_irq_en,
    rx_irq_en,
    tx_irq_clear,
    rx_irq_clear,
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
    tx_dma_done,
    rx_dma_done
);
//============================================================================
input  hclk;
input  clk_3472_KHz;
input  clk_6945_KHz;
input  reset;

input  FEC_enable;
input  CRC_enable;
input  [7:0] UAP;
input  [15:0] payload_size;
input  [15:0] header_size;
 
input  [2:0] hsize;
input  [1:0] htrans;
input  write_en_mem;
input  read_en_mem;
input  [AD-3:0] mem_address;
input  [DATA-1:0] hwdata;

input  enable_chain;
input  mode;
input  tx_irq_en;
input  rx_irq_en;
input  rx_irq_clear;
input  tx_irq_clear;
input dma_mode;
input dma_ack;
input tx_dma_ack;

output [DATA-1:0] hrdata;
output tx_irq;
output rx_irq;
output chain_clr_tx_irq;
output chain_clr_rx_irq;
output rx_dma_req;
output tx_dma_req;
output [AD-5:0] fifo_rd_pntr;
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

input tx_dma_done;
input rx_dma_done;

//============================================================================
// Clock generator
wire hclk;
wire clk_3472_KHz;
wire clk_6945_KHz;

//Slicer to FIFO
wire [AD-5:0] fifo_address;

//Slicer to FIFO (writting)
wire fifo_write_en;
wire [DATA-1:0] fifo_input_from_slicer;

//TX reading from Shared RAM
wire start_rd;
wire done_piso;
wire piso_enabled;
wire re_ram_tx;
wire [DATA-1:0] shared_ram_data_out_to_chain;

// Header and Paylod Segmentation
wire data_out_segmentation;
wire valid_in_header;
wire valid_in_payload;

//RX serial output signals
wire error_flag;
wire data_out;

//RX writing in the Shared RAM
wire done_sipo;
wire valid_out_rx;
wire finish_write_output_ram;
wire we_ram_rx;
wire [DATA-1:0] rx_data_out_parallel;

//Slicer to FIFO (reading)
wire fifo_read_en;

//FIFO to Slicer
wire [DATA-1:0] fifo_out_to_slicer;

//FIFO empty and full flags
wire fifo_full;
//wire fifo_empty;



wire [16:0] data_size;
//============================================================================
assign data_size =payload_size + header_size;

//generating TX DMA REQ flag signal 
reg tx_dma_req_flag;
reg tx_dma_ack_reg;

//============================================================================
//generating TX DMA REQ flag signal 

always @(posedge hclk or negedge reset) begin
    if (~reset) begin
        tx_dma_ack_reg <= 1'b0;
    end   
    else begin
        if (tx_dma_ack) begin
           tx_dma_ack_reg <= 1'b1;
        end
        else if (tx_dma_done) begin
            tx_dma_ack_reg <= 1'b0; //saving the pulse assertion
        end
    end
end 

always @(posedge hclk or negedge reset) begin
    if (~reset) begin
        tx_dma_req_flag <= 1'b0;
    end   
    else begin
        if (tx_dma_ack_reg) begin
           tx_dma_req_flag <= 1'b0;
        end
        else if (fifo_empty & mode) begin
            tx_dma_req_flag <= 1'b1; //saving the pulse assertion
        end
    end
end 
//Rx DMA REQ Signal Assertion
assign tx_dma_req = (dma_mode & tx_dma_req_flag) ? 1'b1:1'b0; 
//============================================================================
//Data Slicing
//(*DONT_TOUCH="yes"*)
data_slicer_ble #(AD-2) data_slicer_inst (
    .clk(hclk), 
    .reset(reset), 
    .wenable(write_en_mem), 
    .renable(read_en_mem), 
    .hsize(hsize), 
    .htrans(htrans), 
    .haddr(mem_address),
    .hwdata_ahb(hwdata), 
    .fifo_read_data(fifo_out_to_slicer), 
    .fifo_read_en(fifo_read_en), 
    .fifo_write_en_out(fifo_write_en), 
    .fifo_address_out(fifo_address), 
    .hrdata_ahb(hrdata), 
    .fifo_write_data_out(fifo_input_from_slicer)
    );

//============================================================================
// Shared RAM (FIFO)
shared_mem_top_ble #(AD-4,DATA,MEM) shared_mem (
    .mode(mode),
    .reset(reset),
    .data_size(data_size),
    //================== AHB Interface (Data Slicer interfcae with FIFO) ==================
    .hclk(hclk),
    .fifo_address(fifo_address),
    .fifo_write_en(fifo_write_en),
    .fifo_read_en(fifo_read_en),
    .fifo_input_from_slicer(fifo_input_from_slicer),
    .fifo_out_to_slicer(fifo_out_to_slicer),
    //================== BLE Interface ==================
    //---------------- BLE TX ----------------
    .clk_read(clk_3472_KHz),
    .re(re_ram_tx),
    //output from chain input to the FIFO
    .tx_irq(tx_irq_pulse),
    // ***** from FIFO to serializer ***** 
    // input data to chain output from FIFO
    .data_out(shared_ram_data_out_to_chain),  
    //---------------- BLE RX ----------------
    .clk_write(clk_6945_KHz),
    //valid_out header | payload
    .we(we_ram_rx),
    // output data from chain input to FIFO
    .data_in(rx_data_out_parallel),
    //================== FIFO signals ==================
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .fifo_rd_pntr(fifo_rd_pntr),
    .w_done_flag(w_done_flag)
    );
    //============================================================================
    //When TX is reading from FIFO to chain
    //============================================================================
    //re_ram_tx to enable the reading from the input ram once entering the read mode
    ////done_piso signal is not enough to read
    //// as we need to stop reading from the memory when switching bwetween header and payload
    ////piso_enabled signals assures that
    ///we need to start reading from the ram using the start_rd pulse
    assign re_ram_tx = start_rd | done_piso & piso_enabled ;

//============================================================================
// Segmentation to Header and Payload
(*DONT_TOUCH="yes"*)
input_segmentation_ble #(DATA) data_segmentation (
    .clk(clk_3472_KHz),
    .reset(reset),
    .enable_chain(enable_chain),
    .valid_in(fifo_write_en),
    .data_in(shared_ram_data_out_to_chain),
    .header_size(header_size),
    .payload_size(payload_size),
    .valid_in_header(valid_in_header),
    .valid_in_payload(valid_in_payload),
    .data_out(data_out_segmentation),
    .done_piso(done_piso),
    .start_rd_pulse(start_rd),
    .enable(piso_enabled)
    );
//============================================================================
// Transmitter Top
(* keep_hierarchy = "yes" *) 
top_tx_ble #(RE_IM_SIZE) tx (
    .clk(clk_3472_KHz),
    .reset(reset),
    .valid_in(valid_in_header | valid_in_payload),
    .data_in(data_out_segmentation),
    .UAP(UAP),
    .payload_size(payload_size),
    .FEC_enable(FEC_enable),
    .CRC_enable(CRC_enable),
    .valid_out(valid_out_tx),
    .data_out_re(data_out_tx_re),
    .data_out_im(data_out_tx_im),
    .header_mapper_data_in_count(header_mapper_data_in_count),
    .payload_mapper_data_in_count(payload_mapper_data_in_count),
    .tx_irq_en(tx_irq_en),
    .tx_irq(tx_irq),
    .tx_irq_clear(tx_irq_clear),
    .tx_irq_pulse(tx_irq_pulse),
    .chain_clr_tx_irq(chain_clr_tx_irq)
    );

//============================================================================
// Receiver Top
(* keep_hierarchy = "yes" *) 
top_rx_ble #(DATA) rx (
    .clk(clk_3472_KHz),
    .clk_fast(clk_6945_KHz),
    .reset(reset),
    .valid_in(valid_out_mem_re | valid_out_mem_im),
    .data_in_re(data_out_tx_re_to_rx),
    .data_in_im(data_out_tx_im_to_rx),
    .UAP(UAP),
    .payload_size(payload_size),
    .header_size(header_size),
    .FEC_enable(FEC_enable),
    .CRC_enable(CRC_enable),
    .rx_irq_en(rx_irq_en),
    .dma_ack(dma_ack),
    .dma_mode(dma_mode),
    .valid_out(valid_out_rx),
    .error_flag(error_flag),
    .data_out(data_out),
    .data_out_parallel(rx_data_out_parallel),
    .done_sipo(done_sipo),
    .rx_irq(rx_irq),
    .rx_irq_clear(rx_irq_clear),
    .chain_clr_rx_irq(chain_clr_rx_irq),
    .finish_write_output_ram(finish_write_output_ram),
    .rx_dma_req(rx_dma_req),
    .rx_dma_done(rx_dma_done)
    );
    //============================================================================
    //When RX is writting from de-srializer to Shared RAM
    //============================================================================    
    //this the write enable signal to the ram
    //the "done_sipo & we" part assures that the writing stops as long the we is deasserted (no valid data)
    ////this happens between header and payload
    // the "| we_done" part assures that we write the last bits before finishing
    ////this is needed as the last no. of bits of the payload are less than DATA-1
	assign we_ram_rx = done_sipo & valid_out_rx | finish_write_output_ram;

//============================================================================   
endmodule
