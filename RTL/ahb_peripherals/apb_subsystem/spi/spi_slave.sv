//==========================================================================================
// Purpose: SPI Slave
// Used in: SPI_TOP
//==========================================================================================
//==========================================================================================
// Module declaration
//==========================================================================================
module SPI_Slave
(
//============================================================================
// I/Os
//============================================================================
  //==========================================================================
  // APB signals
  //==========================================================================
	input 				PRESETn,
	input				PCLK,
  //==========================================================================
  // Slave Inputs
  //==========================================================================
	input				MOSI,				// SPI slave input
	input 				SCK,    			// input clock to SPI slave
	input 				SS,      			// SPI slave select input
	input 				SEL_DATA_Slave,		// the generated pulse when SPI configured as a slave and selected (SS = 0) from the top
	input				CLEAR,				// clear flag is set when there is an apb transfer with the address of the interrupt clear register from the top
	input               SEL_DATA,			// select data flag is set when there is an apb transfer with the address of the data register from the top
	input       [15:0]  CONFIG_REG,			// The used register to configure the slave
	input       [7:0]   DATA_SHIFT_REG,		// The register which is updated with the data to be transmitted
	input 		[1:0]   SPI_INT_CLR,		// the register that clears the interrupt status register
  //==========================================================================
  // Slave Outputs
  //==========================================================================
	output reg	[1:0]   SPI_INT, 			// the register that has the interrupt status for the top
	output reg 	[1:0] 	FIFO_EN,			// the register that has the enable for writing in the rx fifo and reading from the tx fifo for the top
	output reg  [7:0]   RX_REG ,			// The regiseter which have the received data for the top
	output wire			MOSI_half_duplex, 	// SPI slave output in case of half duplex
	output wire         MISO 				// SPI slave output -it is considered not connected in case of half duplex-
);
  //==========================================================================
  // Internal Signals
  //==========================================================================
	wire   		spi_en; 		      		// slave mode enable
	wire [1:0] 	mode;            	  		// the register that has the clock mode configuration	  
	reg 		ss_reg;			  	  		// register slave select
	reg 		tx_alarm; 		  	  		// indicates an incoming transmission session
	reg 		shift_in;       	  		// register serial input and output bits
	reg [7:0] 	shift_reg;       	  		// register received and transmitted data
	reg [7:0] 	sync0;				  		// douple sync register for RX register 
	reg [7:0]   sync1;     	  		  		// douple sync register for RX register 

   // used to control receiving and transmitting data for different spi modes 
	reg 		Flag_PEDGE;           		// positive edge detector
	reg 		Flag_NEDGE;			  		// negative edge detector
	reg 		shift_in_pedge; 	  		// shift bits on positive edge of sck
	reg  [7:0] 	shift_reg_pedge; 	  		// register shifted data
	reg 		shift_in_nedge; 	  		// shift bits on negative edge of sck
	reg  [7:0] 	shift_reg_nedge; 	  		// register shifted data

	reg 		pul;             	  		// register for pulse generation for the tx interrupt
	wire 		tx_int_pul;  	      		// the generated pulse for the tx interrupt
	reg 		int_flag;        	  		// flag indicates that an interrupt should be asserted
	reg 		clear_flag;      	  		// clear data from rx register
  //==========================================================================
  // SPI Enable
  //==========================================================================
	assign spi_en = CONFIG_REG[10];
  //==========================================================================
  // Clock Mode Configuration
  //==========================================================================
	assign mode   = CONFIG_REG[5:4];       //Clock phase and ploarity 
  //==========================================================================
  // Registering Slave Select
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
			ss_reg <= 'b0;
		else
			ss_reg <= SS;
	end
  //==========================================================================
  // Alarm Flag of Tranmission Session Initiation 
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
			tx_alarm <= 1'b0;
	  	else if (SEL_DATA)
	  		tx_alarm <= 1'b1;
	  	else if (SPI_INT_CLR[0]) // no need for this alarm after clearing the tx_interrupt to could use it again when ther is another session
	  		tx_alarm <= 1'b0;
	end
  //==========================================================================
  // Slave Output Generation
  //==========================================================================
	assign MISO = (spi_en && !SS && (CONFIG_REG[7] == 0)) ? shift_reg[7] :1'b0; //Full Duplex           
	assign MOSI_half_duplex = (spi_en && !SS && (CONFIG_REG[7] == 1) && (CONFIG_REG[11] == 0)) ? shift_reg[7] :1'b0; // half duplex
  //==========================================================================
  // RX_REG Double Synchroniser
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
		  sync0  <= 'b0;
		  sync1  <= 'b0;
		  RX_REG <= 'b0;
		end
		else if (SS && ! clear_flag) // update the Receiver Register with the Received Data after triggering the slave slector from low to high
		begin
		  sync0  <= shift_reg;
		  sync1  <= sync0;
		  RX_REG <= sync1;
		end 
		else if (clear_flag)      	// for avoid updating with the transmited data while the slave is active and transmit or during the receiving process
		begin 
		  sync0  <= 'b0;
		  sync1  <= 'b0;
		  RX_REG <= 'b0;	  
		end 
	end
  //==========================================================================
  // Configuring shift_reg based on mode
  //==========================================================================
	always_comb
	begin
		if(mode==2'b00 || mode==2'b11)
		shift_reg = shift_reg_nedge;
		else if(mode==2'b10 || mode==2'b01)
		shift_reg = shift_reg_pedge;
		else
		shift_reg = 'b0;
	end
  //==========================================================================
  // configuring shift_in based on mode
  //==========================================================================
	always_comb
	begin
		if(mode==2'b00 || mode==2'b11)
		shift_in = shift_in_pedge;
		else if(mode==2'b10 || mode==2'b01)
		shift_in = shift_in_nedge;
		else
		shift_in = 'b0;
	end
  //==========================================================================
  // Positive Edge Flag
  //==========================================================================
	always_ff @(posedge SCK or posedge SEL_DATA_Slave)
	begin
	  if(SEL_DATA_Slave)
	  Flag_PEDGE <= 'b1;
	  else 
	  Flag_PEDGE <= 'b0;
	end
  //==========================================================================
  // Negative Edge Flag
  //==========================================================================
	always_ff @(negedge SCK or posedge SEL_DATA_Slave)
	begin
	  if(SEL_DATA_Slave)
	  Flag_NEDGE <= 'b1;
	  else 
	  Flag_NEDGE <= 'b0;
	end
  //==========================================================================
  // Tranmsission and Receiving Data
  //==========================================================================
	always_ff @(posedge SCK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			shift_in_pedge  <= 'b0;
			shift_reg_pedge <= 'b0;
		end
		else if (Flag_PEDGE)
		begin
		shift_reg_pedge <= DATA_SHIFT_REG;
		shift_in_pedge  <= MOSI;
		end
		else if(SS==0 && !CONFIG_REG[6] && spi_en )
		begin
		case(mode)
		2'b00 :
		begin
			shift_in_pedge <= MOSI;
		end
		2'b01 :
		begin
			shift_reg_pedge    <= shift_reg_pedge << 1;
		    shift_reg_pedge[0] <= shift_in_nedge;
		end
		2'b10 :
		begin
			shift_reg_pedge    <= shift_reg_pedge << 1;
		    shift_reg_pedge[0] <= shift_in_nedge;
		end
		2'b11 :
		begin
			shift_in_pedge <= MOSI;
		end
		endcase
		end
	end

	always_ff @(negedge SCK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			shift_in_nedge  <= 'b0;
			shift_reg_nedge <= 'b0;
		end
		else if (Flag_NEDGE)
		begin
		shift_reg_nedge <= DATA_SHIFT_REG;
		shift_in_nedge  <= MOSI;
		end
		else if(SS==0 && !CONFIG_REG[6] && spi_en)
		begin
		case(mode)
		2'b00 :
		begin
			shift_reg_nedge    <= shift_reg_nedge << 1;
		   	shift_reg_nedge[0] <= shift_in_pedge;
		end
		2'b01 :
		begin
			shift_in_nedge <= MOSI;
		end
		2'b10 :
		begin
			shift_in_nedge <= MOSI;
		end
		2'b11 :
		begin
			shift_reg_nedge    <= shift_reg_nedge << 1;
		   	shift_reg_nedge[0] <= shift_in_pedge;
		end
		endcase
		end	
	end
  //==========================================================================
  // TX Interrupt Pulse Generation
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
	    if(!PRESETn)
	        begin
	        pul <= 1'b0;
	        end
	    else if (SS==1)
	        begin
	        pul <= 1'b1;
	        end
	    else
	        begin
	        pul <= 1'b0;
	        end
	end

	assign tx_int_pul = (~pul & SS) ? 'b1 : 'b0; 
  //==========================================================================
  // Generated Interrupt Flag 
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
			int_flag <= 1'b0;
		else if(tx_int_pul)
			int_flag <= 1;
		else if (SPI_INT_CLR[0])
			int_flag <= 0;
		else if (!SS)
			int_flag <= 0;
	end
  //==========================================================================
  // TX Interrupt Generation
  //==========================================================================
	always_comb
	begin
		if(int_flag && CONFIG_REG[6] == 0 && CONFIG_REG[8] == 1 && SPI_INT_CLR[0] == 0 && CONFIG_REG[7] == 0 ) 
		SPI_INT[0] = 'b1;
		else if(int_flag && CONFIG_REG[6] == 0 && CONFIG_REG[8] == 1 && SPI_INT_CLR[0] == 0 && CONFIG_REG[11] == 0 && CONFIG_REG[7] == 1) 
		SPI_INT[0] = 'b1;
		else if(SPI_INT_CLR[0] == 1 && CONFIG_REG[6] == 0 && CONFIG_REG[8] == 1)
		SPI_INT[0] = 'b0;
		else
		SPI_INT[0] = 'b0;
	end
  //==========================================================================
  // RX Interrupt Generation
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
			SPI_INT[1] = 'b0;
		else if(RX_REG != 0 && int_flag && CONFIG_REG[6] == 0 && CONFIG_REG[9] == 1 && SPI_INT_CLR[1] == 0)
			SPI_INT[1] = 1'b1;
		else if(SPI_INT_CLR[1]==1 && CONFIG_REG[6] == 0 && CONFIG_REG[9] == 1)
			SPI_INT[1] = 'b0;
		else
			SPI_INT[1] = 'b0;
	end
  //==========================================================================
  // Interrupt CLEAR Flag
  //==========================================================================
  // generatting flag based on the rx_interrupt to avoid re-update the RX_REG after clearing the rx_interrupt
	always_ff @(posedge PCLK or negedge SS)
	begin
	  	if (!SS)
			clear_flag <= 1'b0; // the RX_INT has been cleared
		else if (CLEAR)
			clear_flag <= 1'b1;
	end
  //==========================================================================
  // Enable Read from TX FIFO
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
			FIFO_EN[0] <= 'b0;
		else if (FIFO_EN[0])
			FIFO_EN[0] <= 'b0;
		else if (tx_int_pul)
			FIFO_EN[0] <= 'b1;
	end
  //==========================================================================
  // Enable Write in RX FIFO
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
			FIFO_EN[1] <= 'b0;
		else if (FIFO_EN[1])
			FIFO_EN[1] <= 'b0;
		else if (~ss_reg && SS)
			FIFO_EN[1] <= 'b1;
	end

endmodule