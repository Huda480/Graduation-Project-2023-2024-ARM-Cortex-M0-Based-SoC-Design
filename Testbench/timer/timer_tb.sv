module timer_tb ;
bit PCLK_TB;    
bit PCLKG_TB;   
bit PRESETn_TB; 
bit PSEL_TB;    
bit [11:2] PADDR_TB;   
bit PENABLE_TB; 
bit PWRITE_TB;  
bit [31:0] PWDATA_TB;  
bit [3:0] ECOREVNUM_TB;
bit [31:0] PRDATA_TB;  
bit PREADY_TB;  
bit PSLVERR_TB; 
bit EXTIN_TB;   
bit TIMERINT_TB; 

////////////////////INSTANTIATION////////////////////

cmsdk_apb_timer DUT (
  .PCLK(PCLK_TB),
  .PCLKG(PCLKG_TB),
  .PRESETn(PRESETn_TB),
  .PSEL(PSEL_TB),
  .PADDR(PADDR_TB),
  .PENABLE(PENABLE_TB),
  .PWRITE(PWRITE_TB),
  .PWDATA(PWDATA_TB),
  .ECOREVNUM(ECOREVNUM_TB),
  .PRDATA(PRDATA_TB),
  .PREADY(PREADY_TB),
  .PSLVERR(PSLVERR_TB),
  .EXTIN(EXTIN_TB),
  .TIMERINT(TIMERINT_TB)
);


////////////////////CLOCK GENERATION////////////////////

localparam  CLK_PERIOD=10 ;
  
always #(CLK_PERIOD/2) PCLK_TB = ~PCLK_TB ;
always #(CLK_PERIOD/2) PCLKG_TB = ~PCLKG_TB;

////////////////////INTERNAL REGISTER ADDRESS////////////////////

localparam [9:0] CTRL = 10'h0;
localparam [9:0] VALUE = 10'h1;
localparam [9:0] RELOAD = 10'h2;
localparam [9:0] INTSTATUS = 10'h3;
localparam [9:0] INTCLR = 10'h3;


////////////////////INITIALIZATION////////////////////

task initialize ;
  begin
    PCLK_TB <= 0;
    PCLKG_TB <= 0;
    PRESETn_TB <= 1'b1;
    PSEL_TB <= 1'b0;
    PADDR_TB <= 10'b0;
    PENABLE_TB <= 0;
    PWRITE_TB <= 0;
    PWDATA_TB <= 32'b0;
    ECOREVNUM_TB <= 4'b0;
    EXTIN_TB <= 1'b0;
    #(3*CLK_PERIOD);
  end
endtask

////////////////////RESET////////////////////

task reset;
  begin
    PRESETn_TB = 1'b0;
    #(7*CLK_PERIOD);
    PRESETn_TB = 1'b1;
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
    
    
    
    initial 
    begin
      $dumpfile("timer.vcd");
      $dumpvars ;
      initialize ();
      reset () ;
      EXTIN_TB = 1'b0;
      APB_TRANS(CTRL,1,10'b1001);
      APB_TRANS(VALUE,1,32'd50);
      APB_TRANS(RELOAD,1,32'd60);
      #(CLK_PERIOD*200);
      $stop;
    end
      
      
    
    
    
  

endmodule