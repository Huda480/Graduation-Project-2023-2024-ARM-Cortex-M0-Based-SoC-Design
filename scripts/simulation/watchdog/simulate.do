do ../../scripts/simulation/watchdog/Compile.do

vsim -voptargs=+acc watchdog_tb

add wave -divider APB_signals
add wave -group APB  watchdog_tb/DUT/PCLK   
add wave -group APB  watchdog_tb/DUT/PRESETn
add wave -group APB -color Gold watchdog_tb/DUT/PENABLE
add wave -group APB -color Gold watchdog_tb/DUT/PSEL   
add wave -group APB -color Gold watchdog_tb/DUT/PADDR  
add wave -group APB -color Gold watchdog_tb/DUT/PWRITE 
add wave -group APB -color Gold watchdog_tb/DUT/PWDATA 
add wave -group APB -color Gold watchdog_tb/DUT/PRDATA
add wave -group APB -color Gold watchdog_tb/DUT/PSLVERR
add wave -group APB -color Gold watchdog_tb/DUT/PRDATA



add wave -divider watchdog_signals
add wave -group WDOG -color Cyan watchdog_tb/DUT/WDOGCLK
add wave -group WDOG -color Cyan watchdog_tb/DUT/WDOGCLKEN
add wave -group WDOG -color Cyan watchdog_tb/DUT/WDOGRESn
add wave -group WDOG -color Cyan watchdog_tb/DUT/WDOGINT
add wave -group WDOG -color Cyan watchdog_tb/DUT/WDOGRES
add wave -group WDOG -color Cyan watchdog_tb/DUT/wdog_lock

add wave -group WDOG -radix Unsigned -color Cyan watchdog_tb/DUT/u_apb_watchdog_frc/wdog_load
add wave -group WDOG -radix Unsigned -color Cyan watchdog_tb/DUT/u_apb_watchdog_frc/reg_count
add wave -group WDOG -radix binary   -color Cyan watchdog_tb/DUT/u_apb_watchdog_frc/wdog_control




run -all



