//===========================================================
// Purpose: Block RAM
// Used in:
//===========================================================
module segmentation_memory 
#(
  parameter int DIM   = 8            ,
  parameter int WIDTH = 8            ,
  parameter int DEPTH = 8192         ,
  parameter int ADDR  = $clog2(DEPTH),
  parameter     IMG1 = "image1.txt"  ,
  parameter     IMG2 = "image2.txt"  ,
  parameter     IMG3 = "image3.txt"  ,
  parameter     IMG4 = "image4.txt"  ,
  parameter     IMG5 = "image5.txt"  ,
  parameter     IMG6 = "image6.txt"  ,
  parameter     IMG7 = "image7.txt"  ,
  parameter     IMG8 = "image8.txt"
) (
  //=======================================================
  // Controls
  //=======================================================
  input  logic             clk       ,
  input  logic             we        ,
  //=======================================================
  // Inputs
  //=======================================================
  input  logic [ ADDR-1:0] addr      ,
  input  logic [WIDTH-1:0] di [DIM]  ,
  //=======================================================
  // Outputs
  //=======================================================
  output logic [WIDTH-1:0] dout	[DIM]
);
  //=======================================================
  // Internals
  //=======================================================
  //generate
  //  genvar n;
  //  for (n = 0; n < DIM; n++)
  //    begin: gen_ram_decl
        (* ram_style = "block" *) logic [WIDTH-1:0] ram_1 [0:DEPTH-1];
        (* ram_style = "block" *) logic [WIDTH-1:0] ram_2 [0:DEPTH-1];
        (* ram_style = "block" *) logic [WIDTH-1:0] ram_3 [0:DEPTH-1];
        (* ram_style = "block" *) logic [WIDTH-1:0] ram_4 [0:DEPTH-1];
        (* ram_style = "block" *) logic [WIDTH-1:0] ram_5 [0:DEPTH-1];
        (* ram_style = "block" *) logic [WIDTH-1:0] ram_6 [0:DEPTH-1];
        (* ram_style = "block" *) logic [WIDTH-1:0] ram_7 [0:DEPTH-1];
        (* ram_style = "block" *) logic [WIDTH-1:0] ram_8 [0:DEPTH-1];


        initial begin
          $readmemb( IMG1,ram_1); 
          $readmemb( IMG2,ram_2);
          $readmemb( IMG3,ram_3);
          $readmemb( IMG4,ram_4);
          $readmemb( IMG5,ram_5);
          $readmemb( IMG6,ram_6);
          $readmemb( IMG7,ram_7);
          $readmemb( IMG8,ram_8);
        end
  //    end: gen_ram_decl
  //endgenerate
  //=======================================================
  //generate
  //  genvar i;
  //  for (i = 0; i < DIM; i++)
  //    begin : gen_ram
        always @(posedge clk)
        begin
            if (we)
              ram_1[addr] <= di[0];
            else
              dout[0] <= ram_1[addr];
        end
        always @(posedge clk)
        begin
            if (we)
              ram_2[addr] <= di[1];
            else
              dout[1] <= ram_2[addr];
        end
        always @(posedge clk)
        begin
            if (we)
              ram_3[addr] <= di[2];
            else
              dout[2] <= ram_3[addr];
        end
        always @(posedge clk)
        begin
            if (we)
              ram_4[addr] <= di[3];
            else
              dout[3] <= ram_4[addr];
        end
        always @(posedge clk)
        begin
            if (we)
              ram_5[addr] <= di[4];
            else
              dout[4] <= ram_5[addr];
        end
        always @(posedge clk)
        begin
            if (we)
              ram_6[addr] <= di[5];
            else
              dout[5] <= ram_6[addr];
        end
        always @(posedge clk)
        begin
            if (we)
              ram_7[addr] <= di[6];
            else
              dout[6] <= ram_7[addr];
        end
        always @(posedge clk)
        begin
            if (we)
              ram_8[addr] <= di[7];
            else
              dout[7] <= ram_8[addr];
        end
  //      end : gen_ram
  //  endgenerate
    //=======================================================
  endmodule