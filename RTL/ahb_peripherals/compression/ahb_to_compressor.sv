//==========================================================================================
// Purpose: Compressor AHB Top Module
// Used in: SYSTEM_TOP
//==========================================================================================
//
// Overview
// ========
//
// 
// 
//==========================================================================================
// Register File
//==========================================================================================
  // -------------------------------------------------------------------
  // Register name      |      Address      |  P |  Reset Value | Size |
  // -------------------------------------------------------------------
  // 1) CTRL            |   Base + 0x000    | RW |  0x0000_0000 |  1   |
  // 2) INTENABLE       |   Base + 0x004    | WO |  0x0000_0000 |  2   |
  // 3) INTSTATUS       |   Base + 0x008    | RO |  0x0000_0000 |  2   |
  // 4) INTCLEAR        |   Base + 0x008    | WO |  0x0000_0000 |  2   |
  // -------------------------------------------------------------------
//==========================================================================================
// Module declaration
//==========================================================================================
module ahb_to_compressor import ahb_pkg::*;
#(
    parameter int OUT_WIDTH         = 16,
    parameter int IN_WIDTH          = 8,   
    parameter int DIM               = 8,     
    parameter int MEM_UNCOMP_DEPTH  = 8192,
    parameter int MEM_COMP_DEPTH    = 2560,
    parameter int AHB_WIDTH         = 32,
    parameter int REGFILE_DEPTH     = 4,
    parameter     IMG1 = "image1.txt"  ,
    parameter     IMG2 = "image2.txt"  ,
    parameter     IMG3 = "image3.txt"  ,
    parameter     IMG4 = "image4.txt"  ,
    parameter     IMG5 = "image5.txt"  ,
    parameter     IMG6 = "image6.txt"  ,
    parameter     IMG7 = "image7.txt"  ,
    parameter     IMG8 = "image8.txt" 
) 
(
    //=======================================================
	// Controls
	//=======================================================
    input wire logic            clk,
    input wire logic            rst,
	//=======================================================
    // AHB signals
    //=======================================================
    input  wire logic           HCLK,      // AHB bus clock
    input  wire logic           HRESETn,   // AHB bus reset
    input  wire logic           HSEL,      // AHB peripheral select
    input  wire logic           HREADY,    // AHB ready input
    input  wire logic  [1:0]    HTRANS,    // AHB transfer type
    input  wire logic  [2:0]    HSIZE,     // AHB hsize
    input  wire logic           HWRITE,    // AHB hwrite
    input  wire logic [31:0]    HADDR,     // AHB address bus
    input  wire logic [31:0]    HWDATA,    // AHB write data bus
    output reg                  HREADYOUT, // AHB ready output to S->M mux
    output reg                  HRESP,     // AHB response
    output wire   [31:0]        HRDATA,    // AHB read data bus
	//=======================================================
    // Interrupts
    //=======================================================
    output wire                 received_image_int,
    output wire                 full_int
);
	//=======================================================
	// Local Parameters
	//=======================================================
    localparam int OFFSET = REGFILE_DEPTH << 2;
    localparam int CTRL      = 'h0;
    localparam int INTENABLE = 'h4;
    localparam int INTSTATUS = 'h8;
    //=======================================================
    // Internals
	//=======================================================
    reg hsel_reg;
    reg [AHB_WIDTH-1:0]  haddr_reg;
    reg         hwrite_reg;
    reg [2:0]   hsize_reg;

    wire   [31:0] hrdata_mem;
    reg    [31:0] hrdata_regfile;
    
    wire rd_en_mem;
    wire rd_en_reg;
    wire wr_en_mem;
    wire wr_en_reg;

    wire [AHB_WIDTH-1:0] wr_data;

    wire isMemory;
    wire full, received_image;
    logic [1:0] interrupt_status_reg;
    logic [1:0] interrupt_clear_reg;
    logic [1:0] interrupt_enable_reg;
    logic control_reg;

    states_t current_state, next_state;
    logic reserved_read_address, reserved_address, error_signal;

	//=======================================================
    // Read & Write enables for reg file and memory
    //=======================================================
    assign rd_en_mem = hsel_reg && ~hwrite_reg && isMemory;
    assign rd_en_reg = hsel_reg && ~hwrite_reg && ~isMemory;
    assign wr_en_reg = hsel_reg && hwrite_reg;
    assign isMemory = (haddr_reg > OFFSET);

	//=======================================================
    // Registering AHB Control Signals
    //=======================================================
        //===================================================
        // HSEL
        //===================================================
        always_ff @(posedge HCLK or negedge HRESETn)
        begin
        if (!HRESETn)
            hsel_reg <= 1'b0;
        else
            hsel_reg <= HSEL;
        end
        //===================================================
        // HWRITE
        //===================================================
        always_ff @(posedge HCLK or negedge HRESETn)
        begin
        if (!HRESETn)
            hwrite_reg <= 1'b0;
        else
            hwrite_reg <= HWRITE;
        end
        //===================================================
        // HSIZE
        //===================================================   
        always_ff @(posedge HCLK or negedge HRESETn)
        begin
        if (!HRESETn)
            hsize_reg <= 3'b0;
        else if (HSEL)
            hsize_reg <= HSIZE ;
        end
    //=======================================================
	// Register File
	//=======================================================
	    //===================================================
        // Write Only (AHB Domain)
        // Interrupt Clear Reg      
        //===================================================
        always_ff @(posedge HCLK or negedge HRESETn)
        begin
            if (!HRESETn)
                interrupt_clear_reg <= 2'b00;
            else
            begin 
                if (wr_en_reg && (haddr_reg[11:0] == INTSTATUS))
                    interrupt_clear_reg <= HWDATA[1:0];
            end
        end
	    //===================================================
        // Write Only (AHB Domain)        
        // Interrupt Enable Register      
        //===================================================
        always_ff @(posedge HCLK or negedge HRESETn)
        begin
            if (!HRESETn)
                interrupt_enable_reg <= 2'b00;
            else
            begin
                if (wr_en_reg && (haddr_reg[11:0] == INTENABLE))
                    interrupt_enable_reg <= HWDATA;
            end
        end
	    //===================================================
        // Write (AHB Domain)        
        // Control Register     
        //===================================================
        always_ff @(posedge HCLK or negedge HRESETn)
        begin
            if (!HRESETn)
                control_reg <= 1'b0;
            else
            begin
                if (wr_en_reg && (haddr_reg[11:0] == CTRL))
                    control_reg <= HWDATA;
            end
        end
	    //===================================================
        // Read (AHB Domain)        
        // Read Phase register
        //===================================================
        always_ff @(posedge HCLK or negedge HRESETn)
        begin
            if (!HRESETn)
                hrdata_regfile <= 'b0;
            else
            begin
                if (rd_en_reg && (haddr_reg[11:0] == INTSTATUS))
                    hrdata_regfile <= interrupt_status_reg;
                else if (rd_en_reg && (haddr_reg[11:0] == CTRL))
                    hrdata_regfile <= control_reg;
            end
        end
	    //===================================================
        // Read Only (Compressor Domain)
        // Interrupt Status Reg
        //===================================================
        always_ff @ (posedge clk or negedge rst) 
        begin
            if (!rst) 
                interrupt_status_reg[0] <= 1'b0;
            else 
            begin
                if (interrupt_clear_reg[0] == 1'b1)
                    interrupt_status_reg[0] <= 1'b0;
                else if (received_image && interrupt_enable_reg[0])
                    interrupt_status_reg[0] <= 1'b1;
            end
        end

        always_ff @ (posedge clk or negedge rst) 
        begin
            if (!rst) 
                interrupt_status_reg[1] <= 1'b0;
            else
            begin 
                if (interrupt_clear_reg[1] == 1'b1)
                    interrupt_status_reg[1] <= 1'b0;
                else if (full && interrupt_enable_reg[1])
                    interrupt_status_reg[1] <= 1'b1;
            end
        end
        //===================================================

    //============================================================================
    // Error generation
    //============================================================================
    // Reserved addresses for read operations
    // These addresses are either non existent in the IP or are write only addresses
    assign reserved_read_address = (haddr_reg == 12'h4) ? 1'b1 : 1'b0;
    assign reserved_address = (haddr_reg == 12'hC) ? 1'b1 : 1'b0;

    //This signal defines the error signal
    //This signal combines both the reserved read and write addresses
    //Also contains a condition where writing zero to the wathcdog load register is prohibited
    assign error_signal = (rd_en_reg & reserved_read_address) || ((wr_en_reg|rd_en_reg) & reserved_address);


    //============================================================================
    // Error generation FSM
    //============================================================================
    always_ff @(posedge HCLK or negedge HRESETn)
    begin
      if(!HRESETn)
          current_state <= IDLE;
      else
        current_state <= next_state;
    end

    always_comb
    begin
      HREADYOUT = 1'b1;
      HRESP = 1'b0;
      next_state = current_state;
      case(current_state)
        IDLE: 
        begin
        if(error_signal)
          next_state = NOT_READY;
        else
          next_state = IDLE;
        end
        NOT_READY: 
        begin
          HREADYOUT = 1'b0;
          HRESP = 1'b1;
          next_state = ERROR;
        end
        ERROR: 
        begin
          HRESP = 1'b1;
          next_state = IDLE;
        end
      endcase
    end

    //============================================================================
    // HRDATA and Interrupts
    //============================================================================
    assign HRDATA = isMemory ? hrdata_mem : hrdata_regfile;

    assign received_image_int = interrupt_status_reg[0];
    assign full_int = interrupt_status_reg[1];

    //=======================================================
	// Compression Block
	//=======================================================
    Compression_TOP 
    #(
        .OUT_WIDTH(OUT_WIDTH),
        .IN_WIDTH(IN_WIDTH),
        .DIM(DIM),
        .MEM_UNCOMP_DEPTH(MEM_UNCOMP_DEPTH),
        .AHB_WIDTH(AHB_WIDTH),
        .IMG1 (IMG1 ),
        .IMG2 (IMG2 ),
        .IMG3 (IMG3 ),
        .IMG4 (IMG4 ),
        .IMG5 (IMG5 ),
        .IMG6 (IMG6 ),
        .IMG7 (IMG7 ),
        .IMG8 (IMG8 )   
    ) 
    compressor 
    (
        .clk(clk),
        .rst(rst),
        .enable(control_reg),
        .wr_data(wr_data),
        .valid_out(wr_en_mem)
    );
    //=======================================================
	// Compression Memory
	//=======================================================
    Compression_Memory  
    #(
        .AHB_WIDTH(AHB_WIDTH), 
        .MEM_COMP_DEPTH(MEM_COMP_DEPTH)
    ) 
    memory 
    (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .clk(clk),
        .rst(rst),
        .data_in(wr_data),
        .wr_en(wr_en_mem),
        .rdata(hrdata_mem),
        .address((haddr_reg - OFFSET)),
        .rd_en(rd_en_mem),
        .full(full),
        .received_image(received_image)
    );
    //=======================================================
endmodule


    











 