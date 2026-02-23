do ../../scripts/simulation/uart/Compile.do

vsim -voptargs=+acc uart_tb

add wave -divider APB_signals
add wave -group APB  uart_tb/DUT/PCLK
add wave -group APB  uart_tb/DUT/PCLKG   
add wave -group APB  uart_tb/DUT/PRESETn
add wave -group APB -color Gold uart_tb/DUT/PENABLE
add wave -group APB -color Gold uart_tb/DUT/PSEL   
add wave -group APB -color Gold uart_tb/DUT/PADDR  
add wave -group APB -color Gold uart_tb/DUT/PWRITE 
add wave -group APB -color Gold uart_tb/DUT/PWDATA 
add wave -group APB -color Gold uart_tb/DUT/PRDATA
add wave -group APB -color Gold uart_tb/DUT/PSLVERR


add wave -divider UART_signals
add wave -group UART -color Magenta uart_tb/DUT/RXD     
add wave -group UART -color Magenta uart_tb/DUT/TXD     
add wave -group UART -color Magenta uart_tb/DUT/TXEN    
add wave -group UART -color Magenta uart_tb/DUT/BAUDTICK
add wave -group UART -color Magenta uart_tb/DUT/TXINT   
add wave -group UART -color Magenta uart_tb/DUT/RXINT   
add wave -group UART -color Magenta uart_tb/DUT/TXOVRINT
add wave -group UART -color Magenta uart_tb/DUT/RXOVRINT
add wave -group UART -color Magenta uart_tb/DUT/UARTINT 
add wave -group UART -color Magenta uart_tb/DUT/RTS     
add wave -group UART -color Magenta uart_tb/DUT/CTS 
add wave -group UART -radix binary   -color Magenta uart_tb/DUT/reg_ctrl
add wave -group UART -radix Unsigned -color Magenta uart_tb/DUT/reg_tx_buf
add wave -group UART -radix Unsigned -color Magenta uart_tb/DUT/reg_rx_buf
add wave -group UART -radix Unsigned -color Magenta uart_tb/DUT/reg_baud_div    


run -all



