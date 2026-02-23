`timescale 1ns/1ps

module spi_tb();
  
	bit         PRESETn;
	bit         PCLK;
    //configure master
    bit         PSEL_M;
	bit         PENABLE_M;
	bit         PWRITE_M;
	bit [11:2]  PADDR_M;
	bit [31:0]  PWDATA_M;
    //configure slave
    bit         PSEL_S;
	bit         PENABLE_S;
	bit         PWRITE_S;
    bit [11:2]  PADDR_S;
	bit [31:0]  PWDATA_S;

	bit [31:0]  PRDATA;
	bit         PREADY;
    bit         PREADY1;
    bit         PSLVERR;
    
	wire         MISO;
	wire         MOSI;
	wire         SCK;

   /* output selector for external slaves from SPI master */
	wire		SS0;
	bit		    SS1;
	bit		    SS2;
	bit		    SS3;

    bit         TXINT_S;
	bit         RXINT_S;
    bit         TXINT_M;
	bit         RXINT_M;

	bit         COMBINT;

 ////////////////////INSTANTIATION////////////////////


  APB_SPI_interface DUT_Master 
 (
  .PRESETn(PRESETn),
  .PCLK(PCLK),
  .PSEL(PSEL_M),
  .PENABLE(PENABLE_M),
  .PWRITE(PWRITE_M),
  .PADDR(PADDR_M),
  .PWDATA(PWDATA_M),
  .PRDATA(),
  .PREADY(PREADY),
  .PSLVERR(PSLVERR),

  .MISO(MISO),
  .MOSI(MOSI),
  .SCK(SCK),

  .SS0(SS0),
  .SS1(SS1),
  .SS2(SS2),
  .SS3(SS3),

  .TXINT(TXINT_M),
  .RXINT(RXINT_M),
  .COMBINT()

 );

 APB_SPI_interface DUT_Slave 
 (
  .PRESETn(PRESETn),
  .PCLK(PCLK),
  .PSEL(PSEL_S),
  .PENABLE(PENABLE_S),
  .PWRITE(PWRITE_S),
  .PADDR(PADDR_S),
  .PWDATA(PWDATA_S),
  .PRDATA(),
  .PREADY(PREADY1),
  .PSLVERR(),

  .MISO(MISO),
  .MOSI(MOSI),
  .SCK(SCK),
  .SS0(SS0),

  .SS1(),
  .SS2(),
  .SS3(),

  .TXINT(TXINT_S),
  .RXINT(RXINT_S),
  .COMBINT()

 );

////////////////////CLOCK GENERATION////////////////////

localparam  CLK_PERIOD=10 ;

always #(CLK_PERIOD/2)  PCLK = ~ PCLK ;

////////////////////SPI_CONFIGURATION////////////////////

//READ parameters
localparam STATUS	    = 4'b0000;
localparam RX		    = 4'b0001;

//Mode parameters   
localparam MODE00	    = 2'b00;
localparam MODE01	    = 2'b01;
localparam MODE10	    = 2'b10;
localparam MODE11	    = 2'b11;

//Which Slave   
localparam SLAVE0	    = 2'b00;
localparam SLAVE1	    = 2'b01;
localparam SLAVE2	    = 2'b10;
localparam SLAVE3	    = 2'b11;

//Clock_Divider
localparam SCK8	        = 2'b00;
localparam SCK4	        = 2'b01;
localparam SCK2	        = 2'b10;
localparam SCK1	        = 2'b11;

localparam Slave	    = 1'b0;
localparam Master	    = 1'b1;

localparam Full_Duplex	= 1'b0;
localparam Half_Duplex	= 1'b1;

localparam TX_INT_EN	= 1'b1;
localparam RX_INT_EN	= 1'b1;

////////////////////INITIALIZATION////////////////////

task initialize ;
begin
  PCLK      <= 1'b0 ;
  PSEL_M    <= 1'b0 ;
  PADDR_M   <= 'b0  ;
  PENABLE_M <= 1'b0 ;
  PWRITE_M  <= 1'b0 ;
  PWDATA_M  <= 'b0  ;


  PADDR_S   <= 'b0  ;
  PWDATA_S  <= 'b0  ;
  PWRITE_S  <= 'b0  ;
  PSEL_S    <= 1'b0 ;
  PENABLE_S <= 1'b0 ;
end
endtask

////////////////////RESET////////////////////

task reset;
begin
    PRESETn <= 1'b0 ;
    repeat (20)
    @(posedge PCLK) ;
    PRESETn <= 1'b1 ;
end
endtask

////////////////////SET_CONFIGURATION////////////////////

task Configure_Master   ;
input [31:0] configgg   ;
begin
  @(posedge PCLK)
  PADDR_M   <= 'h0000   ;
  PWDATA_M  <= configgg ;
  PWRITE_M  <= 'b1      ;
  PSEL_M    <= 1'b1     ;
  PENABLE_M <= 1'b0     ;
  @(posedge PCLK)
  PENABLE_M <= 1'b1     ;
  repeat (5)
  @(posedge PCLK)
  PENABLE_M <= 1'b0    ;
  PSEL_M    <= 1'b0   ;
end
endtask 

task Configure_Slave    ;
input [31:0] configgg   ;
begin
  @(posedge PCLK)
  PADDR_S   <= 'h0000   ;
  PWDATA_S  <= configgg ;
  PWRITE_S  <= 'b1      ;
  PSEL_S    <= 1'b1     ;
  PENABLE_S <= 1'b0     ;
  @(posedge PCLK)
  PENABLE_S <= 1'b1     ;
  repeat (5)
  @(posedge PCLK)
  PENABLE_S <= 1'b0    ;
  PSEL_S    <= 1'b0   ;
end
endtask 

////////////////////Master Mode USING APB TRANSFER////////////////////

task APB_TRANS_Master    ;
input [15:0] address     ;
input write              ;
input [31:0] data        ;
begin
    @(posedge PCLK)
    PADDR_M   <= address ;
    PWRITE_M  <= write   ;
    PWDATA_M  <= data    ;
    PSEL_M    <= 1'b1    ;
    PENABLE_M <= 1'b0    ;
    @(posedge PCLK)
    PENABLE_M <= 1'b1    ;
    repeat (5)
    @(posedge PCLK)
    PENABLE_M <= 1'b0    ;
    PSEL_M    <= 1'b0   ;
end
endtask

task APB_TRANS_Slave     ;
input [15:0] address     ;
input write              ;
input [31:0] data        ;
begin
    @(posedge PCLK)
    PADDR_S   <= address ;
    PWRITE_S  <= write   ;
    PWDATA_S  <= data    ;
    PSEL_S    <= 1'b1    ;
    PENABLE_S <= 1'b0    ;
    @(posedge PCLK)
    PENABLE_S <= 1'b1    ;
    repeat (5)
    @(posedge PCLK)
    PENABLE_S <= 1'b0    ;
    PSEL_S    <= 1'b0   ;
end
endtask

initial
begin
  
$dumpfile("spi.vcd") ;       
$dumpvars; 

//mode1

initialize();
reset();

Configure_Master ({'b00, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE00, SLAVE0, SCK8}) ;
Configure_Slave  ({'b1, RX_INT_EN, TX_INT_EN, Full_Duplex, Slave , MODE00, SLAVE0, SCK8}) ;
APB_TRANS_Slave('h0001,1,'h6b) ;
APB_TRANS_Master('h0001,1,'hc9) ;
Configure_Master ({'b11, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE00, SLAVE0, SCK8}) ;
repeat (50)
@(posedge PCLK);
APB_TRANS_Master('h0003,1,'h3) ;
APB_TRANS_Slave('h0003,1,'h3) ;
@(posedge PCLK);


//mode1

repeat (50)
@(posedge PCLK);

Configure_Master ({'b00, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE01, SLAVE0, SCK8}) ;
Configure_Slave  ({'b1, RX_INT_EN, TX_INT_EN, Full_Duplex, Slave , MODE01, SLAVE0, SCK8}) ;
APB_TRANS_Slave('h0001,1,'hee) ;
APB_TRANS_Master('h0001,1,'h90) ;
Configure_Master ({'b11, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE01, SLAVE0, SCK8}) ;

@ (posedge RXINT_M)
APB_TRANS_Master('h0001,0,'b000) ;

repeat (10)
@(posedge PCLK);

APB_TRANS_Master('h0003,1,'b11) ;

repeat (100)
@(posedge PCLK);

//mode3

Configure_Master ({'b00, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE11, SLAVE0, SCK8}) ;
Configure_Slave  ({'b1, RX_INT_EN, TX_INT_EN, Full_Duplex, Slave , MODE11, SLAVE0, SCK8}) ;
APB_TRANS_Slave('h0001,1,'h81) ;
APB_TRANS_Master('h0001,1,'h87) ;
Configure_Master ({'b11, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE11, SLAVE0, SCK8}) ;
repeat (100)
@(posedge PCLK);

/*
@ (posedge RXINT)

APB_TRANS_Slave('h0001,0,'b000) ;

repeat (10)
@(posedge PCLK);

APB_TRANS_Slave('h0003,1,'b11) ;
*/
repeat (100)
@(posedge PCLK);


Configure_Master ({'b00, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE11, SLAVE0, SCK8}) ;
Configure_Slave  ({'b1, RX_INT_EN, TX_INT_EN, Full_Duplex, Slave , MODE11, SLAVE0, SCK8}) ;
APB_TRANS_Slave('h0001,1,'hf3) ;
APB_TRANS_Master('h0001,1,'h7b) ;
Configure_Master ({'b11, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE11, SLAVE0, SCK8}) ;


repeat (100)
@(posedge PCLK);

reset();

repeat (100)
@(posedge PCLK);

//mode2

Configure_Master ({'b10, RX_INT_EN, TX_INT_EN, Half_Duplex, Master, MODE00, SLAVE0, SCK8}) ;
Configure_Slave  ({'b01, RX_INT_EN, TX_INT_EN, Half_Duplex, Slave , MODE00, SLAVE0, SCK8}) ;
APB_TRANS_Slave('h0001,1,'h02) ;
//APB_TRANS_Master('h0001,1,'h14) ;
Configure_Master ({'b11, RX_INT_EN, TX_INT_EN, Half_Duplex, Master, MODE00, SLAVE0, SCK8}) ;

repeat (100)
@(posedge PCLK);


// mode 3

Configure_Master ({'b00, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE11, SLAVE0, SCK8}) ;
Configure_Slave  ({'b1, RX_INT_EN, TX_INT_EN, Full_Duplex, Slave , MODE11, SLAVE0, SCK8}) ;
APB_TRANS_Slave('h0001,1,'h02) ;
APB_TRANS_Master('h0001,1,'h14) ;
Configure_Master ({'b11, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE11, SLAVE0, SCK8}) ;

repeat (100)
@(posedge PCLK);

// mode0

Configure_Master ({'b00, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE00, SLAVE0, SCK8}) ;
Configure_Slave  ({'b1, RX_INT_EN, TX_INT_EN, Full_Duplex, Slave , MODE00, SLAVE0, SCK8}) ;
APB_TRANS_Slave('h0001,1,'h82) ;
APB_TRANS_Master('h0001,1,'hf3) ;
Configure_Master ({'b11, RX_INT_EN, TX_INT_EN, Full_Duplex, Master, MODE00, SLAVE0, SCK8}) ;


repeat (100)
@(posedge PCLK);
$stop;
end

endmodule