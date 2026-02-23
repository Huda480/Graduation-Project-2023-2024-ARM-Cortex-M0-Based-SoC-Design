module full_system 
#(
    //SYSTEM 1 PARAMETERS
    parameter AW_1 = 16,
    parameter int Include_dual_timer_1 = 1,
    parameter int Include_SPI_1 = 1,
    parameter int Include_DMA_1 = 1,
    parameter int Include_WIFI_1 = 0,
    parameter int Include_COMP_1 = 1,
    parameter GROUP0_1 = "../../sys_1_bin/group_0.bin",
	parameter GROUP1_1 = "../../sys_1_bin/group_1.bin",
	parameter GROUP2_1 = "../../sys_1_bin/group_2.bin",
	parameter GROUP3_1 = "../../sys_1_bin/group_3.bin",
    parameter ALTERNATE_FUNC_MASK_1 = 16'hFFFF,
	parameter [1:0] pri_sel_1  = 2'd2,
	parameter int channel_number_1 = 2,
	parameter int req_number_1     = 10,
	parameter   [1:0]   ch_conf_1 [31] = {2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0},
    parameter ALTERNATE_FUNC_DEFAULT_1 = 16'h0000,

    //SYSTEM 2 PARAMETERS
    parameter int AW_2 = 16,
    parameter int Include_dual_timer_2 = 1,
    parameter int Include_SPI_2 = 1,
    parameter int Include_DMA_2 = 1,
    parameter int Include_WIFI_2 = 1,
    parameter int Include_COMP_2 = 0, // decompression
    parameter GROUP0_2 = "../../sys_2_bin/group_0.bin",
	parameter GROUP1_2 = "../../sys_2_bin/group_1.bin",
	parameter GROUP2_2 = "../../sys_2_bin/group_2.bin",
	parameter GROUP3_2 = "../../sys_2_bin/group_3.bin",
    parameter ALTERNATE_FUNC_MASK_2 = 16'hFFFF,
	parameter [1:0] pri_sel_2  = 2'd2,
	parameter int channel_number_2 = 2,
	parameter int req_number_2     = 10,
	parameter   [1:0]   ch_conf_2 [31] = {2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0},
    parameter ALTERNATE_FUNC_DEFAULT_2 = 16'h0000,
    //BLUETOOTH PARAMETERS
    parameter int BE = 0,
    parameter int PORTWIDTH =  16 ,
    parameter int ALTFUNC   =  4  ,
    parameter int AD_BLE = 12, 
    parameter int DATA_BLE = 32, 
    parameter int MEM_BLE = 256, 
	parameter int RE_IM_AD_BLE = 13, 
    parameter int RE_IM_SIZE_BLE = 12, 
	parameter int RE_IM_MEM_BLE = 8192, 
    parameter int OFFSET_BLE = 'h10, 
	parameter int DEPTH_BLE = 4, 
    parameter int WIDTH_BLE = 32,
	parameter int ADDR_WIFI = 12, 
    parameter int DATA_WIFI = 32,
    // COMPRESSOR PARAMETERS
	parameter int COMP_OUT_WIDTH = 16,
	parameter int COMP_IN_WIDTH = 8,   
	parameter int COMP_DIM = 8,     
	parameter int COMP_MEM_UNCOMP_DEPTH = 8192,
	parameter int COMP_MEM_COMP_DEPTH = 2560,
    parameter     IMG1 = "../../image/image1.txt"  ,
    parameter     IMG2 = "../../image/image2.txt"  ,
    parameter     IMG3 = "../../image/image3.txt"  ,
    parameter     IMG4 = "../../image/image4.txt"  ,
    parameter     IMG5 = "../../image/image5.txt"  ,
    parameter     IMG6 = "../../image/image6.txt"  ,
    parameter     IMG7 = "../../image/image7.txt"  ,
    parameter     IMG8 = "../../image/image8.txt" 
) 
(
    input SYS_FCLK1,
    input SYS_FCLK2,
    input SYS_RESETn1,
    input SYS_RESETn2,
    input phy_ble_clk1,
    input phy_ble_clk2
);

    wire                      RXD0_INTERNAL;
    wire                      TXD0_INTERNAL;
    wire                      RXD1_INTERNAL;
    wire                      TXD1_INTERNAL;
    wire                      CTS0_INTERNAL;
    wire                      RTS0_INTERNAL;
    wire                      CTS1_INTERNAL;
    wire                      RTS1_INTERNAL;
    wire                      S_SCK_INTERNAL;
    wire                      S_MOSI_INTERNAL;
    wire                      S_MISO_INTERNAL;
    wire                      M_MISO_INTERNAL;
    wire                      M_MOSI_INTERNAL;
    wire                      M_SCK_INTERNAL;
    wire                      SS0_INTERNAL;
    wire                      SS_INTERNAL;
    wire [PORTWIDTH-1:0]      PORTOUT_INTERNAL;
    wire [PORTWIDTH-1:0]      PORTIN_INTERNAL;
    
    wire                      valid_out_mem_re_ble_INTERNAL;
    wire [RE_IM_SIZE_BLE-1:0] data_out_re_to_rx_ble_INTERNAL;
    wire                      valid_out_mem_im_ble_INTERNAL;
    wire [RE_IM_SIZE_BLE-1:0] data_out_im_to_rx_ble_INTERNAL;
    wire                      valid_in_mem_re_ble_INTERNAL;
    wire [RE_IM_SIZE_BLE-1:0] data_in_re_to_rx_ble_INTERNAL;
    wire                      valid_in_mem_im_ble_INTERNAL;
    wire [RE_IM_SIZE_BLE-1:0] data_in_im_to_rx_ble_INTERNAL;


SYSTEM_TOP #(.AW(AW_1),
            .Include_DMA(Include_DMA_1),
            .Include_dual_timer(Include_dual_timer_1),
            .Include_SPI(Include_SPI_1),
            .Include_WIFI(Include_WIFI_1),
            .Include_COMP(Include_COMP_1),
            .GROUP0(GROUP0_1),.GROUP1(GROUP1_1),.GROUP2(GROUP2_1),.GROUP3(GROUP3_1),
            .ALTERNATE_FUNC_MASK(ALTERNATE_FUNC_MASK_1),
            .pri_sel(pri_sel_1),
            .channel_number(channel_number_1),
            .req_number(req_number_1),
            .ch_conf(ch_conf_1),
            .ALTERNATE_FUNC_DEFAULT(ALTERNATE_FUNC_DEFAULT_1),
            .BE(BE),
            .PORTWIDTH(PORTWIDTH),
            .ALTFUNC(ALTFUNC),
            .AD_BLE(AD_BLE),
            .DATA_BLE(DATA_BLE),
            .MEM_BLE(MEM_BLE),
            .RE_IM_AD_BLE(RE_IM_AD_BLE),
            .RE_IM_SIZE_BLE(RE_IM_SIZE_BLE),
            .RE_IM_MEM_BLE(RE_IM_MEM_BLE),
            .OFFSET_BLE(OFFSET_BLE),
            .DEPTH_BLE(DEPTH_BLE),
            .WIDTH_BLE(WIDTH_BLE),
            .ADDR_WIFI(ADDR_WIFI),
            .DATA_WIFI(DATA_WIFI),
            .COMP_OUT_WIDTH(COMP_OUT_WIDTH),
            .COMP_IN_WIDTH(COMP_IN_WIDTH),
            .COMP_DIM(COMP_DIM),
            .COMP_MEM_UNCOMP_DEPTH(COMP_MEM_UNCOMP_DEPTH),
            .COMP_MEM_COMP_DEPTH(COMP_MEM_COMP_DEPTH),
            .IMG1(IMG1),
            .IMG2(IMG2),
            .IMG3(IMG3),
            .IMG4(IMG4),
            .IMG5(IMG5),
            .IMG6(IMG6),
            .IMG7(IMG7),
            .IMG8(IMG8))
        SYS_1 (
        .SYS_FCLK(SYS_FCLK1),
        .RESETn(SYS_RESETn1),
        .phy_ble_clk(phy_ble_clk1),
        .RXD0(TXD1_INTERNAL),
        .TXD0(RXD1_INTERNAL),
        .RXD1(TXD0_INTERNAL),
        .TXD1(RXD0_INTERNAL),
        .RTS0(CTS1_INTERNAL),
        .RTS1(CTS0_INTERNAL),
        .CTS0(RTS1_INTERNAL),
        .CTS1(RTS0_INTERNAL),
        .EXTIN(1'b1),
        .M_SCK(S_SCK_INTERNAL),
        .M_MOSI(S_MOSI_INTERNAL),
        .M_MISO(S_MISO_INTERNAL),
        .S_MISO(M_MISO_INTERNAL),
        .S_MOSI(M_MOSI_INTERNAL),
        .S_SCK(M_SCK_INTERNAL),
        .SS(SS0_INTERNAL),
        .SS0(SS_INTERNAL),
        .SS1(),
        .SS2(),
        .SS3(),
        .PORTIN(PORTOUT_INTERNAL),
        .PORTOUT(PORTIN_INTERNAL),

        .valid_in_mem_re_ble(valid_out_mem_re_ble_INTERNAL),
	    .data_in_re_to_rx_ble(data_out_re_to_rx_ble_INTERNAL),
	    .valid_in_mem_im_ble(valid_out_mem_im_ble_INTERNAL),
	    .data_in_im_to_rx_ble(data_out_im_to_rx_ble_INTERNAL),
    
	    .valid_out_mem_re_ble( valid_in_mem_re_ble_INTERNAL),
	    .data_out_re_to_rx_ble(data_in_re_to_rx_ble_INTERNAL),
	    .valid_out_mem_im_ble( valid_in_mem_im_ble_INTERNAL),
	    .data_out_im_to_rx_ble(data_in_im_to_rx_ble_INTERNAL)

);


SYSTEM_TOP #(.AW(AW_2),
            .Include_DMA(Include_DMA_2),
            .Include_dual_timer(Include_dual_timer_2),
            .Include_SPI(Include_SPI_2),
            .Include_WIFI(Include_WIFI_2),
            .Include_COMP(Include_COMP_2),
            .GROUP0(GROUP0_2),.GROUP1(GROUP1_2),.GROUP2(GROUP2_2),.GROUP3(GROUP3_2),
            .ALTERNATE_FUNC_MASK(ALTERNATE_FUNC_MASK_2),
            .pri_sel(pri_sel_2),
            .channel_number(channel_number_2),
            .req_number(req_number_2),
            .ch_conf(ch_conf_2),
            .ALTERNATE_FUNC_DEFAULT(ALTERNATE_FUNC_DEFAULT_2),
            .BE(BE),
            .PORTWIDTH(PORTWIDTH),
            .ALTFUNC(ALTFUNC),
            .AD_BLE(AD_BLE),
            .DATA_BLE(DATA_BLE),
            .MEM_BLE(MEM_BLE),
            .RE_IM_AD_BLE(RE_IM_AD_BLE),
            .RE_IM_SIZE_BLE(RE_IM_SIZE_BLE),
            .RE_IM_MEM_BLE(RE_IM_MEM_BLE),
            .OFFSET_BLE(OFFSET_BLE),
            .DEPTH_BLE(DEPTH_BLE),
            .WIDTH_BLE(WIDTH_BLE),
            .ADDR_WIFI(ADDR_WIFI),
            .DATA_WIFI(DATA_WIFI))
    SYS_2(
        .SYS_FCLK(SYS_FCLK2),
        .RESETn(SYS_RESETn2),
        .phy_ble_clk(phy_ble_clk2),
        .RXD0(RXD0_INTERNAL),
        .TXD0(TXD0_INTERNAL),
        .RXD1(RXD1_INTERNAL),
        .TXD1(TXD1_INTERNAL),
        .RTS0(RTS0_INTERNAL),
        .RTS1(RTS1_INTERNAL),
        .CTS0(CTS0_INTERNAL),
        .CTS1(CTS1_INTERNAL),
        .EXTIN(1'b1),
        .M_SCK(M_SCK_INTERNAL),
        .M_MOSI(M_MOSI_INTERNAL),
        .M_MISO(M_MISO_INTERNAL),
        .S_MISO(S_MISO_INTERNAL),
        .S_MOSI(S_MOSI_INTERNAL),
        .S_SCK(S_SCK_INTERNAL),
        .SS(SS_INTERNAL),
        .SS0(SS0_INTERNAL),
        .SS1(),
        .SS2(),
        .SS3(),
        .PORTIN(PORTIN_INTERNAL),
        .PORTOUT(PORTOUT_INTERNAL),

        .valid_in_mem_re_ble(valid_in_mem_re_ble_INTERNAL),
	    .data_in_re_to_rx_ble(data_in_re_to_rx_ble_INTERNAL),
	    .valid_in_mem_im_ble(valid_in_mem_im_ble_INTERNAL),
	    .data_in_im_to_rx_ble(data_in_im_to_rx_ble_INTERNAL),
    
	    .valid_out_mem_re_ble(valid_out_mem_re_ble_INTERNAL),
	    .data_out_re_to_rx_ble(data_out_re_to_rx_ble_INTERNAL),
	    .valid_out_mem_im_ble(valid_out_mem_im_ble_INTERNAL),
	    .data_out_im_to_rx_ble(data_out_im_to_rx_ble_INTERNAL)

);
endmodule