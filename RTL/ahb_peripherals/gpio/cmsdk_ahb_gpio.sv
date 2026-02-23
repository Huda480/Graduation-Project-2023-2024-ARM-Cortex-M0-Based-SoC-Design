//==============================================================================
// Purpose: GPIO TOP
// Used in: SYSTEM_TOP
//==============================================================================
//==============================================================================
// Module declaration
//==============================================================================
module cmsdk_ahb_gpio 
 #(// Parameter to define valid bit pattern for Alternate functions
   // If an I/O pin does not have alternate function its function mask
   // can be set to 0 to reduce gate count.
   //
   // By default every bit can have alternate function
   parameter  ALTERNATE_FUNC_MASK    = 16'hFFFF,

   // Default alternate function settings
   parameter  ALTERNATE_FUNC_DEFAULT = 16'h0000,

   // By default use little endian
   parameter  BE                     = 0,

   // The GPIO width by default is 16-bit, but is coded in a way that it is
   // easy to customise the width.
   parameter  PORTWIDTH              = 16'd16,

   parameter  ALTFUNC                =  4
  )
  (
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
   input  wire                                          HCLK,      // system bus clock
   input  wire                                          HRESETn,   // system bus reset
   input  wire                                          FCLK,      // system bus clock
    //==========================================================================
    // AHB signals
    //==========================================================================
   input  wire                                          HSEL,      // AHB peripheral select
   input  wire                                          HREADY,    // AHB ready input
   input  wire  [1:0]                                   HTRANS,    // AHB transfer type
   input  wire  [2:0]                                   HSIZE,     // AHB hsize
   input  wire                                          HWRITE,    // AHB hwrite
   input  wire [11:0]                                   HADDR,     // AHB address bus
   input  wire [31:0]                                   HWDATA,    // AHB write data bus
   output wire                                          HREADYOUT, // AHB ready output to S->M mux
   output wire                                          HRESP,     // AHB response
   output wire [31:0]                                   HRDATA,
    //==========================================================================
    // GPIO signals
    //==========================================================================
   input wire  [PORTWIDTH-1:0]                          PORTIN,     // GPIO Interface input
   output wire [PORTWIDTH-1:0]                          PORTOUT,    // GPIO output
   output wire [PORTWIDTH-1:0]                          PORTEN,     // GPIO output enable
   output wire [PORTWIDTH-1:0]                          PORTFUNC,   // Alternate function control
   output wire [PORTWIDTH*$clog2(ALTFUNC)-1:0]          ALT_FUNC,   // Alternate function selector
   output wire [PORTWIDTH-1:0]                          GPIOINT,    // Interrupt output for each pin
   output wire                                          COMBINT,
    //==========================================================================
    // Custom IP signals
    //==========================================================================
   input wire  [3:0]                                    ECOREVNUM
   );

//============================================================================
// Internal wires
//============================================================================

   wire [31:0]           IORDATA;    // I/0 read data bus
   wire                  IOSEL;      // Decode for peripheral
   wire  [11:0]          IOADDR;     // I/O transfer address
   wire                  IOWRITE;    // I/O transfer direction
   wire  [1:0]           IOSIZE;     // I/O transfer size
   wire                  IOTRANS;    // I/O transaction
   wire [31:0]           IOWDATA;    // I/O write data bus
   wire                  RESP;
   wire                  READY;
//==========================================================================
// Block instantiation
//==========================================================================
  //==========================================================================
  // AHB interface
  //==========================================================================
  // Convert AHB Lite protocol to simple I/O port interface
  cmsdk_ahb_to_iop
    u_ahb_to_gpio  (
    // Inputs
    .HCLK         (HCLK),
    .HRESETn      (HRESETn),
    .HSEL         (HSEL),
    .HREADY       (HREADY),
    .HTRANS       (HTRANS),
    .HSIZE        (HSIZE),
    .HWRITE       (HWRITE),
    .HADDR        (HADDR),
    .HWDATA       (HWDATA),
    .RESPONSE     (RESP),
    .READY        (READY),
    .IORDATA      (IORDATA),

    // Outputs
    .HREADYOUT    (HREADYOUT),
    .HRESP        (HRESP),
    .HRDATA       (HRDATA),
  
  
    .IOSEL        (IOSEL),
    .IOADDR       (IOADDR[11:0]),
    .IOWRITE      (IOWRITE),
    .IOSIZE       (IOSIZE),
    .IOTRANS      (IOTRANS),
    .IOWDATA      (IOWDATA));

  //==========================================================================
  // GPIO 
  //==========================================================================
  cmsdk_iop_gpio #(
    .ALTERNATE_FUNC_MASK     (ALTERNATE_FUNC_MASK),
    .ALTERNATE_FUNC_DEFAULT  (ALTERNATE_FUNC_DEFAULT), // All pins default to GPIO
    .BE                      (BE),
    .PORTWIDTH               (PORTWIDTH),
    .ALTFUNC                 (ALTFUNC)  
    )
    u_iop_gpio  (
    // Inputs
    .HCLK         (HCLK),
    .HRESETn      (HRESETn),
    .FCLK         (FCLK),
    .IOADDR       (IOADDR[11:0]),
    .IOSEL        (IOSEL),
    .IOTRANS      (IOTRANS),
    .IOSIZE       (IOSIZE),
    .IOWRITE      (IOWRITE),
    .IOWDATA      (IOWDATA),

    // Outputs
    .IORDATA      (IORDATA),

    .ECOREVNUM    (ECOREVNUM),// Engineering-change-order revision bits

    .PORTIN       (PORTIN),   // GPIO Interface inputs
    .PORTOUT      (PORTOUT),  // GPIO Interface outputs
    .PORTEN       (PORTEN),
    .PORTFUNC     (PORTFUNC), // Alternate function control
    .ALT_FUNC     (ALT_FUNC),
    .GPIOINT      (GPIOINT),  // Interrupt outputs
    .COMBINT      (COMBINT),
    .GRESP        (RESP),
    .GREADY       (READY)
  );

endmodule
