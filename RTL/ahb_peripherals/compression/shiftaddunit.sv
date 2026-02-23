//===========================================================
// Purpose: Shift unit for butterfly
// Used in: IntDCT
//===========================================================
module shiftaddunit import dct_pkg::*;
#(
    parameter IN_WIDTH = 16,
    parameter OUT_WIDTH = 16,
    parameter DIM = 8,
    parameter type SAUN_STRUCT = sau8_struct
)
(
    //========================================================
    // Inputs 
    //========================================================
    input  wire logic signed [IN_WIDTH-1:0] in_val,
    //========================================================
    // Outputs
    //========================================================
    output SAUN_STRUCT                 out_t 
);
    //======================================================== 
    // Internals
    //========================================================     
    logic signed [OUT_WIDTH*2:0] internal_m_9;
    //========================================================     
    // SAU
    //========================================================     
    generate
        //====================================================
        // 4x4 SAU
        // T0_38[0] = (((S[0] << 3) + S[0]) << 1) + (S[0] << 6)
        // T0_36[0] = ((((S[0] << 3) + S[0]) << 1) << 1)        
        //====================================================
        if (DIM == 4)
        begin
            assign internal_m_9 = (in_val << 3) + in_val;
            assign out_t.out_t_36 = (internal_m_9 << 2);
            assign out_t.out_t_83 = (internal_m_9 << 1) + (in_val << 6) + in_val;
        end
        //====================================================
        // 8x8 SAU
        // T0_18[0] = (((S[0] << 3) + S[0]) << 1)
        // T0_50[0] = (((S[0] << 4) + T0_18[0]) << 1) 
        // T0_75[0] = (((S[0] << 6) + ((S[0] << 4) + T0_18[0])) + T0_50[0])
        // T0_89[0] = (((S[0] << 6) + ((S[0] << 4) + T0_18[0]))
        //====================================================
        else if (DIM == 8)
        begin
            logic signed [OUT_WIDTH*2:0] internal_m_25;

            assign internal_m_9 = (in_val << 3) + in_val;
            assign internal_m_25  = (in_val << 4) + internal_m_9; 

            assign out_t.out_t_18 = (internal_m_9 << 1);
            assign out_t.out_t_50 = (internal_m_25 << 1);
            assign out_t.out_t_75 = internal_m_25 + (internal_m_25 << 1);
            assign out_t.out_t_89 = internal_m_25 + (in_val << 6);
        end
        //====================================================
    endgenerate
    //========================================================
endmodule
