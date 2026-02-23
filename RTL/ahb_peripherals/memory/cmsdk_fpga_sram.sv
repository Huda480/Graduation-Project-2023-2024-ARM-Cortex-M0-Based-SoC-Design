module cmsdk_fpga_sram #(
// --------------------------------------------------------------------------
// Parameters
// --------------------------------------------------------------------------
  parameter AW = 16,
  GROUP0 = "C:/STM-Graduation-Project-2024/Program/main.bin",
  GROUP1 = "C:/STM-Graduation-Project-2024/Program/main.bin",
  GROUP2 = "C:/STM-Graduation-Project-2024/Program/main.bin",
  GROUP3 = "C:/STM-Graduation-Project-2024/Program/main.bin",
  parameter int IS_INSTRUCTION = 1
 )
 (
  // Inputs
  input  wire          CLK,
  input  wire [AW-1:0] ADDR,
  input  wire [31:0]   WDATA,
  input  wire [3:0]    WREN,
  input  wire          CS,

  // Outputs
  output wire [31:0]   RDATA
  );

// -----------------------------------------------------------------------------
// Constant Declarations
// -----------------------------------------------------------------------------
localparam AWT = ((1<<(AW-0))-1);
integer File_ID;
localparam MEM_SIZE = 2**(AW+2);
reg [7:0] fileimage [0:((MEM_SIZE)-1)];
  // Memory Array
  reg     [7:0]   BRAM0 [AWT:0];
  reg     [7:0]   BRAM1 [AWT:0];
  reg     [7:0]   BRAM2 [AWT:0];
  reg     [7:0]   BRAM3 [AWT:0];

  // Internal signals
  reg     [AW-1:0]  addr_q1;
  wire    [3:0]     write_enable;
  reg               cs_reg;
  wire    [31:0]    read_data;

  assign write_enable[3:0] = WREN[3:0] & {4{CS}};

  
  generate if(IS_INSTRUCTION == 1)
    begin
      initial 
      begin
        $readmemb (GROUP0,BRAM0);
        $readmemb (GROUP1,BRAM1);
        $readmemb (GROUP2,BRAM2);
        $readmemb (GROUP3,BRAM3);
      end
    end
    else
    begin
      initial 
      begin
        foreach(BRAM0[i])
        begin
          BRAM0[i] = 8'h00;
          BRAM1[i] = 8'h00;
          BRAM2[i] = 8'h00;
          BRAM3[i] = 8'h00;
        end
      end
    end
    endgenerate
  
  
  
  always @ (posedge CLK)
    begin
    cs_reg <= CS;
    end

  // Infer Block RAM - syntax is very specific.
  always @ (posedge CLK)
    begin
      if (write_enable[0])
        BRAM0[ADDR] <= WDATA[7:0];
      if (write_enable[1])
        BRAM1[ADDR] <= WDATA[15:8];
      if (write_enable[2])
        BRAM2[ADDR] <= WDATA[23:16];
      if (write_enable[3])
        BRAM3[ADDR] <= WDATA[31:24];
      // do not use enable on read interface.
      addr_q1 <= ADDR[AW-1:0];
    end

  assign read_data  = {BRAM3[addr_q1],BRAM2[addr_q1],BRAM1[addr_q1],BRAM0[addr_q1]};


  assign RDATA      = (cs_reg) ? read_data : {32{1'b0}};

endmodule
