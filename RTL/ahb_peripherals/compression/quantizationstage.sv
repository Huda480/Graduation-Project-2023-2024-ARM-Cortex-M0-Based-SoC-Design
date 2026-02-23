//===========================================================
// Purpose: Quantization cct
// Used in: MCM_2D_DCT
//===========================================================
module quantizationstage 
#(
    parameter WIDTH = 16,
	parameter DIM = 8
)
(
    //======================================================= 
    // Inputs
    //======================================================= 
    input  wire logic signed [WIDTH-1:0] out_val_clipped [DIM],
    //======================================================= 
    // Outputs   
    //======================================================= 
    output      logic signed [WIDTH-1:0] out_val_quantized [DIM]
);
    //=======================================================
    genvar i;
    generate 
        for(i = 0; i < DIM; i ++)
            quantize_func 
            #(
                .WIDTH(WIDTH)
            ) 
            f_dut 
            (
                out_val_clipped[i],
                out_val_quantized[i]
            );
    endgenerate
    //=======================================================
endmodule