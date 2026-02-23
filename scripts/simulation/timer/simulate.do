do ../../scripts/simulation/timer/Compile.do

vsim -voptargs=+acc timer_tb

add wave -divider APB_signals
add wave -group APB  timer_tb/DUT/PCLK   
add wave -group APB  timer_tb/DUT/PRESETn
add wave -group APB -color Gold timer_tb/DUT/PENABLE
add wave -group APB -color Gold timer_tb/DUT/PSEL   
add wave -group APB -color Gold timer_tb/DUT/PADDR  
add wave -group APB -color Gold timer_tb/DUT/PWRITE 
add wave -group APB -color Gold timer_tb/DUT/PWDATA 
add wave -group APB -color Gold timer_tb/DUT/PRDATA
add wave -group APB -color Gold timer_tb/DUT/PSLVERR
add wave -group APB -color Gold timer_tb/DUT/PRDATA

add wave -divider timer_signals
add wave -group TIMER -radix binary -color Cyan timer_tb/DUT/reg_ctrl
add wave -group TIMER -radix Unsigned -color Cyan timer_tb/DUT/reg_reload_val
add wave -group TIMER -color Cyan timer_tb/DUT/EXTIN
add wave -group TIMER -radix Unsigned -color Cyan timer_tb/DUT/reg_curr_val 
add wave -group TIMER -color Cyan timer_tb/DUT/TIMERINT

run -all



