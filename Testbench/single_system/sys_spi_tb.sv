`timescale 1ns/1ps
module sys_spi_tb ();
                                        

logic HCLK;
logic HRESETn;
logic EXTIN;
logic phy_ble_clk;
wire [15:0] SYSTEM_OUT;

///////////////////////////////////////////////
	bit         PRESETn;
	bit         PCLK;
  //configure master
  bit         PSEL;
	bit         PENABLE;
	bit         PWRITE;
	bit [11:2]  PADDR;
	bit [31:0]  PWDATA;
	bit [31:0]  PRDATA;
	bit         PREADY;
  bit         PSLVERR;
////////////////////////////////////////

reg cts ;

localparam clk_period    = 20;
localparam pclk_period   = 20*2;
            
/////clock generation///////
always #(clk_period/2) HCLK=~HCLK;


SYSTEM_TOP DUT (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .EXTIN(EXTIN),
    .phy_ble_clk(phy_ble_clk),
    .SYSTEM_OUT(SYSTEM_OUT)
);

  integer i;
  localparam AW = 16;
  localparam MEM_SIZE = 2**(AW+2);
  localparam MEMFILE = "C:/Users/ok/OneDrive/Desktop/STM-Graduation-Project-2024/Program/main.bin";
  logic [8:0] fileimage [0:((MEM_SIZE)-1)];
  int depth = 4*1024;
  localparam width = 8;
/*
task receive ;
  input [9:0] data ;
  integer i;
  begin
    for (i = 0 ; i < 10 ; i = i+1)
    begin
      RXD1 = data[i] ;
      repeat(32)
      #(pclk);
    end
  end
endtask
*/

////////////////////////////////////////////////////////////for spi slave testing
APB_SPI_interface SPI_DUT 
 (
  .PRESETn(PRESETn),
  .PCLK(PCLK),
  .PSEL(PSEL),
  .PENABLE(PENABLE),
  .PWRITE(PWRITE),
  .PADDR(PADDR),
  .PWDATA(PWDATA),
  .PRDATA(PRDATA),
  .PREADY(PREADY),
  .PSLVERR(PSLVERR),
  .MISO(SYSTEM_OUT[0]),
  .MOSI(SYSTEM_OUT[1]),
  .SCK(SYSTEM_OUT[2]),
  .SS0(SYSTEM_OUT[3]), // input to the netlist
  .SS1(),
  .SS2(),
  .SS3(),
  .TXINT(TXINT),
  .RXINT(RXINT)
 );

assign SYSTEM_OUT[12] = cts ;

always #(pclk_period/2)  PCLK = ~ PCLK ;

task initialize ;
begin
  PCLK    <= 1'b0 ;
  PSEL    <= 1'b0 ;
  PADDR   <= 'b0  ;
  PENABLE <= 1'b0 ;
  PWRITE  <= 1'b0 ;
  PWDATA  <= 'b0  ;
end
endtask

task reset;
begin
    PRESETn <= 1'b0 ;
    repeat (20)
    @(posedge PCLK) ;
    PRESETn <= 1'b1 ;
end
endtask

task Configure_SPI   ;
input [31:0] configgg   ;
begin
  @(posedge PCLK)
  PADDR   <= 'h0000   ;
  PWDATA  <= configgg ;
  PWRITE  <= 'b1      ;
  PSEL    <= 1'b1     ;
  PENABLE <= 1'b0     ;
  @(posedge PCLK)
  PENABLE <= 1'b1     ;
    repeat (5)
  @(posedge PCLK)
  PENABLE <= 1'b0    ;
  PSEL    <= 1'b0    ;
  PWRITE  <= 1'b0    ;
end
endtask

task APB_TRANS_SPI    ;
input [15:0] address     ;
input write              ;
input [31:0] data        ;
begin
    @(posedge PCLK)
    PADDR   <= address ;
    PWRITE  <= write   ;
    PWDATA  <= data    ;
    PSEL    <= 1'b1    ;
    PENABLE <= 1'b0    ;
    @(posedge PCLK)
    PENABLE <= 1'b1    ;
      repeat (5)
    @(posedge PCLK)
    PENABLE <= 1'b0    ;
    PSEL    <= 1'b0    ;
    PWRITE  <= 1'b0    ;
end
endtask

 //////////////////////////////////////////////////////

initial begin
    
  initialize();
  reset();
    HCLK = 0;
    HRESETn = 0;
    EXTIN = 1;
    #100;
    HRESETn = 1;
  //  #10000;
   // receive(10'b1100100110);
  
  #10;
  
  Configure_SPI('h3300);

  APB_TRANS_SPI('h0001,1,'h56) ;
  repeat (30)
  @(posedge PCLK);
  
  APB_TRANS_SPI('h0001,1,'h83) ;
  repeat (30)
  @(posedge PCLK);
  
  APB_TRANS_SPI('h0001,1,'ha3) ;
  repeat (30)
  @(posedge PCLK);
  
  APB_TRANS_SPI('h0001,1,'h32) ;
  repeat (30)
  @(posedge PCLK);
  
  APB_TRANS_SPI('h0001,1,'had) ;
  repeat (30)
  @(posedge PCLK);
  
  APB_TRANS_SPI('h0001,1,'h11) ;
  repeat (30)
  @(posedge PCLK);
  
  APB_TRANS_SPI('h0001,1,'h48) ;
  repeat (30)
  @(posedge PCLK);


  APB_TRANS_SPI('h0001,1,'h5c) ;
  repeat (30)
  @(posedge PCLK);



  Configure_SPI('h3700);

  #100000;
  Configure_SPI('h3300);

  cts = 1 ;
  repeat (1)
  @(posedge PCLK);
  cts = 0 ;

  #100000;
  
  $stop;

end
             
endmodule  
