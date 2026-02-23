module RCC 
#(
  parameter int scale1 = 8 ,
  parameter int scale2 = 8 ,
  parameter int scale3 = 8 ,
  parameter int RESET_WDOG = 2 ,
  parameter int RESET_APB = 2, 
  parameter int Include_WIFI = 1, 
  parameter int Include_dual_timer = 1
)
(
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
    input             SYS_FCLK,
    input             RESETn,
    input             phy_ble_clk,
    //==========================================================================
    // Control signals
    //==========================================================================
    input             APB_ACTIVE ,
    input [31:0]      HWDATA,
    input             HSEL,
    input             HRESP,
    input             HSEL_REG,
    input             HWRITE,
    input             HWRITE_REG,
    input [2:0]       HSIZE,
    input [2:0]       HSIZE_REG,
    //==========================================================================
    // Clock outputs
    //==========================================================================
    output            HCLK ,
    output reg [31:0] HRDATA_REG ,
    output wire       PCLK,
    output            PCLKG,
    output            PRESETn,
    output            TIMCLK,
    output            WDOGCLK,
    output            clk_3472_KHz,
    output            clk_6945_KHz,
    output            clk_100_MHz,
    output            clk_50_MHz,
    output            clk_20_MHz_WIFI,
    output            WDOGRESn,
    output            HRESETn
);	


reg [31:0] scales ; // [7:0  ] PCLK scale
                    // [15:8 ] TIMCLK scale
                    // [23:16] WDOGCLK scale
                    // [31:24] reserved

always_ff @(posedge HCLK or negedge HRESETn)
begin
  if (!HRESETn)
    scales <= 32'h00020202;
  else if (HSEL_REG && HWRITE_REG)
  begin
    if(HSIZE_REG == 3'b0)
      scales <= {scales[31:8],HWDATA[7:0]};
    else if(HSIZE_REG == 3'b1)
      scales <= {scales[31:16],HWDATA[15:0]};
    else
      scales <= HWDATA ;
  end
end



always_ff @(posedge HCLK or negedge HRESETn)
begin
  if (!HRESETn)
    HRDATA_REG <= 32'b0;
  else if (HSEL && !HWRITE && !HRESP)
  begin
    if(HSIZE == 3'b0)
      HRDATA_REG <= {24'b0,scales[7:0]};
    else if(HSIZE == 3'b1)
      HRDATA_REG <= {16'b0,scales[15:0]};
    else
      HRDATA_REG <= scales ;
  end
  else 
    HRDATA_REG <= 32'b0;
end


 

assign PCLKG = APB_ACTIVE && PCLK;
//BUFG GATED_APB (PCLKG,APB_ACTIVE && PCLK);

CLKDIV #(.width(4)) HCLK_Divider (

  .REF_CLK(SYS_FCLK) ,
  .RST(RESETn) ,
  .DIV_RATIO(4'd2) ,
  .OUT_CLK(HCLK));

CLKDIV #(.width(scale1)) PCLK_Divider (

  .REF_CLK(HCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(8'd2) ,
  .OUT_CLK(PCLK));


CLKDIV #(.width(scale3)) WDOGCLK_Divider (

  .REF_CLK(PCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(8'd2) ,
  .OUT_CLK(WDOGCLK));

generate if(Include_dual_timer == 1) begin:DUAL_TIMER_INCLUDED
  CLKDIV #(.width(scale2)) TIMCLK_Divider (
    .REF_CLK(PCLK) ,
    .RST(HRESETn) ,
    .DIV_RATIO(8'd2) ,
    .OUT_CLK(TIMCLK));
end:DUAL_TIMER_INCLUDED 
else begin
  assign TIMCLK = 1'b0;
end
endgenerate


  CLKDIV #(.width(8)) BLE_DIVIDER1 (

  .REF_CLK(phy_ble_clk) ,
  .RST(HRESETn) ,
  .DIV_RATIO(8'd8) ,
  .OUT_CLK(clk_6945_KHz));

  CLKDIV #(.width(8)) BLE_DIVIDER2 (

  .REF_CLK(phy_ble_clk) ,
  .RST(HRESETn) ,
  .DIV_RATIO(8'd16) ,
  .OUT_CLK(clk_3472_KHz));

 generate if (Include_WIFI == 1) begin:WIFI_INCLUDED
  CLKDIV #(.width(3)) WIFI_DIVIDER1 (

  .REF_CLK(SYS_FCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(3'd1) ,
  .OUT_CLK(clk_100_MHz));

  CLKDIV #(.width(8)) WIFI_DIVIDER2 (

  .REF_CLK(SYS_FCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(8'd2) ,
  .OUT_CLK(clk_50_MHz));
  
  CLKDIV #(.width(4)) WIFI_DIVIDER3 (

  .REF_CLK(SYS_FCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(4'd4) ,
  .OUT_CLK(clk_20_MHz_WIFI));
 end:WIFI_INCLUDED
 else begin
  assign clk_100_MHz = 1'b0;
  assign clk_50_MHz = 1'b0;
  assign clk_20_MHz_WIFI = 1'b0;
 end
endgenerate
  
RESET_SYNC #(.NUM_STAGES(RESET_APB)) AHB_RESET (
.RESET(RESETn),
.CLK  (HCLK),
.SYNC_RESET (HRESETn));

RESET_SYNC #(.NUM_STAGES(RESET_WDOG)) WDOG_RESET (
.RESET(HRESETn),
.CLK  (WDOGCLK),
.SYNC_RESET (WDOGRESn));


RESET_SYNC #(.NUM_STAGES(RESET_APB)) APB_RESET (
.RESET(HRESETn),
.CLK  (PCLK),
.SYNC_RESET (PRESETn));


endmodule

 


