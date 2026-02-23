//==============================================================================
// Purpose: Watch dog APB peripheral
// Used in: cmsdk_apb_subsystem
//==============================================================================
//
// Overview
// ========
//
// The Watchdog Free-Running Counter (WdogFrc) is a sub-component of the
//  Watchdog module. It essentially contains:
//
// * The 32-bit free-running down-counter.
// * Period load register.
// * Control register to enable reset and interrupt signals.
// * Interrupt status register.
// * Lock register to prevent accidental write access.
// * Interrupt and Reset generation logic.
//
// If necessary, this block can be instantiated more than once in the
//  top-level structural description, to form a multi-channel Watchdog.
//
//==============================================================================
// Register File
//==============================================================================
  // -------------------------------------------------------------------
  // Register name      |      Address      |  P |  Reset Value | Size |
  // -------------------------------------------------------------------
  // 1) WDG_LOAD        |   Base + 0x000    | RW |  0xFFFF_FFFF |  32  |
  // 2) WDG_VALUE       |   Base + 0x004    | RO |  0xFFFF_FFFF |  32  |
  // 3) WDG_CONTROL     |   Base + 0x008    | RW |  0x0000_0000 |  2   |
  // 4) WDG_INT_CLR     |   Base + 0x00C    | WO |      NA      |  NA  |
  // 5) WDG_RIS         |   Base + 0x010    | RO |      0x0     |  1   |
  // 6) WDG_MIS         |   Base + 0x014    | RO |      0x0     |  1   |
  // 7) WDG_LOCK        |   Base + 0xC00    | RW |  0x0000_0000 |  32  |
  // 8) WDG_INTEG_CTRL  |   Base + 0xF00    | RO |      0x0     |  1   |
  // 9) WDG_INTEG_OUT   |   Base + 0xF04    | WO |      0x0     |  2   |
  // 10) WDG_PID0       |   Base + 0xFE0    | RO |      0x05    |  8   |
  // 11) WDG_PID1       |   Base + 0xFE4    | RO |      0x18    |  8   |
  // 12) WDG_PID2       |   Base + 0xFE8    | RO |      0x14    |  8   |
  // 13) WDG_PID3       |   Base + 0xFEC    | RO |      0x00    |  8   |
  // 14) WDG_CID0       |   Base + 0xFF0    | RO |      0x0D    |  8   |
  // 15) WDG_CID1       |   Base + 0xFF4    | RO |      0xF0    |  8   |
  // 16) WDG_CID2       |   Base + 0xFF8    | RO |      0x05    |  8   |
  // 17) WDG_PID3       |   Base + 0xFFC    | RO |      0xB1    |  8   |
  // -------------------------------------------------------------------
//==============================================================================
// Module declaration
//==============================================================================
module cmsdk_apb_watchdog import apb_pkg::*;
(
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
    input  wire         WDOGCLK,     // Watchdog clock
    input  wire         WDOGCLKEN,   // Watchdog clock enable
    input  wire         WDOGRESn,    // Watchdog clock reset
    //==========================================================================
    // APB Interface
    //==========================================================================
    input  wire         PCLK,        // APB clock
    input  wire         PRESETn,     // APB reset
    input  wire         PENABLE,     // APB enable
    input  wire         PSEL,        // APB periph select
    input  wire [11:2]  PADDR,       // APB address bus
    input  wire         PWRITE,      // APB write
    input  wire [31:0]  PWDATA,      // APB write data
    output wire [31:0]  PRDATA,      // APB read data
    output reg          PSLVERR,     // APB slave error
    output reg          PREADY,      // APB slave ready
    //==========================================================================
    // Interrupts
    //==========================================================================
    output wire         WDOGINT,     // Watchdog interrupt
    output wire         WDOGRES,     // Watchdog timeout reset
    //==========================================================================
    // Custom IP signals
    //==========================================================================
    input  wire  [3:0]  ECOREVNUM    // ECO revision number
    //==========================================================================
);
  //============================================================================
  // Macro inclusion
  //============================================================================
  `include "cmsdk_apb_watchdog_defs.svh"
  //============================================================================
  // Local Parameters
  //============================================================================
    localparam  WDOG_PERIPH_ID0 = 8'h24;
    localparam  WDOG_PERIPH_ID1 = 8'hB8;
    localparam  WDOG_PERIPH_ID2 = 8'h1B;
    localparam  WDOG_PERIPH_ID3 = 4'h0;
    localparam  WDOG_PERIPH_ID4 = 8'h04;
    localparam  WDOG_PERIPH_ID5 = 8'h00;
    localparam  WDOG_PERIPH_ID6 = 8'h00;
    localparam  WDOG_PERIPH_ID7 = 8'h00;
    localparam  WDOG_PCELL_ID0 = 8'h0D;
    localparam  WDOG_PCELL_ID1 = 8'hF0;
    localparam  WDOG_PCELL_ID2 = 8'h05;
    localparam  WDOG_PCELL_ID3 = 8'hB1;
    localparam  WDOG_LOCK_VALUE = 32'h1ACCE551;
  //============================================================================
  // Internal signals
  //============================================================================
    wire          frc_sel;          //  FRC select (address decoding)
    reg [31:0]    frc_data;         //  FRC data out
    reg [7:0]     wdog_pdata;       //  Peripheral/PrimeCell data out
    reg [31:0]    prdata_next;      //  Internal PRDATA
    reg [31:0]    i_prdata;         //  Registered prdata_next
    wire          wdog_itcr_wr_en;  //  Write enable for Integration Test
                                    // Control Register
    reg           wdog_itcr;        //  Integration Test Control Register
    wire          wdog_itop_wr_en;  //  Write enable for Integration Test
                                    // Output Set Register
    reg [1:0]     wdog_itop;        //  Integration Test Output Set
                                    // Register
    wire          wdog_lock_wr_en;  //  Watchdog lock register write enable
    wire          wdog_lock_wr_val; //  Next Watchdog lock register value
    reg           wdog_lock;        //  Watchdog lock register
    wire          i_wdogint;        //  Counter interrupt
    wire          i_wdogres;        //  Counter reset
    wire          error_signal;     //  error signal
    wire          write_enable;     //  write enable
    wire          read_enable ;     //  read enable

    wire          wdog_ctrl_en;     // Ctrl write enable
    reg [1:0]     wdog_control;     // Control register
    wire          load_en;          // Load write enable
    reg           load_en_reg;      // Registered load enable
    reg [31:0]    wdog_load;        // wdog_load register

    wire          load_tog_en;      // Enable for load request toggle
    reg           load_req_tog_p;   // Load request toggle, PCLK domain
    reg           load_req_tog_w;   // Load request toggle, WDOGCLK domain
    wire          load_req_w;       // Load request pulse, WDOGCLK domain

    wire          count_stop;       // Halt counter
    reg           count_stop_reg;   // Registered count_stop

    reg [15:0]    nxt_count_low;    // Count - 1 [15:0]
    reg [15:0]    nxt_count_high;   // Count - 1 [31:16]
    reg           nxt_carry_0;      // Decrement carry in
    reg           nxt_carry_1;      // Decrement carry in
    wire [1:0]    nxt_carry_mux;    // Decrement carry in (muxed)
    reg [1:0]     reg_carry;        // Decrement carry in
    wire          carry_msb;        // Multiplexed carry for 16/32-bit count
    wire [31:0]   count_mux1;       // Count mux value
    wire [31:0]   count_mux2;       // Count mux value
    reg [31:0]    reg_count;        // Current count
    wire [31:0]   count_read;       // Current count mux
    wire [15:0]   high_count;       // Upper half-word mux

    wire          wdog_int_en;      // Interrupt enable
    reg           wdog_int_en_reg;  // Registered interrupt enable
    wire          wdog_int_en_rise; // Rising edge on interrupt enable
    wire          wdog_res_en;      // Reset enable
    reg           i_wdog_res;       // Registered internal counter reset
    wire          nxt_wdog_res;     // Next i_wdog_res value

    wire          int_clr_en;       // Interrupt clear enable
    reg           int_clr_tog_p;    // Int Clear toggle in PCLK domain
    reg           int_clr_tog_w;    // Int Clear toggle in WDOGCLK domain
    wire          int_clr_pulse;    // Int Clear pulse in PCLK and WDOGCLK
    wire          int_clr_w;        // Int Clear signal in WDOGCLK domain
    reg           int_clr_reg_w;    // Registered int_clr_w, WDOGCLK domain

    wire          nxt_wdog_ris;     // Next wdog_ris value
    reg           wdog_ris;         // Registered internal counter interrupt
    wire          read_wdog_ris;    // Registered internal counter interrupt
    wire          wdog_mis;         // Masked counter interrupt

    states_t      current_state;
    states_t      next_state;
  //============================================================================
  // Main Controls
  //============================================================================    
    // Free Running Counter (FRC) registers which are LOAD/VALE/CONTROL
    assign frc_sel  = (PSEL & (PADDR [11:5] == `ARM_WDOG1A)) ? 1'b1 : 1'b0;

    assign wdog_itop_wr_en = (PADDR == {`ARM_WDOGIA,`ARM_WDOGTOPA}) ?
                        (write_enable & (~wdog_lock)) : 1'b0;

    // Read and write conditions for the module
    assign write_enable = PSEL & PWRITE & ~PENABLE;
    assign read_enable =  PSEL & ~PWRITE & ~PENABLE;
  //============================================================================
  // Register File
  //============================================================================
    //==========================================================================
    // Lock Register
    //==========================================================================
      //========================================================================
      // Address decoding stage
      //========================================================================
      assign wdog_lock_wr_en = (PADDR == {`ARM_WDOGLA,`ARM_WDOGLOCKA}) ? (write_enable) : 1'b0;
      assign wdog_lock_wr_val =(PWDATA == WDOG_LOCK_VALUE ) ? 1'b0 : 1'b1;
      //========================================================================  
      // Drive interrupt and reset outputs
      //========================================================================
      assign WDOGINT = (wdog_itcr == 1'b0) ? i_wdogint : wdog_itop[1];
      assign WDOGRES = (wdog_itcr == 1'b0) ? i_wdogres : wdog_itop[0];
      //========================================================================
      // Register
      //========================================================================
      always_ff @ (posedge PCLK or negedge PRESETn)
      begin : p_lock_seq
        if (!PRESETn)
          wdog_lock <= `ARM_WDOGLOCK_RESET;
        else
          if (wdog_lock_wr_en)
            wdog_lock <= wdog_lock_wr_val;
      end
    //==========================================================================
    // INTEG_CTRL Register
    //==========================================================================
      //========================================================================
      // Address decoding stage
      //========================================================================
      assign wdog_itcr_wr_en = (PADDR == {`ARM_WDOGIA,`ARM_WDOGTCRA}) ? (write_enable & (~wdog_lock)) : 1'b0;
      //========================================================================      
      // Register
      //========================================================================      
      always_ff @ (posedge PCLK or negedge PRESETn)
      begin : p_tcr_seq
        if (!PRESETn)
          wdog_itcr <= `ARM_WDOGITCR_RESET;
        else
          if (wdog_itcr_wr_en)
            wdog_itcr <= PWDATA[0];
      end
      //========================================================================      
    //==========================================================================
    // INTEG_OUT Register
    //==========================================================================
    //==========================================================================  
    // Control Register
    //==========================================================================  
      //========================================================================
      // Address decoding stage
      //========================================================================          
      //assign wdog_ctrl_en = (PADDR == `ARM_WDOGCONTROLA) ? (PWRITE & frc_sel & (~PENABLE) & (~wdog_lock)) : 1'b0;
      assign wdog_ctrl_en = (PADDR == `ARM_WDOGCONTROLA) ? (frc_sel & (~wdog_lock) & write_enable) : 1'b0;
      //========================================================================
      // Register
      //========================================================================      
      always_ff @ (posedge PCLK or negedge PRESETn)
      begin : p_ctrl_seq
        if (!PRESETn)
          wdog_control[1:0] <= `ARM_WDOGCNTRL_RESET;
        else
          if (wdog_ctrl_en)
            wdog_control[1:0] <= PWDATA[1:0];
      end
    //========================================================================== 
    // Load Register
    //==========================================================================
      //========================================================================
      // Address decoding stage
      //======================================================================== 
      // assign load_en = (PADDR == `ARM_WDOGLOADA) ? (PWRITE & frc_sel & (~PENABLE) & (~wdog_lock)) : 1'b0;
      assign load_en = (PADDR == `ARM_WDOGLOADA) ? (frc_sel & (~wdog_lock) & write_enable) : 1'b0;
      //========================================================================
      // Register
      // load_en_reg is not a part of the register file.
      // Register load_en so it is aligned with the data in the Load register
      //======================================================================== 
      always_ff @(negedge PRESETn or posedge PCLK)
      begin : p_load_en_seq
        if (!PRESETn)
          load_en_reg <= 1'b0;
        else
          load_en_reg <= load_en;
      end
      always_ff @ (negedge PRESETn or posedge PCLK)
      begin : p_load_seq
        if (!PRESETn)
          wdog_load <= `ARM_WDOGLOAD_RESET;
        else
          if (load_en && ~PSLVERR && (|PWDATA))
            wdog_load <= PWDATA;
      end
      //========================================================================

    always_ff @ (posedge PCLK or negedge PRESETn)
    begin : p_top_seq
      // process p_TopSeq
      if (PRESETn == 1'b0)
        // asynchronous reset (active low)
        wdog_itop <= 2'b00;
      else
        // rising clock edge
          if (wdog_itop_wr_en)
            wdog_itop <= PWDATA[1:0];
    end
    //==========================================================================
    // PID & CID Registers
    //==========================================================================
      //========================================================================
      // Address decoding stage
      //========================================================================               
      always_comb
      begin: p_wdog_pdata_comb
        if(read_enable)
        begin
          case (PADDR[5:2])
            `ARM_WPERIPHID4A:   wdog_pdata = WDOG_PERIPH_ID4;
            `ARM_WPERIPHID5A:   wdog_pdata = WDOG_PERIPH_ID5;
            `ARM_WPERIPHID6A:   wdog_pdata = WDOG_PERIPH_ID6;
            `ARM_WPERIPHID7A:   wdog_pdata = WDOG_PERIPH_ID7;
            `ARM_WPERIPHID0A:   wdog_pdata = WDOG_PERIPH_ID0;
            `ARM_WPERIPHID1A:   wdog_pdata = WDOG_PERIPH_ID1;
            `ARM_WPERIPHID2A:   wdog_pdata = WDOG_PERIPH_ID2;
            `ARM_WPERIPHID3A:   wdog_pdata = {ECOREVNUM,WDOG_PERIPH_ID3};
            `ARM_WPCELLID0A :   wdog_pdata = WDOG_PCELL_ID0;
            `ARM_WPCELLID1A :   wdog_pdata = WDOG_PCELL_ID1;
            `ARM_WPCELLID2A :   wdog_pdata = WDOG_PCELL_ID2;
            `ARM_WPCELLID3A :   wdog_pdata = WDOG_PCELL_ID3;
            default: wdog_pdata = {8{1'b0}};
          endcase
        end
        else
          wdog_pdata = {8{1'b0}};
      end: p_wdog_pdata_comb
      //========================================================================        
  //============================================================================
  // Internal Logic
  //============================================================================
    //==========================================================================
    // Interrupt enable
    //==========================================================================
      // The counter (in the WDOGCLK domain) needs to be reset to wdog_load
      // when the interrupt is re-enabled.  wdog_int_en_rise will assert for
      // one WDOGCLK cycle after a rising edge on wdog_int_en and is
      // factored into the counter reset
      //============================================================================
      // Register wdog_int_en with WDOGCLK clock domain (wdog interrupt enable signal)
      //============================================================================
      assign wdog_int_en = wdog_control[0];      
      always_ff @ (posedge WDOGCLK or negedge WDOGRESn)
      begin : p_wdog_int_en_reg_seq
        if (!WDOGRESn)
          wdog_int_en_reg <= 1'b0;
        else
          if (WDOGCLKEN)
            wdog_int_en_reg <= wdog_int_en;
      end
      assign wdog_int_en_rise = wdog_int_en & (~wdog_int_en_reg);
    //==========================================================================
    // Load enable register
    //==========================================================================
      // The load_en pulse needs to be sampled into the WDOGCLK domain even if PCLK
      // is subsequently disabled.
      // load_req_tog_p is toggled if a new load request is received and there are no
      //  pending load requests. This prevents multiple toggles before the next
      //  WDOGCLK edge.
      //========================================================================
      // load_tog_en high toggles LoadReqTog on next PCLK
      //========================================================================
      assign load_tog_en = load_en_reg & (~load_req_w); // New load request and none pending
      always_ff @ (negedge PRESETn or posedge PCLK)
      begin : p_load_req_tog_p_seq
        if (!PRESETn)
          load_req_tog_p <= 1'b0;
        else
          if (load_tog_en)
            load_req_tog_p <= (~load_req_tog_p);
      end
      //========================================================================
      // Register LoadReqTog with WDOGCLK clock domain 
      //========================================================================  
      always_ff @(posedge WDOGCLK or negedge WDOGRESn)
      begin : p_load_req_tog_w_seq
        if (!WDOGRESn)
          load_req_tog_w <= 1'b0;
        else
          if (WDOGCLKEN)
            load_req_tog_w <= load_req_tog_p;
      end
      //========================================================================  
      // load_req_w goes high on the PCLK edge after load_tog_en and low on the next valid WDOGCLK edge
      //========================================================================  
      assign load_req_w = load_req_tog_p ^ load_req_tog_w;
    //==========================================================================
    // 32-bit count down with load
    //==========================================================================
      // nxt_count is set to Count when reg_carry = 0 so that loads also change the
      //  value of nxt_count.
      // 32 bit counter is implemented as two 16 bit counters to improve FPGA
      //  implementation.
      // Halfword 0, bits 15:0
      assign nxt_count_low[15:0] = (reg_count[15:0] - 1'b1);

      always_comb
      begin : p_nxt_carry_0_comb
        // Select the value source to be evaluated for the lower half-word
        if (load_req_w | carry_msb | wdog_int_en_rise | int_clr_w)
          if (wdog_load[15:0] == 16'h0000)
            nxt_carry_0 = 1'b1;
          else
            nxt_carry_0 = 1'b0;
        else if (reg_count[15:0] == 16'h0001)
          nxt_carry_0 = 1'b1;
        else
          nxt_carry_0 = 1'b0;
      end

      // Halfword 1, bits 31:16
      assign nxt_count_high[15:0] = (reg_carry[0]) ? (reg_count[31:16] - 1'b1) : reg_count[31:16];

      // Select the value source to be evaluated for the upper half-word
      assign high_count = (load_req_w | carry_msb | wdog_int_en_rise | int_clr_w) ? wdog_load[31:16] : reg_count[31:16];

      assign nxt_carry_1 = ((high_count == 16'h0000) & nxt_carry_0 & (~carry_msb)) ? 1 : 0;

      // Only change reg_carry when counter is enabled (as per setting of count_mux2 below)
      assign nxt_carry_mux = ((wdog_int_en & (~count_stop)) | load_req_w) ? {nxt_carry_1, nxt_carry_0} : reg_carry;

      // Registered carry bits to improve timing, enabled by the same terms as the reg_count register
      always_ff @ (negedge WDOGRESn or posedge WDOGCLK)
      begin : p_reg_carry_seq
        if (!WDOGRESn)
          reg_carry <= 2'b00;
        else
          if (WDOGCLKEN)
            reg_carry <= nxt_carry_mux;
      end

      // The most significant reg_carry bit changes when in 16 or 32-bit counter modes.
      assign carry_msb = reg_carry[1];
    //==========================================================================
    // Counter register
    //==========================================================================
      // Reloads from Load when carry_msb is set.

      // Load the counter with the value from wdog_load when:
      assign count_mux1 = (load_req_w |            // New value written
                          carry_msb |              // Count reaches zero
                          wdog_int_en_rise |         // IRQ output enabled
                          int_clr_w) ? wdog_load :   // IRQ output cleared
                          {nxt_count_high, nxt_count_low}; // Otherwise decrement the counter

      // The counter only changes on a valid WDOGCLKEN, when either:
      //   1. The watchdog is enabled, and the counter is not stopped.
      //   2. A new value is loaded.
      assign count_mux2 = ((wdog_int_en & (~count_stop)) |
                          load_req_w) ? count_mux1 :
                          reg_count;

      // The counter needs to be disabled after the Watchdog has generated a reset.
      // It is re-enabled when a new value is written to the Load register.
      assign count_stop = (i_wdog_res ? 1'b1 :
                          load_req_w ? 1'b0 :
                          count_stop_reg);

      always_ff @ (negedge WDOGRESn or posedge WDOGCLK)
      begin : p_count_stop_seq
        if (!WDOGRESn)
          count_stop_reg <= 1'b0;
        else
          if (WDOGCLKEN)
            count_stop_reg <= count_stop;
      end

      // Counter registers using rising edge of WDOGCLK.
      // WDOGCLKEN is used to enable the counter.
      // Reset sets all outputs HIGH to avoid interrupt generation at start.
      always_ff @ (negedge WDOGRESn or posedge WDOGCLK)
      begin : p_count_seq
        if (!WDOGRESn)
          reg_count <= {32{1'b1}};
        else
          if (WDOGCLKEN)
            reg_count <= count_mux2;
      end

      // count_read is set to the value of wdog_load so that when this
      // register is written to, and then immediately followed by a read
      // from the Count register, the newly loaded value is read back even
      // if no WDOGCLK/WDOGCLKEN edge has yet occurred.
      assign count_read = load_req_w ? wdog_load : reg_count;
    //==========================================================================
    // Interrupt clear
    //==========================================================================
      // carry_msb can be valid for multiple clock cycles, and may not have cleared
      //  until after an interrupt clear has been asserted, allowing the interrupt
      //  to be entered again. The interrupt clear is extended to ensure that it
      //  remains valid until the interrupt is actually cleared in the WDOGCLK
      //  domain. A toggle based handshake is used in case PCLK is removed before
      //  the interrupt clear operation is complete.

      // Decode IntClr transaction
      assign int_clr_en = ((~int_clr_w) &  PWRITE & frc_sel & (~PENABLE) & (~wdog_lock) & (PADDR == `ARM_WDOGCLEARA)) ? 1'b1 : 1'b0; // No pending IntClr operation


      // IntClr high toggles int_clr_tog_p on next PCLK
      always_ff @(negedge PRESETn or posedge PCLK)
      begin : p_int_clr_tog_p_seq
        if (~PRESETn)
          int_clr_tog_p <= 1'b0;
        else
          if (int_clr_en)
            int_clr_tog_p <= (~int_clr_tog_p);
      end

      // Register int_clr_tog_p into WDOGCLK domain
      always_ff @(negedge WDOGRESn or posedge WDOGCLK)
      begin : p_int_clr_tog_w_seq
        if (~WDOGRESn)
          int_clr_tog_w <= 1'b0;
        else
          if (WDOGCLKEN)
            int_clr_tog_w <= int_clr_tog_p;
      end

      // int_clr_pulse is high on PCLK edge, low on WDOGCLK edge
      assign int_clr_pulse = int_clr_tog_p ^ int_clr_tog_w;

      // int_clr_w is used to clear the interrupt. It is asserted when the APB IntClr
      //  transaction is detected and de-asserted when the counter is no longer zero
      //  (to prevent multiple interrupts from one counter event).
      assign int_clr_w = (int_clr_pulse ? 1'b1 : // IntClr transaction sampled into
                                            //  WDOGCLK domain
                        (~carry_msb) ? 1'b0 :   // Counter no longer zero
                        int_clr_reg_w);

      // Register int_clr_w to hold it until counter is non-zero.
      always_ff @(negedge WDOGRESn or posedge WDOGCLK)
      begin : p_int_clr_reg_seq
        if (~WDOGRESn)
          int_clr_reg_w <= 1'b0;
        else
          if (WDOGCLKEN)
            int_clr_reg_w <= int_clr_w;
      end
    //==========================================================================
    // Interrupt generation
    //==========================================================================
      // The interrupt is generated (HIGH) when the counter reaches zero.
      // The interrupt is cleared (LOW) when the WdogIntClr address is written to.
      assign nxt_wdog_ris = (carry_msb | wdog_ris) & (~int_clr_w);

      // Register and hold interrupt until cleared.  WDOGCLK is used to ensure that
      //  an interrupt is still generated even if PCLK is disabled.
      always_ff @ (negedge WDOGRESn or posedge WDOGCLK)
        begin : p_int_seq
          if (~WDOGRESn)
            wdog_ris <= 1'b0;
          else
            if (WDOGCLKEN)
              wdog_ris <= nxt_wdog_ris;
        end

      // Factor int_clr_w into version of raw interrupt status which is read
      // back from the RIS register so that a read from RIS or MIS will
      // show the cleared value immediately
      assign read_wdog_ris = wdog_ris & (~int_clr_w);

      // Gate raw interrupt with enable bit
      assign wdog_mis = read_wdog_ris & wdog_int_en;

      // Drive output with internal signal
      assign i_wdogint = wdog_mis;
    //==========================================================================
    // Reset generation
    //==========================================================================
      // The reset output is activated when the counter reaches zero and the
      //  interrupt output is active, indicating that the counter has previously
      //  reached zero but not been serviced.
      assign wdog_res_en = wdog_control[1];
      assign nxt_wdog_res = ((~wdog_res_en) ? 1'b0 :            // Watchdog reset disabled
                          (wdog_ris & carry_msb) ? 1'b1 : // Raw IRQ asserted and
                                                          // Counter is zero
                          i_wdog_res);

      // WdogRes register
      always_ff @ (negedge WDOGRESn or posedge WDOGCLK)
        begin : p_res_seq
          if (~WDOGRESn)
            i_wdog_res <= 1'b0;
          else
            if (WDOGCLKEN)
              i_wdog_res <= nxt_wdog_res;
        end

      // Drive reset output
      assign i_wdogres = i_wdog_res;
  //============================================================================
  // Error generation
  //============================================================================
    // Reserved addresses for write operations
    //These addresses are either non existent in the IP or are read only addresses
    assign reserved_write_address = ((PADDR[11:2] >= 10'h3F4)|| (PADDR[11:2] == 10'h4) || (PADDR[11:2] == 10'h5) || (PADDR[11:2] == 10'h1))? 1'b1 : 1'b0;

    //Reserved addresses for read operations
    //These addresses are either non existent in the IP or are write only addresses
    assign reserved_read_address = ((PADDR[11:2] == 10'h3) || (PADDR[11:2] == 10'h3C1))? 1'b1 : 1'b0;
    
    //This signal defines the error signal
    //This signal combines both the reserved read and write addresses
    //Also contains a condition where writing zero to the wathcdog load register is prohibited
    assign error_signal = (write_enable & reserved_write_address) || 
                          (read_enable & reserved_read_address) || 
                          (write_enable & (PADDR[11:2] == 10'h0) & (PWDATA == 32'b0));

    always_ff @(posedge PCLK or negedge PRESETn)
    begin
      if(!PRESETn)
          current_state <= IDLE;
      else
        current_state <= next_state;
    end

    always_comb
    begin
      PREADY = 1'b1;
      PSLVERR = 1'b0;
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
          PREADY = 1'b0;
          next_state = ERROR;
        end
        ERROR: 
        begin
          PSLVERR = 1'b1;
          next_state = IDLE;
        end
      endcase
    end
  //============================================================================
  // Output data generation
  //============================================================================
    // Zero data is used as padding for other register reads

      always_comb
      begin : p_frc_data_comb
        frc_data = {32{1'b0}}; // Drive zeros by default
        if ((~PWRITE) && frc_sel && ~PSLVERR)
        begin
          case (PADDR)
            `ARM_WDOGLOADA    : frc_data = wdog_load;               // wdog_load address
            `ARM_WDOGVALUEA   : frc_data = count_read;              // WdogValue address
            `ARM_WDOGCONTROLA : frc_data[1:0] = wdog_control[1:0];  // wdog_control address
            `ARM_WDOGINTRAWA  : frc_data[0] = read_wdog_ris;        // wdog_ris address
            `ARM_WDOGINTA     : frc_data[0] = wdog_mis;             // wdog_mis address
            default           : frc_data = {32{1'b0}};
          endcase
        end
        else
          frc_data = {32{1'b0}};
      end

      // Selects output data from address bus.
      always_comb
        begin : p_prdata_next_comb
          if(read_enable)
          begin: p_prdata_next_comb
            prdata_next =
                ((PADDR[11:5]==`ARM_WDOG1A)? frc_data : {32{1'b0}})|
                ((PADDR[11:5]==`ARM_WDOGLA)? {{31{1'b0}},wdog_lock}: {32{1'b0}})|
                ((PADDR[11:5]==`ARM_WDOGIA)? {{31{1'b0}},wdog_itcr}: {32{1'b0}})|
                (((PADDR[11:5]==`ARM_WDOGPA1)|
                (PADDR[11:5]==`ARM_WDOGPA2))?  {{24{1'b0}}, wdog_pdata} : {32{1'b0}});
          end: p_prdata_next_comb
          else
          begin
            prdata_next = {32{1'b0}};
          end
        end

      // Register used to reduce output delay during reads.
      always_ff @ (posedge PCLK or negedge PRESETn)
        begin : p_i_prdata_seq
          if (PRESETn == 1'b0)
            i_prdata <= {32{1'b0}};
          else
            i_prdata <= prdata_next;
        end

      // Drive output with internal version.
      assign PRDATA = i_prdata;
  //============================================================================
endmodule
