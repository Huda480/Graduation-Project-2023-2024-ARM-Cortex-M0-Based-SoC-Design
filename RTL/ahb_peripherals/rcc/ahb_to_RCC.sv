module ahb_to_RCC 
#(
    parameter int Include_dual_timer = 1 , 
    parameter int Include_WIFI = 1
)  
(
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
    input  wire          SYS_FCLK,
    input  wire          RESETn,    // system bus reset
    input  wire          phy_ble_clk,
    //==========================================================================
    // Control signals
    //==========================================================================
    input  wire          HSEL,      // AHB peripheral select
    input  wire          APB_ACTIVE,//for PCLKG
    input  wire          HREADY,    // AHB ready input
    input  wire    [1:0] HTRANS,    // AHB transfer type
    input  wire    [2:0] HSIZE,     // AHB hsize
    input  wire          HWRITE,    // AHB hwrite
    input  wire   [31:0] HADDR,     // AHB address bus
    input  wire   [31:0] HWDATA,    // AHB write data bus
    //==========================================================================
    // AHB outputs
    //==========================================================================
    output wire          HREADYOUT, // AHB ready output to S->M mux
    output wire          HRESP,     // AHB response
    output wire   [31:0] HRDATA,    // AHB read data bus
    output wire          HCLK,      // system bus clock
    
    //==========================================================================
    // System clocks
    //==========================================================================
    output wire          PCLK,
    output wire          PCLKG,
    output wire          PRESETn,
    output wire          TIMCLK,
    output wire          WDOGCLK,
    output               clk_3472_KHz,
    output               clk_6945_KHz,
    output               clk_100_MHz,
    output               clk_50_MHz,
    output               clk_20_MHz_WIFI,
    output wire          HRESETn,
    output wire          WDOGRESn
    );


    logic HSEL_REG;
    logic HWRITE_REG;
    logic [2:0] HSIZE_REG;
    wire [31:0] HRDATA_REG;
    
        
    //==========================================================================
    // Regestring AHB signals
    //==========================================================================

    always_ff @(posedge HCLK or negedge HRESETn)
    begin
    if (!HRESETn)
      HSEL_REG <= 1'b0;
    else if(HADDR[15:0] == 16'b0)
      HSEL_REG <= HSEL ;
    else
      HSEL_REG <=1'b0;
    end

    
    always_ff @(posedge HCLK or negedge HRESETn)
    begin
    if (!HRESETn)
      HWRITE_REG <= 1'b0;
    else if(HADDR[15:0] == 16'b0)
      HWRITE_REG <= HWRITE ;
    else
      HWRITE_REG <=1'b0;
    end
    

    always_ff @(posedge HCLK or negedge HRESETn)
    begin
    if (!HRESETn)
      HSIZE_REG <= 3'b0;
    else if (HSEL)
      HSIZE_REG <= HSIZE ;
    end

    assign HRDATA = HRDATA_REG ;
    assign HREADYOUT = 1'b1 ;
    assign HRESP = (HSEL && (HADDR[15:0] != 16'b0)) ? 1'b1 : 1'b0 ;

    RCC #(.Include_dual_timer(Include_dual_timer),.Include_WIFI(Include_WIFI)) RESET_CLOCK_CONTROLLER (

        .SYS_FCLK(SYS_FCLK),
        .HCLK(HCLK),
        .RESETn(RESETn),

        //for write transaction
        .HWDATA(HWDATA),
        .HSEL_REG(HSEL_REG),
        .HSIZE_REG(HSIZE_REG),
        .HWRITE_REG(HWRITE_REG),

        //for read transaction
        .HSIZE(HSIZE),
        .HSEL(HSEL),
        .HWRITE(HWRITE),
        .HRESP(HRESP),//for disable read operation if address is not 0

        .phy_ble_clk(phy_ble_clk),
        .clk_3472_KHz(clk_3472_KHz),
        .clk_6945_KHz(clk_6945_KHz),

        .clk_100_MHz(clk_100_MHz),
        .clk_50_MHz(clk_50_MHz),
        .clk_20_MHz_WIFI(clk_20_MHz_WIFI),

        .APB_ACTIVE(APB_ACTIVE),//for PCLKG 

        .HRDATA_REG(HRDATA_REG),

        .PCLK(PCLK),
        .PCLKG(PCLKG),
        .PRESETn(PRESETn),
        .TIMCLK(TIMCLK),
        .WDOGCLK(WDOGCLK),
        .HRESETn(HRESETn),
        .WDOGRESn(WDOGRESn)
    );


    endmodule


    











 