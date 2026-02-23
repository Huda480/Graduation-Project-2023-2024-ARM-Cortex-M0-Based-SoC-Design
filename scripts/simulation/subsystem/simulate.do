quit -sim
do ../../scripts/simulation/subsystem/Compile.do

vsim -voptargs=+acc subsystem_tb

add wave -divider AHBsignals
add wave -group AHB subsystem_tb/DUT/HCLK   
add wave -group AHB subsystem_tb/DUT/HRESETn
add wave -group AHB subsystem_tb/DUT/HTRANS 
add wave -group AHB subsystem_tb/DUT/HSIZE  
add wave -group AHB subsystem_tb/DUT/HPROT  
add wave -group AHB subsystem_tb/DUT/HADDR  
add wave -group AHB subsystem_tb/DUT/HWDATA 
add wave -group AHB subsystem_tb/DUT/HSEL   
add wave -group AHB subsystem_tb/DUT/HWRITE 
add wave -group AHB subsystem_tb/DUT/HREADY 
add wave -group AHB subsystem_tb/DUT/HRDATA   
add wave -group AHB subsystem_tb/DUT/HREADYOUT
add wave -group AHB subsystem_tb/DUT/HRESP 

add wave -divider APBsignals
add wave -group APB subsystem_tb/DUT/PCLK   
add wave -group APB subsystem_tb/DUT/PCLKG  
add wave -group APB subsystem_tb/DUT/PRESETn

add wave -divider timer
add wave -group TIMER -radix binary -color yellowgreen subsystem_tb/DUT/TIMER/reg_ctrl
add wave -group TIMER -radix Unsigned -color yellowgreen subsystem_tb/DUT/TIMER/reg_reload_val
add wave -group TIMER -color yellowgreen subsystem_tb/DUT/TIMER/EXTIN
add wave -group TIMER -radix Unsigned -color yellowgreen subsystem_tb/DUT/TIMER/reg_curr_val
add wave -group TIMER -color yellowgreen subsystem_tb/DUT/TIMER/TIMERINT

add wave -divider dualtimer
add wave -group DUALTIMER -color Magenta subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/TIMCLK
add wave -group DUALTIMER -color Magenta subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/TIMINTC

add wave -group DUALTIMER -group TIMER1 -color Gold subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/TIMINT1
add wave -group DUALTIMER -group TIMER1 -radix Unsigned -color Gold subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/u_apb_timer_frc_1/load_val
add wave -group DUALTIMER -group TIMER1 -radix Unsigned -color Gold subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/u_apb_timer_frc_1/load_period
add wave -group DUALTIMER -group TIMER1 -radix Unsigned -color Gold subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/u_apb_timer_frc_1/count_reg
add wave -group DUALTIMER -group TIMER1 -radix binary -color Gold subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/u_apb_timer_frc_1/ctrl_val

add wave -group DUALTIMER -group TIMER2 -color pink subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/TIMINT2
add wave -group DUALTIMER -group TIMER2 -radix Unsigned -color pink subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/u_apb_timer_frc_2/load_val
add wave -group DUALTIMER -group TIMER2 -radix Unsigned -color pink subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/u_apb_timer_frc_2/load_period
add wave -group DUALTIMER -group TIMER2 -radix Unsigned -color pink subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/u_apb_timer_frc_2/count_reg
add wave -group DUALTIMER -group TIMER2 -radix binary -color pink subsystem_tb/DUT/Dual_timer_instance/DUAL_TIMER/u_apb_timer_frc_2/ctrl_val


add wave -divider watchdog
add wave -group WDOG -color Cyan subsystem_tb/DUT/WATCHDOG/WDOGCLK
add wave -group WDOG -color Cyan subsystem_tb/DUT/WATCHDOG/WDOGCLKEN
add wave -group WDOG -color Cyan subsystem_tb/DUT/WATCHDOG/WDOGRESn
add wave -group WDOG -color Cyan subsystem_tb/DUT/WATCHDOG/WDOGINT
add wave -group WDOG -color Cyan subsystem_tb/DUT/WATCHDOG/WDOGRES
add wave -group WDOG -color Cyan subsystem_tb/DUT/WATCHDOG/wdog_lock

add wave -group WDOG -radix Unsigned -color Cyan subsystem_tb/DUT/WATCHDOG/u_apb_watchdog_frc/wdog_load
add wave -group WDOG -radix Unsigned -color Cyan subsystem_tb/DUT/WATCHDOG/u_apb_watchdog_frc/reg_count
add wave -group WDOG -radix binary   -color Cyan subsystem_tb/DUT/WATCHDOG/u_apb_watchdog_frc/wdog_control


add wave -divider spi



add wave -divider uart


add wave -group UART -group UART0 -color orange subsystem_tb/DUT/UART0/RXD     
add wave -group UART -group UART0 -color orange subsystem_tb/DUT/UART0/TXD     
add wave -group UART -group UART0 -color orange subsystem_tb/DUT/UART0/RTS     
add wave -group UART -group UART0 -color orange subsystem_tb/DUT/UART0/CTS 
add wave -group UART -group UART0 -radix binary   -color orange subsystem_tb/DUT/UART0/reg_ctrl
add wave -group UART -group UART0 -radix Unsigned -color orange subsystem_tb/DUT/UART0/reg_tx_buf
add wave -group UART -group UART0 -radix Unsigned -color orange subsystem_tb/DUT/UART0/reg_rx_buf
add wave -group UART -group UART0 -radix Unsigned -color orange subsystem_tb/DUT/UART0/reg_baud_div    



add wave -group UART -group UART1 -color yellow subsystem_tb/DUT/UART1/RXD     
add wave -group UART -group UART1 -color yellow subsystem_tb/DUT/UART1/TXD     
add wave -group UART -group UART1 -color yellow subsystem_tb/DUT/UART1/RTS     
add wave -group UART -group UART1 -color yellow subsystem_tb/DUT/UART1/CTS 
add wave -group UART -group UART1 -radix binary   -color yellow subsystem_tb/DUT/UART1/reg_ctrl
add wave -group UART -group UART1 -radix Unsigned -color yellow subsystem_tb/DUT/UART1/reg_tx_buf
add wave -group UART -group UART1 -radix Unsigned -color yellow subsystem_tb/DUT/UART1/reg_rx_buf
add wave -group UART -group UART1 -radix Unsigned -color yellow subsystem_tb/DUT/UART1/reg_baud_div   









run -all



