//==========================================================================================
// Purpose: Error and ready signals multiplexer
// Used in: cmsdk_apb_subsystem
//==========================================================================================
module cmsdk_apb_slave_mux
 (
// --------------------------------------------------------------------------
// Port Definitions
// --------------------------------------------------------------------------
 


/*uart 0 signals*/

  input  wire         PSEL0,
  input  wire         PREADY0,
  input  wire [31:0]  PRDATA0,
  input  wire         PSLVERR0,

/*timer signals */

  input  wire         PSEL1,
  input  wire         PREADY1,
  input  wire [31:0]  PRDATA1,
  input  wire         PSLVERR1,
  
  
/*wdog signals */


  input  wire         PSEL2,
  input  wire         PREADY2,
  input  wire [31:0]  PRDATA2,
  input  wire         PSLVERR2,
  
  
  /*dual timer signals */

  input  wire         PSEL3,
  input  wire         PREADY3,
  input  wire [31:0]  PRDATA3,
  input  wire         PSLVERR3,

  /*uart 1 signals*/
  input  wire         PSEL4,
  input  wire         PREADY4,
  input  wire [31:0]  PRDATA4,
  input  wire         PSLVERR4,

 /*spi signals*/

  input  wire         PSEL5,
  input  wire         PREADY5,
  input  wire [31:0]  PRDATA5,
  input  wire         PSLVERR5,

  output wire         PREADY,
  output wire [31:0]  PRDATA,
  output wire         PSLVERR);

  // --------------------------------------------------------------------------
  // Start of main code
  // --------------------------------------------------------------------------

 

  assign PREADY  = (~PSEL0 & ~PSEL1  & ~PSEL2  & ~PSEL3 & ~PSEL4 & ~PSEL5 ) |
                   ((PREADY0  && PSEL0) ) |
                   ((PREADY1  && PSEL1) ) |
                   ((PREADY2  && PSEL2) ) |
                   ((PREADY3  && PSEL3) ) |
                   ((PREADY4  && PSEL4) ) |
                   ((PREADY5  && PSEL5) ) 
                   ;
                

  assign PSLVERR = ( PSEL0  & PSLVERR0  ) |
                   ( PSEL1  & PSLVERR1  ) |
                   ( PSEL2  & PSLVERR2  ) |
                   ( PSEL3  & PSLVERR3  ) |
                   ( PSEL4  & PSLVERR4  ) |
                   ( PSEL5  & PSLVERR5  ) 
                   ;
                

  assign PRDATA  = ( {32{PSEL0 }} & PRDATA0  ) |
                   ( {32{PSEL1 }} & PRDATA1  ) |
                   ( {32{PSEL2 }} & PRDATA2  ) |
                   ( {32{PSEL3 }} & PRDATA3  ) |
                   ( {32{PSEL4 }} & PRDATA4  ) |
                   ( {32{PSEL5 }} & PRDATA5  ) 
                   ;
                  

endmodule
