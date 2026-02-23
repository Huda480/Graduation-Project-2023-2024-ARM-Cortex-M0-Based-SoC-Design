//===========================================================
// Purpose: Input Add unit for butterfly
// Used in: IntDCT
//===========================================================
module inputaddunit
#(
    parameter IN_WIDTH = 16,  
    parameter DIM = 8       
)
(
    //=======================================================
    // Inputs    
    //=======================================================
    input  wire logic signed [IN_WIDTH-1:0] in_val    [DIM], 
    //=======================================================        
    // Outputs
    //=======================================================    
    output      logic signed [  IN_WIDTH:0] out_val_a [DIM/2], 
    output      logic signed [IN_WIDTH-1:0] out_val_b [DIM/2]
);  
    //=======================================================
    // If DIM = 4
    // A[0] = X[0] + X[3] and S[0] = X[0] - X[3]
    // A[1] = X[1] + X[2] and S[1] = X[1] - X[2]
    //=======================================================
    always_comb begin
        for (int i = 0; i < (DIM/2); i ++) begin
            out_val_a[i] = in_val[i] + in_val[DIM-i-1];
            out_val_b[i] = in_val[i] - in_val[DIM-i-1];
        end
    end
    //=======================================================
endmodule