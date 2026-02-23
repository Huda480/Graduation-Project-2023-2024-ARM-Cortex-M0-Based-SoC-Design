do ../../scripts/simulation/gpio/Compile.do

vsim -voptargs=+acc gpio_tb

add wave gpio_tb/DUT/HCLK
add wave gpio_tb/DUT/HRESETn 

add wave -divider UART_transmit
add wave -group UART_TRANSMIT -color MediumOrchid gpio_tb/DUT/TXD0 
add wave -group UART_TRANSMIT -color MediumOrchid -radix ASCII gpio_tb/DUT/cmsdk_apb_subsystem_instance/UART0/reg_tx_buf

add wave -divider UART_receive
add wave -group UART_RECEIVE -color Cyan gpio_tb/DUT/RXD1 
add wave -group UART_RECEIVE -color Cyan -radix ASCII gpio_tb/DUT/cmsdk_apb_subsystem_instance/UART1/reg_rx_buf

add wave -divider SPI
add wave -group SPI -color Gold gpio_tb/MOSI
add wave -group SPI -color Gold gpio_tb/DUT/SCK_clk
add wave -group SPI -color Gold gpio_tb/DUT/SS0
add wave -group SPI -color Gold -radix ASCII gpio_tb/DUT/cmsdk_apb_subsystem_instance/SPI/DATA_SHIFT_REG

add wave -divider GPIO
add wave -group GPIO -color Magenta -radix ASCII gpio_tb/DUT/PORTOUT

run -all



