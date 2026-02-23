//==========================================================================================
// Purpose: SPI Master
// Used in: SPI_TOP
//==========================================================================================
//==========================================================================================
// Module declaration
//==========================================================================================
module SPI_Master import spi_pkg::*;
(
//============================================================================
// I/Os
//============================================================================
  //==========================================================================
  // APB signals
  //==========================================================================
	input 				PRESETn,
	input 				PCLK,
  //==========================================================================
  // Master inputs
  //==========================================================================
	input 				SEL_DATA,			// select data flag is set when there is an apb transfer with the address of the data register from the top
	input 				SEL_CMD,			// select command flag is set when there is an apb transfer with the address of the configuration regiser from the top
	input				CLEAR,				// clear flag is set when there is an apb transfer with the address of the interrupt clear register from the top
	input  		[15:0] 	CONFIG_REG, 		// The used register to configure the master
	input  		[1:0] 	SPI_INT_CLR, 		// the register that clears the interrupt status register
	input  		[7:0] 	DATA_SHIFT_REG,		// The register which is updated with the data to be transmitted from the top
	input 				MISO_half_duplex,	// SPI master input in case of half duplex
	input 				MISO,				// SPI master input
  //==========================================================================
  // Master outputs
  //==========================================================================
	output reg 	[7:0] 	RX_REG,				// The regiseter which have the received data for the top
	output reg 	[1:0] 	SPI_INT,			// the register that has the interrupt status for the top
	output reg 	[1:0] 	FIFO_EN,			// the register that has the enable for writing in the rx fifo and reading from the tx fifo for the top
	output				RX_PULSE,			// the generated pulse when the receiving seesion of the data end
	output 	 			MOSI, 				// SPI master output
	output reg  		SCK,				// SPI master clock
	output reg 			SS0,				// SPI output select0
	output reg 			SS1,				// SPI output select1
	output reg 			SS2,				// SPI output select2
	output reg 			SS3					// SPI output select3
);
  //==========================================================================
  // internal signals
  //==========================================================================
	wire   	  	spi_en;        				// SPI Master enable
	reg 		cmd; 		   				// the command that enables master to initiate session
	wire [1:0]  mode;          				// the register that has the clock mode configuration	  

	reg  [3:0] 	divider;       				// the register that has the clock division ratio
	reg  [3:0] 	counter;       				// the register that has the clock counter value for different clock division ratios

	reg  [4:0] 	sck_cnt; 	   				// the register that counts with every pos and neg edge of the clock signal 
	reg 		sck_en;    				// the register that has the generated clock enable based on sck_cnt value the enable of generated clock is set and reset
	reg 		spi_clk;       				// the register that has the generated clock to the selected slaves

	reg			d_ffp;         				// positive edge detector
	wire		p_edge;		   				// the generated positive edge pulse for clock signal generation
	reg			d_ffn;		   				// negative edge detector	   
	wire		n_edge;		   				// the generated negative edge pulse for clock signal generation

	reg 		capture; 	  				// the flag that enables tx and rx operation
	reg 		tx_end;	   					// the flag that indicates the end of the transfer

	reg 	  	shift_in;      				// register serial input and output bits
	reg  [7:0] 	shift_reg;     				// register received and transmitted data

	reg 		rx_dff;        				// register used to generate pulse when the session end 

	reg 		rx_int_flag;  				// rx interrupt flag
	reg 		tx_int_flag;  				// tx interrupt flag
	reg 		clear_flag;   				// flag for clearing the interrupts and the receiving data register after reading the data as expected

	state_t   	state;    	  				// fsm states
  //==========================================================================
  // SPI Master Enable
  //==========================================================================
	assign spi_en = CONFIG_REG[10];
  //==========================================================================
  // SPI Master Start Session Enable
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			cmd <= 'b0;
		end
		else if (SEL_CMD && CONFIG_REG[6])
		begin
			cmd <= CONFIG_REG[10];	
		end
		else if(state == CONFIGURE)
		begin
			cmd <='b0;
		end 
	end
  //==========================================================================
  // Clock Mode Configuration
  //==========================================================================
	assign mode = CONFIG_REG[5:4];	
  //==========================================================================
  // Clock Division Ratio
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			divider<=4'b0000;
		end
		else if(state == CONFIGURE)
		begin
			case(CONFIG_REG[1:0])
			2'b00: divider<=4'b0001;
			2'b01: divider<=4'b0011;
			2'b10: divider<=4'b0111;
			2'b11: divider<=4'b1111;
			endcase
		end
	end
  //==========================================================================
  // Positive Edge Detector
  //==========================================================================
	always_ff @(posedge PCLK)
	begin
		if(sck_en==1)
		begin
			if(PRESETn==0)
			begin
				d_ffp<=1'b0;
			end
			else if (spi_clk==1)
			begin
				d_ffp<=1'b1;
			end
			else
			begin
				d_ffp<=1'b0;
			end
		end
	end

	assign p_edge = sck_en? (~d_ffp & spi_clk): 1'b0;
  //==========================================================================
  // Negative Edge Detector
  //==========================================================================
	always_ff @(posedge PCLK)
	begin
		if(sck_en==1)
		begin
			if(PRESETn==0)
			begin
				d_ffn<=1'b0;
			end
			else if (spi_clk==0)
			begin
				d_ffn<=1'b1;
			end
			else
			begin
				d_ffn<=1'b0;
			end
		end
	end

	assign n_edge = sck_en? (~d_ffn & ~spi_clk): 1'b0; 
  //==========================================================================
  // Clock Configuration Generation
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			spi_clk <= 'b0;
			counter <= 4'b0000;
		end
		else if(state==IDLE && cmd)
		begin
			spi_clk <= CONFIG_REG[5]; // clock polarity
		end
		else if(state==CONFIGURE)
		begin
			counter <= 4'b0000;
		end
		else if(sck_en==1)
		begin
			if(counter==divider)
			begin
				counter <= 4'b0000;
				spi_clk <= ~spi_clk;
			end
			else
			begin
				counter <= counter+1'b1;
			end
		end
	end
  //==========================================================================
  // Clock Generation
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			SCK <= 1'b0;
		end
		else if(sck_en==1)
		begin
			if(p_edge)
			begin
				SCK <= 1'b1;
			end
			else if(n_edge)
			begin
				SCK <= 1'b0;
			end
		end
		else
		begin
			SCK <= 1'b0;
		end
	end
  //==========================================================================
  // FSM Enable
  //==========================================================================
	always_ff @  (posedge PCLK or negedge PRESETn)
	begin
	  if(!PRESETn)
	  capture <= 'b0;
	  else if (p_edge && (mode == 1 || mode == 2))
	  capture <= 'b1;
	  else if (n_edge && (mode == 0 || mode == 3))
	  capture <= 'b1;
	  else if (state==TRANSFER_END)
	  capture <= 'b0;
	end
  //==========================================================================
  // Slave Selection
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			SS0 <= 1;
			SS1 <= 1;
			SS2 <= 1;
			SS3 <= 1;
		end
		else if(state == CONFIGURE) 
		begin
			case (CONFIG_REG[3:2])
			2'b00: SS0 <= 0;
			2'b01: SS1 <= 0;
			2'b10: SS2 <= 0;
			2'b11: SS3 <= 0;
			endcase
		end
		else if (state == TRANSFER_END) 
		begin
			SS0 <= 1;
			SS1 <= 1;
			SS2 <= 1;
			SS3 <= 1;
		end
	end
  //==========================================================================
  // Master FSM 
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
	    	RX_REG     <= 8'b0;
			sck_en	   <= 1'b0;
			state      <= IDLE;
			tx_end     <= 0;
		end
		else if(CONFIG_REG[6])
		begin
	    case (state)
	    IDLE : 
	    begin
			tx_end <= 0;
	        if(!cmd && RX_PULSE)  
	            RX_REG <= shift_reg;
			else if (clear_flag)
				RX_REG <= 'b0; 		  
	        else if (cmd)  //BUSY state
	            state  <= CONFIGURE;
	    end
	    CONFIGURE :
	    begin
			tx_end <= 0;
	        state <= TRANSFER;
	    end
	    TRANSFER:
	    begin
			tx_end <= 0;
			sck_en <= 1'b1;
			if(sck_cnt<16)
			begin
				sck_en <= 1'b1;
			end
			else
			begin
				sck_en <= 1'b0;
				state      <= TRANSFER_END;
			end        
	    end
	    TRANSFER_END: 
	    begin
			state <= IDLE;    
			tx_end <= 1;
	    end
	    endcase
		end
	end	
  //==========================================================================
  // Master Output Generation
  //==========================================================================
	assign MOSI = ((({SS0,SS1,SS2,SS3})!=4'b1111)  )? shift_reg[7] : 1'b0;
  //==========================================================================
  // Tranmitting and Receiving Data
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			shift_reg <= 8'b0;
			sck_cnt   <= 4'b0000;
			shift_in  <= 1'b0;
		end
		else if (SEL_DATA && CONFIG_REG[6])
		begin
			shift_reg <= DATA_SHIFT_REG;	
		end
		else if(state==CONFIGURE || state==TRANSFER_END)
		begin
			sck_cnt <= 4'b0000;
		end
		else if(state== TRANSFER && capture)
		begin
		    if(!CONFIG_REG[7]) 	//full duplex mode
		    begin
		        shift_in <= MISO;
		    end
			else               // half duplex mode
		    begin  
			    shift_in <= MISO_half_duplex;
		    end	
		    if(p_edge)
		    begin
		        sck_cnt <= sck_cnt + 1'b1;
		        case (mode)
		        2'b00 : 
		        begin           
		            if(!CONFIG_REG[7]) 	//full duplex mode
		            begin
		                shift_in <= MISO;
		            end
					else                // half duplex mode
		            begin  
					    shift_in <= MISO_half_duplex;
		            end				
		        end
		        2'b01 : 
		        begin
					shift_reg    <= shift_reg << 1;
					shift_reg[0] <= shift_in;
		        end
		        2'b10 : 
		        begin
					shift_reg    <= shift_reg << 1;
					shift_reg[0] <= shift_in;
		        end
		        2'b11 : 
		        begin
		            if(!CONFIG_REG[7]) 	//full duplex mode
		            begin
		                shift_in <= MISO;
		            end
					else                // half duplex mode
		            begin  
					    shift_in <= MISO_half_duplex;
		            end
		        end
		        endcase
		    end
		    else if (n_edge)
		    begin
		        sck_cnt <= sck_cnt + 1'b1;
		        case (mode)
		        2'b00 : 
		        begin
					shift_reg    <= shift_reg << 1;
					shift_reg[0] <= shift_in;            
		        end
		        2'b01 : 
		        begin
		            if(!CONFIG_REG[7]) 	//full duplex mode
		            begin
		                shift_in <= MISO;
		            end
					else                // half duplex mode
		            begin  
					    shift_in <= MISO_half_duplex;
		            end            
		        end
		        2'b10 : 
		        begin
		            if(!CONFIG_REG[7]) 	//full duplex mode
		            begin
		                shift_in <= MISO;
		            end
					else                // half duplex mode
		            begin  
					    shift_in <= MISO_half_duplex;
		            end            
		        end
		        2'b11 : 
		        begin
		 			shift_reg    <= shift_reg << 1;
					shift_reg[0] <= shift_in;           
		        end
		        endcase        
		    end
		end	
	end
  //==========================================================================
  // End of Receive Session Pulse
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		begin
			rx_dff <= 1'b0;
		end
	    else if (SS0 == 0 || SS1 == 0 || SS2 == 0 || SS3 == 0)
		begin
			rx_dff <= 1'b1;
		end
		else
		begin
			rx_dff <= 1'b0;
		end
	end

	assign RX_PULSE = rx_dff & (SS0 == 1 && SS1 == 1 && SS2 == 1 && SS3 == 1); 
  //==========================================================================
  // rx interrupt flag generation
  //==========================================================================
	always_ff @  (posedge PCLK or negedge PRESETn)
	begin
	  	if (!PRESETn)
			rx_int_flag <= 0;
		else if (RX_PULSE)
			rx_int_flag <= 1;
		else if (SPI_INT_CLR[1])
			rx_int_flag <= 0;
	end
  //==========================================================================
  // clear interrupt flag
  //==========================================================================
	always_ff @  (posedge PCLK or posedge PRESETn)
	begin
		if(!PRESETn)
			clear_flag <= 1'b0;
	 	else if(CLEAR)
	  		clear_flag <= 1'b1;
	  	else if (SEL_DATA)
	  		clear_flag <= 1'b0;
	end
  //==========================================================================
  // tx interrupt flag
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
		        tx_int_flag <= 'b0;
	    else if(spi_en  && state == TRANSFER_END && CONFIG_REG[7] == 0) // Transmission Session   CONFIG_REG[10] == TX_EN // FULL DUPLEX MODE
				tx_int_flag <= 'b1;     
		else if(spi_en && state == TRANSFER_END && CONFIG_REG[7] == 1 && CONFIG_REG[11] == 0) // Transmission Session   CONFIG_REG[10] == TX_EN // Half DUPLEX MODE
				tx_int_flag <= 'b1; 
		else if(clear_flag)
				tx_int_flag <= 'b0;  
	end
  //==========================================================================
  // tx interrupt generation
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
			SPI_INT[0] <= 'b0;
		else if(tx_int_flag && CONFIG_REG[6] == 1 && CONFIG_REG[8] == 1 && SPI_INT_CLR[0] == 0 ) 
			SPI_INT[0] <= 'b1;
		else if(SPI_INT_CLR[0]==1 && CONFIG_REG[8] == 1 && CONFIG_REG[6] == 1)
			SPI_INT[0] <= 'b0;
	    else if(CONFIG_REG[6] == 0)
			SPI_INT[0] <= 'b0;
	end
  //==========================================================================
  // rx interrupt generation
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
			SPI_INT[1] <= 'b0;
		else if((RX_REG == shift_reg) && rx_int_flag && SPI_INT_CLR[1] != 1 && CONFIG_REG[9] == 1 && CONFIG_REG[6] == 1 && CONFIG_REG[7] ==0 ) 
			SPI_INT[1] <= 'b1;
		else if((RX_REG == shift_reg) && rx_int_flag && SPI_INT_CLR[1] != 1 && CONFIG_REG[9] == 1 && CONFIG_REG[6] == 1 && CONFIG_REG[7] ==1  && CONFIG_REG[11] == 1) 
			SPI_INT[1] <= 'b1;
		else if(SPI_INT_CLR[1] && CONFIG_REG[9] == 1 && CONFIG_REG[6] == 1)
			SPI_INT[1] <= 'b0;	
	    else if(CONFIG_REG[6] == 0)
			SPI_INT[1] <= 'b0;
	end

 //==========================================================================
  // enable read from tx fifo
  //========================================================================== 
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
			FIFO_EN[0] <= 'b0;
		else if (FIFO_EN[0])
			FIFO_EN[0] <= 'b0;
		else if (tx_end)
			FIFO_EN[0] <= 'b1;
	end
  //==========================================================================
  // enable write in rx fifo
  //==========================================================================
	always_ff @(posedge PCLK or negedge PRESETn)
	begin
		if(!PRESETn)
			FIFO_EN[1] <= 'b0;
		else if (FIFO_EN[1])
			FIFO_EN[1] <= 'b0;
		else if (RX_PULSE)
			FIFO_EN[1] <= 'b1;
	end

endmodule

