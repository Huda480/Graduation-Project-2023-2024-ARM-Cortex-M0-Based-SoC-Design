//==========================================================================================
// Purpose: TOP ram module
// Used in: SYSTEM_TOP
//==========================================================================================
module RAM_TOP 
#(
parameter AW       = 16,
parameter GROUP0 = "../Program/Scratch/main.bin",
parameter GROUP1 = "../Program/Scratch/main.bin",
parameter GROUP2 = "../Program/Scratch/main.bin",
parameter GROUP3 = "../Program/Scratch/main.bin",
parameter int IS_INSTRUCTION = 0)
( 

  //Bus Matrix inputs to SRAM 
  
  input  wire          HCLK,      // system bus clock
  input  wire          HRESETn,   // system bus reset
  input  wire          HSEL,      // AHB peripheral select
  input  wire          HREADY,    // AHB ready input
  input  wire    [1:0] HTRANS,    // AHB transfer type
  input  wire    [2:0] HSIZE,     // AHB hsize
  input  wire          HWRITE,    // AHB hwrite
  input  wire [AW-1:0] HADDR,     // AHB address bus
  input  wire   [31:0] HWDATA,    // AHB write data bus
  
  //outputs 
  output wire          HREADYOUT, // AHB ready output to S->M mux
  output wire          HRESP,     // AHB response
  output wire   [31:0] HRDATA    // AHB read data bus
	
	);
	
	//internal connections 

wire   [31:0] SRAMRDATA; // SRAM Read Data
wire [AW-3:0] SRAMADDR;  // SRAM address
wire    [3:0] SRAMWEN;   // SRAM write enable (active high)
wire   [31:0] SRAMWDATA; // SRAM write data
wire          SRAMCS;    // SRAM Chip Select  (active high)


cmsdk_ahb_to_sram U0_cmsdk_ahb_to_sram(
//inputs 
.HCLK(HCLK),
.HRESETn(HRESETn),

.HSEL(HSEL),
.HREADY(HREADY),
.HTRANS(HTRANS),

.HSIZE(HSIZE),
.HWRITE(HWRITE),
.HADDR(HADDR),
.HWDATA(HWDATA),

.SRAMRDATA(SRAMRDATA),

//outputs

.HREADYOUT(HREADYOUT),
.HRESP(HRESP),
.HRDATA(HRDATA),

.SRAMADDR(SRAMADDR),
.SRAMWEN(SRAMWEN),
.SRAMWDATA(SRAMWDATA),
.SRAMCS(SRAMCS)

);


cmsdk_fpga_sram #(.AW(AW),.GROUP0(GROUP0),.GROUP1(GROUP1),.GROUP2(GROUP2),.GROUP3(GROUP3),.IS_INSTRUCTION(IS_INSTRUCTION)) 
U0_cmsdk_fpga_sram
( 
.CLK(HCLK),
.ADDR({1'b0,1'b0,SRAMADDR}),
.WDATA(SRAMWDATA),
.WREN(SRAMWEN),
.CS(SRAMCS),
.RDATA(SRAMRDATA)
//.ADDR(SRAMADDR),
);

	
endmodule