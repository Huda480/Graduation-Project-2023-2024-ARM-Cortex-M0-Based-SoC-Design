//===========================================================
// Purpose: 2D DCT Top Level
//===========================================================
module mcm_2d_dct import dct_pkg::*;
#(
    parameter IN_WIDTH = 8,
    parameter WIDTH = 16,
    parameter DIM = 8,
    parameter ADD_WIDTH = $clog2(DIM),
    parameter type SAUN_STRUCT = sau8_struct
)
(
    //=======================================================    
    // Controls
    //=======================================================
    input logic                    clk,
    input logic                    rst,
    input logic                    valid_in,
    //=======================================================
    // Inputs
    //=======================================================
    input  wire logic [IN_WIDTH-1:0] in_val [DIM],
    //=======================================================
    // Outputs
    //=======================================================
    output      logic signed [WIDTH-1:0] out_val_reg   [DIM],
    output      logic                    valid_out_reg,
    output      logic                    finish
);
    
    localparam CONCAT_WIDTH = WIDTH-IN_WIDTH;

    //=======================================================
    // Internals
    //=======================================================
    logic  signed [WIDTH-1:0] in_val_internal           [DIM];
    logic  signed [WIDTH*2:0] out_val_dct_internal      [DIM];
    logic  signed [WIDTH-1:0] out_val_clip_internal     [DIM];
    logic  signed [WIDTH-1:0] out_val_memTrans_internal [DIM];

    logic [ADD_WIDTH-1:0] add_tm;

    logic signed [WIDTH-1:0] out_val   [DIM];
    logic                    valid_out;

    //=======================================================
    // Multiplexing the output of transpose memory
    //=======================================================
    genvar n;
    generate
        for (n = 0; n < DIM; n ++)
            assign in_val_internal[n] = (valid_in)? $signed({{CONCAT_WIDTH{1'b0}},in_val[n]}):out_val_memTrans_internal[n];
    endgenerate

    //=======================================================
    // Registering outputs
    //=======================================================
    always_ff @ (posedge clk or negedge rst)
    begin
        if (!rst)
            begin
                foreach (out_val_reg[i]) begin
                    out_val_reg[i] <= 'b0;
                end
                valid_out_reg <= 1'b0;
            end
        else
            begin
                foreach (out_val_reg[i]) begin
                    out_val_reg[i] <= out_val[i];
                end
                valid_out_reg <= valid_out;
            end
    end

    //=======================================================
    // 1) Control Unit
    //=======================================================
    ctrlunit 
    #(
        .DIM(DIM)
    )
    cu 
    (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),  
        .valid_out(valid_out),
        .finish(finish), 
        .add_tm(add_tm)
    );
    //=======================================================
    // 2) Int DCT
    //=======================================================
    intdct 
    #(
        .IN_WIDTH(WIDTH),
        .OUT_WIDTH(WIDTH),
        .DIM(DIM),
        .SAUN_STRUCT(SAUN_STRUCT)
    ) 
    _1d_dct 
    (
        .in_val_a (in_val_internal),
        .out_val(out_val_dct_internal)
    );
    //=======================================================
    // 3) Clipping
    //=======================================================
    clipping 
    #(
        .WIDTH(WIDTH),
        .DIM(DIM)
    ) 
    cs
    (
        ._1st_2nd_stage_sel(valid_in),

        .out_val        (out_val_dct_internal),
        .out_val_clipped(out_val_clip_internal)
    );
    //=======================================================
    // 4) Quantization
    //=======================================================
    quantizationstage 
    #(
        .WIDTH(WIDTH),
        .DIM(DIM)
    ) 
    qs
    (
        .out_val_clipped  (out_val_clip_internal),
        .out_val_quantized(out_val)
    );
    //=======================================================
    // 5) Transpose Memory
    //=======================================================
    transpose_mem 
    #(
        .WIDTH(WIDTH),
        .DIM(DIM)
    ) 
    tm 
    (
        .clk              (clk),
        .rst              (rst),
        .wr               (valid_in),
        .add_in           (add_tm),

        .out_val_quantized(out_val_clip_internal),
        .out_val_2d_dct   (out_val_memTrans_internal)
    );
    //=======================================================
endmodule