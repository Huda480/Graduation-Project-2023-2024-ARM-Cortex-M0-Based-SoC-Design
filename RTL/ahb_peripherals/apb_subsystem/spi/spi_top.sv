//==========================================================================================
// Purpose: SPI TOP 
// Used in: apb_spi_interface
//==========================================================================================
//==========================================================================================
// Module declaration
//==========================================================================================
module SPI_TOP
(
//============================================================================
// I/Os
//============================================================================
  //==========================================================================
  // APB signals
  //==========================================================================
	input 		 	PCLK,
	input 		 	PRESETn,
  //==========================================================================
  // Shared Signals
  //==========================================================================
	input 		 	SEL_DATA,       // enable data registering 
	input			CLEAR,          // clear interrupt pulse
	input  [15:0] 	CONFIG_REG,     // module configuration
	input  [1:0] 	SPI_INT_CLR,    // clear interrupt bit
	input  [7:0] 	DATA_SHIFT_REG, // transmission data
	output [7:0] 	RX_REG,         // received data
	output [1:0] 	SPI_INT,        // module interrupt off if fifo mode is on
	output [1:0] 	FIFO_EN,        // enable fifo reading and writing 
  //==========================================================================
  // Master Signals
  //==========================================================================
	input  			M_MISO,   		// master input data from slave
	input 		 	SEL_CMD,  		// master start session
	output		 	RX_PULSE, 		// master receive data state
	output 			M_SCK, 	  		// master output clock
	output 			M_MOSI,   		// master output data
	output 			SS0,			// SPI output select0      		
	output		 	SS1,			// SPI output select1
	output		 	SS2,			// SPI output select2
	output		 	SS3,			// SPI output select3
  //==========================================================================
  // Slave Signals
  //==========================================================================
	input		 	SEL_DATA_Slave, // enable slave transmission
	input  			S_MOSI, 		// slave input data from master
	input  			SS, 			// slave select input
	input  			S_SCK, 			// input clock to slave
	output 			S_MISO  		// slave output to master
);
  //==========================================================================
  // Internal Signals
  //==========================================================================
   	wire [7:0] RX_REG_master;		// The regiseter which have the received data for the top from the master
	wire [7:0] RX_REG_slave;		// The regiseter which have the received data for the top from the slave
	wire [1:0] SPI_INT_master;		// the register that has the interrupt status for the top from the master
	wire [1:0] SPI_INT_slave;		// the register that has the interrupt status for the top from the slave
	wire [1:0] FIFO_EN_master;		// the register that has the enable for writing in the rx fifo and reading from the tx fifo for the top from the master
	wire [1:0] FIFO_EN_slave;		// the register that has the enable for writing in the rx fifo and reading from the tx fifo for the top from the slave
  //==========================================================================
  // Register Decoding
  //==========================================================================
   	assign SPI_INT = (CONFIG_REG[6]==0) ?  SPI_INT_slave : SPI_INT_master;
	assign FIFO_EN = (CONFIG_REG[6]==0) ?  FIFO_EN_slave : FIFO_EN_master;
   	assign RX_REG = (CONFIG_REG[6]==0) ?  RX_REG_slave : RX_REG_master;
  //==========================================================================
  // Master Instantiation
  //==========================================================================
	SPI_Master SPI_MASTER
	(

		.PRESETn(PRESETn),
		.PCLK(PCLK),

		.SEL_DATA(SEL_DATA),
		.SEL_CMD(SEL_CMD),
		.CLEAR(CLEAR),

		.CONFIG_REG(CONFIG_REG),
		.RX_REG(RX_REG_master),
		.SPI_INT(SPI_INT_master),
		.FIFO_EN(FIFO_EN_master),
		.SPI_INT_CLR(SPI_INT_CLR),
		.DATA_SHIFT_REG(DATA_SHIFT_REG),
		.RX_PULSE(RX_PULSE),

		.MISO_half_duplex(),
		.MISO(M_MISO),
		.MOSI(M_MOSI), 
		.SCK(M_SCK),
		.SS0(SS0),
		.SS1(SS1),
		.SS2(SS2),
		.SS3(SS3)
	);
  //==========================================================================
  // Slave Instantiation
  //==========================================================================
	SPI_Slave SPI_SLAVE
	(
		.PRESETn(PRESETn),
		.PCLK(PCLK),
		.SCK(S_SCK),
		.MOSI_half_duplex(),
		.MOSI(S_MOSI),
		.MISO(S_MISO),
		.SS(SS),
		.CONFIG_REG(CONFIG_REG),
		.SPI_INT(SPI_INT_slave),
		.FIFO_EN(FIFO_EN_slave),
		.SPI_INT_CLR(SPI_INT_CLR),
		.DATA_SHIFT_REG(DATA_SHIFT_REG),
		.SEL_DATA_Slave(SEL_DATA_Slave),
		.SEL_DATA(SEL_DATA),
		.CLEAR(CLEAR),
		.RX_REG(RX_REG_slave)
	);

endmodule