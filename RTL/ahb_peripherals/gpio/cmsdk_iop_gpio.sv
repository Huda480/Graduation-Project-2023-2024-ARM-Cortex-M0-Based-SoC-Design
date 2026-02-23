//==============================================================================
// Purpose: Simple IOP GPIO
// Used in: cmsdk_ahb_gpio.sv
//==============================================================================
//
// Overview
// ========
//
// The AHB GPIO, is a general purpose I/O interface unit. It provides a up to 32 I/O 
// interface with the following properties: 
// programmable interrupt generation capability
// bit masking support using address values
// registers for alternate function switching with pin multiplexing support
// thread safe operation by providing separate set and clear addresses for control registers
// inputs are sampled using a double flip-flop to avoid meta-stability issues. 
//
//==============================================================================
// Register File
//==============================================================================
  // -------------------------------------------------------------------
  // Register name               |      Address              |  P |  Reset Value     | Size |
  // -------------------------------------------------------------------
  // 1)  DATA                    |   Base + 0x0000           | RW |      0x0000      |  16  |
  // 2)  DATA_OUT                |   Base + 0x0004           | RW |      0x0000      |  16  |
  // 3)  OUTENSET                |   Base + 0x0010           | RW |      0x0000      |  16  |
  // 4)  OUTENCLR                |   Base + 0x0014           | RW |      0x0000      |  16  |
  // 5)  ALTFUNCSET              |   Base + 0x0018           | RW |      0x0000      |  16  |
  // 6)  ALTFUNCCLR              |   Base + 0x001C           | RW |      0x0000      |  16  |
  // 7)  INTENSET                |   Base + 0x0020           | RW |      0x0000      |  16  |
  // 8)  INTENCLR                |   Base + 0x0024           | RW |      0x0000      |  16  |
  // 9)  INTTYPESET              |   Base + 0x0028           | RW |      0x0000      |  16  |
  // 10) INTTYPECLR              |   Base + 0x002C           | RW |      0x0000      |  16  |
  // 11) INTPOLSET               |   Base + 0x0030           | RW |      0x0000      |  16  |
  // 12) INTPOLCLR               |   Base + 0x0034           | RW |      0x0000      |  16  |
  // 13) INTCLEAR                |   Base + 0x0038           | WO |      0x0000      |  16  |
  // 14) INTSTATUS               |   Base + 0x0038           | RO |      0x0000      |  16  |
  // 15) ALTFUNCNUMSET           |   Base + 0x003C           | RW |      0x0000      |  32  |
  // 16) ALTFUNCNUMCLR           |   Base + 0x0040           | RW |      0x0000      |  32  |
  // 17) MASKLOWBYTE             |   Base + 0x0400-0x07FC    | RW |      0x0000      |  16  |
  // 18) MASKHIGHBYTE            |   Base + 0x0800-0x0BFC    | RW |      0x0000      |  16  |
  // 19) PID4                    |   Base + 0x0FD0           | RO |      0x04        |  8   |
  // 20) PID5                    |   Base + 0x0FD4           | RO |      0x00        |  -   |
  // 21) PID6                    |   Base + 0x0FD8           | RO |      0x00        |  -   |
  // 22) PID7                    |   Base + 0x0FDC           | RO |      0x00        |  -   |
  // 23) PID0                    |   Base + 0x0FE0           | RO |      0x20        |  8   |
  // 24) PID1                    |   Base + 0x0FE4           | RO |      0xB8        |  8   |
  // 25) PID2                    |   Base + 0x0FE8           | RO |      0x0B        |  8   |
  // 26) PID3                    |   Base + 0x0FEC           | RO |      0x00        |  8   |
  // 27) CID0                    |   Base + 0x0FF0           | RO |      0x0D        |  8   |
  // 28) CID1                    |   Base + 0x0FF4           | RO |      0xF0        |  8   |
  // 29) CID2                    |   Base + 0x0FFC           | RO |      0x05        |  8   |
  // 30) CID3                    |   Base + 0x0FFC           | RO |      0xB1        |  8   |
  // -------------------------------------------------------------------
//==============================================================================
// Module declaration
//==============================================================================

module cmsdk_iop_gpio import ahb_pkg::*;
 #(// Parameter to define valid bit pattern for Alternate functions
   // If an I/O pin does not have alternate function its function mask
   // can be set to 0 to reduce gate count.
   //
   // By default every bit can have alternate function
   parameter int  ALTERNATE_FUNC_MASK    = 16'hFFFF,

   // Default alternate function settings
   parameter int  ALTERNATE_FUNC_DEFAULT = 16'h0000,

   // By default use little endian
   parameter int  BE                     = 0,

   // The GPIO width by default is 16-bit, but is coded in a way that it is
   // easy to customise the width.
   parameter int  PORTWIDTH              = 16'd16,
   // number of alternate functions per pin
   parameter int  ALTFUNC                =  4

  )
  (
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
    input wire                                           FCLK,       // Free-running clock
    input wire                                           HCLK,       // System clock
    input wire                                           HRESETn,    // System reset
    //==========================================================================
    // GPIO Signals
    //==========================================================================
    input  wire                                            IOSEL,      // Decode for peripheral
    input  wire  [11:0]                                    IOADDR,     // I/O transfer address
    input  wire                                            IOWRITE,    // I/O transfer direction
    input  wire  [1:0]                                     IOSIZE,     // I/O transfer size
    input  wire                                            IOTRANS,    // I/O transaction
    input  wire  [31:0]                                    IOWDATA,    // I/O write data bus
    input  wire  [PORTWIDTH-1:0]                           PORTIN,     // GPIO Interface input                
    output wire  [31:0]                                    IORDATA,    // I/0 read data bus
    output reg                                             GRESP,
    output reg                                             GREADY,
    output wire [PORTWIDTH-1:0]                            PORTOUT,    // GPIO output
    output wire [PORTWIDTH-1:0]                            PORTEN,     // GPIO output enable
    output wire [PORTWIDTH-1:0]                            PORTFUNC,   // Alternate function control
    output wire [PORTWIDTH*$clog2(ALTFUNC)-1:0]            ALT_FUNC,   // Alternate function selector
    //==========================================================================
    // Interrupts
    //==========================================================================
    output wire [PORTWIDTH-1:0]                           GPIOINT,    // Interrupt output for each pin
    output wire                                           COMBINT,
    //==========================================================================
    // Custom IP signals
    //==========================================================================
   
    input wire  [3:0]                                     ECOREVNUM
    //==========================================================================
  );  

//============================================================================
// Local Parameters
//============================================================================
  localparam int  ARM_CMSDK_IOP_GPIO_PID0        = {32'h00000020}; // 0xFE0 : PID 0 IOP GPIO part number[7:0]
  localparam int  ARM_CMSDK_IOP_GPIO_PID1        = {32'h000000B8}; // 0xFE4 : PID 1 [7:4] jep106_id_3_0. [3:0] part number [11:8]
  localparam int  ARM_CMSDK_IOP_GPIO_PID2        = {32'h0000001B}; // 0xFE8 : PID 2 [7:4] revision, [3] jedec_used. [2:0] jep106_id_6_4
  localparam int  ARM_CMSDK_IOP_GPIO_PID3        = {32'h00000000}; // 0xFEC : PID 3
  localparam int  ARM_CMSDK_IOP_GPIO_PID4        = {32'h00000004}; // 0xFD0 : PID 4
  localparam int  ARM_CMSDK_IOP_GPIO_PID5        = {32'h00000000}; // 0xFD4 : PID 5
  localparam int  ARM_CMSDK_IOP_GPIO_PID6        = {32'h00000000}; // 0xFD8 : PID 6
  localparam int  ARM_CMSDK_IOP_GPIO_PID7        = {32'h00000000}; // 0xFDC : PID 7
  localparam int  ARM_CMSDK_IOP_GPIO_CID0        = {32'h0000000D}; // 0xFF0 : CID 0
  localparam int  ARM_CMSDK_IOP_GPIO_CID1        = {32'h000000F0}; // 0xFF4 : CID 1 PrimeCell class
  localparam int  ARM_CMSDK_IOP_GPIO_CID2        = {32'h00000005}; // 0xFF8 : CID 2
  localparam int  ARM_CMSDK_IOP_GPIO_CID3        = {32'h000000B1}; // 0xFFC : CID 3
  localparam int sel_bits = $clog2(ALTFUNC);
  // Calculate the total number of bits required
  localparam int total_bits = PORTWIDTH * sel_bits;
  // Calculate the number of 32-bit registers needed
  localparam int num_registers = (total_bits / 32) + ((total_bits % 32) != 0 ? 1 : 0);
  localparam int start_address  = 32'h003C; // Starting address for register writes
  localparam int clear_address  = 32'h0040; // Clearing address for register writes
  localparam int address_offset = 32'h0008; // Offset between addresses for each register

//============================================================================
// Internal signals
//============================================================================
  wire   [PORTWIDTH-1:0]            new_raw_int;  // carrying configuration of interrupt
  wire                              bigendian;
  reg    [31:0]                     iodatale;    // Little endian version of IOWDATA
    
  reg    [PORTWIDTH-1:0]            reg_in_sync1; // Signals for input double flop-flop synchroniser
  reg    [PORTWIDTH-1:0]            reg_in_sync2; // Signals for input double flop-flop synchroniser
  
  reg    [31:0]                     read_mux;
  reg    [31:0]                     read_mux_le;
  wire   [31:0]                     reg_datain32;
  wire   [PORTWIDTH-1:0]            reg_datain;
  wire   [PORTWIDTH-1:0]            reg_dout;     // Output pin register
  wire   [PORTWIDTH-1:0]            reg_douten;   // Port enable register
  wire   [PORTWIDTH-1:0]            reg_altfunc;  // Alternate function register
  wire   [PORTWIDTH-1:0]            reg_inten;    // Interrupt enable
  wire   [PORTWIDTH-1:0]            reg_inttype;  // Interrupt edge(1)/level(0)
  wire   [PORTWIDTH-1:0]            reg_intpol;   // Interrupt active level
  wire   [PORTWIDTH-1:0]            reg_intstat;  // interrupt status
          
  reg    [31:0]                     registers             [num_registers - 1:0];
  reg    [31:0]                     current_start_address [num_registers-1:0];
  reg    [31:0]                     current_clear_address [num_registers-1:0];
  wire   [total_bits-1:0]           total_regs;
  wire   [(32*num_registers) - 1:0] temp_regs;

  wire   [32:0]                     current_dout_padded;
  wire   [PORTWIDTH-1:0]            nxt_dout_padded;
  reg    [PORTWIDTH-1:0]            reg_dout_padded;

  wire                              reg_dout_normal_write0;
  wire                              reg_dout_normal_write1;
  wire                              reg_dout_masked_write0; 
  wire                              reg_dout_masked_write1; 

  reg     [PORTWIDTH-1:0]           reg_douten_padded;
  integer                           loop1;              // loop variable for register
  wire    [PORTWIDTH-1:0]           reg_doutenclr;
  wire    [PORTWIDTH-1:0]           reg_doutenset;

  reg     [PORTWIDTH-1:0]           reg_altfunc_padded;
  reg     [31:0]                    reg_altfuncsel_padded;
  integer                           loop2;              // loop variable for register
  wire    [PORTWIDTH-1:0]           reg_altfuncset;
  wire    [PORTWIDTH-1:0]           reg_altfuncclr;
  wire    [31:0]                    reg_altfuncselset;
  wire    [31:0]                    reg_altfuncselclr;

  reg     [PORTWIDTH-1:0]           reg_inten_padded;
  integer                           loop3;              // loop variable for register
  wire    [PORTWIDTH-1:0]           reg_intenset;
  wire    [PORTWIDTH-1:0]           reg_intenclr;

  reg     [PORTWIDTH-1:0]           reg_inttype_padded;
  integer                           loop4;              // loop variable for register
  wire    [PORTWIDTH-1:0]           reg_inttypeset;
  wire    [PORTWIDTH-1:0]           reg_inttypeclr;

  reg     [PORTWIDTH-1:0]           reg_intpol_padded;
  integer                           loop5;              // loop variable for register
  wire    [PORTWIDTH-1:0]           reg_intpolset;
  wire    [PORTWIDTH-1:0]           reg_intpolclr;

  reg     [PORTWIDTH-1:0]           reg_intstat_padded;
  integer                           loop6;              // loop variable for register
  wire    [PORTWIDTH-1:0]           reg_intclr_padded;
  wire                              reg_intclr_normal_write0;
  wire                              reg_intclr_normal_write1;

  reg     [PORTWIDTH-1:0]           reg_last_datain; // last state of synchronized input
  wire    [PORTWIDTH-1:0]           high_level_int;
  wire    [PORTWIDTH-1:0]           low_level_int;
  wire    [PORTWIDTH-1:0]           rise_edge_int;
  wire    [PORTWIDTH-1:0]           fall_edge_int;

  wire    [PORTWIDTH-1:0]           new_masked_int;

  wire                              write_trans  = IOSEL & IOWRITE & IOTRANS;
  wire    [1:0]                     iop_byte_strobe;

  states_t                          current_state;
  states_t                          next_state;

  genvar f;
  genvar i;


  //============================================================================
  // Alternate Function Selection Calculation
  //============================================================================    

    // Calculate the number of selection bits per port based on ALTFUNC
    // Manage writes to the registers based on the input address
    // Generate block that iterates through each register
  generate
      for (i = 0; i < num_registers; i = i + 1) begin: register_management
          always_ff @(posedge HCLK or negedge HRESETn) 
          begin
              if (!HRESETn) 
              begin
                  // Clear the current register on reset
                  registers[i] <= 32'd0;
                  current_start_address[i] <= 'b0;
                  current_clear_address[i] <= 'b0;
              end 
              else 
              begin
                  // Calculate the current register's start and clear addresses
                  current_start_address[i] <= start_address + (i << 3);
                  current_clear_address[i] <= clear_address + (i << 3);
                  // Manage the current register based on IOADDR
                  if (IOADDR == current_start_address[i]) 
                  begin
                      // Write IOWDATA to the current register when address matches start address
                      registers[i] <= IOWDATA;
                  end 
                  else if (IOADDR == current_clear_address[i]) 
                  begin
                      // Clear the current register when address matches clear address
                      registers[i] <= 32'd0;
                  end
              end
          end
      end
  endgenerate

  generate
      for (f = 0; f < num_registers; f = f + 1) begin : concatenate_loop
          // Use an assign statement to concatenate each 32-bit register into temp_regs
         assign  temp_regs[(f + 1) * 32 - 1 : f * 32] = registers[f];
      end
  endgenerate

  assign total_regs = temp_regs;
  assign ALT_FUNC = total_regs;

  //============================================================================
  // Byte Strobbing
  //============================================================================

   // Generate byte strobes to allow the GPIO registers to handle different transfer sizes
   assign iop_byte_strobe[0] = (IOSIZE[1] | ((IOADDR[1]==1'b0) & IOSIZE[0]) | (IOADDR[1:0]==2'b00)) & IOSEL;
   assign iop_byte_strobe[1] = (IOSIZE[1] | ((IOADDR[1]==1'b0) & IOSIZE[0]) | (IOADDR[1:0]==2'b01)) & IOSEL;

  //============================================================================
  // Endian Conversion
  //============================================================================
  always_comb
  begin
    if ((bigendian)&(IOSIZE==2'b10))
      begin
      read_mux = {read_mux_le[ 7: 0],read_mux_le[15: 8],
                  read_mux_le[23:16],read_mux_le[31:24]};
      iodatale = {IOWDATA[ 7: 0],IOWDATA[15: 8],IOWDATA[23:16],IOWDATA[ 31:24]};
      end
    else if ((bigendian)&(IOSIZE==2'b01))
      begin
      read_mux = {read_mux_le[23:16],read_mux_le[31:24],
                  read_mux_le[ 7: 0],read_mux_le[15: 8]};
      iodatale = {IOWDATA[23:16],IOWDATA[ 31:24],IOWDATA[ 7: 0],IOWDATA[15: 8]};
      end
    else
      begin
      read_mux = read_mux_le;
      iodatale = IOWDATA;
      end
  end

  assign bigendian = (BE!=0) ? 1'b1 : 1'b0;

  //============================================================================
  // Error generation
  //============================================================================
    // Reserved addresses for write operations
    //These addresses are either non existent in the IP or are read only addresses
    assign reserved_write_address = ((IOADDR == 12'h8)|| (IOADDR == 12'hC) || (IOADDR == 12'hFCF) || (IOADDR >= 12'hFCF))? 1'b1 : 1'b0;

    //This signal defines the error signal
    //This signal combines both the reserved read and write addresses
    //Also contains a condition where writing zero to the wathcdog load register is prohibited
    assign error_signal = (write_trans & reserved_write_address);

    
    always_ff @(posedge HCLK or negedge HRESETn)
    begin
      if(!HRESETn)
          current_state <= IDLE;
      else
        current_state <= next_state;
    end

    always_comb
    begin
      GREADY = 1'b1;
      GRESP = 1'b0;
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
          GRESP = 1'b1;
          GREADY  = 1'b0;
          next_state = ERROR;
        end
        ERROR: 
        begin
          GRESP = 1'b1;
          next_state = IDLE;
        end
      endcase
    end
  //============================================================================
  // Reading registers
  //============================================================================
  
  always_comb
  begin
  case (IOADDR[11:10]) 
    2'b00: begin
           if (IOADDR[9:6]==4'h0)
             case (IOADDR[5:2])
              4'h0      : read_mux_le = reg_datain32;
              4'h1      : read_mux_le = {{32-PORTWIDTH{1'b0}}, reg_dout};
              4'h2, 4'h3: read_mux_le = {32{1'b0}};
              4'h4, 4'h5: read_mux_le = {{32-PORTWIDTH{1'b0}}, reg_douten };
              4'h6, 4'h7: read_mux_le = {{32-PORTWIDTH{1'b0}}, reg_altfunc};
              4'h8, 4'h9: read_mux_le = {{32-PORTWIDTH{1'b0}}, reg_inten  };
              4'hA, 4'hB: read_mux_le = {{32-PORTWIDTH{1'b0}}, reg_inttype};
              4'hC, 4'hD: read_mux_le = {{32-PORTWIDTH{1'b0}}, reg_intpol };
              4'hE      : read_mux_le = {{32-PORTWIDTH{1'b0}}, reg_intstat};
              //4'hF      : read_mux_le = reg_altfuncsel;
              default: read_mux_le = {32{1'bx}}; // X-propagation if address is X
             endcase
           else
             read_mux_le = {32{1'b0}};
           end
    2'b01: begin
           // lower byte mask read
           read_mux_le = {{24{1'b0}}, (reg_datain32[7:0] & IOADDR[9:2])};
           end
    2'b10: begin
           // upper byte mask read
           read_mux_le = {{16{1'b0}}, (reg_datain32[15:8] & IOADDR[9:2]), {8{1'b0}}};
           end
    2'b11: begin
           if (IOADDR[9:6]==4'hF) // Peripheral IDs and Component IDs.
             case (IOADDR[5:2])   // IOP GPIO has part number of 820
              4'h0, 4'h1,
              4'h2, 4'h3: read_mux_le = {32{1'b0}};   // 0xFC0-0xFCC : not used
              4'h4      : read_mux_le = ARM_CMSDK_IOP_GPIO_PID4; // 0xFD0 : PID 4
              4'h5      : read_mux_le = ARM_CMSDK_IOP_GPIO_PID5; // 0xFD4 : PID 5
              4'h6      : read_mux_le = ARM_CMSDK_IOP_GPIO_PID6; // 0xFD8 : PID 6
              4'h7      : read_mux_le = ARM_CMSDK_IOP_GPIO_PID7; // 0xFDC : PID 7
              4'h8      : read_mux_le = ARM_CMSDK_IOP_GPIO_PID0; // 0xFE0 : PID 0 AHB GPIO part number[7:0]
              4'h9      : read_mux_le = ARM_CMSDK_IOP_GPIO_PID1;
                          // 0xFE0 : PID 1 [7:4] jep106_id_3_0. [3:0] part number [11:8]
              4'hA      : read_mux_le = ARM_CMSDK_IOP_GPIO_PID2;
                          // 0xFE0 : PID 2 [7:4] revision, [3] jedec_used. [2:0] jep106_id_6_4
              4'hB      : read_mux_le = {ARM_CMSDK_IOP_GPIO_PID3[31:8],ECOREVNUM[3:0], 4'h0};
                          // 0xFE0  PID 3 [7:4] ECO revision, [3:0] modification number
              4'hC      : read_mux_le = ARM_CMSDK_IOP_GPIO_CID0; // 0xFF0 : CID 0
              4'hD      : read_mux_le = ARM_CMSDK_IOP_GPIO_CID1; // 0xFF4 : CID 1 PrimeCell class
              4'hE      : read_mux_le = ARM_CMSDK_IOP_GPIO_CID2; // 0xFF8 : CID 2
              4'hF      : read_mux_le = ARM_CMSDK_IOP_GPIO_CID3; // 0xFFC : CID 3
              default: read_mux_le = {32{1'bx}}; // X-propagation if address is X
             endcase
           // Note : Customer changing the design should modify
           // - jep106 value (www.jedec.org)
           // - part number (customer define)
           // - Optional revision and modification number (e.g. rXpY)
           else
             read_mux_le = {32{1'b0}};
           end
    default: begin
           read_mux_le = {32{1'bx}}; // X-propagation if address is X
           end
  endcase
  end

  assign IORDATA   = read_mux;
  //============================================================================
  // Synchronize input with double stage flip-flops
  //============================================================================
  always_ff@(posedge FCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      begin
      reg_in_sync1 <= {PORTWIDTH{1'b0}};
      reg_in_sync2 <= {PORTWIDTH{1'b0}};
      end
    else
      begin
      reg_in_sync1 <= PORTIN;
      reg_in_sync2 <= reg_in_sync1;
      end
  end
  assign reg_datain = reg_in_sync2;
  // format to 32-bit for data read
  assign reg_datain32 = {{32-PORTWIDTH{1'b0}},reg_datain};
  //============================================================================
  // Data Output register
  //============================================================================

  // write on output pin using register DATA 0x0000 or register DATAOUT 0x0004
  assign      reg_dout_normal_write0 = write_trans & 
              ((IOADDR[11:2]  == 10'h000)|(IOADDR[11:2]  == 10'h001)) & iop_byte_strobe[0];
  assign      reg_dout_normal_write1 = write_trans & 
              ((IOADDR[11:2]  == 10'h000)|(IOADDR[11:2]  == 10'h001)) & iop_byte_strobe[1];
 // lower part of ports mask since its range is 0x400 - 0x7FC
  assign      reg_dout_masked_write0 = write_trans & 
              (IOADDR[11:10] == 2'b01) & iop_byte_strobe[0]; 
 // upper part of ports mask since its range is 0x800 - 0xBFC
  assign      reg_dout_masked_write1 = write_trans &
              (IOADDR[11:10] == 2'b10) & iop_byte_strobe[1];

  // padding to 33-bit for easier coding
  assign current_dout_padded = {{(33-PORTWIDTH){1'b0}},reg_dout};

  // lower half of ports
  assign nxt_dout_padded[(PORTWIDTH/2)-1:0] = // simple write
     (reg_dout_normal_write0) ? iodatale[(PORTWIDTH/2)-1:0] :
     // write lower port with bit mask
     ((iodatale[(PORTWIDTH/2)-1:0] & IOADDR[9:2])|(current_dout_padded[(PORTWIDTH/2)-1:0] & (~(IOADDR[9:2]))));

  //============================================================================
  // lower half of ports registering stage
  //============================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_dout_padded[(PORTWIDTH/2)-1:0] <= 8'h00;
    else if (reg_dout_normal_write0 | reg_dout_masked_write0) // we can either write using the mask 
                                                              // or we can write using the register itself
                                                               
      reg_dout_padded[(PORTWIDTH/2)-1:0] <= nxt_dout_padded[(PORTWIDTH/2)-1:0];
  end

  // upper half of ports
  assign nxt_dout_padded[PORTWIDTH-1:(PORTWIDTH/2)]  = // simple write
     (reg_dout_normal_write1) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)]  :
     // write higher byte with bit mask
     ((iodatale[PORTWIDTH-1:(PORTWIDTH/2)]  & IOADDR[9:2])|(current_dout_padded[PORTWIDTH-1:(PORTWIDTH/2)]  & (~(IOADDR[9:2]))));

  //============================================================================
  // upper half of ports registering stage
  //============================================================================
  always_ff@(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_dout_padded[PORTWIDTH-1:(PORTWIDTH/2)]  <= 8'h00;
    else if (reg_dout_normal_write1 | reg_dout_masked_write1)// we can either write using the mask 
                                                             // or we can write using the register itself
      
      reg_dout_padded[PORTWIDTH-1:(PORTWIDTH/2)]  <= nxt_dout_padded[PORTWIDTH-1:(PORTWIDTH/2)] ;
  end

  assign reg_dout[PORTWIDTH-1:0] = reg_dout_padded[PORTWIDTH-1:0]; // this register value will be assigned to PORT_OUT

  assign PORTOUT   = reg_dout;
  //============================================================================
  // Output Enable 
  //============================================================================

  // since its address is 0x10
  assign    reg_doutenset[(PORTWIDTH/2)-1:0]   = ((write_trans == 1'b1) & (IOADDR[11:2]  == 10'h004)
                                   & (iop_byte_strobe[0] == 1'b1)) ?  iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign    reg_doutenset[PORTWIDTH-1:(PORTWIDTH/2)]   = ((write_trans == 1'b1) & (IOADDR[11:2]  == 10'h004)
                                   & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)]  : {8{1'b0}};
 // since its address is 0x14
  assign    reg_doutenclr[(PORTWIDTH/2)-1:0]   = ((write_trans == 1'b1) & (IOADDR[11:2]  == 10'h005)
                                   & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign    reg_doutenclr[PORTWIDTH-1:(PORTWIDTH/2)]   = ((write_trans == 1'b1) & (IOADDR[11:2]  == 10'h005)
                                   & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};
  //============================================================================
  // output enable register
  //============================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_douten_padded <= {PORTWIDTH{1'b0}};
    else
      for (loop1 = 0; loop1 < PORTWIDTH; loop1 = loop1 + 1)
      begin
        if (reg_doutenset[loop1] | reg_doutenclr[loop1])
          reg_douten_padded[loop1] <= reg_doutenset[loop1];
      end
  end

  assign reg_douten[PORTWIDTH-1:0] = reg_douten_padded[PORTWIDTH-1:0]; // this value will be assigned to PORT_EN reg

  assign PORTEN    = reg_douten;
  //============================================================================
  // Alternate Function
  //============================================================================

  assign  reg_altfuncset[(PORTWIDTH/2)-1:0]  =  ((write_trans == 1'b1) & (IOADDR[11:2]  == 10'h006)
                                  & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign  reg_altfuncset[PORTWIDTH-1:(PORTWIDTH/2)] =  ((write_trans == 1'b1) & (IOADDR[11:2]  == 10'h006)
                                  & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};

  assign  reg_altfuncclr[(PORTWIDTH/2)-1:0]  =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h007)
                                  & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign  reg_altfuncclr[PORTWIDTH-1:(PORTWIDTH/2)] =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h007)
                                  & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};

  //============================================================================
  // Alternate function register
  //============================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_altfunc_padded <= ALTERNATE_FUNC_DEFAULT;
    else
      for(loop2 = 0; loop2 < PORTWIDTH; loop2 = loop2 + 1)
    begin
        if (reg_altfuncset[loop2] | reg_altfuncclr[loop2])
          reg_altfunc_padded[loop2] <= reg_altfuncset[loop2];
      end
  end
  // this value will be written in ALT_FUNC reg, the anding with parameter int mask is bec its an 
  // enable for the GPIO pins to support or not support ALT_FUNC
  assign reg_altfunc[PORTWIDTH-1:0] = reg_altfunc_padded[PORTWIDTH-1:0] & ALTERNATE_FUNC_MASK; 

  assign PORTFUNC  = reg_altfunc;
  //============================================================================
  // Interrupt enable
  //============================================================================

  assign  reg_intenset[(PORTWIDTH/2)-1:0]    =   ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h008)
                                   & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign  reg_intenset[PORTWIDTH-1:(PORTWIDTH/2)]   =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h008)
                                  & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};

  assign  reg_intenclr[(PORTWIDTH/2)-1:0]    =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h009)
                                  & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign  reg_intenclr[PORTWIDTH-1:(PORTWIDTH/2)]   =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h009)
                                  & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};


  //============================================================================
  // Interrupt enable registering
  //============================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_inten_padded <= {PORTWIDTH{1'b0}};
    else
      for(loop3 = 0; loop3 < PORTWIDTH; loop3 = loop3 + 1)
      begin
        if (reg_intenclr[loop3] | reg_intenset[loop3])
        reg_inten_padded[loop3] <= reg_intenset[loop3];
      end
  end

  assign reg_inten[PORTWIDTH-1:0] = reg_inten_padded[PORTWIDTH-1:0]; 


  //============================================================================
  // Interrupt type
  //============================================================================

  assign  reg_inttypeset[(PORTWIDTH/2)-1:0]  =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h00A)
                                  & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign  reg_inttypeset[PORTWIDTH-1:(PORTWIDTH/2)] =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h00A)
                                  & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};

  assign  reg_inttypeclr[(PORTWIDTH/2)-1:0]  =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h00B)
                                  & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign  reg_inttypeclr[PORTWIDTH-1:(PORTWIDTH/2)] =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h00B)
                                  & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};


  //============================================================================
  // Interrupt type registering
  //============================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_inttype_padded <= {PORTWIDTH{1'b0}};
    else
    for(loop4 = 0; loop4 < PORTWIDTH; loop4 = loop4 + 1)
    begin
      if (reg_inttypeset[loop4] | reg_inttypeclr[loop4])
        reg_inttype_padded[loop4] <= reg_inttypeset[loop4];
      end
  end

  assign reg_inttype[PORTWIDTH-1:0] = reg_inttype_padded[PORTWIDTH-1:0];


  //============================================================================
  // Interrupt polarity 
  //============================================================================


  assign  reg_intpolset[(PORTWIDTH/2)-1:0]   =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h00C)
                                  & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign  reg_intpolset[PORTWIDTH-1:(PORTWIDTH/2)]  =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h00C)
                                  & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};

  assign  reg_intpolclr[(PORTWIDTH/2)-1:0]   =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h00D)
                                  & (iop_byte_strobe[0] == 1'b1)) ? iodatale[(PORTWIDTH/2)-1:0] : {8{1'b0}};

  assign  reg_intpolclr[PORTWIDTH-1:(PORTWIDTH/2)]  =  ((write_trans  == 1'b1) & (IOADDR[11:2]  == 10'h00D)
                                  & (iop_byte_strobe[1] == 1'b1)) ? iodatale[PORTWIDTH-1:(PORTWIDTH/2)] : {8{1'b0}};

  //============================================================================
  // Interrupt polarity registering
  //============================================================================
  always_ff @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_intpol_padded <= {PORTWIDTH{1'b0}};
    else
    for(loop5 = 0; loop5 < PORTWIDTH; loop5 = loop5 + 1)
      begin
      if (reg_intpolset[loop5] | reg_intpolclr[loop5])
          reg_intpol_padded[loop5] <= reg_intpolset[loop5];
      end
  end

  assign reg_intpol[PORTWIDTH-1:0] = reg_intpol_padded[PORTWIDTH-1:0];


  //============================================================================
  // Interrupt status/clear register: reading interrupt statues and clearing interrupt
  //============================================================================

 // clearing interrupt register
  assign      reg_intclr_normal_write0 = write_trans &
              (IOADDR[11:2]  == 10'h00E) & iop_byte_strobe[0];
  assign      reg_intclr_normal_write1 = write_trans &
              (IOADDR[11:2]  == 10'h00E) & iop_byte_strobe[1];

  assign      reg_intclr_padded[(PORTWIDTH/2)-1:0] = {8{reg_intclr_normal_write0}} & iodatale[(PORTWIDTH/2)-1:0];
  assign      reg_intclr_padded[PORTWIDTH-1:(PORTWIDTH/2)] = {8{reg_intclr_normal_write1}} & iodatale[PORTWIDTH-1:(PORTWIDTH/2)];
 // update reg when interrupt is enabled and new_raw_int carries the statues of interrupt
  assign      new_masked_int[PORTWIDTH-1:0] = new_raw_int[PORTWIDTH-1:0] & reg_inten[PORTWIDTH-1:0];

  //===================================================================================
  // registering interrupt clear and interrupt status
  //====================================================================================
  always_ff @(posedge FCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_intstat_padded <= {PORTWIDTH{1'b0}};
    else
      for (loop6=0;loop6<PORTWIDTH;loop6=loop6+1)
        begin
        if (new_masked_int[loop6] | reg_intclr_padded[loop6])
          reg_intstat_padded[loop6] <= new_masked_int[loop6];
        end
  end

  assign reg_intstat[PORTWIDTH-1:0] = reg_intstat_padded[PORTWIDTH-1:0];

  //============================================================================
  // Interrupt generation stage
  //============================================================================
  
  // reg_datain is the synchronized input

  // Last input state for edge detection
  always_ff @(posedge FCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      reg_last_datain <= {PORTWIDTH{1'b0}};
    else  if (|reg_inttype)
      reg_last_datain <= reg_datain;
  end
  
  assign high_level_int =   reg_datain  &                        reg_intpol  & (~reg_inttype);
  assign low_level_int  = (~reg_datain) &                      (~reg_intpol) & (~reg_inttype);
  assign rise_edge_int  =   reg_datain  & (~reg_last_datain) &   reg_intpol  &   reg_inttype;
  assign fall_edge_int  = (~reg_datain) &   reg_last_datain  & (~reg_intpol) &   reg_inttype;
  assign new_raw_int    = high_level_int | low_level_int | rise_edge_int | fall_edge_int;

  // Connect interrupt signal to top level
  assign GPIOINT = reg_intstat;
  assign COMBINT = (|reg_intstat);


    

endmodule