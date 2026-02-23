//===========================================================
// Purpose: Top level control unit
// Used in: MCM_2D_DCT
//===========================================================
(* dont_touch = "true" *)module ctrlunit
#(
    parameter DIM = 8,
    parameter ADD_WIDTH = $clog2(DIM)
)
(
    //======================================================= 
    // Controls
    //======================================================= 
    input  logic                 clk       ,   
    input  logic                 rst       ,
    input  logic                 valid_in  ,
    //======================================================= 
    // Outputs
    //======================================================= 
    output logic                 valid_out ,
    output logic                 finish,
    output logic [ADD_WIDTH-1:0] add_tm
);
    //======================================================= 
    // Internals
    //======================================================= 
    logic [ADD_WIDTH-1:0] counter;

    logic internal_valid_in;
    //======================================================= 
    always_comb 
    begin
        add_tm     = counter ;
        valid_out  = internal_valid_in && !(valid_in); 
        finish     = ((counter == (DIM-1)) & valid_out)? 1'b1:1'b0;
    end
    //======================================================= 
    // TODO: check FPGA translation
    //======================================================= 
    always_ff @(posedge clk or negedge rst) 
    begin
        //===================================================
        // Reset
        //===================================================
        if (!rst) 
        begin
            internal_valid_in <= 0;
        end 
        //===================================================
        // Valid
        //===================================================
        else 
        begin
            if ((counter == (DIM-1)) && !(valid_in)) 
            begin
                internal_valid_in <= 0;
            end
            else if (valid_in) 
            begin
                internal_valid_in <= 1;
            end
        end
        //===================================================
    end
    //======================================================= 
    // Counter
    // TODO: check FPGA translation
    //======================================================= 
    always_ff @(posedge clk or negedge rst) 
    begin
        //===================================================
        // Reset
        //===================================================
        if (!rst) 
        begin
            counter <= 0;
        end
        //===================================================
        // Count
        //===================================================
        else
        begin 
            if (internal_valid_in || valid_in) 
            begin
                counter <= counter + 1;
            end
        end
        //===================================================
    end
    //======================================================= 
endmodule