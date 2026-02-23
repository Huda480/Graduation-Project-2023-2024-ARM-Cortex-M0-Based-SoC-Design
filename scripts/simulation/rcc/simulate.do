do ../../scripts/simulation/rcc/Compile.do

vsim -voptargs=+acc rcc_tb

add wave -divider AHB_clk_reset
add wave -group AHB_clk_reset -color yellowgreen rcc_tb/DUT/HCLK
add wave -group AHB_clk_reset -color yellowgreen rcc_tb/DUT/HRESETn
add wave -divider AHB_signals
add wave -group AHB  rcc_tb/DUT/HSEL   
add wave -group AHB  rcc_tb/DUT/HREADY   
add wave -group AHB  rcc_tb/DUT/HTRANS   
add wave -group AHB  rcc_tb/DUT/HSIZE    
add wave -group AHB  rcc_tb/DUT/HWRITE   
add wave -group AHB  rcc_tb/DUT/HADDR    
add wave -group AHB  rcc_tb/DUT/HWDATA   
add wave -group AHB  rcc_tb/DUT/HREADYOUT
add wave -group AHB  rcc_tb/DUT/HRESP    
add wave -group AHB  rcc_tb/DUT/HRDATA

add wave -divider APB_clk_reset
add wave -group APB_clk_reset -color Magenta rcc_tb/DUT/PRESETn
add wave -group APB_clk_reset -color Magenta rcc_tb/DUT/PCLK
add wave -group APB_clk_reset -color Magenta rcc_tb/DUT/rcc/PCLK_Divider/EVEN_RATIO

add wave -divider APB_clk_gating
add wave -group APB_clk_gating -color MediumOrchid rcc_tb/DUT/APB_ACTIVE
add wave -group APB_clk_gating -color MediumOrchid rcc_tb/DUT/PCLKG

add wave -divider watchdog_clk_reset
add wave -group WDOG_clk_reset -color Cyan rcc_tb/DUT/WDOGCLK
add wave -group WDOG_clk_reset -color Cyan rcc_tb/DUT/WDOGRESn
add wave -group WDOG_clk_reset -color Cyan rcc_tb/DUT/rcc/WDOGCLK_Divider/EVEN_RATIO

add wave -divider dual_timer_clk
add wave -group TIMCLK -color yellow rcc_tb/DUT/TIMCLK
add wave -group TIMCLK -color yellow rcc_tb/DUT/rcc/TIMCLK_Divider/EVEN_RATIO

add wave -divider gpio_clk
add wave -group GPIOCLK -color Orange rcc_tb/DUT/FCLK




run -all



