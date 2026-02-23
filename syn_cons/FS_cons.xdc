################################################### VARIABLE DECLARATION ###################################################
set delay 0.2
set o_delay 0.05
set period 10
set period_sck 40
set half [expr $period*0.5]
set half_sck [expr $period_sck*0.5]
set pdiv 2

set pclk [expr $period * $pdiv]
set wdogdiv 2
set timdiv 2

set wdogclk [expr $pclk * $wdogdiv]
set timclk [expr $pclk * $timdiv]
set h_delay [expr $period * $delay]
set p_delay [expr $pclk * $delay]
set w_delay [expr $wdogclk * $delay]
set t_delay [expr $timclk * $delay]

set oh_delay [expr $period * $o_delay]
set op_delay [expr $pclk * $o_delay]
set ow_delay [expr $wdogclk * $o_delay]
set ot_delay [expr $timclk * $o_delay]


################################################### FISRT SYSTEM CLOCK GENERATION ###################################################
create_clock -period $period -name SYS_FCLK1 -waveform "0.000 $half" [get_ports SYS_FCLK1]
create_clock -period 18 -name phy_ble_SYS1 [get_ports phy_ble_clk1]

################################################### SECOND SYSTEM CLOCK GENERATION ###################################################
create_clock -period $period -name SYS_FCLK2 -waveform "0.000 $half" [get_ports SYS_FCLK2]
create_clock -period 18 -name phy_ble_SYS2 [get_ports phy_ble_clk2]

################################################### FISRT SYSTEM GENERATED CLOCKS ###################################################
create_generated_clock -name HCLK_SYS1 -source [get_ports SYS_FCLK1] -divide_by 2 \ [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/HCLK_Divider/div_clk_reg/Q]

create_generated_clock -name BLE1_SYS1 -source [get_ports phy_ble_clk1] -divide_by 8 \ [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/BLE_DIVIDER1/div_clk_reg/Q]

create_generated_clock -name BLE2_SYS1 -source [get_ports phy_ble_clk1] -divide_by 16 \ [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/BLE_DIVIDER2/div_clk_reg/Q]

create_generated_clock -name PCLK_SYS1 -source [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/PCLK_Divider/REF_CLK] -divide_by 2 \ [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/PCLK_Divider/OUT_CLK]

create_generated_clock -name PCLKG_SYS1 -source [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/PCLK_Divider/OUT_CLK] -divide_by 1 \ [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/PCLKG]

create_generated_clock -name WDOGCLK_SYS1 -source [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/WDOGCLK_Divider/REF_CLK] -divide_by 2 \ [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/WDOGCLK_Divider/div_clk_reg/Q]


create_generated_clock -name clk_wr_rx_ble_SYS1 -source [get_pins SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_w/clk[1]] -divide_by 1 -add -master_clock BLE1_SYS1 \ [get_pins SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_w/clk_out]

create_generated_clock -name clk_wr_ahb_ble_SYS1 -source [get_pins SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_w/clk[0]] -divide_by 1 -add -master_clock HCLK_SYS1 \ [get_pins SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_w/clk_out]

create_generated_clock -name clk_rd_tx_ble_SYS1 -source [get_pins SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_r/clk[1]] -divide_by 1 -add -master_clock BLE2_SYS1 \ [get_pins SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_r/clk_out]

create_generated_clock -name clk_rd_ahb_ble_SYS1 -source [get_pins SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_r/clk[0]] -divide_by 1 -add -master_clock HCLK_SYS1 \ [get_pins SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_r/clk_out]

create_generated_clock -name TIMCLK_SYS1 -source [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/DUAL_TIMER_INCLUDED.TIMCLK_Divider/REF_CLK] -divide_by 2 \ [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/DUAL_TIMER_INCLUDED.TIMCLK_Divider/div_clk_reg/Q]

create_generated_clock -name SCK_SYS1 -source [get_pins SYS_1/RCC_instance/RESET_CLOCK_CONTROLLER/PCLK] -divide_by 2 \ [get_pins SYS_1/cmsdk_apb_subsystem_instance/SPI_INCLUDED.SPI/SPI/SPI_MASTER/SCK_reg/Q]


################################################### SECOND SYSTEM GENERATED CLOCKS ###################################################
create_generated_clock -name HCLK_SYS2 -source [get_ports SYS_FCLK2] -divide_by 2 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/HCLK_Divider/div_clk_reg/Q]

create_generated_clock -name BLE1_SYS2 -source [get_ports phy_ble_clk2] -divide_by 8 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/BLE_DIVIDER1/div_clk_reg/Q]

create_generated_clock -name BLE2_SYS2 -source [get_ports phy_ble_clk2] -divide_by 16 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/BLE_DIVIDER2/div_clk_reg/Q]

create_generated_clock -name WIFI1_SYS2 -source [get_ports SYS_FCLK2] -divide_by 1 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/WIFI_INCLUDED.WIFI_DIVIDER1/TEST/O]

create_generated_clock -name WIFI2_SYS2 -source [get_ports SYS_FCLK2] -divide_by 2 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/WIFI_INCLUDED.WIFI_DIVIDER2/TEST/O]

create_generated_clock -name WIFI3_SYS2 -source [get_ports SYS_FCLK2] -divide_by 4 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/WIFI_INCLUDED.WIFI_DIVIDER3/div_clk_reg/Q]

create_generated_clock -name PCLK_SYS2 -source [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/PCLK_Divider/REF_CLK] -divide_by 2 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/PCLK_Divider/OUT_CLK]

create_generated_clock -name PCLKG_SYS2 -source [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/PCLK] -divide_by 1 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/PCLKG]

create_generated_clock -name WDOGCLK_SYS2 -source [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/WDOGCLK_Divider/REF_CLK] -divide_by 2 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/WDOGCLK_Divider/div_clk_reg/Q]


create_generated_clock -name clk_wr_rx_ble_SYS2 -source [get_pins SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_w/clk[1]] -divide_by 1 -add -master_clock BLE1_SYS2 \ [get_pins SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_w/clk_out]

create_generated_clock -name clk_wr_ahb_ble_SYS2 -source [get_pins SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_w/clk[0]] -divide_by 1 -add -master_clock HCLK_SYS2 \ [get_pins SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_w/clk_out]

create_generated_clock -name clk_rd_tx_ble_SYS2 -source [get_pins SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_r/clk[1]] -divide_by 1 -add -master_clock BLE2_SYS2 \ [get_pins SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_r/clk_out]

create_generated_clock -name clk_rd_ahb_ble_SYS2 -source [get_pins SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_r/clk[0]] -divide_by 1 -add -master_clock HCLK_SYS2 \ [get_pins SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/clk_r/clk_out]

create_generated_clock -name clk1mux_SYS2 -source [get_pins SYS_2/dma_included.dma_and_wifi.phy_wifi_instance/WIFI_TOP/shared_memory/clk_w/clk[0]] -divide_by 1 -add -master_clock HCLK_SYS2 \ [get_pins SYS_2/dma_included.dma_and_wifi.phy_wifi_instance/WIFI_TOP/shared_memory/clk_w/clk_out]

create_generated_clock -name clk2mux_SYS2 -source [get_pins SYS_2/dma_included.dma_and_wifi.phy_wifi_instance/WIFI_TOP/shared_memory/clk_w/clk[1]] -divide_by 1 -add -master_clock WIFI2_SYS2 \ [get_pins SYS_2/dma_included.dma_and_wifi.phy_wifi_instance/WIFI_TOP/shared_memory/clk_w/clk_out]

create_generated_clock -name clk3mux_SYS2 -source [get_pins SYS_2/dma_included.dma_and_wifi.phy_wifi_instance/WIFI_TOP/shared_memory/clk_r/clk[0]] -divide_by 1  -add -master_clock HCLK_SYS2 \ [get_pins SYS_2/dma_included.dma_and_wifi.phy_wifi_instance/WIFI_TOP/shared_memory/clk_r/clk_out]

create_generated_clock -name clk4mux_SYS2 -source [get_pins SYS_2/dma_included.dma_and_wifi.phy_wifi_instance/WIFI_TOP/shared_memory/clk_r/clk[1]] -divide_by 1 -add -master_clock WIFI2_SYS2 \ [get_pins SYS_2/dma_included.dma_and_wifi.phy_wifi_instance/WIFI_TOP/shared_memory/clk_r/clk_out]

create_generated_clock -name TIMCLK_SYS2 -source [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/DUAL_TIMER_INCLUDED.TIMCLK_Divider/REF_CLK] -divide_by 2 \ [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/DUAL_TIMER_INCLUDED.TIMCLK_Divider/div_clk_reg/Q]

create_generated_clock -name SCK_SYS2 -source [get_pins SYS_2/RCC_instance/RESET_CLOCK_CONTROLLER/PCLK] -divide_by 2 \ [get_pins SYS_2/cmsdk_apb_subsystem_instance/SPI_INCLUDED.SPI/SPI/SPI_MASTER/SCK_reg/Q]


################################################### FIRST SYSTEM PHYSICALLY EXCLUSIVE GROUPS ###################################################
set_clock_groups -physically_exclusive -group clk_wr_rx_ble_SYS1 -group clk_wr_ahb_ble_SYS1
set_clock_groups -physically_exclusive -group clk_rd_tx_ble_SYS1 -group clk_rd_ahb_ble_SYS1

################################################### SECOND SYSTEM PHYSICALLY EXCLUSIVE GROUPS ###################################################
set_clock_groups -physically_exclusive -group clk_wr_rx_ble_SYS2 -group clk_wr_ahb_ble_SYS2
set_clock_groups -physically_exclusive -group clk_rd_tx_ble_SYS2 -group clk_rd_ahb_ble_SYS2
set_clock_groups -physically_exclusive -group clk1mux_SYS2 -group clk2mux_SYS2
set_clock_groups -physically_exclusive -group clk3mux_SYS2 -group clk4mux_SYS2

################################################### ASYNCHRONOUS CLOCKS DECLARATION ###################################################
set_clock_groups -asynchronous -group [get_clocks {SYS_FCLK1 HCLK_SYS1 PCLK_SYS1 PCLKG_SYS1 WDOGCLK_SYS1 clk_wr_ahb_ble_SYS1 clk_rd_ahb_ble_SYS1 TIMCLK_SYS1 SCK_SYS1}] -group [get_clocks {phy_ble_SYS1 BLE1_SYS1 BLE2_SYS1 clk_wr_rx_ble_SYS1 clk_rd_tx_ble_SYS1}] -group [get_clocks {SYS_FCLK2 HCLK_SYS2 PCLK_SYS2 PCLKG_SYS2 WDOGCLK_SYS2 WIFI1_SYS2 WIFI2_SYS2  WIFI3_SYS2 clk_wr_ahb_ble_SYS2 clk_rd_ahb_ble_SYS2 TIMCLK_SYS2 SCK_SYS2}] -group [get_clocks {phy_ble_SYS2 BLE1_SYS2 BLE2_SYS2 clk_wr_rx_ble_SYS2 clk_rd_tx_ble_SYS2}]


################################################### FIRST SYSTEM INPUT DELAY ###################################################
set_input_delay -clock [get_clocks SYS_FCLK1] -min -add_delay $h_delay [get_ports SYS_RESETn1]
set_input_delay -clock [get_clocks SYS_FCLK1] -max -add_delay $p_delay [get_ports SYS_RESETn1]

################################################### SECOND SYSTEM INPUT DELAY ###################################################
set_input_delay -clock [get_clocks SYS_FCLK2] -min -add_delay $h_delay [get_ports SYS_RESETn2]
set_input_delay -clock [get_clocks SYS_FCLK2] -max -add_delay $p_delay [get_ports SYS_RESETn2]

################################################### SETUP FIRST SYSTEM ###################################################
set_multicycle_path -setup $pdiv -from [get_clocks PCLK_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -setup $pdiv -from [get_clocks PCLKG_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -setup "[expr $pdiv * $wdogdiv]" -from [get_clocks WDOGCLK_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -setup $wdogdiv -from [get_clocks WDOGCLK_SYS1] -to [get_clocks PCLK_SYS1]
set_multicycle_path -setup $wdogdiv -from [get_clocks WDOGCLK_SYS1] -to [get_clocks PCLKG_SYS1]
set_multicycle_path -setup 2 -from [get_clocks HCLK_SYS1] -to [get_clocks SYS_FCLK1]

set_multicycle_path -setup "[expr $pdiv * $timdiv]" -from [get_clocks TIMCLK_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -setup $timdiv -from [get_clocks TIMCLK_SYS1] -to [get_clocks PCLK_SYS1]
set_multicycle_path -setup $timdiv -from [get_clocks TIMCLK_SYS1] -to [get_clocks PCLKG_SYS1]
set_multicycle_path -setup "[expr $pdiv * $timdiv]" -from [get_clocks TIMCLK_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -setup $timdiv -from [get_clocks TIMCLK_SYS1] -to [get_clocks PCLK_SYS1]
set_multicycle_path -setup $timdiv -from [get_clocks TIMCLK_SYS1] -to [get_clocks PCLKG_SYS1]
set_multicycle_path -setup 2 -from [get_clocks SCK_SYS1] -to [get_clocks PCLK_SYS1]

################################################### SETUP SECOND SYSTEM ###################################################
set_multicycle_path -setup $pdiv -from [get_clocks PCLK_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -setup $pdiv -from [get_clocks PCLKG_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -setup "[expr $pdiv * $wdogdiv]" -from [get_clocks WDOGCLK_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -setup $wdogdiv -from [get_clocks WDOGCLK_SYS2] -to [get_clocks PCLK_SYS2]
set_multicycle_path -setup $wdogdiv -from [get_clocks WDOGCLK_SYS2] -to [get_clocks PCLKG_SYS2]
set_multicycle_path -setup 2 -from [get_clocks HCLK_SYS2] -to [get_clocks WIFI1_SYS2]
set_multicycle_path -setup 2 -from [get_clocks WIFI2_SYS2] -to [get_clocks WIFI1_SYS2]
set_multicycle_path -setup 2 -from [get_clocks WIFI3_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -setup 2 -from [get_clocks WIFI3_SYS2] -to [get_clocks WIFI2_SYS2]
set_multicycle_path -setup 4 -from [get_clocks WIFI3_SYS2] -to [get_clocks WIFI1_SYS2]
set_multicycle_path -setup 2 -from [get_clocks HCLK_SYS2] -to [get_clocks SYS_FCLK2]

set_multicycle_path -setup "[expr $pdiv * $timdiv]" -from [get_clocks TIMCLK_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -setup $timdiv -from [get_clocks TIMCLK_SYS2] -to [get_clocks PCLK_SYS2]
set_multicycle_path -setup $timdiv -from [get_clocks TIMCLK_SYS2] -to [get_clocks PCLKG_SYS2]
set_multicycle_path -setup 2 -from [get_clocks SCK_SYS2] -to [get_clocks PCLK_SYS2]

################################################### HOLD FIRST SYSTEM ###################################################
set_multicycle_path -hold "[expr $pdiv-1]" -from [get_clocks PCLK_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -hold "[expr $pdiv-1]" -from [get_clocks PCLKG_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -hold "[expr [expr $pdiv * $wdogdiv]-1]" -from [get_clocks WDOGCLK_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -hold "[expr $wdogdiv -1]" -from [get_clocks WDOGCLK_SYS1] -to [get_clocks PCLK_SYS1]
set_multicycle_path -hold "[expr $wdogdiv -1]" -from [get_clocks WDOGCLK_SYS1] -to [get_clocks PCLKG_SYS1]
set_multicycle_path -hold 1 -from [get_clocks HCLK_SYS1] -to [get_clocks SYS_FCLK1]

set_multicycle_path -hold "[expr [expr $pdiv * $timdiv]-1]" -from [get_clocks TIMCLK_SYS1] -to [get_clocks HCLK_SYS1]
set_multicycle_path -hold "[expr $timdiv-1]" -from [get_clocks TIMCLK_SYS1] -to [get_clocks PCLK_SYS1]
set_multicycle_path -hold "[expr $timdiv-1]" -from [get_clocks TIMCLK_SYS1] -to [get_clocks PCLKG_SYS1]
set_multicycle_path -hold 1 -from [get_clocks SCK_SYS1] -to [get_clocks PCLK_SYS1]

################################################### HOLD SECOND SYSTEM ###################################################
set_multicycle_path -hold "[expr $pdiv-1]" -from [get_clocks PCLK_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -hold "[expr $pdiv-1]" -from [get_clocks PCLKG_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -hold "[expr [expr $pdiv * $wdogdiv]-1]" -from [get_clocks WDOGCLK_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -hold "[expr $wdogdiv -1]" -from [get_clocks WDOGCLK_SYS2] -to [get_clocks PCLK_SYS2]
set_multicycle_path -hold "[expr $wdogdiv -1]" -from [get_clocks WDOGCLK_SYS2] -to [get_clocks PCLKG_SYS2]
set_multicycle_path -hold 1 -from [get_clocks HCLK_SYS2] -to [get_clocks WIFI1_SYS2]
set_multicycle_path -hold 1 -from [get_clocks WIFI2_SYS2] -to [get_clocks WIFI1_SYS2]
set_multicycle_path -hold 1 -from [get_clocks WIFI3_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -hold 1 -from [get_clocks WIFI3_SYS2] -to [get_clocks WIFI2_SYS2]
set_multicycle_path -hold 3 -from [get_clocks WIFI3_SYS2] -to [get_clocks WIFI1_SYS2]
set_multicycle_path -hold 1 -from [get_clocks HCLK_SYS2] -to [get_clocks SYS_FCLK2]

set_multicycle_path -hold "[expr [expr $pdiv * $timdiv]-1]" -from [get_clocks TIMCLK_SYS2] -to [get_clocks HCLK_SYS2]
set_multicycle_path -hold "[expr $timdiv-1]" -from [get_clocks TIMCLK_SYS2] -to [get_clocks PCLK_SYS2]
set_multicycle_path -hold "[expr $timdiv-1]" -from [get_clocks TIMCLK_SYS2] -to [get_clocks PCLKG_SYS2]
set_multicycle_path -hold 1 -from [get_clocks SCK_SYS2] -to [get_clocks PCLK_SYS2]

################################################### CLOCK LATENCY FIRST SYSTEM ###################################################
#set_clock_latency 0.3 [get_clocks PCLK_SYS1]
#set_clock_latency 0.3 [get_clocks PCLKG_SYS1]
#set_clock_latency 0.3 [get_clocks WDOGCLK_SYS1]
#set_clock_latency 0.3 [get_clocks clk_rd_tx_ble_SYS1]
#set_clock_latency 0.3 [get_clocks clk_wr_rx_ble_SYS1]
#set_clock_latency 0.3 [get_clocks clk_wr_ahb_ble_SYS1]
#set_clock_latency 0.3 [get_clocks clk_rd_ahb_ble_SYS1]
#set_clock_latency 0.3 [get_clocks TIMCLK_SYS1]
#set_clock_latency 0.3 [get_clocks SCK_SYS1]

################################################### CLOCK LATENCY SECOND SYSTEM ###################################################
#set_clock_latency 0.3 [get_clocks PCLK_SYS2]
#set_clock_latency 0.3 [get_clocks PCLKG_SYS2]
#set_clock_latency 0.3 [get_clocks WDOGCLK_SYS2]
#set_clock_latency 0.3 [get_clocks WIFI1_SYS2]
#set_clock_latency 0.3 [get_clocks WIFI3_SYS2]
#set_clock_latency 0.3 [get_clocks clk_rd_tx_ble_SYS2]
#set_clock_latency 0.3 [get_clocks clk_wr_rx_ble_SYS2]
#set_clock_latency 0.3 [get_clocks clk_wr_ahb_ble_SYS2]
#set_clock_latency 0.3 [get_clocks clk_rd_ahb_ble_SYS2]
#set_clock_latency 0.3 [get_clocks TIMCLK_SYS2]
#set_clock_latency 0.3 [get_clocks SCK_SYS2]
