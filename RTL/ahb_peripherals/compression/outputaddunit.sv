//===========================================================
// Purpose: Output add unit for butterfly
// Used in: IntDCT
//===========================================================
module outputaddunit import dct_pkg::*;
#(
    parameter OUT_WIDTH = 16,  
    parameter DIM = 8,
    parameter type SAUN_STRUCT = sau8_struct   
)
(
    //========================================================
    // Inputs
    //========================================================
    input  SAUN_STRUCT                  in_val  [DIM/2],  
    //========================================================
    // Outputs
    //========================================================
    output logic signed [OUT_WIDTH*2:0] out_val [DIM/2]  
);
    //========================================================
    // OAU
    //========================================================
    generate 
        //====================================================
        // 4x4 OAU
        //====================================================
        if (DIM == 4)
        begin
            assign out_val[0] = in_val[0].out_t_83 + in_val[1].out_t_36;
            assign out_val[1] = in_val[0].out_t_36 - in_val[1].out_t_83;
        end
        //====================================================
        // 8x8 OAU
        //====================================================
        else if (DIM == 8)
        begin
            assign out_val[0] = in_val[0].out_t_89 + in_val[1].out_t_75 + in_val[2].out_t_50 + in_val[3].out_t_18;
            assign out_val[1] = in_val[0].out_t_75 - in_val[1].out_t_18 - in_val[2].out_t_89 - in_val[3].out_t_50;
            assign out_val[2] = in_val[0].out_t_50 - in_val[1].out_t_89 + in_val[2].out_t_18 + in_val[3].out_t_75;
            assign out_val[3] = in_val[0].out_t_18 - in_val[1].out_t_50 + in_val[2].out_t_75 - in_val[3].out_t_89;
        end
        //====================================================
    endgenerate
    //========================================================
endmodule
