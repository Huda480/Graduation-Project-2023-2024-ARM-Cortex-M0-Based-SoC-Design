//////////////////////////////////////////////////////////////////////////////////
// Create Date: 07/01/2024
// Design Name: AHB and BLE chain "Shared Memory"
// Module Name: shared_mem_top
//////////////////////////////////////////////////////////////////////////////////

module shared_mem_top_ble #(parameter AD=8, DATA=32, MEM=256 )(
    mode,
    reset,
    data_size,
    //================== AHB Interface ==================
    hclk,
    fifo_address,
    fifo_write_en,
    fifo_read_en,
    fifo_input_from_slicer,
    fifo_out_to_slicer,
    //================== BLE Interface ==================
    //---------------- BLE TX ----------------
    clk_read,
    re,
    //output from chain input to the FIFO
    tx_irq,
    // ***** from FIFO to serializer ***** 
    // input data to chain output from FIFO
    data_out,
    //---------------- BLE RX ----------------
    clk_write,
    //valid_out header | payload
    we,
    // output data from chain input to FIFO
    data_in,
    //================== FIFO signals ==================
    fifo_full,
    fifo_empty,
    fifo_rd_pntr,
    w_done_flag
    );
    input reset;
    //mode = 1 -> ahb write or ahb read
    //mode = 0 -> tx read or rx write
    input mode;
    
    input [16:0] data_size;
    //================== AHB Interface ==================
    input hclk;
    //input [2:0] hsize;
    //input [1:0] htrans;
    input [AD-1:0] fifo_address;
    input fifo_write_en;
    input fifo_read_en;
    input [DATA-1:0] fifo_input_from_slicer;
    output [DATA-1:0] fifo_out_to_slicer;
    //================== BLE Interface ==================
    //---------------- BLE TX ----------------
    input clk_read;
    input re;
    // ***** from FIFO to serializer ***** 
    // input data to chain output from FIFO
    output [DATA-1:0] data_out;
    //---------------- BLE RX ----------------
    input clk_write;
    //output from chain input to the FIFO
    input tx_irq;
    //valid_out header | payload
    input we;
    // output data from chain input to FIFO
    input [DATA-1:0] data_in;
    //================== FIFO signals ==================
    output fifo_full;
    output fifo_empty;
    output [AD-1:0] fifo_rd_pntr;
    output w_done_flag;
    //============================================================================
    wire W_clk;
    wire R_clk;   
    wire w_en;
    wire r_en;
    wire re_ram_signal;
    wire [DATA-1:0] data_in_fifo;
    wire [DATA-1:0] data_out_fifo;
    //============================================================================
    //asynchrounous fifo
	//============================================================================
    FIFO_TOP_ble #(AD,DATA) async_fifo_top
    (
        .mode(mode),
        .data_size(data_size),
        .W_CLK(W_clk),
        .R_CLK(R_clk),
        .W_rst_n(reset),
        .R_rst_n(reset),
        .W_inc(w_en),
        .R_inc(r_en),
        .W_Data(data_in_fifo),
        .fifo_address(fifo_address),
        .tx_irq(tx_irq),
        .Full(fifo_full),
        .Empty(fifo_empty),
        .R_Data(data_out_fifo),
        .r_addr_fifo(fifo_rd_pntr),
        .w_done_flag(w_done_flag)
    );
    //============================================================================
    assign w_en = mode ? fifo_write_en : we;
    assign data_in_fifo = mode ? fifo_input_from_slicer  : data_in;
    assign r_en = mode ? re : fifo_read_en;
    //when mode = 1 -> data_out = data_out_fifo
    //when mode = 0 -> hrdata = data_out_fifo
    assign {fifo_out_to_slicer,data_out} = mode ? {DATA-1'd0,data_out_fifo}: {data_out_fifo,DATA-1'd0};
    
    clock_mux_ble clk_w (
        .clk({clk_write,hclk}),
        .clk_select({!mode,mode}),
        .clk_out(W_clk)
 	  );

 clock_mux_ble clk_r (
        .clk({clk_read,hclk}),
        .clk_select({mode,!mode}),
        .clk_out(R_clk)
 	  );
 	 //============================================================================
endmodule
