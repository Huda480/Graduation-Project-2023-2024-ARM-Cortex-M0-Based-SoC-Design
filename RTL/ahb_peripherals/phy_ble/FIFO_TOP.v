module FIFO_TOP_ble #(parameter AD = 8, DATA = 32)
    (
    
    /////////////////
    // Input Ports //
    /////////////////
        input  wire 			 W_CLK,
        input  wire 			 R_CLK,
        input  wire 			 W_rst_n,
        input  wire 			 R_rst_n,
        input  wire 			 W_inc,
        input  wire 			 R_inc,
        input  wire [DATA-1:0]   W_Data,
        input wire  [AD-1:0]     fifo_address,
        input wire               mode,
        input wire               tx_irq,
        input wire  [16:0]       data_size,
    //////////////////
    // Output Ports //
    //////////////////
        output wire                      Full,
        output wire                      Empty,
        output wire [DATA-1:0]           R_Data,
        output wire [AD-1:0]             r_addr_fifo,
        output reg                       w_done_flag
    );

//-----------------
// Internal Wires
//-----------------
	wire [AD-1:0]  W_Addr,R_Addr;
	wire [AD-1:0]  w_addr_fifo;
	wire [AD:0]    W_ptr, R_ptr, Wq2_rptr, Rq2_wptr;
	
    wire [16:0] W_Addr_bits;
    wire Empty_Value;
	
	assign W_Addr_bits = W_Addr<<5;

//---------------------------------------------------------------
// 		Internal Modules Connections
//---------------------------------------------------------------

///////////////////////////////
//     1. Write Pointer	     //
///////////////////////////////

FIFO_Write_Pointer_ble #(AD) FIFO_Write_Pointer_F1(

	.W_CLK(W_CLK), 
	.W_rst_n(W_rst_n),
	.W_inc(W_inc),
	.Wq2_rptr(Wq2_rptr),						 
	.tx_irq(tx_irq),
	.FULL_VALUE(Full),
	.W_ptr(W_ptr),								
	.W_Addr(W_Addr),
	.data_size(data_size),
	.W_Addr_bits(W_Addr_bits)
);

assign w_addr_fifo = mode ? fifo_address : W_Addr;

///////////////////////////////
//	2. Read Pointer      //
///////////////////////////////

FIFO_R_Pointer_ble #(AD) FIFO_R_Pointer_F2(

	.R_CLK(R_CLK),
	.R_rst_n(R_rst_n),
	.R_inc(R_inc),
	.Rq2_wptr(Rq2_wptr),
	.tx_irq(tx_irq),
	.R_empty(Empty),
	.Empty_Value(Empty_Value),
	.R_ptr(R_ptr),
	.R_Addr(R_Addr),
	.data_size(data_size)
);

assign r_addr_fifo = mode ? R_Addr : fifo_address ;

//////////////////////////////////////////////////////////////
always @(posedge W_CLK or negedge R_rst_n) begin

    if (~R_rst_n) begin
        w_done_flag <= 0;
    end
    else begin
        if (W_Addr_bits >= data_size) begin
            w_done_flag <= 1;
        end
        else if (Empty_Value) begin
            w_done_flag <= 0;
        end
    end

end
//////////////////////////////////////////////////////////////


///////////////////////////////
// 	3. FIFO Memory       //
///////////////////////////////

ASYNC_FIFO_RAM_ble #(AD,DATA)  ASYNC_FIFO_RAM_F3(

	.W_CLK(W_CLK),
	.R_CLK(R_CLK),					
	.W_CLK_en(W_inc & ~Full),
	.R_CLK_en(R_inc),				
	.W_Data(W_Data),				
	.W_Addr(w_addr_fifo),				
	.R_Addr(r_addr_fifo),
	.R_Data(R_Data)					

);

//////////////////////////////////////////////////////////////
//        4. Read Pointer Synchronizer to Write Clk         //
//////////////////////////////////////////////////////////////
Sync_R2W_ble #(AD) Sync_R2W_F4(

	.W_CLK(W_CLK),					
	.W_rst_n(W_rst_n),				
	.R_ptr(R_ptr),					
	
	.Wq2_rptr(Wq2_rptr)				

);


//////////////////////////////////////////////////////////////
//        4. Write Pointer Synchronizer to Read Clk         //
//////////////////////////////////////////////////////////////

Sync_W2R_ble #(AD) Sync_W2R_F5(
 
	.R_CLK(R_CLK),					
	.R_rst_n(R_rst_n),				
	.W_ptr(W_ptr),					
	
	.Rq2_wptr(Rq2_wptr)				
	
);

endmodule
