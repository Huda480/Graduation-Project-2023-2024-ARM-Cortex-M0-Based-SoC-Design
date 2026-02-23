module mem_dma #(
//==========================================================================
// Parameters
//==========================================================================  
parameter depth = 256,num_of_addr = 1 + $clog2(depth),fall_through = 1) (
//==========================================================================
// Inputs & Outputs
//==========================================================================
    //==========================================================================
    // Clocks and resets
    //==========================================================================
    input                   clk,
    input                   reset,
    //==========================================================================
    // Control signals
    //==========================================================================
    input  [2:0]            transfer_size,
    input  [31:0]           write_data,
    input                   read_enable,
    input                   response,
    input                   write_enable,
    output reg [31:0]       read_data
);
//==========================================================================
// Internal signls
//==========================================================================
  reg         rd_en_1;
  reg         rd_en_2;
  reg         rd_en_3;
  reg         rd_en_4;
  reg         wr_en_1;
  reg         wr_en_2;
  reg         wr_en_3;
  reg         wr_en_4;
  reg [1:0]   wr_count;
  reg [1:0]   rd_count;
  reg [31:0]  data_write;
  wire[31:0]  data_read;
//==========================================================================
// Main code
//==========================================================================
  always@(posedge clk or negedge reset)
  begin
    if(!reset)
    wr_count <= 2'b0;
    else if (write_enable) begin
        wr_count <= wr_count + (2'b1 << transfer_size);
    end
  end

  always@(posedge clk or negedge reset)
  begin
    if(!reset)
    rd_count <= 2'b0;
    else if (read_enable) begin
        rd_count <= rd_count + (2'b1 << transfer_size);
    end
  end

  always_comb
  begin
    if (read_enable)
    begin
        case(transfer_size)
            3'b0: begin
                case(rd_count[1:0])
                    2'b0: begin
                        rd_en_1 = 1'b1;
                        rd_en_2 = 1'b0;
                        rd_en_3 = 1'b0;
                        rd_en_4 = 1'b0;
                        read_data = {24'b0,data_read[7:0]};
                    end
                    2'b1: begin
                        rd_en_1 = 1'b0;
                        rd_en_2 = 1'b1;
                        rd_en_3 = 1'b0;
                        rd_en_4 = 1'b0;
                        read_data = {24'b0,data_read[15:8]};
                    end
                    2'b10: begin
                        rd_en_1 = 1'b0;
                        rd_en_2 = 1'b0;
                        rd_en_3 = 1'b1;
                        rd_en_4 = 1'b0;
                        read_data = {24'b0,data_read[23:16]};
                    end
                    2'b11: begin
                        rd_en_1 = 1'b0;
                        rd_en_2 = 1'b0;
                        rd_en_3 = 1'b0;
                        rd_en_4 = 1'b1;
                        read_data = {24'b0,data_read[31:24]};
                    end
                endcase
            end
            3'b1: begin
                case(rd_count[1])
                    1'b0: begin
                        rd_en_1 = 1'b1;
                        rd_en_2 = 1'b1;
                        rd_en_3 = 1'b0;
                        rd_en_4 = 1'b0;
                        read_data = {24'b0,data_read[15:0]};
                    end
                    1'b1: begin
                        rd_en_1 = 1'b0;
                        rd_en_2 = 1'b0;
                        rd_en_3 = 1'b1;
                        rd_en_4 = 1'b1;
                        read_data = {24'b0,data_read[31:16]};
                    end
                endcase
            end
            default : begin
                rd_en_1 = 1'b1;
                rd_en_2 = 1'b1;
                rd_en_3 = 1'b1;
                rd_en_4 = 1'b1;
                read_data = data_read;
            end
        endcase
    end
    else
    begin
        rd_en_1 = 1'b0;
        rd_en_2 = 1'b0;
        rd_en_3 = 1'b0;
        rd_en_4 = 1'b0;
        read_data = 32'b0;
    end
  end




  always_comb
  begin
    if (write_enable)
    begin
        case(transfer_size)
            3'b0: begin
                case(wr_count[1:0])
                    2'b0: begin
                        wr_en_1 = 1'b1;
                        wr_en_2 = 1'b0;
                        wr_en_3 = 1'b0;
                        wr_en_4 = 1'b0;
                        data_write = {24'b0 , write_data[7:0]} ;
                    end
                    2'b1: begin
                        wr_en_1 = 1'b0;
                        wr_en_2 = 1'b1;
                        wr_en_3 = 1'b0;
                        wr_en_4 = 1'b0;
                        data_write = {16'b0 , write_data[7:0] , 8'b0 } ;                      
                    end
                    2'b10: begin
                        wr_en_1 = 1'b0;
                        wr_en_2 = 1'b0;
                        wr_en_3 = 1'b1;
                        wr_en_4 = 1'b0;
                        data_write = {8'b0 , write_data[7:0],16'b0} ;
                    end
                    2'b11: begin
                        wr_en_1 = 1'b0;
                        wr_en_2 = 1'b0;
                        wr_en_3 = 1'b0;
                        wr_en_4 = 1'b1;
                        data_write = {write_data[7:0],24'b0} ;
                    end
                endcase
            end
            3'b1: begin
                case(wr_count[1])
                    1'b0: begin
                        wr_en_1 = 1'b1;
                        wr_en_2 = 1'b1;
                        wr_en_3 = 1'b0;
                        wr_en_4 = 1'b0;
                        data_write = {16'b0 , write_data[15:0]} ;
                    end
                    1'b1: begin
                        wr_en_1 = 1'b0;
                        wr_en_2 = 1'b0;
                        wr_en_3 = 1'b1;
                        wr_en_4 = 1'b1;
                        data_write = {write_data[15:0],16'b0} ;
                    end
                endcase
            end
            default : begin
                wr_en_1 = 1'b1;
                wr_en_2 = 1'b1;
                wr_en_3 = 1'b1;
                wr_en_4 = 1'b1;
                data_write = write_data;
            end
        endcase
    end
    else
    begin
        wr_en_1 = 1'b0;
        wr_en_2 = 1'b0;
        wr_en_3 = 1'b0;
        wr_en_4 = 1'b0;
        data_write = 32'b0;
    end
  end



  FIFO_dma  #(.FIFO_WIDTH(8),.FIFO_DEPTH(depth),.FALL_THROUGH(fall_through)) FIFO_1 (
  .data_in(data_write[7:0]),
  .clk(clk),
  .rst_n(reset),
  .response(response),
  .wr_en(wr_en_1),
  .rd_en(rd_en_1),
  .data_out(data_read[7:0])
  );



  FIFO_dma  #(.FIFO_WIDTH(8),.FIFO_DEPTH(depth),.FALL_THROUGH(fall_through)) FIFO_2 (
  .data_in(data_write[15:8]),
  .clk(clk),
  .rst_n(reset),
  .response(response),
  .wr_en(wr_en_2),
  .rd_en(rd_en_2),
  .data_out(data_read[15:8])
  );


  FIFO_dma  #(.FIFO_WIDTH(8),.FIFO_DEPTH(depth),.FALL_THROUGH(fall_through)) FIFO_3 (
  .data_in(data_write[23:16]),
  .clk(clk),
  .rst_n(reset),
  .response(response),
  .wr_en(wr_en_3),
  .rd_en(rd_en_3),
  .data_out(data_read[23:16])
  );


  FIFO_dma  #(.FIFO_WIDTH(8),.FIFO_DEPTH(depth),.FALL_THROUGH(fall_through)) FIFO_4 (
  .data_in(data_write[31:24]),
  .clk(clk),
  .rst_n(reset),
  .response(response),
  .wr_en(wr_en_4),
  .rd_en(rd_en_4),
  .data_out(data_read[31:24])
  );


endmodule

  
      
