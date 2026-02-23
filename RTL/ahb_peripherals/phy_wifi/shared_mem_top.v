module  shared_mem_top #(parameter ADDR_FIFO=8, DATA_WIDTH=32, DEPTH_FIFO=1024 ) (
	mode,
    reset,
    //================== AHB Interface ==================
    hclk,
    fifo_address,
    fifo_write_en,
    fifo_read_en,
    fifo_input_from_slicer,
    fifo_out_to_slicer,
	//================== WIFI Interface ==================
    //---------------- WIFI TX ----------------
    clk_read,
    re,
    //output from chain input to the FIFO
    tx_irq,
    // ***** from FIFO to serializer ***** 
    // input data to chain output from FIFO
    data_out,
	//---------------- WIFI RX ----------------
    clk_write,
    we,
    // output data from chain input to FIFO
    data_in,
	//================== FIFO signals ==================
    fifo_full,
    fifo_empty,
    R_Data_ahb,
    //================== DATA SIZE REGISTER ==================
    data_size
);

input 					reset;
input 					mode;
//================== AHB Interface ==================
input 					hclk;
input [ADDR_FIFO-1:0] 	fifo_address;
input 					fifo_write_en;
input 					fifo_read_en;
input [DATA_WIDTH-1:0] 	fifo_input_from_slicer;
output[DATA_WIDTH-1:0] 	fifo_out_to_slicer;
output[DATA_WIDTH-1:0] 	R_Data_ahb;

//================== WIFI Interface ==================
//---------------- WIFI TX ----------------
input 					clk_read;
input 					re;
// ***** from FIFO to serializer ***** 
// input data to chain output from FIFO
output [DATA_WIDTH-1:0] data_out;
//---------------- WIFI RX ----------------
input 					clk_write;
//output from chain input to the FIFO
input 					tx_irq;
input 					we;
// output data from chain input to FIFO
input [DATA_WIDTH-1:0] 	data_in;
//================== FIFO signals ==================
output 					fifo_full;
output 					fifo_empty;

//================== DATA SIZE REGISTER ==================
input [DATA_WIDTH-1:0]  data_size;
//============================================================================
wire 					W_clk;
wire 					R_clk;   
wire 					w_en;
wire 					r_en;
wire 					re_ram_signal;
wire [DATA_WIDTH-1:0] 	data_in_fifo;
wire [DATA_WIDTH-1:0] 	data_out_fifo;




//============================================================================
//asynchrounous fifo
//============================================================================
FIFO_TOP_WIFI #(ADDR_FIFO, DATA_WIDTH, DEPTH_FIFO) async_fifo_top
(
    .mode(mode),
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
    .R_Data_ahb(R_Data_ahb),
    .data_size(data_size)
);
//============================================================================
assign w_en = mode ? fifo_write_en : we;
assign data_in_fifo = mode ? fifo_input_from_slicer  : data_in;
assign r_en = mode ? re : fifo_read_en;
//when mode = 1 -> data_out = data_out_fifo
//when mode = 0 -> hrdata = data_out_fifo
assign {fifo_out_to_slicer,data_out} = mode ? {DATA_WIDTH-1'd0,data_out_fifo}: {data_out_fifo,DATA_WIDTH-1'd0};

clock_mux clk_w (
    .clk({clk_write,hclk}),
    .clk_select({!mode,mode}),
    .clk_out(W_clk)
);
//============================================================================
clock_mux clk_r (
    .clk({clk_read,hclk}),
    .clk_select({mode,!mode}),
    .clk_out(R_clk)
);
endmodule