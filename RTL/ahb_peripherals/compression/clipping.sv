//===========================================================
// Purpose: Clipping cct
// Used in: MCM_2D_DCT
//===========================================================
module clipping
#(
    parameter WIDTH = 16,   
    parameter DIM = 8      
)
(
    //=======================================================    
    // Controls
    //=======================================================
    input  logic                    _1st_2nd_stage_sel       ,
    //=======================================================
    // Inputs
    //=======================================================
    input  wire logic signed [WIDTH*2:0] out_val             [DIM], 
    //=======================================================
    // Outputs
    //=======================================================
    output      logic signed [WIDTH-1:0] out_val_clipped     [DIM]
);
    //=======================================================
    // Local parameters
    //=======================================================
    localparam N        = 8;
    localparam B        = 8;
    localparam M        = $clog2(N);
    localparam OFFSET_1 = 2**(M+B-10);
    localparam OFFSET_2 = 2**(M+5);
    localparam SHIFT_1  = (M+B-9);
    localparam SHIFT_2  = (M+6);
    //=======================================================
    // Clipping mechanism
    //=======================================================
    genvar i;
    generate
        for (i = 0; i < DIM; i ++) begin : clipping_loop
            assign out_val_clipped[i] = (_1st_2nd_stage_sel)? (out_val[i] + OFFSET_1) >>> SHIFT_1:(out_val[i] + OFFSET_2) >>> SHIFT_2;
        end
    endgenerate
    //=======================================================
endmodule

