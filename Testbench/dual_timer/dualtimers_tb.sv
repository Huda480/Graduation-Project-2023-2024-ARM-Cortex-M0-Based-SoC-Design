module dualtimers_tb();
  bit             PCLK_TB;       
  bit             PRESETn_TB;    
  bit             PENABLE_TB;    
  bit             PSEL_TB;       
  bit [11:2]      PADDR_TB;      
  bit             PWRITE_TB;     
  bit [31:0]      PWDATA_TB;     
  bit             TIMCLK_TB;     
  bit             TIMCLKEN1_TB;  
  bit             TIMCLKEN2_TB;  
  bit             PSLVERR_TB ;
  bit  [3:0]      ECOREVNUM_TB;  
  bit [31:0]      PRDATA_TB;     
  bit             TIMINT1_TB;    
  bit             TIMINT2_TB;    
  bit             TIMINTC_TB;    

 ////////////////////INSTANTIATION////////////////////
  
  cmsdk_apb_dualtimers DUT (
.PCLK       (PCLK_TB),   
.PRESETn    (PRESETn_TB),
.PENABLE    (PENABLE_TB),
.PSEL       (PSEL_TB),   
.PADDR      (PADDR_TB),  
.PWRITE     (PWRITE_TB), 
.PWDATA     (PWDATA_TB), 
.TIMCLK     (TIMCLK_TB), 
.TIMCLKEN1  (TIMCLKEN1_TB),
.TIMCLKEN2  (TIMCLKEN2_TB),
.ECOREVNUM  (ECOREVNUM_TB),
.PRDATA     (PRDATA_TB), 
.TIMINT1    (TIMINT1_TB),
.TIMINT2    (TIMINT2_TB),
.TIMINTC    (TIMINTC_TB),
.PSLVERR    (PSLVERR_TB)
);

////////////////////CLOCK GENERATION////////////////////

localparam  CLK_PERIOD=10 ;
localparam  TIMER_PERIOD = 40;

always #(CLK_PERIOD/2) PCLK_TB = ~PCLK_TB;
always #(TIMER_PERIOD/2) TIMCLK_TB = ~TIMCLK_TB;

////////////////////INTERNAL REGISTER ADDRESS////////////////////
localparam [9:0] TIMER1LOAD = 10'h0;
localparam [9:0] TIMER1VALUE = 10'h1;
localparam [9:0] TIMER1CONTROL = 10'h2;
localparam [9:0] TIMER1INTCLR = 10'h3;
localparam [9:0] TIMER1RIS = 10'h4;
localparam [9:0] TIMER1MIS = 10'h5;
localparam [9:0] TIMER1BGLOAD = 10'h6;

localparam [9:0] TIMER2LOAD = 10'h8;
localparam [9:0] TIMER2VALUE = 10'h9;
localparam [9:0] TIMER2CONTROL = 10'hA;
localparam [9:0] TIMER2INTCLR = 10'hB;
localparam [9:0] TIMER2RIS = 10'hC;
localparam [9:0] TIMER2MIS = 10'hD;
localparam [9:0] TIMER2BGLOAD = 10'hE;




////////////////////INITIALIZATION////////////////////

task initialize;
begin
    PCLK_TB       <=0;
    PRESETn_TB    <=1;
    PENABLE_TB    <=0;
    PSEL_TB       <=0;
    PADDR_TB      <=0;
    PWRITE_TB     <=0;
    PWDATA_TB     <=0;
    TIMCLK_TB     <=0;
    TIMCLKEN1_TB  <=0;
    TIMCLKEN2_TB  <=0;
    ECOREVNUM_TB  <=0;
    #(CLK_PERIOD*10);
end
endtask

////////////////////RESET////////////////////


task reset;
begin
    PRESETn_TB <= 1'b0;
    #(CLK_PERIOD*10);
    PRESETn_TB <= 1'b1;
    #(CLK_PERIOD*10);
end
endtask

////////////////////TRANSFER USING APB TRANSFER////////////////////

task APB_TRANS ;
input [9:0] address;
input write ;
input [31:0] data;
begin
    @(posedge PCLK_TB)
    PADDR_TB <= address;
    PWRITE_TB <= write;
    PWDATA_TB <= data;
    PSEL_TB <= 1'b1;
    PENABLE_TB <= 1'b0;
    @(posedge PCLK_TB)
    PENABLE_TB <= 1'b1;
end
endtask

initial begin
    $dumpfile("dualtimers.vcd");
    $dumpvars;
    initialize();
    reset();
    #(CLK_PERIOD*10);
    TIMCLKEN1_TB<=1'b1;
    TIMCLKEN2_TB<=1'b1;
    APB_TRANS(TIMER1CONTROL,1'b1,8'b10100000);
    APB_TRANS(TIMER2CONTROL,1'b1,8'b10100000);
    APB_TRANS(TIMER1LOAD,1'b1,32'd30);
    APB_TRANS(TIMER2LOAD,1'b1,32'd70);
    APB_TRANS(TIMER1BGLOAD,1'b1,32'd90);
    APB_TRANS(TIMER2BGLOAD,1'b1,32'd100);
    #(TIMER_PERIOD*2000);
    $stop;
end
endmodule

