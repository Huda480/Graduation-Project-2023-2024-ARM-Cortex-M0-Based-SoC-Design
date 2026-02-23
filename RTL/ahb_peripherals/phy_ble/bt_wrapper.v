/*
======================================================================================
				Standard   : Bluetooth 
				Block name : AHB Slave Bus and Bluetooth Wrapper
======================================================================================
*/
module bt_wrapper #(parameter AD=12, DATA=32, MEM=256,RE_IM_AD=13, RE_IM_SIZE=12, RE_IM_MEM=8192, OFFSET = 'h10, DEPTH=4, WIDTH=32)(
    input wire hclk,
    input wire clk_3472_KHz,
    input wire  clk_6945_KHz,
    input wire reset,	
    input wire [2:0] hsize,
    input wire [1:0] htrans,
    input wire [DATA-1:0] haddress,
    input wire [DATA-1:0] hwdata,
    input wire hwrite,
    input wire hsel,
    input wire dma_ack,
    input wire tx_dma_ack,
    output wire [DATA-1:0] hrdata,
    output wire tx_irq,
    output wire rx_irq,
    output wire hresp,
    output wire hreadyout,
    output wire rx_dma_req,
    output wire tx_dma_req,
    
    //DATA FROM OTHER SYSTEM TO RX
    input valid_in_mem_re_ble,
    input [RE_IM_SIZE-1:0] data_in_re_to_rx_ble,
    input valid_in_mem_im_ble,
    input [RE_IM_SIZE-1:0] data_in_im_to_rx_ble,
    
    //DATA TO OTHER SYSTEM
    output valid_out_mem_re_ble,
    output [RE_IM_SIZE-1:0] data_out_re_to_rx_ble,
    output valid_out_mem_im_ble,
    output [RE_IM_SIZE-1:0] data_out_im_to_rx_ble,

    input tx_dma_done,
    input rx_dma_done
    );

//============================================================================
   
    //AHB Bus to BLE Chain
    wire [DATA-1:0] hwdata_ahb;
    wire [AD-1:0] haddress_ahb;
    wire [1:0] htrans_ahb;
    wire [2:0] hsize_ahb;
    
    //AHB Bus to Address Decoder
    wire renable;
    wire wenable;
    
    //BLE Chain to AHB Bus 
    wire [DATA-1:0] hrdata_ahb;
    wire [AD-5:0] fifo_rd_pntr;
    
    //Address Decoder to BLE Chain
    wire write_en_mem;
    wire read_en_mem;
    wire [AD-3:0] mem_address;
    
    //Address Decoder to Reg File
    wire write_en_reg;
    wire read_en_reg;
    wire [1:0] reg_address;
    
    //Register File to BLE Chain
    wire enable_chain;
    wire tx_irq_en;
    wire rx_irq_en;
    wire rx_irq_clear;
    wire tx_irq_clear;
    wire dma_mode;
    wire mode;
    wire fifo_empty;
    wire w_done_flag;
    
    //BLE Chain to Reg File
    wire chain_clr_tx_irq;
    wire chain_clr_rx_irq;
    
    //TX Interface with INTERMEDIATE RAM
    wire tx_irq_pulse;
    wire valid_out_tx;
    wire [RE_IM_SIZE-1:0] data_out_tx_re;
    wire [RE_IM_SIZE-1:0] data_out_tx_im;
    wire [11:0] header_mapper_data_in_count;
    wire [11:0] payload_mapper_data_in_count;
    
    wire [15:0] payload_size;
    wire [15:0] header_size;
//============================================================================
// AHB Slave Bus Top 
(*DONT_TOUCH="yes"*)
AHB_Slave_ble AHB_Slave_inst (
    //AHB interface signals
    .HCLK(hclk), 
    .HRESETn(reset), 
    .HWRITE(hwrite), 
    .HSEL(hsel),
    .HADDR(haddress), 
    .HWDATA(hwdata),
    .HTRANS(htrans),
    .HBURST(), 
    .HSIZE(hsize),
    .HRDATA(hrdata),
    .HREADY(1'b1),
    .HRESP(hresp), 
    .HREADYOUT(hreadyout),
    //Address Decoder module interface signals 
    .address(haddress_ahb),
    .renable(renable), 
    .wenable(wenable),
    //Registed File and Bluetooth Chain interface signals
    .hwdata_ahb(hwdata_ahb),
    //Bluetooth Chain interface signals
    .hrdata_ahb(hrdata_ahb),
    .data_trans(htrans_ahb),
    .data_size(hsize_ahb), 
    .fifo_rd_pntr(fifo_rd_pntr),
    .fifo_empty(fifo_empty),
    .w_done_flag(w_done_flag),
    .mode(mode),
    //unused
    .burst_size()
    );
//============================================================================
// Bluetooth Top    
(* keep_hierarchy = "yes" *)   
tx_rx_bt_ble #(AD, DATA, MEM,RE_IM_AD, RE_IM_SIZE, RE_IM_MEM) tx_rx_bt_inst (
    .hclk(hclk),
    .clk_6945_KHz(clk_6945_KHz),
    .clk_3472_KHz(clk_3472_KHz),
    .reset(reset),
    .hsize(hsize_ahb),
    .htrans(htrans_ahb),
    .hwdata(hwdata_ahb),
    .hrdata(hrdata_ahb),
    .read_en_mem(read_en_mem),
    .write_en_mem(write_en_mem),
    .mem_address(mem_address),
    .tx_irq(tx_irq),
    .rx_irq(rx_irq),
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
    
    .valid_out_mem_re(valid_in_mem_re_ble),
    .data_out_tx_re_to_rx(data_in_re_to_rx_ble),
    .valid_out_mem_im(valid_in_mem_im_ble),
    .data_out_tx_im_to_rx(data_in_im_to_rx_ble),
    
    .payload_size(payload_size),
    .header_size(header_size),
    .tx_dma_done(tx_dma_done),
    .rx_dma_done(rx_dma_done)
    ); 
  //============================================================================
  //Added: 7/7/2024
    //Inermediate RAM real
    inter_ram_top_ble #(RE_IM_AD, RE_IM_SIZE, RE_IM_MEM) inter_ram_re (
            .clk(clk_3472_KHz),
            .reset(reset),
            
            .tx_finished(tx_irq_pulse),
            .data_in_count_header(header_mapper_data_in_count),
            .data_in_count_payload(payload_mapper_data_in_count),
            .tx_valid_out(valid_out_tx),
            .data_in(data_out_tx_re),
            
            .valid_out(valid_out_mem_re_ble),
            .data_out(data_out_re_to_rx_ble)
            );
        
    //============================================================================
    //Added: 7/7/2024
    // Inermediate RAM imag
    inter_ram_top_ble #(RE_IM_AD, RE_IM_SIZE, RE_IM_MEM) inter_ram_im (
        .clk(clk_3472_KHz),
        .reset(reset),
        
        .tx_finished(tx_irq_pulse),
        .data_in_count_header(header_mapper_data_in_count),
        .data_in_count_payload(payload_mapper_data_in_count),
        .tx_valid_out(valid_out_tx),
        .data_in(data_out_tx_im),
        
        .valid_out(valid_out_mem_im_ble),
        .data_out(data_out_im_to_rx_ble)    
        );
//============================================================================
//Address Decoder
(* keep_hierarchy = "yes" *)
address_decoder_ble #(AD,OFFSET) address_decoder_inst (
    .address(haddress_ahb),
    .wenable(wenable),
    .renable(renable),
    .memory_address(mem_address),
    .reg_address(reg_address),
    .read_en_mem(read_en_mem),
    .write_en_mem(write_en_mem),
    .read_en_reg(read_en_reg),
    .write_en_reg(write_en_reg)
    );    
//============================================================================
//Register File
Register_File_ble #(2, DEPTH, WIDTH) RegFile_inst (
    .clk(hclk), 
    .reset(reset), 
    .read_en(read_en_reg), 
    .write_en(write_en_reg), 
    .address(reg_address),
    .ahb_data_in(hwdata_ahb),
    .chain_clr_tx_irq(chain_clr_tx_irq),
    .chain_clr_rx_irq(chain_clr_rx_irq),
    .data_out(),
    .enable(enable_chain),
    .mode(mode),
    .dma_mode(dma_mode),
    .tx_irq_en(tx_irq_en), 
    .rx_irq_en(rx_irq_en),
    .tx_irq_clear(tx_irq_clear), 
    .rx_irq_clear(rx_irq_clear),
    
    .payload_size(payload_size),
    .header_size(header_size)
    );     
//============================================================================
endmodule
