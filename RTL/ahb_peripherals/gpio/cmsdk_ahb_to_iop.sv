//==============================================================================
// Purpose: Simple AHB to IOP Bridge (for use with the IOP GPIO to make an AHB GPIO).
// Used in: cmsdk_ahb_gpio
//==============================================================================

module cmsdk_ahb_to_iop
// ----------------------------------------------------------------------------
// Port Definitions
// ----------------------------------------------------------------------------
  (
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
   input  wire                 HCLK,      // system bus clock
   input  wire                 HRESETn,   // system bus reset
    //==========================================================================
    // AHB Signals
    //==========================================================================
   input  wire                  HSEL,      // AHB peripheral select
   input  wire                  HREADY,    // AHB ready input
   input  wire  [1:0]           HTRANS,    // AHB transfer type
   input  wire  [2:0]           HSIZE,     // AHB hsize
   input  wire                  HWRITE,    // AHB hwrite
   input  wire  [11:0]          HADDR,     // AHB address bus
   input  wire  [31:0]          HWDATA,    // AHB write data bus
   input  wire                  RESPONSE,
   input  wire                  READY,
   output wire                  HREADYOUT, // AHB ready output to S->M mux
   output wire                  HRESP,     // AHB response
   output wire  [31:0]          HRDATA,
   
    //==========================================================================
    // GPIO signals
    //==========================================================================
   input wire [31:0]           IORDATA,    // I/0 read data bus
   output reg                  IOSEL,      // Decode for peripheral
   output reg  [11:0]          IOADDR,     // I/O transfer address
   output reg                  IOWRITE,    // I/O transfer direction
   output reg  [1:0]           IOSIZE,     // I/O transfer size
   output reg                  IOTRANS,    // I/O transaction
   output wire [31:0]          IOWDATA);   // I/O write data bus

  //==========================================================================
  // Rgistering HSEL
  //==========================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOSEL <= 1'b0;
    else
      IOSEL <= HSEL & HREADY;
  end

  //==========================================================================
  // Registering HADDR
  //==========================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOADDR <= {12{1'b0}};
    else
      IOADDR <= HADDR[11:0];
  end

  //==========================================================================
  // Registering HWRITE
  //==========================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOWRITE <= 1'b0;
    else
      IOWRITE <= HWRITE;
  end

  //==========================================================================
  // Registering HSIZE
  //==========================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOSIZE <= {2{1'b0}};
    else
      IOSIZE <= HSIZE[1:0];
  end

  //==========================================================================
  // Registering HTRANS
  //==========================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOTRANS <= 1'b0;
    else
      IOTRANS <= HTRANS[1];
  end

  //==========================================================================
  // Assigning signals
  //==========================================================================
  assign IOWDATA   = HWDATA;
  assign HRDATA    = IORDATA;
  assign HREADYOUT = READY;
  assign HRESP     = RESPONSE;

endmodule
