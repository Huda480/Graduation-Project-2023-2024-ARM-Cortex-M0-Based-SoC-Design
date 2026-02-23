`timescale  1ns/1ps


module dma_test #( parameter         rf_addr  = 0,
  parameter [1:0]   pri_sel  = 2'h0,
  parameter         ch_count = 1,
  parameter [3:0]   ch0_conf = 4'h1,
  parameter [3:0]   ch1_conf = 4'h0,
  parameter [3:0]   ch2_conf = 4'h0,
  parameter [3:0]   ch3_conf = 4'h0,
  parameter [3:0]   ch4_conf = 4'h0,
  parameter [3:0]   ch5_conf = 4'h0,
  parameter [3:0]   ch6_conf = 4'h0,
  parameter [3:0]   ch7_conf = 4'h0,
  parameter [3:0]   ch8_conf = 4'h0,
  parameter [3:0]   ch9_conf = 4'h0,
  parameter [3:0]   ch10_conf = 4'h0,
  parameter [3:0]   ch11_conf = 4'h0,
  parameter [3:0]   ch12_conf = 4'h0,
  parameter [3:0]   ch13_conf = 4'h0,
  parameter [3:0]   ch14_conf = 4'h0,
  parameter [3:0]   ch15_conf = 4'h0,
  parameter [3:0]   ch16_conf = 4'h0,
  parameter [3:0]   ch17_conf = 4'h0,
  parameter [3:0]   ch18_conf = 4'h0,
  parameter [3:0]   ch19_conf = 4'h0,
  parameter [3:0]   ch20_conf = 4'h0,
  parameter [3:0]   ch21_conf = 4'h0,
  parameter [3:0]   ch22_conf = 4'h0,
  parameter [3:0]   ch23_conf = 4'h0,
  parameter [3:0]   ch24_conf = 4'h0,
  parameter [3:0]   ch25_conf = 4'h0,
  parameter [3:0]   ch26_conf = 4'h0,
  parameter [3:0]   ch27_conf = 4'h0,
  parameter [3:0]   ch28_conf = 4'h0,
  parameter [3:0]   ch29_conf = 4'h0,
  parameter [3:0]   ch30_conf = 4'h0) ();



 reg                 clk_i;
  reg                 rst_n_i;

  // --------------------------------------
  // AHB3-Lite INTERFACE 0
  // Slave Interface
  reg                 s0HSEL;
  reg  [31:0]         s0HADDR;
  reg  [31:0]         s0HWDATA;
  wire [31:0]         s0HRDATA;
  reg                 s0HWRITE;
  reg  [ 2:0]         s0HSIZE;
  reg  [ 2:0]         s0HBURST;
  reg  [ 3:0]         s0HPROT;
  reg  [ 1:0]         s0HTRANS;
  wire                s0HREADYOUT;
  reg                 s0HREADY;
  wire                s0HRESP;

  // Master Interface
  wire                m0HSEL;
  wire [31:0]         m0HADDR;
  wire [31:0]         m0HWDATA;
  reg  [31:0]         m0HRDATA;
  wire                m0HWRITE;
  wire [ 2:0]         m0HSIZE;
  wire [ 2:0]         m0HBURST;
  wire [ 3:0]         m0HPROT;
  wire [ 1:0]         m0HTRANS;
  wire                m0HREADYOUT;
  reg                 m0HREADY;
  reg                 m0HRESP;






  //DRAM
DATA_SRAM_TOP DATA_SRAM_TOP_instance(
    .HCLK(clk_i),
    .HRESETn(rst_n_i),
    .HSEL(m0HSEL),
    .HREADY(m0HREADY),
    .HTRANS( m0HTRANS),
    .HSIZE(m0HSIZE),
    .HWRITE(m0HWRITE),
    .HADDR(m0HADDR),
    .HWDATA(m0HWDATA),
    .HREADYOUT(m0HREADYOUT),
    .HRESP( m0HRESP),
    .HRDATA(m0HRDATA)
);







  // --------------------------------------
  // AHB3-Lite INTERFACE 1
  // Slave Interface
  reg                 s1HSEL;
  reg  [31:0]         s1HADDR;
  reg  [31:0]         s1HWDATA;
  wire [31:0]         s1HRDATA;
  reg                 s1HWRITE;
  reg  [ 2:0]         s1HSIZE;
  reg  [ 2:0]         s1HBURST;
  reg  [ 3:0]         s1HPROT;
  reg  [ 1:0]         s1HTRANS;
  wire                s1HREADYOUT;
  reg                 s1HREADY;
  wire                s1HRESP;

  // Master Interface
  wire                m1HSEL;
  wire [31:0]         m1HADDR;
  wire [31:0]         m1HWDATA;
  reg  [31:0]         m1HRDATA;
  wire                m1HWRITE;
  wire [ 2:0]         m1HSIZE;
  wire [ 2:0]         m1HBURST;
  wire [ 3:0]         m1HPROT;
  wire [ 1:0]         m1HTRANS;
  wire                m1HREADYOUT;
  reg                 m1HREADY;
  reg                 m1HRESP;



/*DATA_SRAM_TOP DATA_SRAM_TOP_instance2(
    .HCLK(clk_i),
    .HRESETn(rst_n_i),
    .HSEL(m1HSEL),
    .HREADY(m1HREADY),
    .HTRANS( m1HTRANS),
    .HSIZE(m1HSIZE),
    .HWRITE(m1HWRITE),
    .HADDR(m1HADDR),
    .HWDATA(m1HWDATA),
    .HREADYOUT(m1HREADYOUT),
    .HRESP( m1HRESP),
    .HRDATA(m1HRDATA)
);*/


  // --------------------------------------
  // Misc Signal,
  reg  [ch_count-1:0] dma_req_i;
  reg  [ch_count-1:0] dma_nd_i;
  wire [ch_count-1:0] dma_ack_o;
  reg  [ch_count-1:0] dma_rest_i;
  wire                irqa_o;
  wire                irqb_o;




logic [31:0] data_array_tb[];
logic [31:0] address_array_tb[];
logic        write_array_tb[];
logic [1:0]  trans_array_tb[];
logic [2:0]  burst_array_tb[];
logic [2:0]  size_array_tb[];


















//////////////////////////////////////////////////////////////////
ahb3lite_dma  DUT (.*);
//////////////////////////////////////////////////////////////////



always #5 clk_i = ~clk_i ;

task initialization ;
begin
clk_i = 0 ;
rst_n_i = 1 ;


s0HSEL = 0 ;
s0HADDR = 32 'b0 ;
s0HWDATA = 32 'b0 ;
s0HWRITE = 0 ;
s0HSIZE = 3'b0 ;
s0HBURST = 3'b0 ;
s0HPROT = 3'b0 ;
s0HTRANS = 3'b0 ;
s0HREADY = 1 ;


m0HREADY = 1 ;
//m0HRESP = 0 ;
//m0HRDATA = 32'b0 ;


s1HSEL = 0 ;
s1HADDR = 32 'b0 ;
s1HWDATA = 32 'b0 ;
s1HWRITE = 0 ;
s1HSIZE = 3'b0 ;
s1HBURST = 3'b0 ;
s1HPROT = 3'b0 ;
s1HTRANS = 3'b0 ;


m1HREADY = 1 ;
m1HRESP = 0 ;
m1HRDATA = 32'b0 ;


dma_req_i = 0 ;
dma_nd_i = 0 ;
dma_rest_i = 0 ;

end
endtask


task  reset  ;
begin

rst_n_i = 0 ;
@(posedge clk_i);
rst_n_i = 1 ;

end
endtask













task AHB_Master;
  input logic [31:0] data_array    [];
  input logic [31:0] address_array [];
  input logic        write_array   [];
  input logic [1:0]  trans_array   [];
  input logic [2:0]  burst_array   [];
  input logic [2:0]  size_array    [];
begin

  // Address and Data Phase
  @(posedge clk_i);

  s0HSEL = 1 ;
  s0HADDR = address_array[0];
  s0HWRITE = write_array[0];
  s0HTRANS = trans_array[0];
  s0HBURST = burst_array[0];
  s0HSIZE = size_array[0];
 @(posedge clk_i);


  for (int i = 1; i < address_array.size(); i++) begin
    s0HSEL = 0 ;
    
    if (write_array[i-1]) begin
        s0HWDATA = data_array[i-1];
      end

@(posedge clk_i);


    s0HADDR = address_array[i];
    s0HWRITE = write_array[i];
    s0HTRANS = trans_array[i];
    s0HBURST = burst_array[i];
    s0HSIZE = size_array[i];
    s0HSEL = 1 ;
@(posedge clk_i);
    
  end
  s0HSEL = 0 ;
  if (write_array[address_array.size()-1]) begin
    s0HWDATA = data_array[address_array.size()-1];
  end
end

endtask









task request ;
input         dma_request ;
input         dma_force ;
input         dma_restart ;

begin



dma_req_i = dma_request ;
dma_nd_i = dma_force ;
dma_rest_i = dma_restart ;


end

endtask





initial
begin
$dumpfile("dma_test.vcd");
$dumpvars;

initialization();
@(posedge clk_i);
reset();
@(posedge clk_i);


    data_array_tb       =   {32'h0,32'h1,32'h1,32'b11111110000000111001,32'b00000000000001000000000000001000,32'h20,32'h20,32'h40,32'h0 ,32'h12,32'hf0000000};
    address_array_tb    =   {32'h0,32'h4,32'h8,32'h20                  ,32'h24                              ,32'h28,32'h2c,32'h30,32'h34,32'h38,32'h40      };
    write_array_tb      =   {1,1,1,1,1,1,1,1,1,1,1};
    trans_array_tb      =   {2'b10, 2'b10, 2'b10, 2'b10 ,2'b10 ,2'b10,2'b10,2'b10,2'b10,2'b10,2'b10};
    burst_array_tb      =   {0,0,0,0,0,0,0,0,0,0,0};
    size_array_tb       =   {3'b010, 3'b010, 3'b010, 3'b010,3'b010,3'b010,3'b010,3'b010,3'b010,3'b010,3'b010};

    AHB_Master(data_array_tb
    ,address_array_tb
    ,write_array_tb
    ,trans_array_tb
    ,burst_array_tb
    ,size_array_tb);

  #200
    
    request (1,0,0);
/*#100
    s0HADDR = 32'h20;
    s0HWRITE = 1;
    s0HTRANS = 2'b10;
    s0HBURST = 0;
    s0HSIZE = 3'b010;
    s0HSEL = 1 ;
#10
s0HWDATA = 32'b11111110000000011001;
s0HSEL = 1 ;
#10*/

@(negedge dma_ack_o)
request (0,0,0);

#20 request (1,0,0);


#2000
$stop ;




end





endmodule


