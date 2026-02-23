do ../../scripts/simulation/dual_timer/Compile.do

vsim -voptargs=+acc dualtimers_tb

add wave -divider APB_signals
add wave -group APB  dualtimers_tb/DUT/PCLK   
add wave -group APB  dualtimers_tb/DUT/PRESETn
add wave -group APB -color Gold dualtimers_tb/DUT/PENABLE
add wave -group APB -color Gold dualtimers_tb/DUT/PSEL   
add wave -group APB -color Gold dualtimers_tb/DUT/PADDR  
add wave -group APB -color Gold dualtimers_tb/DUT/PWRITE 
add wave -group APB -color Gold dualtimers_tb/DUT/PWDATA 
add wave -group APB -color Gold dualtimers_tb/DUT/PRDATA
add wave -group APB -color Gold dualtimers_tb/DUT/PSLVERR
add wave -group APB -color Gold dualtimers_tb/DUT/PRDATA

add wave -divider shared_signals
add wave dualtimers_tb/DUT/TIMCLK
add wave dualtimers_tb/DUT/TIMINTC

add wave -divider TIMER1
add wave -group TIM1 -color Magenta dualtimers_tb/DUT/TIMCLKEN1
add wave -group TIM1 -color Magenta dualtimers_tb/DUT/TIMINT1
add wave -group TIM1 -color Magenta -radix Unsigned dualtimers_tb/DUT/u_apb_timer_frc_1/load_val   
add wave -group TIM1 -color Magenta -radix Unsigned dualtimers_tb/DUT/u_apb_timer_frc_1/load_period
add wave -group TIM1 -color Magenta -radix Unsigned dualtimers_tb/DUT/u_apb_timer_frc_1/count_reg 
add wave -group TIM1 -color Magenta -radix binary dualtimers_tb/DUT/u_apb_timer_frc_1/ctrl_val 

add wave -divider TIMER2
add wave -group TIM2 -color Cyan dualtimers_tb/DUT/TIMCLKEN2
add wave -group TIM2 -color Cyan dualtimers_tb/DUT/TIMINT2
add wave -group TIM2 -color Cyan -radix Unsigned dualtimers_tb/DUT/u_apb_timer_frc_2/load_val
add wave -group TIM2 -color Cyan -radix Unsigned dualtimers_tb/DUT/u_apb_timer_frc_2/load_period
add wave -group TIM2 -color Cyan -radix Unsigned dualtimers_tb/DUT/u_apb_timer_frc_2/count_reg
add wave -group TIM2 -color Cyan -radix binary dualtimers_tb/DUT/u_apb_timer_frc_2/ctrl_val


run -all



