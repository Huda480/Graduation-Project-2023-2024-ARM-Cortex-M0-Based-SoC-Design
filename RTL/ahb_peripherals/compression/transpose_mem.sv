//===========================================================
// Purpose:
// Used in: MCM_2D_DCT
//===========================================================
module transpose_mem
#(
    parameter WIDTH = 16,            
    parameter DIM = 8,                 
    parameter ADD_WIDTH = $clog2(DIM)            
)
(
    //=======================================================
    // Clock & Reset
    //=======================================================
    input  logic                        clk                    ,               
    input  logic                        rst                    ,
    //=======================================================
    // Control
    //=======================================================    
    input  logic                        wr                     ,
    //=======================================================  
    // Memory input (Quantization output)
    //=======================================================                      
    input       logic        [ADD_WIDTH-1:0] add_in                 ,            
    input  wire logic signed [    WIDTH-1:0] out_val_quantized [DIM],  
    output      logic signed [    WIDTH-1:0] out_val_2d_dct    [DIM]     
);
    //=======================================================
    // Transpose memory 8x8 each 8 bits
    //=======================================================
    logic signed [WIDTH-1:0] trans_mem [DIM][DIM];
    //=======================================================
    // Transpose memory initialization
    // TODO: Check FPGA translation
    //=======================================================        
    always_ff @(posedge clk or negedge rst) begin
        //===================================================
        // Reseting the memory
        // TODO: Check if reset is needed
        //===================================================
        if (!rst) 
        begin
            foreach(trans_mem[i,j])
                trans_mem[i][j] = '0;
        end 
        //===================================================
        // Writing in the memory
        //===================================================
        else if (wr) 
        begin
            for (int i = 0; i < DIM; i ++) begin
                trans_mem[add_in][i] = out_val_quantized[i];
            end
        end
        //===================================================
    end
    //=======================================================
    // Multiplexing the output
    //=======================================================    
    genvar row;
    generate
        for (row = 0; row < DIM; row ++) begin : mux_gen
            muxN #(
                .WIDTH(WIDTH),
                .DIM(DIM)
            ) mux_instance (
                .sel_in(add_in),
                .in(trans_mem[row]),
                .mux_out(out_val_2d_dct[row])
            );
        end
    endgenerate
    //=======================================================
endmodule
