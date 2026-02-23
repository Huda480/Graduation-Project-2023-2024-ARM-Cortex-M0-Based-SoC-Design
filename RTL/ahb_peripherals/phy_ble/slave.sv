/*
======================================================================================
				File name:   AHB_Slave.sv
				Created:     11/14/2017
				Author:      Vaibhav Ramachandran
				Description: AHB Slave module
				Modified:     8/8/2024
======================================================================================
*/
module AHB_Slave_ble
#(
	parameter BASE_ADDRESS = 32'h0,
	parameter NUMBER_OF_ADDRESSES = 600
)
(
	//AHB-Lite interface signals
	input logic HCLK, HRESETn, HWRITE, HSEL,
	input logic [31:0] HADDR, HWDATA,
	input logic [1:0] HTRANS,
	input logic [2:0] HBURST, HSIZE,
	output logic [31:0] HRDATA,
	output logic HRESP, HREADYOUT,
	//Control module interface signals
	input logic [31:0] hrdata_ahb,
	input logic HREADY,
	input logic [7:0] fifo_rd_pntr,
	output logic [31:0] hwdata_ahb, 
	output logic [11:0] address,
	output logic renable, wenable,
	output logic [2:0] data_size, burst_size,
	output logic [1:0] data_trans,
	input fifo_empty,
	input w_done_flag,
	input mode
);

localparam ADDRESS_MAX = BASE_ADDRESS + NUMBER_OF_ADDRESSES - 1;

//Types of Transfers possible in AHB protocol
localparam IDLE_TRANS = 2'b00;
localparam BUSY_TRANS = 2'b01;
localparam NONSEQ_TRANS = 2'b10;
localparam SEQ_TRANS = 2'b11;

//Types of Burst transfers possible in AHB protocol
//HBURST is always SINGLE_BURST
localparam SINGLE_BURST = 3'b000;
localparam INCR_BURST = 3'b001;
localparam WRAP4_BURST = 3'b010;
localparam INCR4_BURST = 3'b011;
localparam WRAP8_BURST = 3'b100;
localparam INCR8_BURST = 3'b101;
localparam WRAP16_BURST = 3'b110;
localparam INCR16_BURST = 3'b111;

localparam SLAVE_OKAY = 1'b0;
localparam SLAVE_ERROR = 1'b1;

localparam SLAVE_READY = 1'b1;
localparam SLAVE_NOTREADY = 1'b0;

typedef enum bit [2:0] {IDLE, READ, WRITE, FIRST_ERROR, SECOND_ERROR} stateType;
stateType state, next_state;

logic [4:0] burst_counter; //Tracker for the current iteration in the burst sequence
logic [31:0] haddr_offset;

always_ff @ (posedge HCLK, negedge HRESETn) begin
	if(HRESETn == 0) begin
		state <= IDLE;
		burst_counter <= 0;
	end
	else begin
		state <= next_state;
		if(HTRANS == NONSEQ_TRANS)
			burst_counter <= 1;
		else if(HTRANS == SEQ_TRANS)
			burst_counter <= burst_counter + 1;
		else
			burst_counter <= burst_counter;
	end
end

always_comb begin
	next_state = state;
	case(state)
		IDLE: begin
			if(HSEL) begin
				if((HADDR[14:0] > ADDRESS_MAX) || (HTRANS != NONSEQ_TRANS))
					next_state = FIRST_ERROR;
				else if(HWRITE)
					next_state = WRITE;
				else 
					next_state = READ;
			end
			else
				next_state = IDLE;
		end
		READ: begin
			if(HTRANS == BUSY_TRANS)
				next_state = READ;
			else if(HSEL) begin
				if(HADDR[11:0] > ADDRESS_MAX)
					next_state = FIRST_ERROR;
				else if(HSEL && HWRITE && HTRANS == NONSEQ_TRANS)
					next_state = WRITE;
				else if(HSEL && ~HWRITE) begin
				    if(HADDR[11:0]=='h8)    next_state = FIRST_ERROR;
				    else if (mode && (HADDR[11:0] >= 'h10) ) next_state = FIRST_ERROR;
				    else if (~mode && fifo_empty) next_state = FIRST_ERROR;
				    else                   next_state = READ;
			    end
				else
					next_state = FIRST_ERROR;
			end
			else
				next_state = IDLE;
		end
		WRITE: begin
			if(HTRANS == BUSY_TRANS)
				next_state = WRITE;
			else if(HSEL) begin
				if(HADDR[11:0] > ADDRESS_MAX)
					next_state = FIRST_ERROR;
				else if(HSEL && ~HWRITE && HTRANS == NONSEQ_TRANS)
					next_state = READ;
				else if(HSEL && HWRITE)
					next_state = WRITE;
				else
					next_state = FIRST_ERROR;
			end
			else
				next_state = IDLE;
		end
		FIRST_ERROR: begin			
		    //First of two error cycles needed as per the specifications in the AHB protocol manual
			next_state = SECOND_ERROR;
		end
		SECOND_ERROR: begin
			next_state = IDLE;
		end
	endcase
end

//Assigning the outputs based on conditions met in the state machine
assign HRESP = ((state == FIRST_ERROR) || (state == SECOND_ERROR))? SLAVE_ERROR : SLAVE_OKAY;
//assign current_count = burst_counter;
//assign HRDATA = (state == READ) ? hrdata_ahb : 'b0;
assign HRDATA = hrdata_ahb;
assign hwdata_ahb = HWDATA;
//need to be tied to haddress, hsel, htrans and the clk speed of tx compared with hclk to not overwrite the unread data from FIFO
//we are serializing using 3.472 MHz clk, so we need "3.472/32 = 0.1085" to read the first word
//we could compare the rd_pointer of fifo with the haddress when hsel & hwrite are asserted
assign haddr_offset = HADDR - 'h10;
assign HREADYOUT = (state == FIRST_ERROR)? 1'b0 : mode ? HREADY && ~w_done_flag : HREADY;
//assign HREADYOUT = (state == FIRST_ERROR)? 1'b0 : HREADY && (!(HSEL && HWRITE && !fifo_empty && (haddr_offset[9:2] >= fifo_rd_pntr)));
//assign HREADYOUT = ((state == FIRST_ERROR)? 1'b0 : ((state == SECOND_ERROR)? 1'b0 : ~HREADY));
assign address = HADDR[11:0];
assign burst_size = HBURST;
assign data_size = HSIZE;
assign renable = HSEL && ~HWRITE;
//assign renable = (((state == READ) || ((state == IDLE) && HSEL && ~HWRITE)) && HTRANS != BUSY_TRANS);
assign wenable = HSEL && HWRITE;
//assign wenable = (((state == WRITE) || ((state == IDLE) && HSEL && HWRITE)) && HTRANS != BUSY_TRANS);
assign data_trans = HTRANS;

endmodule 