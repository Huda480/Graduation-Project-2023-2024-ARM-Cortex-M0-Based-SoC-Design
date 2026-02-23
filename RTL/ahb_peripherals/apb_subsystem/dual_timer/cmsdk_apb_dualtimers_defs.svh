//==============================================================================
// Purpose: Dual timer APB peripheral header
// Used in: cmsdk_apb_dualtimers
//==============================================================================

//------------------------------------------------------------------------------
// Timer register addresses
//------------------------------------------------------------------------------

// Timer base address prefixes
`define ARM_TIMER1A       7'b0000000
`define ARM_TIMER2A       7'b0000001
`define ARM_TIMER3A       7'b0000010
`define ARM_TIMER4A       7'b0000011

// Integration Test register base address
`define ARM_TIMERIA       7'b1111000
// Peripheral and PrimeCell register base address
`define ARM_TIMERP0A      7'b1111110
`define ARM_TIMERP1A      7'b1111111

// Integration Test register and ID registers base address
//`define ARM_TIMERIA       4'b1111

// Register addresses for use by Frcs
`define ARM_TIMERLOADA    3'b000
`define ARM_TIMERVALUEA   3'b001
`define ARM_TIMERCONTROLA 3'b010
`define ARM_TIMERCLEARA   3'b011
`define ARM_TIMERINTRAWA  3'b100
`define ARM_TIMERINTA     3'b101
`define ARM_TIMERLOADBGA  3'b110

// Peripheral and PrimeCell ID registers addresses
`define ARM_TIMERITCRA    6'b000000
`define ARM_TIMERITOPA    6'b000001
`define ARM_TPERIPHID4A   4'b0100
`define ARM_TPERIPHID5A   4'b0101
`define ARM_TPERIPHID6A   4'b0110
`define ARM_TPERIPHID7A   4'b0111
`define ARM_TPERIPHID0A   4'b1000
`define ARM_TPERIPHID1A   4'b1001
`define ARM_TPERIPHID2A   4'b1010
`define ARM_TPERIPHID3A   4'b1011
`define ARM_TPCELLID0A    4'b1100
`define ARM_TPCELLID1A    4'b1101
`define ARM_TPCELLID2A    4'b1110
`define ARM_TPCELLID3A    4'b1111

// Dualtimer reset macros
`define ARM_TIMERITCR_RESET     1'b0
`define ARM_TIMERITOP_RESET     2'b00
`define ARM_TIMERLOAD_RESET     32'h0000_0000
`define ARM_TIMERCTRL75_RESET   3'b001
`define ARM_TIMERCTRL30_RESET   4'b0000

// --========================= End ===========================================--
