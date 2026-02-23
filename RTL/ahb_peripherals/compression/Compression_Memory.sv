module Compression_Memory 
#(
    parameter int   MEM_COMP_DEPTH = 3584,
    parameter int   AHB_WIDTH = 32
) 
(
    //=======================================================
	// Controls
	//=======================================================
    input wire logic                    HCLK,
    input wire logic                    HRESETn,
    input wire logic                    clk,
    input wire logic                    rst,
    //=======================================================
	// Compression Inputs 
	//=======================================================
    input wire logic [AHB_WIDTH-1:0]    data_in,
    input wire logic                    wr_en,
	//=======================================================
    // AHB Outputs
	//=======================================================
    output logic [31:0]                 rdata,
	//=======================================================
    // AHB Inputs
	//=======================================================
    input wire logic [31:0]             address,
    input wire logic                    rd_en,
	//=======================================================
    // Interrupts
	//=======================================================    
    output reg                          full,
    output reg                          received_image
	//=======================================================      
);
    //=======================================================
    // Internals
	//=======================================================
    localparam int PTR_WIDTH = $ceil($clog2(MEM_COMP_DEPTH));

    logic [AHB_WIDTH-1:0] mem [MEM_COMP_DEPTH];

    logic [PTR_WIDTH:0] wr_ptr, rd_ptr;
    logic [PTR_WIDTH:0] gray_wr_ptr, gray_rd_ptr;
    logic  empty;

    logic [11:0] image_counter;

    initial 
    begin
        foreach (mem[i]) 
        begin
            mem[i] = 0;
        end   
    end

    always @(posedge clk)
    begin
        if (wr_en && ~full) 
        begin
            mem[wr_ptr]   <= data_in;
        end
    end

    always_ff @(posedge clk or negedge rst)
    begin
        if (!rst) 
        begin
            image_counter <= 0;
            received_image <= 1'b0;
        end
        else 
        begin
            if (wr_en && ~full) 
            begin
                if (image_counter == 12'd3584) 
                begin
                    image_counter <= 0;
                    received_image <= 1'b1;
                end
                else
                begin
                    image_counter <= image_counter + 1'b1;
                    received_image <= 1'b0;
                end
            end
        end
    end

    always_ff @(posedge clk or negedge rst)
    begin
        if (!rst) 
        begin
            wr_ptr <= 0;
        end
        else begin
            if (wr_en && ~full)
            begin
                if (wr_ptr[PTR_WIDTH-1:0] == MEM_COMP_DEPTH-1) 
                begin
                    wr_ptr[PTR_WIDTH] <= ~wr_ptr[PTR_WIDTH];
                    wr_ptr[PTR_WIDTH-1:0] <= 0;
                end
                else 
                begin
                    wr_ptr <= wr_ptr + 3'd1;
                end
            end     
        end         
    end

    always_ff @(posedge HCLK or negedge HRESETn)
    begin
        if (!HRESETn) 
        begin
            rd_ptr <= 0;
        end
        else 
        begin
            if (rd_en && ~empty) 
            begin
                if (rd_ptr[PTR_WIDTH-1:0] == MEM_COMP_DEPTH-1) 
                begin
                    rd_ptr[PTR_WIDTH] <= ~rd_ptr[PTR_WIDTH];
                    rd_ptr[PTR_WIDTH-1:0] <= 0;
                end
                else 
                begin
                    rd_ptr <= rd_ptr + 1'b1;  
                end  
            end     
        end         
    end

    always_comb
    begin
        if (gray_wr_ptr [PTR_WIDTH]     != gray_rd_ptr[PTR_WIDTH]   &&
            gray_wr_ptr [PTR_WIDTH-1]   != gray_rd_ptr[PTR_WIDTH-1] &&
            gray_wr_ptr [PTR_WIDTH-2:0] == gray_rd_ptr[PTR_WIDTH-2:0])
            
            full = 1'b1;
        else
            full = 1'b0;
    end

    always_comb
    begin
        if (gray_wr_ptr == gray_rd_ptr)
            empty = 1'b1;
        else
            empty = 1'b0;
    end

    assign gray_wr_ptr = wr_ptr ^ (wr_ptr >> 1);
    assign gray_rd_ptr = rd_ptr ^ (rd_ptr >> 1);

    assign rdata = rd_en ? mem[address] : 32'b0;

endmodule