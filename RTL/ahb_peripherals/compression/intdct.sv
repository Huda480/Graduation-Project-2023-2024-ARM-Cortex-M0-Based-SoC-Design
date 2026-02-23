//===========================================================
// Purpose: Top level for Int DCT
// Used in: MCM_2D_DCT
//===========================================================
module intdct import dct_pkg::*;
#(
    parameter IN_WIDTH = 16,
    parameter OUT_WIDTH = 16,
    parameter DIM = 8,
    parameter type SAUN_STRUCT = sau8_struct
)
(
    //=======================================================
    // Inputs
    //=======================================================
    input  wire logic  signed [ IN_WIDTH-1:0] in_val_a [DIM],
    //=======================================================
    // Outputs
    //=======================================================
    output      logic  signed [OUT_WIDTH*2:0] out_val  [DIM]
);
    logic signed [   IN_WIDTH:0] internal_out_val_a    [DIM/2];
    logic signed [ IN_WIDTH-1:0] internal_out_val_b    [DIM/2];
    logic signed [OUT_WIDTH*2:0] internal_out_val_even [DIM/2];
    logic signed [OUT_WIDTH*2:0] internal_out_val_odd  [DIM/2];

    SAUN_STRUCT internal_t [DIM/2];
    //=======================================================
    // IAU
    //=======================================================
    inputaddunit 
    #(
        .IN_WIDTH(IN_WIDTH),
        .DIM(DIM)
    )
    iauN_0 
    (
        .in_val    (in_val_a),
        .out_val_a (internal_out_val_a),
        .out_val_b (internal_out_val_b)
    );
    //=======================================================
    // Even Part
     // Y[0], Y[2], Y[4], ... etc
    //=======================================================
    generate 
        //===================================================
        // 4x4 DCT
        // Shift by 6
        //===================================================
        if (DIM == 4)
        begin
            logic signed [OUT_WIDTH*2:0] internal_a [DIM/2];
            //===============================================
            // 2x2 DCT
            //===============================================
            genvar j;
            for (j = 0; j < (DIM/2); j ++)
            begin
                assign internal_a[j] = internal_out_val_a[j] << 6;
            end
            assign internal_out_val_even[0] = internal_a[0] + internal_a[1];
            assign internal_out_val_even[1] = internal_a[0] - internal_a[1];
            //===============================================
        end
        //===================================================
        // 8x8 DCT
        // N/2 Int DCT
        //===================================================
        else if (DIM == 8)
        begin
            //===============================================
            intdct
            #(
                .IN_WIDTH(IN_WIDTH+1),
                .OUT_WIDTH(OUT_WIDTH),
                .DIM(DIM/2),
                .SAUN_STRUCT(sau4_struct)
            )
            intdct4_0 
            (
                .in_val_a(internal_out_val_a),
                .out_val (internal_out_val_even)
            );
            //===============================================
        end
        //===================================================
    endgenerate
    //=======================================================
    // Odd part
    // Y[1] , Y[3], Y[5], ... etc
    // SAU
    //=======================================================
    genvar i;
    generate
        for (i = 0; i < DIM/2; i ++)
        begin
            shiftaddunit 
            #(
                .IN_WIDTH(IN_WIDTH),
                .OUT_WIDTH(OUT_WIDTH),
                .DIM(DIM),
                .SAUN_STRUCT(SAUN_STRUCT)
            ) 
            sadN_i 
            (
                .in_val(internal_out_val_b[i]),
                .out_t(internal_t[i])
            );
        end
    endgenerate
    //=======================================================
    // OAU
    // Odd part
    // Y[1] , Y[3], Y[5], ... etc    
    //=======================================================
    outputaddunit 
    #(
        .OUT_WIDTH(OUT_WIDTH),
        .DIM(DIM),
        .SAUN_STRUCT(SAUN_STRUCT)
    )
    oauN_0 
    (
        .in_val (internal_t),
        .out_val(internal_out_val_odd)
    );
    //=======================================================
    // Concatenate the even part with the odd part
    //=======================================================
    genvar k;
    generate
        for (k = 0; k < (DIM/2); k ++) begin
            assign out_val[  2*k] = internal_out_val_even[k];
            assign out_val[2*k+1] = internal_out_val_odd [k];
        end
    endgenerate
    //=======================================================
endmodule