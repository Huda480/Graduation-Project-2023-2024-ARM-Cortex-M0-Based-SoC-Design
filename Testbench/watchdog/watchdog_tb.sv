module watchdog_tb ;
  bit          PCLK_TB ;        
  bit          PRESETn_TB ;     
  bit          PENABLE_TB ;     
  bit          PSEL_TB ;        
  bit  [11:2]  PADDR_TB ;       
  bit          PWRITE_TB ;      
  bit  [31:0]  PWDATA_TB  ;     
  bit          WDOGCLK_TB  ;    
  bit          WDOGCLKEN_TB ;   
  bit          WDOGRESn_TB ;    
  bit  [3:0]   ECOREVNUM_TB ;   
  bit  [31:0]  PRDATA_TB ;      
  bit          WDOGINT_TB ;     
  bit          WDOGRES_TB ; 
  bit          PSLVERR_TB;

////////////////////INSTANTIATION////////////////////    
  
cmsdk_apb_watchdog DUT (
  .PCLK (PCLK_TB) ,      
  .PRESETn (PRESETn_TB) ,    
  .PENABLE (PENABLE_TB) ,     
  .PSEL (PSEL_TB) ,        
  .PADDR (PADDR_TB) ,       
  .PWRITE (PWRITE_TB) ,          
  .PWDATA (PWDATA_TB) ,     
  .WDOGCLK (WDOGCLK_TB) ,         
  .WDOGCLKEN (WDOGCLKEN_TB) ,       
  .WDOGRESn (WDOGRESn_TB) ,       
  .ECOREVNUM (ECOREVNUM_TB) ,        
  .PRDATA (PRDATA_TB) ,           
  .WDOGINT (WDOGINT_TB) ,         
  .WDOGRES (WDOGRES_TB) ,
  .PSLVERR(PSLVERR_TB)
  ); 
  
  
  
  
  
  
  
  
  
////////////////////CLOCK GENERATION////////////////////

localparam  CLK_PERIOD=10 ;

always #(CLK_PERIOD/2) PCLK_TB = ~PCLK_TB ;
always #(CLK_PERIOD/2) WDOGCLK_TB = ~WDOGCLK_TB ;

////////////////////INTERNAL REGISTER ADDRESS////////////////////

localparam [9:0] WDOGLOAD = 10'h0;
localparam [9:0] WDOGVALUE = 10'h1;
localparam [9:0] WDOGCONTROL = 10'h2;
localparam [9:0] WDOGINTCLR = 10'h3;
localparam [9:0] WDOGRIS = 10'h4;
localparam [9:0] WDOGMIS = 10'h5;
localparam [9:0] WDOGLOCK= 10'h300;


////////////////////UNLOCK VALUE////////////////////

localparam [31:0] UNLOCK =32'h1ACCE551;
  
  
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
    ECOREVNUM_TB  <=0;
   // PRDATA_TB     <=0;
    WDOGCLKEN_TB  <=0;
    WDOGRESn_TB   <=1;
    #(CLK_PERIOD*10);
end
endtask

////////////////////RESET////////////////////

task reset;
begin
    PRESETn_TB <= 1'b0;
    WDOGRESn_TB <=1'b0;
    #(CLK_PERIOD*10);
    PRESETn_TB <= 1'b1;
    WDOGRESn_TB <=1'b1;
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
    @(posedge PCLK_TB)
    PENABLE_TB <= 1'b0;
    PSEL_TB <= 1'b0;
    PWRITE_TB <= 1'b0;
end
endtask
  
  
  
  
  initial
  begin
    
    $dumpfile("watchdog.vcd");
    $dumpvars;
    initialize();
    reset();
    #(CLK_PERIOD*10);

    APB_TRANS(WDOGLOCK,1,UNLOCK);
    APB_TRANS(WDOGCONTROL,1,10'b11);
    APB_TRANS(WDOGLOAD,1,10'd50);
    #(CLK_PERIOD*150);
    WDOGCLKEN_TB  <=1'b1;
    #(CLK_PERIOD*70);
    APB_TRANS(WDOGLOAD,1,10'd75);
    #(CLK_PERIOD*30);
    APB_TRANS(WDOGLOAD,0,10'd75);
    APB_TRANS(WDOGINTCLR,1,10'b1);
    APB_TRANS(WDOGLOAD,1,10'b0);
    #(CLK_PERIOD*180);
    $stop;
    
    
  end  
endmodule
