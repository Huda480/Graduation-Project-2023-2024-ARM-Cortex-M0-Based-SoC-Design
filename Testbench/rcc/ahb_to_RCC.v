module ahb_to_RCC  (
    ///AHB signals
    input  wire          HCLK,      // system bus clock
    input  wire          HRESETn,   // system bus reset
    input  wire          HSEL,      // AHB peripheral select
    input  wire          HREADY,    // AHB ready input
    input  wire    [1:0] HTRANS,    // AHB transfer type
    input  wire    [2:0] HSIZE,     // AHB hsize
    input  wire          HWRITE,    // AHB hwrite
    input  wire   [31:0] HADDR,     // AHB address bus
    input  wire   [31:0] HWDATA,    // AHB write data bus
    output wire          HREADYOUT, // AHB ready output to S->M mux
    output wire          HRESP,     // AHB response
    output wire   [31:0] HRDATA,    // AHB read data bus
    

    input  wire          phy_ble_clk,
    input  wire          APB_ACTIVE,//for PCLKG
    output wire          PCLK,
    output wire          PCLKG,
    output wire          PRESETn,
    output wire          TIMCLK,
    output wire          WDOGCLK,
    output            clk_3472_KHz,
    output            clk_6945_KHz,
    output            clk_20_MHz_WIFI,
    output            clk_25_MHz,
    output wire          WDOGRESn,
    output wire          FCLK);


    reg HSEL_REG;
    reg HWRITE_REG;
    reg [2:0] HSIZE_REG;
    wire [31:0] HRDATA_REG;
    


    always@(posedge HCLK or negedge HRESETn)
    begin
    if (!HRESETn)
    HSEL_REG <= 1'b0;
    else if(HADDR[15:0] == 16'b0)
    HSEL_REG <= HSEL ;
    else
    HSEL_REG <=1'b0;
    end

    
    always@(posedge HCLK or negedge HRESETn)
    begin
    if (!HRESETn)
    HWRITE_REG <= 1'b0;
    else if(HADDR[15:0] == 16'b0)
    HWRITE_REG <= HWRITE ;
    else
    HWRITE_REG <=1'b0;
    end
    

    always@(posedge HCLK or negedge HRESETn)
    begin
    if (!HRESETn)
    HSIZE_REG <= 3'b0;
    else if (HSEL)
    HSIZE_REG <= HSIZE ;
    end

    assign HRDATA = HRDATA_REG ;
    assign HREADYOUT = 1'b1 ;
    assign HRESP = (HSEL && (HADDR[15:0] != 16'b0)) ? 1'b1 : 1'b0 ;

    RCC el3b_f_elclk (


        .HCLK(HCLK),
        .HRESETn(HRESETn),

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

        .clk_25_MHz(clk_25_MHz),
        .clk_20_MHz_WIFI(clk_20_MHz_WIFI),

        .APB_ACTIVE(APB_ACTIVE),//for PCLKG 

        .HRDATA_REG(HRDATA_REG),

        .PCLK(PCLK),
        .PCLKG(PCLKG),
        .PRESETn(PRESETn),
        .TIMCLK(TIMCLK),
        .WDOGCLK(WDOGCLK),
        .WDOGRESn(WDOGRESn),
        .FCLK(FCLK)
    );


    endmodule


    











 