//===========================================================
// Purpose: Generic package for data types
//===========================================================
package dct_pkg;
    //=======================================================
    parameter OUT_WIDTH = 16;
    //=======================================================
    typedef struct packed {
        logic signed [OUT_WIDTH*2:0] out_t_18;
        logic signed [OUT_WIDTH*2:0] out_t_50;
        logic signed [OUT_WIDTH*2:0] out_t_75;
        logic signed [OUT_WIDTH*2:0] out_t_89;
    } sau8_struct;
    //=======================================================
    typedef struct packed {
        logic signed [OUT_WIDTH*2:0] out_t_36;
        logic signed [OUT_WIDTH*2:0] out_t_83;
    } sau4_struct;
    //=======================================================
endpackage