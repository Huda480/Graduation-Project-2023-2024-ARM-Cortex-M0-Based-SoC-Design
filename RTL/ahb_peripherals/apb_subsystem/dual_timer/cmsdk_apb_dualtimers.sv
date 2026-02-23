//==============================================================================
// Purpose: Dual Timers APB peripheral
// Used in: cmsdk_apb_subsystem
//==============================================================================
//------------------------------------------------------------------------------
//
//                       Timers
//                       ======
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
// The Timers module is a reference design of an APB-based slave which forms
//  a hardware mechanism to generate timed interrupts.
//
// The Timers module has the following features:
//
//  * Flexible clocking scheme.
//  * Configurable 16 or 32-bit free-running down-counter with an 8-bit
//     prescaler (two instances).
//
//    For each timer channel:
//
//    * Independent clock enable signal.
//    * Three modes of operation: one-shot, periodic and free-running.
//    * Period load register and Background load register.
//    * Control register for mode, size and prescale configuration,
//       including an interrupt enable mask.
//    * Interrupt status register.
//    * Interrupt clear register.
//    * Interrupt generation with separate output.
//
//  * Combined interrupt signal for interrupt controllers.
//  * Common Integration Test registers.
//  * PrimeCell and Peripheral ID registers.
//
// Module Address Map
// ==================
//
// For information about the address map for this module, please refer to
//  the constants defined in the apb_dualtimers_defs.v include file and also the
//  appropriate section of the Technical Reference Manual.
//
//------------------------------------------------------------------------------

//==============================================================================
// Register File
//==============================================================================
  // -----------------------------------------------------------------------
  // Register name            |      Address      |  P |  Reset Value | Size |
  // -----------------------------------------------------------------------
  // 1)   TIMER1LOAD          |   Base + 0x000    | RW |  0x000_0000  |  32  |
  // 2)   TIMER1VALUE         |   Base + 0x004    | RO |  0xFFFF_FFFF |  32  |
  // 3)   TIMER1CONTROL       |   Base + 0x008    | RW |  0x20        |  8   |
  // 4)   TIMER1INT_CLR       |   Base + 0x00C    | WO |      NA      |  NA  |
  // 5)   TIMER1RIS           |   Base + 0x010    | RO |      0x0     |  1   |
  // 6)   TIMER1MIS           |   Base + 0x014    | RO |      0x0     |  1   |
  // 7)   TIMER1BGLOAD        |   Base + 0x018    | RW |  0x0000_0000 |  32  |
  // 8)   TIMER2LOAD          |   Base + 0x020    | RW |  0x000_0000  |  32  |
  // 9)   TIMER2VALUE         |   Base + 0x024    | RO |  0xFFFF_FFFF |  32  |
  // 10)  TIMER2CONTROL       |   Base + 0x028    | RW |  0x20        |  8   |
  // 11)  TIMER2INT_CLR       |   Base + 0x02C    | WO |      NA      |  NA  |
  // 12)  TIMER2RIS           |   Base + 0x030    | RO |      0x0     |  1   |
  // 13)  TIMER2MIS           |   Base + 0x034    | RO |      0x0     |  1   |
  // 14)  TIMER2BGLOAD        |   Base + 0x038    | RW |  0x0000_0000 |  32  |
  // 15)  TIMERITCR           |   Base + 0xF00    | RW |      0x0     |  1   |
  // 16)  TIMERITOP           |   Base + 0xF04    | WO |      0x0     |  2   |
  // 17)  TIMERPERIPHID4      |   Base + 0xFD0    | RO |      0x04    |  8   |
  // 18)  TIMERPERIPHID5      |   Base + 0xFD4    | RO |      0x00    |  8   |
  // 19)  TIMERPERIPHID6      |   Base + 0xFDC    | RO |      0x00    |  8   |
  // 20)  TIMERPERIPHID0      |   Base + 0xFE0    | RO |      0x00    |  8   |
  // 21)  TIMERPERIPHID1      |   Base + 0xFE4    | RO |      0x00    |  8   |
  // 22)  TIMERPERIPHID2      |   Base + 0xFE8    | RO |      0x00    |  8   |
  // 23)  TIMERPERIPHID3      |   Base + 0xFEC    | RO |      0x00    |  8   |
  // 24)  TIMERPCELLID0       |   Base + 0xFF0    | RO |      0x0D    |  8   |
  // 25)  TIMERPCELLID1       |   Base + 0xFF4    | RO |      0xF0    |  8   |
  // 26)  TIMERPCELLID2       |   Base + 0xFF8    | RO |      0x05    |  8   |
  // 27)  TIMERPCELLID3       |   Base + 0xFFC    | RO |      0xB1    |  8   |

//==============================================================================
// Module declaration
//==============================================================================

module cmsdk_apb_dualtimers import apb_pkg::*;
 (
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
    input  wire             TIMCLK,      // Timer clock
    input  wire             TIMCLKEN1,   // Timer clock enable 1
    input  wire             TIMCLKEN2,   // Timer clock enable 2
    //==========================================================================
    // APB Interface
    //==========================================================================
    input  wire             PCLK,        // APB clock
    input  wire             PRESETn,     // APB reset
    input  wire             PENABLE,     // APB enable
    input  wire             PSEL,        // APB periph select
    input  wire [11:2]      PADDR,       // APB address bus
    input  wire             PWRITE,      // APB write
    input  wire [31:0]      PWDATA,      // APB write data
    output wire [31:0]      PRDATA,      // APB read data
    output reg              PSLVERR,     // APB error 
    output reg              PREADY,      // APB ready
    //==========================================================================
    // Custom IP signals
    //==========================================================================
    input  wire  [3:0]      ECOREVNUM,   // ECO revision number
    //==========================================================================
    // Interrupts
    //==========================================================================
    output wire             TIMINT1,     // Counter 1 interrupt
    output wire             TIMINT2,     // Counter 2 interrupt
    output wire             TIMINTC);    // Counter combined interrupt
//============================================================================
// Macro inclusion
//============================================================================
`include "cmsdk_apb_dualtimers_defs.svh"


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Internal Signals
  wire              frc_sel1;         // FRC1 select (address decoding)
  wire              frc_sel2;         // FRC2 select (address decoding)
  wire [31:0]       frc_data1;        // FRC1 data out
  wire [31:0]       frc_data2;        // FRC2 data out
  reg  [7:0]        timer_id_mux;     // Peripheral/PrimeCell data out
  reg  [31:0]       prdata_next;      // Internal PRDATA
  reg  [31:0]       i_prdata;         // Regd prdata_next
  wire              timer_itcr_wr_en; // Write enable for Integration Test
                                      // Control Register
  reg               timer_itcr;       // Integration Test Control Register
  wire              timer_itop_wr_en; // Write enable for Integration Test
                                      // Output Set Register
  reg  [1:0]        timer_itop;       // Integration Test Output Set Register
  wire              i_frc_int1;       // Counter 1 interrupt
  wire              i_frc_int1_mux;   // Counter 1 irq mux with integration test
  wire              i_frc_int2;       // Counter 2 interrupt
  wire              i_frc_int2_mux;   // Counter 2 irq mux with integration test
  wire              write_enable;
  wire              read_enable ;
  states_t          current_state;
  states_t          next_state;



  //============================================================================
  // Main Controls
  //============================================================================  
  
  // FRC selection process
  assign frc_sel1 = (PSEL & (PADDR [11:5] == `ARM_TIMER1A)) ? 1'b1 : 1'b0;
  assign frc_sel2 = (PSEL & (PADDR [11:5] == `ARM_TIMER2A)) ? 1'b1 : 1'b0;

  // Write enable and read enable
  assign write_enable = PSEL & PWRITE & ~PENABLE;
  assign read_enable =  PSEL & ~PWRITE & ~PENABLE;
  
  // Write enable for Integration Test
  assign timer_itcr_wr_en = (PADDR[11:2] == {4'hF,`ARM_TIMERITCRA}) ? (write_enable) : 1'b0;
  assign timer_itop_wr_en = (PADDR[11:2] == {4'hF,`ARM_TIMERITOPA}) ? (write_enable) : 1'b0;

  always_ff @ (posedge PCLK or negedge PRESETn)
    begin : p_itcr_seq
      if (~PRESETn)
        timer_itcr <= `ARM_TIMERITCR_RESET;
      else
        if (timer_itcr_wr_en)
          timer_itcr <= PWDATA[0];
    end

  always_ff @ (posedge PCLK or negedge PRESETn)
    begin : p_itop_seq
      if (~PRESETn)
        timer_itop <= `ARM_TIMERITOP_RESET;
      else
        if (timer_itop_wr_en)
          timer_itop <= PWDATA[1:0];
    end

  //============================================================================
  // Error generation
  //============================================================================
  assign reserved_write_address = ((PADDR[11:2] >= 10'h3F4)|| (PADDR[11:2] == 10'h4) || (PADDR[11:2] == 10'h5) || (PADDR[11:2] == 10'h1) || (PADDR[11:2] == 10'h9) || (PADDR[11:2] == 10'hC) || (PADDR[11:2] == 10'hD))? 1'b1 : 1'b0;
  assign reserved_read_address = ((PADDR[11:2] == 10'h3) || (PADDR[11:2] == 10'h3C1) || (PADDR[11:2] == 10'hB))? 1'b1 : 1'b0;
  assign error_signal = (write_enable && reserved_write_address) || 
                        (read_enable && reserved_read_address) || 
                        (write_enable & (~(|PWDATA)) & ((PADDR[11:2] == 10'h0) | (PADDR[11:2] == 10'h8) |(PADDR[11:2] == 10'h6) | (PADDR[11:2] == 10'hE))) || 
                        (write_enable & ((PADDR[11:2] == 10'h2) | (PADDR[11:2] == 10'hA)) && (PWDATA[3:2] == 2'b11 ));

  always_ff @(posedge PCLK or negedge PRESETn)
  begin
    if(~PRESETn)
      begin
        current_state <= IDLE;
      end
    else
    begin
      current_state <= next_state;
    end
  end

  always_comb
  begin
    PREADY = 1'b1;
    PSLVERR = 1'b0;
    next_state = current_state;

    case(current_state)
      IDLE: begin:idle_state
      if(error_signal)
      begin
        next_state = NOT_READY;
      end
      else
      begin
        next_state = IDLE;
      end
      end:idle_state

      NOT_READY: begin:not_ready_state
        PREADY = 1'b0;
        next_state = ERROR;
      end:not_ready_state

      ERROR: begin:error_state
        PSLVERR = 1'b1;
        next_state = IDLE;
      end:error_state

    endcase
  end

//==========================================================================
// PID & CID Registers
//==========================================================================
  //========================================================================
  // Address decoding stage
  //========================================================================  
  always_comb
  begin : p_timer_id_mux_comb
  if(read_enable)
    begin
        if (PADDR[7:6] == 2'b11) begin
          case (PADDR[5:2])
          `ARM_TPERIPHID4A:  timer_id_mux = 8'h04;
          `ARM_TPERIPHID5A:  timer_id_mux = 8'h00;
          `ARM_TPERIPHID6A:  timer_id_mux = 8'h00;
          `ARM_TPERIPHID7A:  timer_id_mux = 8'h00;
          `ARM_TPERIPHID0A:  timer_id_mux = 8'h23;
          `ARM_TPERIPHID1A:  timer_id_mux = 8'hB8;
          `ARM_TPERIPHID2A:  timer_id_mux = 8'h1B;
          `ARM_TPERIPHID3A:  timer_id_mux = {ECOREVNUM, 4'h0};
          `ARM_TPCELLID0A:   timer_id_mux = 8'h0D;
          `ARM_TPCELLID1A:   timer_id_mux = 8'hF0;
          `ARM_TPCELLID2A:   timer_id_mux = 8'h05;
          `ARM_TPCELLID3A:   timer_id_mux = 8'hB1;
          default: timer_id_mux = {8{1'b0}};
         endcase
       end
       else 
       begin
          timer_id_mux = {8{1'b0}};
       end
    end
    else
    begin
       timer_id_mux = {8{1'b0}};
    end
  end
  
  //============================================================================
  // Output data generation
  //============================================================================
  always_comb
  begin : p_prdata_next_comb
    if (read_enable)
      case (PADDR[11:5])
        `ARM_TIMER1A : prdata_next      = frc_data1;
        `ARM_TIMER2A : prdata_next      = frc_data2;
        `ARM_TIMER3A : prdata_next      = {32{1'b0}}; // FRC3 not implemented
        `ARM_TIMER4A : prdata_next      = {32{1'b0}}; // FRC4 not implemented
        `ARM_TIMERIA : prdata_next      = {{31{1'b0}}, timer_itcr};
        `ARM_TIMERP0A,
        `ARM_TIMERP1A: prdata_next      = {{24{1'b0}}, timer_id_mux};
        default      : prdata_next      = {32{1'b0}};
      endcase
    else
      prdata_next = {32{1'b0}};
  end

  // Register used to reduce output delay during reads.
  always_ff @ (negedge PRESETn or posedge PCLK)
  begin : p_i_prdata_seq
    if (~PRESETn)
      i_prdata <= {32{1'b0}};
    else
      i_prdata <= prdata_next;
  end

  // Drive output with internal version.
  assign PRDATA = i_prdata;

  // Drive Interrupt outputs
  // TIMINT1 and TIMINT2 can be forced directly from the Test Integration
  //  registers.
  assign i_frc_int1_mux = ((timer_itcr == 1'b0) ? i_frc_int1 : timer_itop[0]);

  assign TIMINT1 = i_frc_int1_mux;

  assign i_frc_int2_mux = ((timer_itcr == 1'b0) ? i_frc_int2 : timer_itop[1]);

  assign TIMINT2 = i_frc_int2_mux;

  // TIMINTC is the logical OR of the final interrupts from each individual
  // free running counter.
  assign TIMINTC = (i_frc_int1_mux | i_frc_int2_mux);
  
//------------------------------------------------------------------------------
// Free running counter blocks
//------------------------------------------------------------------------------
  cmsdk_apb_dualtimers_frc u_apb_timer_frc_1
    (.PCLK     (PCLK),
     .PRESETn  (PRESETn),
     .PENABLE  (PENABLE),
     .PADDR    (PADDR[4:2]),
     .PWRITE   (PWRITE),
     .PWDATA   (PWDATA),
     .frc_sel  (frc_sel1),
     .TIMCLK   (TIMCLK),
     .PSLVERR(PSLVERR),
     .TIMCLKEN (TIMCLKEN1),
     .frc_int  (i_frc_int1),
     .data_out (frc_data1)
    );

  cmsdk_apb_dualtimers_frc u_apb_timer_frc_2
    (.PCLK     (PCLK),
     .PRESETn  (PRESETn),
     .PENABLE  (PENABLE),
     .PADDR    (PADDR[4:2]),
     .PWRITE   (PWRITE),
     .PWDATA   (PWDATA),
     .frc_sel  (frc_sel2),
     .TIMCLK   (TIMCLK),
     .PSLVERR(PSLVERR),
     .TIMCLKEN (TIMCLKEN2),
     .frc_int  (i_frc_int2),
     .data_out (frc_data2)
    );

endmodule

// --============================ End ========================================--

