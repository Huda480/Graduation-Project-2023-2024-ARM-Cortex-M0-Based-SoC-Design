////////////////////////////////////////////////////////////////////////////////
// Author: Marwan Ahmed
// Title: MR AMD
////////////////////////////////////////////////////////////////////////////////
module FIFO
#(
	parameter int FIFO_WIDTH = 16,
	parameter int FIFO_DEPTH = 8,
	parameter int FALL_THROUGH = 0
)
(	
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
	input clk, rst_n,
	//==========================================================================
    // Control signals
    //==========================================================================
	input [FIFO_WIDTH-1:0] data_in, 
	input wire logic wr_en, rd_en,

	output reg [FIFO_WIDTH-1:0] data_out,
	output reg wr_ack, overflow,underflow,
	output full, empty, almostfull, almostempty
);
 
localparam int max_fifo_addr = $clog2(FIFO_DEPTH);


int i ;

logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
logic [max_fifo_addr:0] count;

initial 
begin
	for(i=0;i<FIFO_DEPTH;i=i+1)
	begin
		mem [i] = 'b0;
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
		wr_ptr <= 0;
		overflow <= 0;
		wr_ack <= 0;
	end
	else if (wr_en && count < FIFO_DEPTH) 
	begin
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow <= 0;
	end
	else 
	begin 
		wr_ack <= 0; 
		if (full & wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end


always @(posedge clk)
begin
	if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
		rd_ptr <= 0;
		underflow <= 1'b0;
	
	end
	else if (rd_en && count != 0) 
	begin
		rd_ptr <= rd_ptr + 1;
		underflow <= 1'b0;
	end
	else if(rd_en && empty) 
	begin
		underflow <= 1'b1;
	end
	else 
	begin
		underflow = 1'b0;
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else 
	begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		else if ({wr_en, rd_en} == 2'b11) 
		begin
			if(empty)
				count <= count+1;
			else if(full)
				count <= count -1;
		end
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;

generate if (FALL_THROUGH ==1) begin
	always_comb
	begin
		data_out = mem[rd_ptr];
	end

end
else
begin
	always_ff @(posedge clk or negedge rst_n) 
	begin
		if(!rst_n)
		data_out<=0;
		else if (rd_en && count != 0) 
		begin
			data_out <= mem[rd_ptr];
	    end
	end 
end
	
endgenerate



endmodule

