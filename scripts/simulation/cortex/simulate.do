do ../../scripts/simulation/cortex/Compile.do

vsim -voptargs=+acc cortex_tb

add wave cortex_tb/DUT/HCLK
add wave cortex_tb/DUT/HRESETn 

add wave -divider UART_transmit
add wave -group UART_TRANSMIT -color MediumOrchid cortex_tb/DUT/TXD0 
add wave -group UART_TRANSMIT -color MediumOrchid -radix ASCII cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART0/reg_tx_buf

add wave -divider UART_receive
add wave -group UART_RECEIVE -color Cyan cortex_tb/DUT/RXD1 
add wave -group UART_RECEIVE -color Cyan -radix ASCII cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART1/reg_rx_buf

add wave -divider SPI
add wave -group SPI -color Gold cortex_tb/DUT/MOSI
add wave -group SPI -color Gold cortex_tb/DUT/SCK
add wave -group SPI -color Gold cortex_tb/DUT/SS0
add wave -group SPI -color Gold -radix ASCII cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI/DATA_SHIFT_REG

add wave -divider GPIO
add wave -group GPIO -color Magenta -radix ASCII cortex_tb/DUT/SYSTEM_OUT

run -all



