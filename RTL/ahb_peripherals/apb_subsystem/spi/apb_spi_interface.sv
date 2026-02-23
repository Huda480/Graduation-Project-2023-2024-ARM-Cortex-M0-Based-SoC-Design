//==========================================================================================
// Purpose: SPI APB peripheral
// Used in: cmsdk_apb_subsystem
//==========================================================================================
//
// Overview
// ========
/////////////////////////////////////////////////////////////////////////////////////////
// 
// SPI (Serial Peripheral Interface) is a synchronous serial communication protocol used to 
// connect microcontrollers and peripheral devices. 
// It supports the following properties:
// 1. Switching between master and slave modes
// 2. Communication with up to 4 slaves
// 3. Switching between full-duplex and half-duplex modes
// 4. Programmable clock modes
// 5. Clock divsion up to 16 times
// 6. Enable and disable interrupts
// 7. Communication with DMA
// 8. Enable and disable tx and rx fifos
//==========================================================================================
// Register File
//==========================================================================================
  // -------------------------------------------------------------------
  // Register name      |      Address      |  P |  Reset Value | Size |
  // -------------------------------------------------------------------
  // 1) CONFIG_REG      |   Base + 0x000    | RW |  0x0000_0000 |  16  |
  // 2) TDR             |   Base + 0x004    | RO |  0x0000_0000 |  8   |
  // 3) RDR             |   Base + 0x004    | WO |  0x0000_0000 |  8   |
  // 4) STATE_REG       |   Base + 0x008    | RO |  0x0000_0000	|  2   |
  // 5) INTCLEAR        |   Base + 0x00C    | WO |      NA      |  4   |
  // 6) INTSTATUS       |   Base + 0x010    | RO |  0x0000_0000 |  4   |
  // -------------------------------------------------------------------
//==========================================================================================
// Programmer's model
//==========================================================================================
// 0x000 RW    Config Reg[15:0]
//				 [14] RX FIFO mode
//				 [13] TX FIFO mode
//				 [12] DMA mode
//				 [11] RX or TX in half_duplex mode
//               [10] SPI Enable
//               [9] RX interrupt enable
//               [8] TX interrupt enable
//               [7] Full/Half Duplex (write 1 for half-duplex)
//               [6] Slave/Master Mode (write 1 to enable master mode)
//               [4:5] Clock phase and polarity
//               [2:3] Slave selector
//               [0:1] Clock divider
// 0x004 R     RX Data[7:0]           Received Data
//       W     Data Shift Reg[7:0]    Transmit Data
// 0x08  R     State Register
//               [1] RX buffer full
//               [0] TX buffer full
// 0x0C  R     Interrupt Status
//               [1] RX interrupt STATUS
//		         [0] TX interrupt STATUS
//       W     Interrupt Status clear
//               [1] clear RX INT
//		         [0] clear TX INT
//==========================================================================================
// Module declaration
//==========================================================================================
module APB_SPI_interface import apb_pkg::*;
(
//============================================================================
// I/Os
//============================================================================
  //==========================================================================
  // APB Interface
  //==========================================================================
    input  wire         PCLK,        	// APB clock
    input  wire         PRESETn,     	// APB reset
    input  wire         PENABLE,     	// APB enable
    input  wire         PSEL,        	// APB periph select
    input  wire [11:2]  PADDR,       	// APB address bus
    input  wire         PWRITE,      	// APB write
    input  wire [31:0]  PWDATA,      	// APB write data
    output reg  [31:0]  PRDATA,      	// APB read data
    output reg          PSLVERR,     	// APB slave error
    output reg          PREADY,      	// APB slave ready
	//==========================================================================
    // SPI Interface
    //==========================================================================
	output wire         M_SCK,   	 	// SPI master clock
	output wire         M_MOSI, 	 	// SPI master output
	input  wire         M_MISO,  	 	// SPI master input
	output wire         S_MISO,	     	// SPI slave output
    input  wire         S_MOSI,		 	// SPI slave input
	input  wire         SS,  		 	// SPI slave select input
	input  wire         S_SCK,		 	// input clock to SPI slave
	output wire         SS0, 		 	// SPI output select0
	output wire	        SS1,		 	// SPI output select1
	output wire	        SS2, 		 	// SPI output select2
	output wire     	SS3, 		 	// SPI output select3
	//==========================================================================
    // DMA Interface
    //==========================================================================
	input  wire		    DMA_READ_DONE,	// DMA read done signal
	input  wire		    DMA_WRITE_DONE,	// DMA write done signal
	input  wire		    DMA_READ_ACK,	// DMA read acknowledge signal
	input  wire		    DMA_WRITE_ACK,	// DMA write acknowledge signal
	output reg          DMA_READ_REQ,	// DMA read request signal
	output reg          DMA_WRITE_REQ,  // DMA write request signal
	//==========================================================================
    // Interrupts
    //==========================================================================
	output wire			TXINT,			// The TX interrupt
	output wire			RXINT,			// The RX interrupt
	output reg 		    COMBINT			// The combined interrupt
);
//==========================================================================================
// SPI Registers
//==========================================================================================  
  	reg  [15:0] CONFIG_REG;      	// The used register to configure the module
	reg  [7:0]  TDR;			 	// The register which is updated with the data to be transmitted	
	wire [7:0]  RDR;			 	// The regiseter which have the received data from the master or the slave
	wire [7:0] 	RX_REG;          	// The regiseter which have the received data from the master or the slave
	wire [3:0] 	INTSTATUS;       	// The register that has the interrupt status 
	reg  [3:0]  INTCLEAR;        	// the register that clears the interrupt status register
	wire [7:0]  DATA_SHIFT_REG;  	// The register which is updated with the data to be transmitted
	reg  [1:0]  STATE_REG; 	     	// The register that defines if there transimission or receiving is processing 
	wire [1:0]  SPI_INT;		 	// the register that has the interrupt status
	wire [1:0] 	FIFO_EN;            // the register that control the tx and rx fifo enable from the master & slave
	wire [7:0]  tx_data_out;	 	// The register which is updated with the data to be transmitted from the tx fifo
	wire [7:0]  rx_data_out;     	// The register which is updated with the received data from the rx fifo
//========================================================================================== 
// Internal Signals
//==========================================================================================
	reg 		penable_pul;	 	// the register used to generate penable signal based pulse
	wire 		apb_pulse;			// the generated pulse based on the penable signal every time there is an apb transfer
	reg 		sel_cmd; 		 	// select command flag is set when there is an apb transfer with the address of the configuration regiser 
	reg 		sel_data;		 	// select data flag is set when there is an apb transfer with the address of the data register
	reg  		clear;  		 	// clear flag is set when there is an apb transfer with the address of the interrupt clear register
	reg 		pul;                // the register used to generate pulse when spi slave is slected 
	wire 		sel_data_slave;     // the generated pulse when SPI configured as a slave and selected (SS0 = 0)
	wire 		rx_pulse;           // the generated pulse when the receiving seesion of the data end 

	wire        tx_empty;		 	// empty fifo flag of the tx fifo
	wire 		rx_empty;		 	// empty fifo flag of the rx fifo
	wire 		tx_full; 		 	// full fifo flag of the tx fifo
	wire        rx_full;		 	// full fifo flag of the rx fifo
	reg  		rx_full_reg;	 	// registered full fifo flag for pulse generation for the rx interrupt in case of fifo enabled
	wire 		rx_full_pul;	 	// the generated pulse for the rx interrupt in case of fifo enabled
	reg			rx_fifo_int;	 	// the rx interrupt in case of fifo enabled
	reg  		tx_empty_reg;	 	// registered empty fifo flag for pulse generation for the tx interrupt in case of fifo enabled
	wire 		tx_empty_pul;    	// the generated pulse for the tx interrupt in case of fifo enabled
	reg         tx_fifo_int;     	// the tx interrupt in case of fifo enabled
	wire 		rx_almostfull;  	// the almost full flag of the rx fifo
	reg 		rx_almostfull_reg;  // registered almost full flag for pulse generation for the rx interrupt in case of fifo enabled
	wire 		rx_almostfull_pul;  // the generated pulse for the rx interrupt in case of fifo enabled
	
	wire 		spi_idle;        	// idle SPI signal is high when all select signals are high
	reg 		spi_reg;		 	// registered SPI idle signal for pulse generation
	wire 		spi_pul;		 	// the generated pulse for the SPI idle signal to could generate the DMA write request in case of fifo disabled
	
	reg 		write_ack;			// register is used to register the dma write acknowledge signal
	reg 		read_ack;			// register is used to register the dma read acknowledge signal

	reg  		spi_en_pul; 	    // register the enable configuration bit for SPI enable pulse generation
	wire 		spi_en;      	    // the generated pulse for SPI enable for the fifos
	reg 		tx_fifo_sel_cmd;    // select command flag is set when the tx fifo is enabled to enable the spi for transmission data after filling the fifo with data
	reg         rx_fifo_sel_cmd;    // select command flag is set when the rx fifo is enabled to enable the spi for storing the received data after the receiving session ends
	reg  		fifo_sel_data;		// select data flag is set for the internal registers of the master and slave to be updated with the transmission data

	reg     	fifo_tx_wr_en;		// write enable of the tx fifo
	wire        fifo_tx_en;		    // control signal for the tx fifo read enable 
	wire 		fifo_tx_rd_en;      // read enable of the tx fifo
	reg         fifo_rx_rd_en;		// read enable of the rx fifo
	reg 		fifo_rx_wr_en0;		// reg for synchronizing the write enable of the rx fifo
	reg 	    fifo_rx_wr_en;		// write enable of the rx fifo
	
    reg         error_signal;       // error signal for controlling PSLVERR
	states_t    current_state;		// current state register of PSLVERR& PREADY FSM
    states_t    next_state;			// next state register of PSLVERR& PREADY FSM
//==========================================================================================
// the generated pulse for the SPI idle signal to could generate 
// the DMA write request in case of fifo disabled
//==========================================================================================
	assign spi_idle = (SS0 && SS1 && SS2 && SS3 && SS);

	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
	    if(!PRESETn)
	    begin
	        spi_reg <= 1'b0;
	    end
		else
	    begin
	        spi_reg <= spi_idle;
	    end
	end

	assign spi_pul = (!spi_reg & spi_idle) ? 'b1 : 'b0;
//==========================================================================================
// Interrupts
//==========================================================================================
	assign TXINT = (CONFIG_REG[13])?  INTSTATUS[2] :  INTSTATUS[0];

	assign RXINT = (CONFIG_REG[14])?  INTSTATUS[3] :  INTSTATUS[1];

	assign INTSTATUS = {rx_fifo_int,tx_fifo_int,SPI_INT};
  //==========================================================================================
  // Combined Interrupt
  //==========================================================================================
	always_comb
	begin
		if(|INTSTATUS)
		COMBINT = 1;
		else
		COMBINT = 0;
	end
  //==========================================================================================
  // RX FIFO Interrupt
  //==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
	    if(!PRESETn)
	    begin
	        rx_full_reg <= 1'b0;
	    end
	    else if (rx_full)
	    begin
	        rx_full_reg <= 1'b1;
	    end
	    else
	    begin
	        rx_full_reg <= 1'b0;
	    end
	end

	assign rx_full_pul = (!rx_full_reg & rx_full) ? 'b1 : 'b0;

	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
	    if(!PRESETn)
	    begin
	        rx_fifo_int <= 1'b0;
	    end
	    else if (rx_full_pul && CONFIG_REG[14])
	    begin
	        rx_fifo_int <= 1'b1;
	    end
	    else if (clear && INTCLEAR[3])
	    begin
	        rx_fifo_int <= 1'b0;
	    end
	end
  //==========================================================================================
  // TX FIFO Interrupt
  //==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
	    if(!PRESETn)
	    begin
	        tx_empty_reg <= 1'b0;
	    end
	    else if (tx_empty)
	    begin
	        tx_empty_reg <= 1'b1;
	    end
	    else
	    begin
	        tx_empty_reg <= 1'b0;
	    end
	end

	assign tx_empty_pul = (!tx_empty_reg & tx_empty) ? 'b1 : 'b0;

	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
	    if(!PRESETn)
	    begin
	        tx_fifo_int <= 1'b0;
	    end
	    else if (tx_empty_pul && CONFIG_REG[13])
	    begin
	        tx_fifo_int <= 1'b1;
	    end
	    else if (clear && INTCLEAR[2])
	    begin
	        tx_fifo_int <= 1'b0;
	    end
	end
//==========================================================================================
// SPI Enable based on FIFOs to handle the transmit and receive of the data
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)				
	begin
		if(!PRESETn)
		begin
			spi_en_pul <= 1'b0;
		end
	    else if (CONFIG_REG[10])
		begin
			spi_en_pul <= 1'b1;
		end
		else
		begin
			spi_en_pul <= 1'b0;
		end
	end

	assign spi_en = !spi_en_pul & CONFIG_REG[10] & (CONFIG_REG[13] || CONFIG_REG[14]); 

	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			tx_fifo_sel_cmd    <= 0;
		end 
		else if (spi_en && !tx_empty) // fifo has data
		begin
			tx_fifo_sel_cmd    <= 1;
		end
		else if (FIFO_EN[0] && !tx_empty) 
		begin
			tx_fifo_sel_cmd    <= 1;
		end
		else
		begin
			tx_fifo_sel_cmd    <= 0;
		end
	end

	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			rx_fifo_sel_cmd    <= 0;
		end 
		else if (spi_en && !rx_full && (!CONFIG_REG[11]) && CONFIG_REG[7]) 
		begin
			rx_fifo_sel_cmd    <= 1;
		end
		else if (FIFO_EN[1] && !rx_full && (!CONFIG_REG[11]) && CONFIG_REG[7]) 
		begin
			rx_fifo_sel_cmd    <= 1;
		end
		else
		begin
			rx_fifo_sel_cmd    <= 0;
		end
	end
//==========================================================================================
// the generated pulse based on the penable signal every time there is an apb transfer
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)				
	begin
		if(!PRESETn)
		begin
			penable_pul <= 1'b0;
		end
	    else if (PENABLE==1)
		begin
			penable_pul <= 1'b1;
		end
		else
		begin
			penable_pul <= 1'b0;
		end
	end

	assign apb_pulse = ~penable_pul & PENABLE; 
//========================================================================================== 
// Shared Area Registers
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			CONFIG_REG	   <= 'b0;
			TDR			   <= 'b0;
			INTCLEAR       <= 'b0;
			PRDATA         <= 'b0;   
			sel_cmd  	   <= 'b0;
	        sel_data       <= 'b0;
	        clear          <= 'b0;
			fifo_tx_wr_en 	   <= 'b0;
		end
		else if( PSEL && PREADY) 
		begin
			if( (PADDR[11:7] == 0) && PWRITE )
			begin
				case(PADDR[6:2])
				4'h0 :  
				begin
				  	CONFIG_REG <= PWDATA;
					if(PWDATA[10] && !CONFIG_REG[13] && !CONFIG_REG[14]) 
						sel_cmd    <= apb_pulse; // this bit is the commond which triggers spi_master_fsm from the idle state
				end
				4'h1 :  
				begin
					TDR <= PWDATA;
					if(!CONFIG_REG[13])
						sel_data <= apb_pulse;
					else
						fifo_tx_wr_en <= apb_pulse;
				end
				4'h3 :  
				begin
					INTCLEAR   <= PWDATA; // write only
					clear      <= apb_pulse;
				end
				default :
				begin
					CONFIG_REG	   <= 'b0;
			 		TDR			   <= 'b0;
			 		INTCLEAR       <= 'b0;
				end
				endcase
			end
			else if( (PADDR[11:7] == 0) && (! PWRITE) )
			begin
				case(PADDR[6:2])
				4'h0 :    begin 
								PRDATA <= CONFIG_REG; 
						  end
				4'h1 :    begin 
								PRDATA <= RDR; 
						  end
				4'h2 :    begin 
								PRDATA <= STATE_REG; 
						  end
				4'h3 :    begin 
								PRDATA <= INTSTATUS; 
						  end
				default : begin 
								PRDATA <= 'b0; 
						  end
				endcase
			end
		end
		else if (!apb_pulse)
		begin
			sel_cmd  		<= 'b0;
			sel_data 		<= 'b0;
			clear       	<= 'b0;
			INTCLEAR    	<= 'b0;
			fifo_tx_wr_en   <= 'b0;
		end		
	end
//==========================================================================================
// the data propgated to the master or the slave for transmission
//==========================================================================================
	assign DATA_SHIFT_REG = (CONFIG_REG[13]) ? tx_data_out : TDR;
//==========================================================================================
// the received data from the master or the slave
//==========================================================================================
	assign RDR = (CONFIG_REG[14])? rx_data_out : RX_REG;
//========================================================================================== 
// PRAEDY & PSLVERR
//==========================================================================================
	always_comb
	begin
		if(PADDR > 'h3 && PSEL)
		   error_signal = 1'b1;
		else if(PADDR == 'h2 && PWRITE == 1 && PSEL)
		   error_signal = 1'b1;
		else if(rx_empty && PADDR == 'h1 && PWRITE == 0)
		   error_signal = 1'b1;
		else
		    error_signal = 1'b0;
	end

    always_ff @ (posedge PCLK or negedge PRESETn)
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
//========================================================================================== 
// State Register
// * STATE_REG[0] Trasmission
// * STATE_REG[1] Recieve
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn) 
	begin
		if(!PRESETn)
		STATE_REG <= 'b0;
		else if (PWRITE && (PADDR[6:2] == 'h1)&& PSEL)
		STATE_REG[0] <= 'b1;
		else if (rx_pulse)
		begin
		  STATE_REG[0] <= 'b0;
		  STATE_REG[1] <= 'b1;
		end
		else if (!PWRITE && (PADDR[6:2] == 'h1)&& PSEL)
		STATE_REG[1] <= 'b0;	
	end
//==========================================================================================
// the pulse which generated when SPI is configurated as a slave (SS0 = 0)
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
	    if(!PRESETn)
	        begin
	        pul <= 1'b0;
	        end
	    else if (SS==0)
	        begin
	        pul <= 1'b1;
	        end
	    else
	        begin
	        pul <= 1'b0;
	        end
	end

	assign sel_data_slave = (~pul & !SS) ? 'b1 : 'b0; 
//==========================================================================================
// DMA Requests & Acknowledge
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
	    if(!PRESETn)
	    begin
	        rx_almostfull_reg <= 1'b0;
	    end
	    else if (rx_almostfull)
	    begin
	        rx_almostfull_reg <= 1'b1;
	    end
	    else
	    begin
	        rx_almostfull_reg <= 1'b0;
	    end
	end

	assign rx_almostfull_pul = (!rx_almostfull_reg & rx_almostfull) ? 'b1 : 'b0;
//==========================================================================================
// registering the DMA read Acknowledge
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn) 
	begin
		if(!PRESETn)
	    begin
	        read_ack <= 1'b0;
	    end
		else if (DMA_READ_ACK)
	    begin
	        read_ack <= 1'b1;
	    end
		else if (DMA_READ_DONE)
		begin
			read_ack <= 1'b0;
		end
	end
//==========================================================================================
// generating the DMA read Request
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn) 
	begin
		if(!PRESETn)
	    begin
	        DMA_READ_REQ <= 1'b0;
	    end
		else if (read_ack)
	    begin
	        DMA_READ_REQ <= 1'b0;
	    end
	    else if (CONFIG_REG[14] && CONFIG_REG[12] && rx_almostfull_pul) // in case of fifo mode
	    begin
	        DMA_READ_REQ <= 1'b1;
	    end	
		else if (!CONFIG_REG[14] && CONFIG_REG[12] && rx_pulse) // if the fifo mode is disabled
	    begin
	        DMA_READ_REQ <= 1'b1;
	    end	
	end
//==========================================================================================
// registering the DMA write Acknowledge
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn) 
	begin
		if(!PRESETn)
	    begin
	        write_ack <= 1'b0;
	    end
		else if (DMA_WRITE_ACK)
	    begin
	        write_ack <= 1'b1;
	    end
		else if (DMA_WRITE_DONE)
		begin
			write_ack <= 1'b0;
		end
	end
//==========================================================================================
// generating the DMA write Request
//==========================================================================================
always_ff @ (posedge PCLK or negedge PRESETn) 
begin
	if(!PRESETn)
    begin
        DMA_WRITE_REQ <= 1'b0;
    end
	else if (write_ack)
    begin
        DMA_WRITE_REQ <= 1'b0;
    end
    else if (CONFIG_REG[13] && CONFIG_REG[12] && tx_empty) // in case of fifo mode
    begin
        DMA_WRITE_REQ <= 1'b1;
    end	
	else if (!CONFIG_REG[13] && CONFIG_REG[12] && spi_pul) // if the fifo mode is disabled
    begin
        DMA_WRITE_REQ <= 1'b1;
    end	
end
//==========================================================================================
// the pulse for the spi master or slave to update their internal register with 
// the data for transmission
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			fifo_sel_data <= 1'b0;
		end
	    else if (fifo_tx_en && ~tx_empty && CONFIG_REG[13])
		begin
			fifo_sel_data <= 1'b1;
		end
		else
		begin
			fifo_sel_data <= 1'b0;
		end
	end
//==========================================================================================
// read and write enables of RX FIFO
//==========================================================================================
	always_ff @ (posedge PCLK or negedge PRESETn)				
	begin
		if(!PRESETn)
		begin
			fifo_rx_wr_en0 <= 0; 
			fifo_rx_wr_en  <= 0;
		end
		else if (CONFIG_REG[14])
		begin
			fifo_rx_wr_en0 <= FIFO_EN[1];
			fifo_rx_wr_en  <= fifo_rx_wr_en0; 
		end
	end

	always_ff @ (posedge PCLK or negedge PRESETn)				
	begin
		if(!PRESETn)
		begin
			fifo_rx_rd_en <= 1'b0;
		end
	    else if ((PADDR[6:2] == 4'h1) && PENABLE && !PWRITE && CONFIG_REG[14])
		begin
			fifo_rx_rd_en <= 1'b1;
		end
		else
		begin
			fifo_rx_rd_en <= 1'b0;
		end
	end
//==========================================================================================
// read enable of TX FIFO
//==========================================================================================
	assign fifo_tx_en = spi_idle & CONFIG_REG[13];
	//assign fifo_tx_rd_en = CONFIG_REG[13] && ((tx_fifo_sel_cmd && CONFIG_REG[6] && fifo_tx_en && ~tx_empty) || ((tx_fifo_sel_cmd || FIFO_EN[0]) && !CONFIG_REG[6] && fifo_tx_en && ~tx_empty));
	assign fifo_tx_rd_en = ((tx_fifo_sel_cmd && CONFIG_REG[6] && fifo_tx_en && ~tx_empty) || ((tx_fifo_sel_cmd || FIFO_EN[0]) && !CONFIG_REG[6] && fifo_tx_en && ~tx_empty));
//========================================================================================== 
// TX & RX FIFO Instantaition
//==========================================================================================
	FIFO #(.FIFO_DEPTH(8), .FIFO_WIDTH(8), .FALL_THROUGH(0)) FIFO_TX 
	(
	.data_in(TDR), 
	.wr_en(fifo_tx_wr_en), 
	.rd_en(fifo_tx_rd_en), 
	.clk(PCLK), 
	.rst_n(PRESETn), 
	.full(tx_full), 
	.empty(tx_empty), 
	.almostfull(),
	.almostempty(),
	.wr_ack(), 
	.overflow(),
	.underflow(),
	.data_out(tx_data_out)
	);

	FIFO #(.FIFO_DEPTH(8), .FIFO_WIDTH(8), .FALL_THROUGH(1)) FIFO_RX 
	(
	.data_in(RX_REG), 
	.wr_en(fifo_rx_wr_en), 
	.rd_en(fifo_rx_rd_en), 
	.clk(PCLK), 
	.rst_n(PRESETn), 
	.full(rx_full), 
	.empty(rx_empty), 
	.almostfull(rx_almostfull), 
	.almostempty(), 
	.wr_ack(), 
	.overflow(), 
	.underflow(), 
	.data_out(rx_data_out)
	);
//========================================================================================== 
// SPI Instantiation
//==========================================================================================
	SPI_TOP SPI
	(
		.PCLK(PCLK),
		.PRESETn(PRESETn),

		.SEL_DATA(sel_data || fifo_sel_data),
		.SEL_CMD(sel_cmd || tx_fifo_sel_cmd || rx_fifo_sel_cmd),
		.CLEAR(clear),
		.SEL_DATA_Slave(sel_data_slave),

		.CONFIG_REG(CONFIG_REG),
		.RX_REG(RX_REG),
		.FIFO_EN(FIFO_EN),
		.SPI_INT(SPI_INT),
		.SPI_INT_CLR(INTCLEAR[1:0]),
		.DATA_SHIFT_REG(DATA_SHIFT_REG),
		.RX_PULSE(rx_pulse),

		.M_SCK(M_SCK),   			// master output clk
		.M_MOSI(M_MOSI), 			// master output data
		.M_MISO(M_MISO), 			// master input data
			
		.S_MISO(S_MISO), 			// slave output data
	    .S_MOSI(S_MOSI), 			// slave input data
		.S_SCK(S_SCK),   			// input clock to slave
		.SS(SS), 		 			//input selector to the slave
		.SS0(SS0), 		 			// the slave selector 0, which is output from the master
		.SS1(SS1),       			// the slave selector 1, which is output from the master
		.SS2(SS2),       			// the slave selector 2, which is output from the master
		.SS3(SS3)        			// the slave selector 3, which is output from the master
	);
endmodule
 



