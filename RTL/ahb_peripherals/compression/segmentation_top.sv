module segmentation_top #(
  parameter int DIM = 8,
  parameter int DEPTH = 8192         ,
  parameter int ADDR  = $clog2(DEPTH),
  parameter int WIDTH = 8             ,
  parameter     IMG1 = "image1.txt"  ,
  parameter     IMG2 = "image2.txt"  ,
  parameter     IMG3 = "image3.txt"  ,
  parameter     IMG4 = "image4.txt"  ,
  parameter     IMG5 = "image5.txt"  ,
  parameter     IMG6 = "image6.txt"  ,
  parameter     IMG7 = "image7.txt"  ,
  parameter     IMG8 = "image8.txt"           
)
(
  input logic clk, rst,
  input logic enable,
  input logic we,
  input wire logic [WIDTH-1:0] din [DIM],
  //output logic finished, 
  output logic valid_out,
  output logic [WIDTH-1:0] data_out   [DIM] 
  );
  
  //============================
  logic [ADDR-1:0] address;
  //============================

  ////////////////////////////////////////

  logic [3:0] enable_counter;
  logic enable_internal;

  //Enable signal from configuration register file ahb_to_compressor
  //Creates an enable bit that is high for 8 clock cycles and low for 8 clock cycles
  always_ff @ (posedge clk or negedge rst)
  begin
      if (!rst)
        enable_internal <= 1'b0;
      else
        enable_internal <= enable_counter[3];
  end

  //Enable signal from configuration register file ahb_to_compressor
  always_ff @ (posedge clk or negedge rst)
  begin
      if (!rst)
          enable_counter <= 'b0;
      else
      begin
          if (enable)
              enable_counter <= enable_counter + 1'b1;
          else
              enable_counter <= 'b0;
      end
  end
  ////////////////////////////////////

  segmentation_memory #(
    .DIM  (DIM  ),
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .ADDR (ADDR ),
    .IMG1 (IMG1 ),
    .IMG2 (IMG2 ),
    .IMG3 (IMG3 ),
    .IMG4 (IMG4 ),
    .IMG5 (IMG5 ),
    .IMG6 (IMG6 ),
    .IMG7 (IMG7 ),
    .IMG8 (IMG8 )
  ) image_memory_inst (
    .clk (clk),
    .we  (we),
    .addr(address),
    .di  (din),
    .dout(data_out)
  );
  
  segmentation_controller #(
    .DEPTH(DEPTH),
    .ADDR (ADDR )
  ) image_segmentation_inst (
    .clk      (clk),
    .rst_n    (rst),
    .enable   (enable_internal),
    .valid_out(valid_out),
    //.finished (finished),
    .addr_out (address)
  );


endmodule