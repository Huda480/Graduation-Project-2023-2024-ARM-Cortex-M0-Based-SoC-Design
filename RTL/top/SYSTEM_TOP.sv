module SYSTEM_TOP 
#(
	//INCLUDES
	parameter int Include_dual_timer = 1,
	parameter int Include_SPI = 1,
	parameter int Include_DMA = 1,
	parameter int Include_WIFI = 0,
	parameter int Include_COMP = 1, // if 1, compression is included, if 0, decompression is included
	//MEMORY PARAMETERS
	parameter int AW = 16,
	parameter GROUP0 = "../../sys_1_bin/group_0.bin",
	parameter GROUP1 = "../../sys_1_bin/group_1.bin",
	parameter GROUP2 = "../../sys_1_bin/group_2.bin",
	parameter GROUP3 = "../../sys_1_bin/group_3.bin",
	//DMA PRAMETERS
	parameter [1:0]	pri_sel  = 2'd2,
	parameter int channel_number = 5,
	parameter int req_number     = 10,
	parameter [1:0] ch_conf [31] = {2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0},
    //GPIO PARAMETERS
	parameter  ALTERNATE_FUNC_DEFAULT = 16'h0000,
	parameter ALTERNATE_FUNC_MASK = 16'hFFFF,
    parameter int  BE = 0,
    parameter int  PORTWIDTH =  16 ,
    parameter int  ALTFUNC   =  4  ,
	//BLUETOOTH PARAMETERS
	parameter int  AD_BLE = 12, 
	parameter int  DATA_BLE = 32, 
	parameter int  MEM_BLE = 256, 
	parameter int  RE_IM_AD_BLE = 13, 
	parameter int  RE_IM_SIZE_BLE = 12, 
	parameter int  RE_IM_MEM_BLE = 8192, 
	parameter int  OFFSET_BLE = 'h10, 
	parameter int  DEPTH_BLE = 4, 
	parameter int  WIDTH_BLE = 32,
	//WIFI PARAMETERS
	parameter int  ADDR_WIFI = 12, 
	parameter int  DATA_WIFI = 32,
	// COMPRESSOR PARAMETERS
	parameter int COMP_OUT_WIDTH = 16,
	parameter int COMP_IN_WIDTH = 8,   
	parameter int COMP_DIM = 8,     
	parameter int COMP_MEM_UNCOMP_DEPTH = 8192,
	parameter int COMP_MEM_COMP_DEPTH = 2560,
	parameter     IMG1 = "../../image/image1.txt"  ,
    parameter     IMG2 = "../../image/image2.txt"  ,
    parameter     IMG3 = "../../image/image3.txt"  ,
    parameter     IMG4 = "../../image/image4.txt"  ,
    parameter     IMG5 = "../../image/image5.txt"  ,
    parameter     IMG6 = "../../image/image6.txt"  ,
    parameter     IMG7 = "../../image/image7.txt"  ,
    parameter     IMG8 = "../../image/image8.txt" 
)
( 
   
	input 						SYS_FCLK,
    input 						RESETn,	
	input 						phy_ble_clk,	
	//UART	
	input 						RXD0,
 	input 						RXD1,
 	output						TXD0,
    output						TXD1,
	output						RTS0,
	output						RTS1,
    input 						CTS0,
	input 						CTS1,
	input 			 			EXTIN,
    //SPI	
	output						M_SCK, // master output
	output						M_MOSI, // master output
	input 						M_MISO,  // master input
	output						S_MISO, // slave output
    input 						S_MOSI, // slave input MOSI
	input 						SS, // slave select input
	input 						S_SCK ,// input clock to slave
    output						SS0, // output master
	output						SS1,
	output						SS2,
	output						SS3,
	//GPIO
	input  [PORTWIDTH-1:0]  	PORTIN,
	output [PORTWIDTH-1:0]		PORTOUT,

	    //DATA FROM OTHER SYSTEM TO RX
    input 						valid_in_mem_re_ble,
    input [RE_IM_SIZE_BLE-1:0] 	data_in_re_to_rx_ble,
    input					    valid_in_mem_im_ble,
    input [RE_IM_SIZE_BLE-1:0] 	data_in_im_to_rx_ble,
    
    //DATA TO OTHER SYSTEM
    output 						valid_out_mem_re_ble,
    output [RE_IM_SIZE_BLE-1:0] data_out_re_to_rx_ble,
    output 						valid_out_mem_im_ble,
    output [RE_IM_SIZE_BLE-1:0] data_out_im_to_rx_ble
    );
   wire HCLK;
   wire TXD0_EN;	
   wire TXD1_EN;

   // Input port SI0 (inputs from cortex)
   wire  [31:0] HADDRS0;        // Address bus
   wire  [1:0] HTRANSS0;        // Transfer type
   wire        HWRITES0;        // Transfer direction
   wire  [2:0] HSIZES0;         // Transfer size
   wire  [2:0] HBURSTS0;        // Burst type
   wire  [3:0] HPROTS0;         // Protection control
   wire [31:0] HWDATAS0;        // Write data
   wire        HMASTLOCKS0;     // Locked Sequence

   // Input port SI0 (outputs to cortex)
   wire [31:0] HRDATAS0;        // Read data bus
   wire        HREADYS0;        // HREADY feedback
   wire        HRESPS0;         // Transfer response

  //output wire        SCANOUTHCLK;


// Output port MI0 (outputs to ISRAM)
    wire        HSELM0;          // Slave Select
    wire [31:0] HADDRM0;         // Address bus
    wire [1:0]  HTRANSM0;        // Transfer type
    wire        HWRITEM0;        // Transfer direction
    wire [2:0]  HSIZEM0;         // Transfer size
    wire [2:0]  HBURSTM0;        // Burst type
    wire [3:0]  HPROTM0;         // Protection control
    wire [31:0] HWDATAM0;        // Write data
    wire [31:0] HRDATAM0;        // Read data
    wire        HMASTLOCKM0;     // Locked Sequence
    wire        HREADYMUXM0;     // Transfer done
    wire        HREADYOUTM0;     // Transfer done
	wire 		HRESPM0;		 //Response signal

	// Output port MI1 (outputs to DSRAM)
    wire        HSELM1;          // Slave Select
    wire [31:0] HADDRM1;         // Address bus
    wire [1:0]  HTRANSM1;        // Transfer type
    wire        HWRITEM1;        // Transfer direction
    wire [2:0]  HSIZEM1;         // Transfer size
    wire [2:0]  HBURSTM1;        // Burst type
    wire [3:0]  HPROTM1;         // Protection control
    wire [31:0] HWDATAM1;        // Write data
    wire [31:0] HRDATAM1;        // Read data
    wire        HMASTLOCKM1;     // Locked Sequence
    wire        HREADYMUXM1;     // Transfer done
    wire        HREADYOUTM1;     // Transfer done
	wire 		HRESPM1;		 //Response signal
	
	// Output port MI2 (outputs to apb_subsystem)
    wire        HSELM2;          // Slave Select
    wire [31:0] HADDRM2;         // Address bus
    wire [1:0]  HTRANSM2;        // Transfer type
    wire        HWRITEM2;        // Transfer direction
    wire [2:0]  HSIZEM2;         // Transfer size
    wire [2:0]  HBURSTM2;        // Burst type
    wire [3:0]  HPROTM2;         // Protection control
    wire [31:0] HWDATAM2;        // Write data
    wire [31:0] HRDATAM2;        // Read data
    wire        HMASTLOCKM2;     // Locked Sequence
    wire        HREADYMUXM2;     // Transfer done
    wire        HREADYOUTM2;     // Transfer done
	wire 		HRESPM2;		 //Response signal

	// Output port MI3 (outputs to GPIO)
    wire        HSELM3;          // Slave Select
    wire [31:0] HADDRM3;         // Address bus
    wire [1:0]  HTRANSM3;        // Transfer type
    wire        HWRITEM3;        // Transfer direction
    wire [2:0]  HSIZEM3;         // Transfer size
    wire [2:0]  HBURSTM3;        // Burst type
    wire [3:0]  HPROTM3;         // Protection control
    wire [31:0] HWDATAM3;        // Write data
    wire [31:0] HRDATAM3;        // Read data
    wire        HMASTLOCKM3;     // Locked Sequence
    wire        HREADYMUXM3;     // Transfer done
    wire        HREADYOUTM3;     // Transfer done
	wire 		HRESPM3;		 //Response signal


	// Output port MI5 (outputs to RCC)
	wire        HSELM5;          // Slave Select
    wire [31:0] HADDRM5;         // Address bus
    wire [1:0]  HTRANSM5;        // Transfer type
    wire        HWRITEM5;        // Transfer direction
    wire [2:0]  HSIZEM5;         // Transfer size
    wire [2:0]  HBURSTM5;        // Burst type
    wire [3:0]  HPROTM5;         // Protection control
    wire [31:0] HWDATAM5;        // Write data
    wire [31:0] HRDATAM5;        // Read data
    wire        HMASTLOCKM5;     // Locked Sequence
    wire        HREADYMUXM5;     // Transfer done
    wire        HREADYOUTM5;     // Transfer done
	wire 		HRESPM5;		 //Response signal

	// Output port MI6 (outputs to PHY_BLE)
    wire        HSELM6;          // Slave Select
    wire [31:0] HADDRM6;         // Address bus
    wire [1:0]  HTRANSM6;        // Transfer type
    wire        HWRITEM6;        // Transfer direction
    wire [2:0]  HSIZEM6;         // Transfer size
    wire [2:0]  HBURSTM6;        // Burst type
    wire [3:0]  HPROTM6;         // Protection control
    wire [31:0] HWDATAM6;        // Write data
    wire [31:0] HRDATAM6;        // Read data
    wire        HMASTLOCKM6;     // Locked Sequence
    wire        HREADYMUXM6;     // Transfer done
    wire        HREADYOUTM6;     // Transfer done
	wire 		HRESPM6;		 //Response signal

	// Output port MI8 (outputs to COMPRESSOR)
    wire        HSELM8;          // Slave Select
    wire [31:0] HADDRM8;         // Address bus
    wire [1:0]  HTRANSM8;        // Transfer type
    wire        HWRITEM8;        // Transfer direction
    wire [2:0]  HSIZEM8;         // Transfer size
    wire [2:0]  HBURSTM8;        // Burst type
    wire [3:0]  HPROTM8;         // Protection control
    wire [31:0] HWDATAM8;        // Write data
    wire [31:0] HRDATAM8;        // Read data
    wire        HMASTLOCKM8;     // Locked Sequence
    wire        HREADYMUXM8;     // Transfer done
    wire        HREADYOUTM8;     // Transfer done
	wire 		HRESPM8;		 //Response signal


	/***************************** Clocks and Resets **********************************/

	wire           PCLK   ;		
	wire           PCLKG  ;
	wire           PRESETn;
	wire           HRESETn;
	wire		   WDOGCLK;
	wire		   TIMCLK;
	wire		   WDOGRESn;

	/***************************** INTERRUPTS **********************************/

	wire  [31:0] irq ;
	wire  [req_number-1:0]    ack_for_req;
	wire  [req_number-1:0]    done_all;
	//wire  [req_number-1:0]    unkown_size_end;

	wire [req_number-1:0] dma_req_i;
	wire [req_number-1:0] dma_ack_o;
	wire [req_number-1:0] dma_done_i;
	wire [5:0]            subsys_dma_req_i;
	wire [5:0] 			  subsys_ack_for_req;
	wire [5:0]            subsys_dma_done_i;
	wire 				  irqa_o;
	wire 				  irqb_o;

	wire rx_dma_ack_ble, tx_dma_ack_ble;
	wire rx_dma_ack_wifi, tx_dma_ack_wifi;
	wire rx_dma_req_ble, tx_dma_req_ble;
	wire rx_dma_req_wifi, tx_dma_req_wifi;

	wire [10:0] subsystem_interrupt ;

	wire [15:0] GPIOINT ;
	wire COMBINT;

	wire        watchdog_interrupt ;
	wire		watchdog_reset ;
	
	wire APB_ACTIVE ;
    wire [(PORTWIDTH*ALTFUNC)-1:0]         ALT_FUNC_IN ;

	wire rx_irq_ble, tx_irq_ble ;
	wire rx_irq_wifi, tx_irq_wifi ;
	wire rx_dma_done_wifi;
	wire tx_dma_done_wifi; 
	wire rx_dma_done_ble; 
	wire tx_dma_done_ble;

	wire          received_image_int;
    wire          full_int;
	 
	// interrupts
	assign irq[0]  = subsystem_interrupt[0] ;   // Timer interrupt
	assign irq[1]  =  tx_irq_ble;
	assign irq[2]  =  rx_irq_ble;
	assign irq[3]  =  tx_irq_wifi;
	assign irq[4]  =  rx_irq_wifi;
	assign irq[5]  = subsystem_interrupt[4] ;  // Uart 0 transmit interrupt
	assign irq[6]  = subsystem_interrupt[5] ;  // Uart 0 receive interrupt
	assign irq[7]  = subsystem_interrupt[6] ;  // Uart 1 transmit interrupt
	assign irq[8]  = subsystem_interrupt[7] ;  // Uart 1 receive interrupt
	assign irq[9]  = subsystem_interrupt[8] ;  // SPI transmit interrupt
	assign irq[10] = subsystem_interrupt[9] ;  // SPI receiver interrupt
	assign irq[11] = subsystem_interrupt[3] ;  // Dual timer combined interrupt
	assign irq[12] = COMBINT; 				   // GPIO combined interrupt
	assign irq[13] = irqa_o;				   // DMA combined interrupt
	assign irq[14] = received_image_int;	   // Compressor ReceivedImage interrupt
	assign irq[15] = full_int;				   // Compressor Full interrupt

/***************************** SYSTEM INSTANTIATION **********************************/
//Cortex
CORTEXM0INTEGRATION U0_CORTEXM0INTEGRATION (
	.clk(HCLK),
	.rst(HRESETn|watchdog_reset), // watchdog_reset is ored with system reset
	.nTRST('b1),

	.HADDR(HADDRS0),
	.HBURST(HBURSTS0),
	.HMASTLOCK(HMASTLOCKS0),
	.HPROT(HPROTS0),
	.HSIZE(HSIZES0),
	.HTRANS(HTRANSS0),
	.HWDATA(HWDATAS0),
	.HWRITE(HWRITES0),
	.HRDATA(HRDATAS0),
	.HREADY(HREADYS0),
	.HRESP(HRESPS0),
	.HMASTER(),

	.CODENSEQ(),
	.CODEHINTDE(),
	.SPECHTRANS(),

	.SWDITMS(1'b1),
	.TDI(1'b1),
	.SWDO(),
	.SWDOEN(),
	.TDO(),
	.nTDOEN(),
	.DBGRESTART(1'b0),
	.DBGRESTARTED(),
	.EDBGRQ(1'b0),
	.HALTED(),

	.NMI(watchdog_interrupt),       
	.IRQ(irq),
	.TXEV(),
	.RXEV(1'b0),
	.LOCKUP(),
	.SYSRESETREQ(),
	.STCALIB(26'b10_0000_1111_0100_0010_0011_1111),
	.STCLKEN(1'b0),
	.IRQLATENCY(8'd0), // 
	.ECOREVNUM (8'd0), //

	.GATEHCLK(),
	.SLEEPING(),
	.SLEEPDEEP(),
	.WAKEUP(),
	.WICSENSE(),
	.SLEEPHOLDREQn(1'b1),
	.SLEEPHOLDACKn(),
	.WICENREQ(1'b0),
	.WICENACK(),
	.CDBGPWRUPREQ(),
	.CDBGPWRUPACK(1'b0),

	.SE(1'b1),
	.RSTBYPASS(1'b1)

); 
	

//RCC
//ble clocks
wire clk_3472_KHz, clk_6945_KHz ;
//wifi clocks
wire clk_100_MHz, clk_50_MHz, clk_20_MHz_WIFI ;

ahb_to_RCC #(.Include_dual_timer(Include_dual_timer),.Include_WIFI(Include_WIFI)) 
RCC_instance
(
	.SYS_FCLK(SYS_FCLK),
   .HCLK(HCLK),
   .phy_ble_clk(phy_ble_clk),
   .clk_6945_KHz(clk_6945_KHz),
   .clk_3472_KHz(clk_3472_KHz),
   .clk_100_MHz(clk_100_MHz),
   .clk_50_MHz(clk_50_MHz),
   .clk_20_MHz_WIFI(clk_20_MHz_WIFI),
   .RESETn(RESETn),
   .HRESETn(HRESETn),
   .APB_ACTIVE(APB_ACTIVE),
   .HSEL(HSELM5),      // AHB peripheral select
   .HREADY(HREADYMUXM5),    // AHB ready input
   .HTRANS(HTRANSM5),    // AHB transfer type
   .HSIZE(HSIZEM5),     // AHB hsize
   .HWRITE(HWRITEM5),    // AHB hwrite
   .HADDR(HADDRM5),     // AHB address bus
   .HWDATA(HWDATAM5),    // AHB write data bus
   .HREADYOUT(HREADYOUTM5), // AHB ready output to S->M mux
   .HRESP(HRESPM5),     // AHB response
   .HRDATA(HRDATAM5),    // AHB read data bus
   .PCLK(PCLK),
   .PCLKG(PCLKG),
   .PRESETn(PRESETn),
   .TIMCLK(TIMCLK),
   .WDOGCLK(WDOGCLK),
   .WDOGRESn(WDOGRESn)
);
//SRAM
RAM_TOP #(.AW(AW),.GROUP0(GROUP0),.GROUP1(GROUP1),.GROUP2(GROUP2),.GROUP3(GROUP3),.IS_INSTRUCTION(1)) 
Instruction_SRAM_TOP_instance(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(HSELM0),
    .HREADY(HREADYMUXM0),
    .HTRANS(HTRANSM0),
    .HSIZE(HSIZEM0),
    .HWRITE(HWRITEM0),
    .HADDR(HADDRM0[AW-1:0]),
    .HWDATA(HWDATAM0),
    .HREADYOUT(HREADYOUTM0),
    .HRESP(HRESPM0),
    .HRDATA(HRDATAM0)
);

//DRAM
RAM_TOP #(.AW(AW),.GROUP0(GROUP0),.GROUP1(GROUP1),.GROUP2(GROUP2),.GROUP3(GROUP3),.IS_INSTRUCTION(0)) DATA_SRAM_TOP_instance(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(HSELM1),
    .HREADY(HREADYMUXM1),
    .HTRANS(HTRANSM1),
    .HSIZE(HSIZEM1),
    .HWRITE(HWRITEM1),
    .HADDR(HADDRM1[AW-1:0]),
    .HWDATA(HWDATAM1),
    .HREADYOUT(HREADYOUTM1),
    .HRESP(HRESPM1),
    .HRDATA(HRDATAM1)
);

//APB subsystem
cmsdk_apb_subsystem #(.Include_dual_timer(Include_dual_timer),.Include_SPI(Include_SPI))  cmsdk_apb_subsystem_instance(
	    .HCLK(HCLK),
	    .HRESETn(HRESETn),
	    .HSEL(HSELM2),
	    .HADDR(HADDRM2[15:0]),
	    .HTRANS(HTRANSM2),
	    .HWRITE(HWRITEM2),
	    .HSIZE(HSIZEM2),
	    .HPROT(HPROTM2),
	    .HREADY(HREADYMUXM2),
	    .HWDATA(HWDATAM2),
	    .HREADYOUT(HREADYOUTM2),
	    .HRDATA(HRDATAM2),
	    .HRESP(HRESPM2),
	    .PCLK(PCLK),
	    .PCLKG(PCLKG),
	    .PRESETn(PRESETn),
		.APB_ACTIVE(APB_ACTIVE),
		.WDOGCLK(WDOGCLK),
  		.WDOGRESn(WDOGRESn),
		.TIMCLK(TIMCLK),
	    .TXD0 (TXD0),
	    .RXD0 (RXD0),  
	    .TXD0_EN(TXD0_EN),
		.RTS0(RTS0),
		.CTS0(CTS0),
		.TXD1 (TXD1),
	    .RXD1 (RXD1),  
	    .TXD1_EN(TXD1_EN),
		.RTS1(RTS1),
		.CTS1(CTS1),
	    .EXTIN(EXTIN),
		.M_MOSI(M_MOSI), 
		.M_MISO(M_MISO), 
		.M_SCK(M_SCK), 
		.S_MOSI(S_MOSI), 
		.S_MISO(S_MISO), 
		.S_SCK(S_SCK), 
		.SS(SS),
		.SS0(SS0),
		.SS1(SS1),
		.SS2(SS2),
		.SS3(SS3),
		.subsystem_requests(subsys_dma_req_i),
		.subsystem_acks(subsys_ack_for_req),
		.subsystem_transfer_done(subsys_dma_done_i),
	    .subsystem_interrupt(subsystem_interrupt), 
	    .watchdog_interrupt(watchdog_interrupt),   
	    .watchdog_reset(watchdog_reset)            
	);


	assign dma_req_i = {rx_dma_req_wifi, tx_dma_req_wifi, rx_dma_req_ble, tx_dma_req_ble, subsys_dma_req_i};
	assign {rx_dma_ack_wifi, tx_dma_ack_wifi, rx_dma_ack_ble, tx_dma_ack_ble, subsys_ack_for_req} = ack_for_req ;
	assign {rx_dma_done_wifi, tx_dma_done_wifi, rx_dma_done_ble, tx_dma_done_ble, subsys_dma_done_i} = dma_done_i;

//GPIO
cmsdk_ahb_gpio #(
    .ALTERNATE_FUNC_MASK     (ALTERNATE_FUNC_MASK),
    .ALTERNATE_FUNC_DEFAULT  (ALTERNATE_FUNC_DEFAULT), // All pins default to GPIO
    .BE                      (BE),
    .PORTWIDTH               (PORTWIDTH),
    .ALTFUNC                 (ALTFUNC)  
    ) cmsdk_ahb_gpio_instance (
	    .HCLK(HCLK),
	    .HRESETn(HRESETn),
	    .FCLK(HCLK),
	    .HSEL(HSELM3),
	    .HREADY(HREADYMUXM3),
	    .HTRANS(HTRANSM3),
	    .HSIZE(HSIZEM3),
	    .HWRITE(HWRITEM3),
	    .HADDR(HADDRM3[11:0]),
	    .HWDATA(HWDATAM3),
	    .ECOREVNUM('b0),
	    .HREADYOUT(HREADYOUTM3),
	    .HRESP(HRESPM3),
	    .HRDATA(HRDATAM3),
		.PORTOUT(PORTOUT),
		.PORTIN(PORTIN),
		.PORTEN(PORTEN),
		.PORTFUNC(),
		.ALT_FUNC(),
	    .GPIOINT(GPIOINT),
	    .COMBINT(COMBINT)
);

// 
generate
if (Include_COMP == 1) begin:COMP_INCLUDED
	ahb_to_compressor # (
		.OUT_WIDTH(COMP_OUT_WIDTH),
		.IN_WIDTH(COMP_IN_WIDTH),
		.DIM(COMP_DIM),
		.MEM_UNCOMP_DEPTH(COMP_MEM_UNCOMP_DEPTH),
		.MEM_COMP_DEPTH(COMP_MEM_COMP_DEPTH),
		.AHB_WIDTH(32),
		.REGFILE_DEPTH(4),
		.IMG1 (IMG1 ),
		.IMG2 (IMG2 ),
		.IMG3 (IMG3 ),
		.IMG4 (IMG4 ),
		.IMG5 (IMG5 ),
		.IMG6 (IMG6 ),
		.IMG7 (IMG7 ),
		.IMG8 (IMG8 ) 
	)
	ahb_to_compressor_inst (
		.clk(clk),
		.rst(rst),
		.HCLK(HCLK),
		.HRESETn(HRESETn),
		.HSEL(HSELM8),
		.HREADY(HREADYM8),
		.HTRANS(HTRANSM8),
		.HSIZE(HSIZEM8),
		.HWRITE(HWRITEM8),
		.HADDR(HADDRM8),
		.HWDATA(HWDATAM8),
		.HREADYOUT(HREADYOUTM8),
		.HRESP(HRESPM8),
		.HRDATA(HRDATAM8),
		.received_image_int(received_image_int),
		.full_int(full_int)
	);
end
else begin:DE_COMP_INCLUDED
	// to be added
end
endgenerate

//Bus matrix & DMA
generate
	if (Include_DMA) begin:dma_included

		wire   [31:0] HADDRS1;        // Address bus////////////
		wire   [1:0] HTRANSS1;        // Transfer type//////
		wire         HWRITES1;        // Transfer direction//////
		wire   [2:0] HSIZES1;         // Transfer size
		wire   [2:0] HBURSTS1;        // Burst type//////////
		wire   [3:0] HPROTS1;         // Protection control///////////////////
		wire  [31:0] HWDATAS1;        // Write data/////////////////////
		wire [31:0] HRDATAS1;        // Read data bus
		wire        HREADYS1;        // HREADY feedback
		wire        HRESPS1;         // Transfer response

		wire [31:0] HRDATAM4;        // Read data bus
		wire        HREADYOUTM4;     // HREADY feedback
		wire        HRESPM4;         // Transfer response
		wire        HSELM4;          // Slave Select
		wire [31:0] HADDRM4;         // Address bus
		wire  [1:0] HTRANSM4;        // Transfer type
		wire        HWRITEM4;        // Transfer direction
		wire  [2:0] HSIZEM4;         // Transfer size
		wire  [2:0] HBURSTM4;        // Burst type
		wire  [3:0] HPROTM4;         // Protection control
		wire [31:0] HWDATAM4;        // Write data
		wire        HREADYMUXM4;     // Transfer done
		

		// chXX_conf = { CBUF, ED, ARS, EN }

		//Bus matrix


		ahb_dma_top #(
			// ch_conf [x] = { CBUF, ED, ARS, EN }
		   .ch_conf(ch_conf),
		   .pri_sel(pri_sel),
		   .req_number(req_number),
		   .channel_number(channel_number)
			
		) DMA_instance (
			// Common signals
			.clk_i(HCLK),
			.rst_i(HRESETn),

			// Slave Interface
			.sHSEL(HSELM4),
			.sHADDR(HADDRM4),
			.sHWDATA(HWDATAM4),
			.sHRDATA(HRDATAM4),
			.sHWRITE(HWRITEM4),
			.sHSIZE(HSIZEM4),
			.sHBURST(HBURSTM4),
			.sHPROT(HPROTM4),
			.sHTRANS(HTRANSM4),
			.sHREADYOUT(HREADYOUTM4),
			.sHREADY(HREADYMUXM4),
			.sHRESP(HRESPM4),

			// Master Interface
			//.m0HSEL(),
			.m0HADDR(HADDRS1),
			.m0HWDATA(HWDATAS1),
			.m0HRDATA(HRDATAS1),
			.m0HWRITE(HWRITES1),
			.m0HSIZE(HSIZES1),
			.m0HBURST(HBURSTS1),
			.m0HPROT(HPROTS1),
			.m0HTRANS(HTRANSS1),
			.m0HREADY(HREADYS1),
			.m0HRESP(HRESPS1),


			// --------------------------------------
			// Misc Signal(),
			.dma_req_i(dma_req_i),
			.dma_ack_o(dma_done_i),
			.dma_rest_i(0),
			.ch_done_all_transfer(done_all),
			.ack_for_req(ack_for_req),
			.irqa_o(irqa_o)
		);

	if (Include_WIFI)
	begin:dma_and_wifi
		
		// Output port MI6 (outputs to PHY_WIFI)
    	wire        HSELM7;          // Slave Select
    	wire [31:0] HADDRM7;         // Address bus
    	wire [1:0]  HTRANSM7;        // Transfer type
    	wire        HWRITEM7;        // Transfer direction
    	wire [2:0]  HSIZEM7;         // Transfer size
    	wire [2:0]  HBURSTM7;        // Burst type
    	wire [3:0]  HPROTM7;         // Protection control
    	wire [31:0] HWDATAM7;        // Write data
    	wire [31:0] HRDATAM7;        // Read data
    	wire        HMASTLOCKM7;     // Locked Sequence
    	wire        HREADYMUXM7;     // Transfer done
    	wire        HREADYOUTM7;     // Transfer done
		wire 		HRESPM7;		 //Response signal

		WIFI_AHB_TOP #(.ADDR_AHB(ADDR_WIFI), .DATA_WIDTH(DATA_WIFI)) phy_wifi_instance
		(
			.clk_100_MHz(clk_100_MHz),
			.clk_50_MHz(clk_50_MHz),
			.HCLK(HCLK),
			.clk_20_MHz_WIFI(clk_20_MHz_WIFI),
			.reset(HRESETn),
			.HWRITE(HWRITEM7),
			.HSEL(HSELM7),
			.HREADY(HREADYMUXM7),
			.HADDR(HADDRM7),
			.HWDATA(HWDATAM7),
			.HTRANS(HTRANSM7),
			.HBURST(HBURSTM7),
			.HSIZE(HSIZEM7),
			.HRDATA(HRDATAM7),
			.HRESP(HRESPM7),
			.HREADYOUT(HREADYOUTM7),
			.rx_irq(rx_irq_wifi),
			.Tx_irq(tx_irq_wifi),
			.DMA_READ_ACK(rx_dma_ack_wifi),
			.DMA_READ_REQ(rx_dma_req_wifi),
			.DMA_WRITE_ACK(tx_dma_ack_wifi),
			.DMA_WRITE_REQ(tx_dma_req_wifi),
			.DMA_READ_DONE(rx_dma_done_wifi),
			.DMA_WRITE_DONE(tx_dma_done_wifi)
		);

		AHB_BusMatrix_DMA_PHY_lite AHB_BusMatrix_DMA_PHY_lite_instance
		(
			.HCLK(HCLK),
			.HRESETn(HRESETn),
			.REMAP(4'b0), //Remapping signal is not used in our top module or system
			
			.HADDRS0(HADDRS0),
			.HTRANSS0(HTRANSS0),
			.HWRITES0(HWRITES0),
			.HSIZES0(HSIZES0),
			.HBURSTS0(HBURSTS0),
			.HPROTS0(HPROTS0),
			.HWDATAS0(HWDATAS0),
			.HMASTLOCKS0(HMASTLOCKS0),
			.HRDATAS0(HRDATAS0),
			.HREADYS0(HREADYS0),
			.HRESPS0(HRESPS0),

			.HADDRS1(HADDRS1),
			.HTRANSS1(HTRANSS1),
			.HWRITES1(HWRITES1),
			.HSIZES1(HSIZES1),
			.HBURSTS1(HBURSTS1),
			.HPROTS1(HPROTS1),
			.HWDATAS1(HWDATAS1),
			.HMASTLOCKS1(HMASTLOCKS1),
			.HRDATAS1(HRDATAS1),
    		.HREADYS1(HREADYS1),
    		.HRESPS1(HRESPS1),
			
			.HRDATAM0(HRDATAM0),
			.HREADYOUTM0(HREADYOUTM0),
			.HRESPM0(HRESPM0),
			.HSELM0(HSELM0),
			.HADDRM0(HADDRM0),
			.HTRANSM0(HTRANSM0),
			.HWRITEM0(HWRITEM0),
			.HSIZEM0(HSIZEM0),
			.HBURSTM0(HBURSTM0),
			.HPROTM0(HPROTM0),
			.HWDATAM0(HWDATAM0),
			.HMASTLOCKM0(HMASTLOCKM0),
			.HREADYMUXM0(HREADYMUXM0),
			

			.HRDATAM1(HRDATAM1),
			.HREADYOUTM1(HREADYOUTM1),
			.HRESPM1(HRESPM1),
			.HSELM1(HSELM1),
			.HADDRM1(HADDRM1),
			.HTRANSM1(HTRANSM1),
			.HWRITEM1(HWRITEM1),
			.HSIZEM1(HSIZEM1),
			.HBURSTM1(HBURSTM1),
			.HPROTM1(HPROTM1),
			.HWDATAM1(HWDATAM1),
			.HMASTLOCKM1(HMASTLOCKM1),
			.HREADYMUXM1(HREADYMUXM1),

			
			.HRDATAM2(HRDATAM2),
			.HREADYOUTM2(HREADYOUTM2),
			.HRESPM2(HRESPM2),
			.HSELM2(HSELM2),
			.HADDRM2(HADDRM2),
			.HTRANSM2(HTRANSM2),
			.HWRITEM2(HWRITEM2),
			.HSIZEM2(HSIZEM2),
			.HBURSTM2(HBURSTM2),
			.HPROTM2(HPROTM2),
			.HWDATAM2(HWDATAM2),
			.HMASTLOCKM2(HMASTLOCKM2),
			.HREADYMUXM2(HREADYMUXM2),

			
			.HRDATAM3(HRDATAM3),
			.HREADYOUTM3(HREADYOUTM3),
			.HRESPM3(HRESPM3),
			.HSELM3(HSELM3),
			.HADDRM3(HADDRM3),
			.HTRANSM3(HTRANSM3),
			.HWRITEM3(HWRITEM3),
			.HSIZEM3(HSIZEM3),
			.HBURSTM3(HBURSTM3),
			.HPROTM3(HPROTM3),
			.HWDATAM3(HWDATAM3),
			.HMASTLOCKM3(HMASTLOCKM3),
			.HREADYMUXM3(HREADYMUXM3),

			.HRDATAM4(HRDATAM4),
    		.HREADYOUTM4(HREADYOUTM4),
    		.HRESPM4(HRESPM4),
			.HSELM4(HSELM4),
    		.HADDRM4(HADDRM4),
    		.HTRANSM4(HTRANSM4),
    		.HWRITEM4(HWRITEM4),
    		.HSIZEM4(HSIZEM4),
    		.HBURSTM4(HBURSTM4),
    		.HPROTM4(HPROTM4),
    		.HWDATAM4(HWDATAM4),
    		.HMASTLOCKM4(HMASTLOCKM4),
    		.HREADYMUXM4(HREADYMUXM4),


			.HRDATAM5(HRDATAM5),
    		.HREADYOUTM5(HREADYOUTM5),
    		.HRESPM5(HRESPM5),
			.HSELM5(HSELM5),
    		.HADDRM5(HADDRM5),
    		.HTRANSM5(HTRANSM5),
    		.HWRITEM5(HWRITEM5),
    		.HSIZEM5(HSIZEM5),
    		.HBURSTM5(HBURSTM5),
    		.HPROTM5(HPROTM5),
    		.HWDATAM5(HWDATAM5),
    		.HMASTLOCKM5(HMASTLOCKM5),
    		.HREADYMUXM5(HREADYMUXM5),

			.HRDATAM6(HRDATAM6),
    		.HREADYOUTM6(1'b1),
    		.HRESPM6(HRESPM6),
			.HSELM6(HSELM6),
    		.HADDRM6(HADDRM6),
    		.HTRANSM6(HTRANSM6),
    		.HWRITEM6(HWRITEM6),
    		.HSIZEM6(HSIZEM6),
    		.HBURSTM6(HBURSTM6),
    		.HPROTM6(HPROTM6),
    		.HWDATAM6(HWDATAM6),
    		.HMASTLOCKM6(HMASTLOCKM6),
    		.HREADYMUXM6(HREADYMUXM6),

			.HRDATAM7(HRDATAM7),
    		.HREADYOUTM7(HREADYOUTM7),
    		.HRESPM7(HRESPM7),
			.HSELM7(HSELM7),
    		.HADDRM7(HADDRM7),
    		.HTRANSM7(HTRANSM7),
    		.HWRITEM7(HWRITEM7),
    		.HSIZEM7(HSIZEM7),
    		.HBURSTM7(HBURSTM7),
    		.HPROTM7(HPROTM7),
    		.HWDATAM7(HWDATAM7),
    		.HMASTLOCKM7(HMASTLOCKM7),
    		.HREADYMUXM7(HREADYMUXM7),
			
			.SCANENABLE(1'b0),
			.SCANINHCLK(1'b0),
			.SCANOUTHCLK()
		);

	end:dma_and_wifi
	else
	begin:dma_and_no_wifi
		
		AHB_BusMatrix_DMA_COM_lite AHB_BusMatrix_DMA_COM_lite_instance (
			.HCLK(HCLK),
			.HRESETn(HRESETn),
			.REMAP(4'b0), //Remapping signal is not used in our top module or system
			
			.HADDRS0(HADDRS0),
			.HTRANSS0(HTRANSS0),
			.HWRITES0(HWRITES0),
			.HSIZES0(HSIZES0),
			.HBURSTS0(HBURSTS0),
			.HPROTS0(HPROTS0),
			.HWDATAS0(HWDATAS0),
			.HMASTLOCKS0(HMASTLOCKS0),
			.HRDATAS0(HRDATAS0),
			.HREADYS0(HREADYS0),
			.HRESPS0(HRESPS0),

			.HADDRS1(HADDRS1),
			.HTRANSS1(HTRANSS1),
			.HWRITES1(HWRITES1),
			.HSIZES1(HSIZES1),
			.HBURSTS1(HBURSTS1),
			.HPROTS1(HPROTS1),
			.HWDATAS1(HWDATAS1),
			.HMASTLOCKS1(HMASTLOCKS1),
			.HRDATAS1(HRDATAS1),
    		.HREADYS1(HREADYS1),
    		.HRESPS1(HRESPS1),
			
			.HRDATAM0(HRDATAM0),
			.HREADYOUTM0(HREADYOUTM0),
			.HRESPM0(HRESPM0),
			.HSELM0(HSELM0),
			.HADDRM0(HADDRM0),
			.HTRANSM0(HTRANSM0),
			.HWRITEM0(HWRITEM0),
			.HSIZEM0(HSIZEM0),
			.HBURSTM0(HBURSTM0),
			.HPROTM0(HPROTM0),
			.HWDATAM0(HWDATAM0),
			.HMASTLOCKM0(HMASTLOCKM0),
			.HREADYMUXM0(HREADYMUXM0),
			

			.HRDATAM1(HRDATAM1),
			.HREADYOUTM1(HREADYOUTM1),
			.HRESPM1(HRESPM1),
			.HSELM1(HSELM1),
			.HADDRM1(HADDRM1),
			.HTRANSM1(HTRANSM1),
			.HWRITEM1(HWRITEM1),
			.HSIZEM1(HSIZEM1),
			.HBURSTM1(HBURSTM1),
			.HPROTM1(HPROTM1),
			.HWDATAM1(HWDATAM1),
			.HMASTLOCKM1(HMASTLOCKM1),
			.HREADYMUXM1(HREADYMUXM1),

			
			.HRDATAM2(HRDATAM2),
			.HREADYOUTM2(HREADYOUTM2),
			.HRESPM2(HRESPM2),
			.HSELM2(HSELM2),
			.HADDRM2(HADDRM2),
			.HTRANSM2(HTRANSM2),
			.HWRITEM2(HWRITEM2),
			.HSIZEM2(HSIZEM2),
			.HBURSTM2(HBURSTM2),
			.HPROTM2(HPROTM2),
			.HWDATAM2(HWDATAM2),
			.HMASTLOCKM2(HMASTLOCKM2),
			.HREADYMUXM2(HREADYMUXM2),

			
			.HRDATAM3(HRDATAM3),
			.HREADYOUTM3(HREADYOUTM3),
			.HRESPM3(HRESPM3),
			.HSELM3(HSELM3),
			.HADDRM3(HADDRM3),
			.HTRANSM3(HTRANSM3),
			.HWRITEM3(HWRITEM3),
			.HSIZEM3(HSIZEM3),
			.HBURSTM3(HBURSTM3),
			.HPROTM3(HPROTM3),
			.HWDATAM3(HWDATAM3),
			.HMASTLOCKM3(HMASTLOCKM3),
			.HREADYMUXM3(HREADYMUXM3),

			.HRDATAM4(HRDATAM4),
    		.HREADYOUTM4(HREADYOUTM4),
    		.HRESPM4(HRESPM4),
			.HSELM4(HSELM4),
    		.HADDRM4(HADDRM4),
    		.HTRANSM4(HTRANSM4),
    		.HWRITEM4(HWRITEM4),
    		.HSIZEM4(HSIZEM4),
    		.HBURSTM4(HBURSTM4),
    		.HPROTM4(HPROTM4),
    		.HWDATAM4(HWDATAM4),
    		.HMASTLOCKM4(HMASTLOCKM4),
    		.HREADYMUXM4(HREADYMUXM4),


			.HRDATAM5(HRDATAM5),
    		.HREADYOUTM5(HREADYOUTM5),
    		.HRESPM5(HRESPM5),
			.HSELM5(HSELM5),
    		.HADDRM5(HADDRM5),
    		.HTRANSM5(HTRANSM5),
    		.HWRITEM5(HWRITEM5),
    		.HSIZEM5(HSIZEM5),
    		.HBURSTM5(HBURSTM5),
    		.HPROTM5(HPROTM5),
    		.HWDATAM5(HWDATAM5),
    		.HMASTLOCKM5(HMASTLOCKM5),
    		.HREADYMUXM5(HREADYMUXM5),

			.HRDATAM6(HRDATAM6),
    		.HREADYOUTM6(HREADYOUTM6),
    		.HRESPM6(HRESPM6),
			.HSELM6(HSELM6),
    		.HADDRM6(HADDRM6),
    		.HTRANSM6(HTRANSM6),
    		.HWRITEM6(HWRITEM6),
    		.HSIZEM6(HSIZEM6),
    		.HBURSTM6(HBURSTM6),
    		.HPROTM6(HPROTM6),
    		.HWDATAM6(HWDATAM6),
    		.HMASTLOCKM6(HMASTLOCKM6),
    		.HREADYMUXM6(HREADYMUXM6),

			.HRDATAM8(HRDATAM8),
			.HREADYOUTM8(HREADYOUTM8),
			.HRESPM8(HRESPM8),
			.HSELM8(HSELM8),
			.HADDRM8(HADDRM8),
			.HTRANSM8(HTRANSM8),
			.HWRITEM8(HWRITEM8),
			.HSIZEM8(HSIZEM8),
			.HBURSTM8(HBURSTM8),
			.HPROTM8(HPROTM8),
			.HWDATAM8(HWDATAM8),
    		.HMASTLOCKM8(HMASTLOCKM8),
    		.HREADYMUXM8(HREADYMUXM8),
			
			.SCANENABLE(1'b0),
			.SCANINHCLK(1'b0),
			.SCANOUTHCLK() );
	end:dma_and_no_wifi

	end:dma_included

	else begin:dma_not_included
	//Bus matrix
	if (Include_WIFI)
	begin:wifi_no_dma
		
		// Output port MI6 (outputs to PHY_WIFI)
    	wire        HSELM7;          // Slave Select
    	wire [31:0] HADDRM7;         // Address bus
    	wire [1:0]  HTRANSM7;        // Transfer type
    	wire        HWRITEM7;        // Transfer direction
    	wire [2:0]  HSIZEM7;         // Transfer size
    	wire [2:0]  HBURSTM7;        // Burst type
    	wire [3:0]  HPROTM7;         // Protection control
    	wire [31:0] HWDATAM7;        // Write data
    	wire [31:0] HRDATAM7;        // Read data
    	wire        HMASTLOCKM7;     // Locked Sequence
    	wire        HREADYMUXM7;     // Transfer done
    	wire        HREADYOUTM7;     // Transfer done
		wire 		HRESPM7;		 //Response signal

		WIFI_AHB_TOP #(.ADDR_AHB(ADDR_WIFI), .DATA_WIDTH(DATA_WIFI)) phy_wifi_instance
		(
			.clk_100_MHz(clk_100_MHz),
			.clk_50_MHz(clk_50_MHz),
			.clk_20_MHz_WIFI(clk_20_MHz_WIFI),
			.reset(HRESETn),
			.HWRITE(HWRITEM7),
			.HSEL(HSELM7),
			.HREADY(HREADYMUXM7),
			.HADDR(HADDRM7),
			.HWDATA(HWDATAM7),
			.HTRANS(HTRANSM7),
			.HBURST(HBURSTM7),
			.HSIZE(HSIZEM7),
			.HRDATA(HRDATAM7),
			.HRESP(HRESPM7),
			.HREADYOUT(HREADYOUTM7),
			.rx_irq(rx_irq_wifi),
			.Tx_irq(tx_irq_wifi),	
			.DMA_READ_ACK(rx_dma_ack_wifi),
			.DMA_READ_REQ(rx_dma_req_wifi),
			.DMA_WRITE_ACK(tx_dma_ack_wifi),
			.DMA_WRITE_REQ(tx_dma_req_wifi),
			.DMA_READ_DONE(rx_dma_done_wifi),
			.DMA_WRITE_DONE(tx_dma_done_wifi)
		);

		AHB_BusMatrix_PHY_lite AHB_BusMatrix_PHY_lite_instance
		(	
			.HCLK(HCLK),
			.HRESETn(HRESETn),
			.REMAP(4'b0), //Remapping signal is not used in our top module or system
			
			.HADDRS0(HADDRS0),
			.HTRANSS0(HTRANSS0),
			.HWRITES0(HWRITES0),
			.HSIZES0(HSIZES0),
			.HBURSTS0(HBURSTS0),
			.HPROTS0(HPROTS0),
			.HWDATAS0(HWDATAS0),
			.HMASTLOCKS0(HMASTLOCKS0),
			.HRDATAS0(HRDATAS0),
			.HREADYS0(HREADYS0),
			.HRESPS0(HRESPS0),
			
			.HRDATAM0(HRDATAM0),
			.HREADYOUTM0(HREADYOUTM0),
			.HRESPM0(HRESPM0),
			.HSELM0(HSELM0),
			.HADDRM0(HADDRM0),
			.HTRANSM0(HTRANSM0),
			.HWRITEM0(HWRITEM0),
			.HSIZEM0(HSIZEM0),
			.HBURSTM0(HBURSTM0),
			.HPROTM0(HPROTM0),
			.HWDATAM0(HWDATAM0),
			.HMASTLOCKM0(HMASTLOCKM0),
			.HREADYMUXM0(HREADYMUXM0),
			

			.HRDATAM1(HRDATAM1),
			.HREADYOUTM1(HREADYOUTM1),
			.HRESPM1(HRESPM1),
			.HSELM1(HSELM1),
			.HADDRM1(HADDRM1),
			.HTRANSM1(HTRANSM1),
			.HWRITEM1(HWRITEM1),
			.HSIZEM1(HSIZEM1),
			.HBURSTM1(HBURSTM1),
			.HPROTM1(HPROTM1),
			.HWDATAM1(HWDATAM1),
			.HMASTLOCKM1(HMASTLOCKM1),
			.HREADYMUXM1(HREADYMUXM1),

			
			.HRDATAM2(HRDATAM2),
			.HREADYOUTM2(HREADYOUTM2),
			.HRESPM2(HRESPM2),
			.HSELM2(HSELM2),
			.HADDRM2(HADDRM2),
			.HTRANSM2(HTRANSM2),
			.HWRITEM2(HWRITEM2),
			.HSIZEM2(HSIZEM2),
			.HBURSTM2(HBURSTM2),
			.HPROTM2(HPROTM2),
			.HWDATAM2(HWDATAM2),
			.HMASTLOCKM2(HMASTLOCKM2),
			.HREADYMUXM2(HREADYMUXM2),

			
			.HRDATAM3(HRDATAM3),
			.HREADYOUTM3(HREADYOUTM3),
			.HRESPM3(HRESPM3),
			.HSELM3(HSELM3),
			.HADDRM3(HADDRM3),
			.HTRANSM3(HTRANSM3),
			.HWRITEM3(HWRITEM3),
			.HSIZEM3(HSIZEM3),
			.HBURSTM3(HBURSTM3),
			.HPROTM3(HPROTM3),
			.HWDATAM3(HWDATAM3),
			.HMASTLOCKM3(HMASTLOCKM3),
			.HREADYMUXM3(HREADYMUXM3),

			.HRDATAM5(HRDATAM5),
    		.HREADYOUTM5(HREADYOUTM5),
    		.HRESPM5(HRESPM5),
			.HSELM5(HSELM5),
    		.HADDRM5(HADDRM5),
    		.HTRANSM5(HTRANSM5),
    		.HWRITEM5(HWRITEM5),
    		.HSIZEM5(HSIZEM5),
    		.HBURSTM5(HBURSTM5),
    		.HPROTM5(HPROTM5),
    		.HWDATAM5(HWDATAM5),
    		.HMASTLOCKM5(HMASTLOCKM5),
    		.HREADYMUXM5(HREADYMUXM5),

			.HRDATAM6(HRDATAM6),
    		.HREADYOUTM6(HREADYOUTM6),
    		.HRESPM6(HRESPM6),
			.HSELM6(HSELM6),
    		.HADDRM6(HADDRM6),
    		.HTRANSM6(HTRANSM6),
    		.HWRITEM6(HWRITEM6),
    		.HSIZEM6(HSIZEM6),
    		.HBURSTM6(HBURSTM6),
    		.HPROTM6(HPROTM6),
    		.HWDATAM6(HWDATAM6),
    		.HMASTLOCKM6(HMASTLOCKM6),
    		.HREADYMUXM6(HREADYMUXM6),

			.HRDATAM7(HRDATAM7),
    		.HREADYOUTM7(HREADYOUTM7),
    		.HRESPM7(HRESPM7),
			.HSELM7(HSELM7),
    		.HADDRM7(HADDRM7),
    		.HTRANSM7(HTRANSM7),
    		.HWRITEM7(HWRITEM7),
    		.HSIZEM7(HSIZEM7),
    		.HBURSTM7(HBURSTM7),
    		.HPROTM7(HPROTM7),
    		.HWDATAM7(HWDATAM7),
    		.HMASTLOCKM7(HMASTLOCKM7),
    		.HREADYMUXM7(HREADYMUXM7),
			
			.SCANENABLE(1'b0),
			.SCANINHCLK(1'b0),
			.SCANOUTHCLK()
		);		


	end:wifi_no_dma
	else
	begin:no_wifi_no_dma
		
		AHB_BusMatrix_COM_lite AHB_BusMatrix_COM_lite_instance (
			.HCLK(HCLK),
			.HRESETn(HRESETn),
			.REMAP(4'b0), //Remapping signal is not used in our top module or system
			
			.HADDRS0(HADDRS0),
			.HTRANSS0(HTRANSS0),
			.HWRITES0(HWRITES0),
			.HSIZES0(HSIZES0),
			.HBURSTS0(HBURSTS0),
			.HPROTS0(HPROTS0),
			.HWDATAS0(HWDATAS0),
			.HMASTLOCKS0(HMASTLOCKS0),
			.HRDATAS0(HRDATAS0),
			.HREADYS0(HREADYS0),
			.HRESPS0(HRESPS0),
			
			.HRDATAM0(HRDATAM0),
			.HREADYOUTM0(HREADYOUTM0),
			.HRESPM0(HRESPM0),
			.HSELM0(HSELM0),
			.HADDRM0(HADDRM0),
			.HTRANSM0(HTRANSM0),
			.HWRITEM0(HWRITEM0),
			.HSIZEM0(HSIZEM0),
			.HBURSTM0(HBURSTM0),
			.HPROTM0(HPROTM0),
			.HWDATAM0(HWDATAM0),
			.HMASTLOCKM0(HMASTLOCKM0),
			.HREADYMUXM0(HREADYMUXM0),
			

			.HRDATAM1(HRDATAM1),
			.HREADYOUTM1(HREADYOUTM1),
			.HRESPM1(HRESPM1),
			.HSELM1(HSELM1),
			.HADDRM1(HADDRM1),
			.HTRANSM1(HTRANSM1),
			.HWRITEM1(HWRITEM1),
			.HSIZEM1(HSIZEM1),
			.HBURSTM1(HBURSTM1),
			.HPROTM1(HPROTM1),
			.HWDATAM1(HWDATAM1),
			.HMASTLOCKM1(HMASTLOCKM1),
			.HREADYMUXM1(HREADYMUXM1),

			
			.HRDATAM2(HRDATAM2),
			.HREADYOUTM2(HREADYOUTM2),
			.HRESPM2(HRESPM2),
			.HSELM2(HSELM2),
			.HADDRM2(HADDRM2),
			.HTRANSM2(HTRANSM2),
			.HWRITEM2(HWRITEM2),
			.HSIZEM2(HSIZEM2),
			.HBURSTM2(HBURSTM2),
			.HPROTM2(HPROTM2),
			.HWDATAM2(HWDATAM2),
			.HMASTLOCKM2(HMASTLOCKM2),
			.HREADYMUXM2(HREADYMUXM2),

			
			.HRDATAM3(HRDATAM3),
			.HREADYOUTM3(HREADYOUTM3),
			.HRESPM3(HRESPM3),
			.HSELM3(HSELM3),
			.HADDRM3(HADDRM3),
			.HTRANSM3(HTRANSM3),
			.HWRITEM3(HWRITEM3),
			.HSIZEM3(HSIZEM3),
			.HBURSTM3(HBURSTM3),
			.HPROTM3(HPROTM3),
			.HWDATAM3(HWDATAM3),
			.HMASTLOCKM3(HMASTLOCKM3),
			.HREADYMUXM3(HREADYMUXM3),

			.HRDATAM5(HRDATAM5),
    		.HREADYOUTM5(HREADYOUTM5),
    		.HRESPM5(HRESPM5),
			.HSELM5(HSELM5),
    		.HADDRM5(HADDRM5),
    		.HTRANSM5(HTRANSM5),
    		.HWRITEM5(HWRITEM5),
    		.HSIZEM5(HSIZEM5),
    		.HBURSTM5(HBURSTM5),
    		.HPROTM5(HPROTM5),
    		.HWDATAM5(HWDATAM5),
    		.HMASTLOCKM5(HMASTLOCKM5),
    		.HREADYMUXM5(HREADYMUXM5),

			.HRDATAM6(HRDATAM6),
    		.HREADYOUTM6(HREADYOUTM6),
    		.HRESPM6(HRESPM6),
			.HSELM6(HSELM6),
    		.HADDRM6(HADDRM6),
    		.HTRANSM6(HTRANSM6),
    		.HWRITEM6(HWRITEM6),
    		.HSIZEM6(HSIZEM6),
    		.HBURSTM6(HBURSTM6),
    		.HPROTM6(HPROTM6),
    		.HWDATAM6(HWDATAM6),
    		.HMASTLOCKM6(HMASTLOCKM6),
    		.HREADYMUXM6(HREADYMUXM6),

			.HRDATAM8(HRDATAM8),
			.HREADYOUTM8(HREADYOUTM8),
			.HRESPM8(HRESPM8),
			.HSELM8(HSELM8),
			.HADDRM8(HADDRM8),
			.HTRANSM8(HTRANSM8),
			.HWRITEM8(HWRITEM8),
			.HSIZEM8(HSIZEM8),
			.HBURSTM8(HBURSTM8),
			.HPROTM8(HPROTM8),
			.HWDATAM8(HWDATAM8),
    		.HMASTLOCKM8(HMASTLOCKM8),
    		.HREADYMUXM8(HREADYMUXM8),
			
			.SCANENABLE(1'b0),
			.SCANINHCLK(1'b0),
			.SCANOUTHCLK()
		);
	end:no_wifi_no_dma

	end:dma_not_included
endgenerate

	bt_wrapper #( .AD(AD_BLE), .DATA(DATA_BLE), .MEM(MEM_BLE), .RE_IM_AD(RE_IM_AD_BLE), .RE_IM_SIZE(RE_IM_SIZE_BLE), .RE_IM_MEM(RE_IM_MEM_BLE), .OFFSET(OFFSET_BLE), .DEPTH(DEPTH_BLE), .WIDTH(WIDTH_BLE)) phy_ble_instance
	(
    	.hclk(HCLK),
   		.clk_6945_KHz(clk_6945_KHz),
  	 	.clk_3472_KHz(clk_3472_KHz),
    	.reset(HRESETn),
    	.hsize(HSIZEM6),
    	.htrans(HTRANSM6),
    	.haddress(HADDRM6),
		.hwdata(HWDATAM6),
		.hwrite(HWRITEM6),
		.hsel(HSELM6),
    	.hrdata(HRDATAM6),
		.hresp(HRESPM6),
    	.hreadyout(HREADYOUTM6),
    	.tx_irq(tx_irq_ble),
    	.rx_irq(rx_irq_ble),
		.dma_ack(rx_dma_ack_ble),
		.tx_dma_ack(tx_dma_ack_ble),
		.tx_dma_req(tx_dma_req_ble),
		.rx_dma_req(rx_dma_req_ble),

		.tx_dma_done(tx_dma_done_ble),
    	.rx_dma_done(rx_dma_done_ble),
		
		.valid_in_mem_re_ble(valid_in_mem_re_ble),
		.data_in_re_to_rx_ble(data_in_re_to_rx_ble),
		.valid_in_mem_im_ble(valid_in_mem_im_ble),
		.data_in_im_to_rx_ble(data_in_im_to_rx_ble),
		
		.valid_out_mem_re_ble(valid_out_mem_re_ble),
		.data_out_re_to_rx_ble(data_out_re_to_rx_ble),
		.valid_out_mem_im_ble(valid_out_mem_im_ble),
		.data_out_im_to_rx_ble(data_out_im_to_rx_ble)
    );


endmodule   