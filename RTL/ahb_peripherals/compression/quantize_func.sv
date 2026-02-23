//===========================================================
// Purpose: Quantization cct function
// Used in: QuantizationStage
//===========================================================
module quantize_func 
#(
    parameter QP = 34,
    parameter WIDTH = 16
)
(
    //======================================================= 
    // Inputs
    //======================================================= 
    input  logic signed [WIDTH-1:0] in,
    //======================================================= 
    // Outputs
    //======================================================= 
    output logic signed [WIDTH-1:0] out
);
    //=======================================================
    // Local parameters
    //=======================================================
    localparam N         = 8;
    localparam B         = 8;
    localparam M         = $clog2(N);
    localparam F_INDEX   = (QP % 6);
    localparam int SHIFT = (29-M-B+$ceil(QP/6)+1);
    //=======================================================
    // Internals
    //=======================================================
    logic signed [2*WIDTH+2:0] internal_out;
    logic signed [2*WIDTH+2-SHIFT-1:0] add_bit;
    logic signed [2*WIDTH+2-SHIFT-1:0] internal_out_shift;
    //=======================================================
    // Value range calculation
    //=======================================================
    always_comb begin
        case(F_INDEX)
        0: internal_out = (in << 15) - (in << 12) - (in << 11) - (in << 9) + (in << 6) + (in << 5) + (in << 2) + (in >>> 1);
        1: internal_out = (in << 15) - (in << 13) - (in << 10) - (in << 8) + (in << 2) + (in >>> 1);
        2: internal_out = (in << 14) + (in << 12) + (in << 6 ) + (in << 4);
        3: internal_out = (in << 14) + (in << 11) - (in << 5 ) - (in << 2);
        4: internal_out = (in << 14);
        5: internal_out = (in << 14) - (in << 11) + (in << 7) + (in << 6) + (in << 5) + (in << 2);
        default: internal_out = 0;
        endcase
    end
    //=======================================================
    // Quantization step
    //=======================================================
    always_comb begin
        add_bit = (internal_out[2*WIDTH+2])? internal_out[SHIFT-1]&(|internal_out[SHIFT-2:0]):internal_out[SHIFT-1];
        internal_out_shift = internal_out >>> SHIFT;
        out = internal_out_shift + add_bit;
    end
    //=======================================================
endmodule