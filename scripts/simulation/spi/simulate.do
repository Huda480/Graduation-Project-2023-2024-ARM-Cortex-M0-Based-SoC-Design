do ../../scripts/simulation/spi/Compile.do

vsim -voptargs=+acc spi_tb

add wave spi_tb/PCLK
add wave spi_tb/PRESETn 

add wave -divider SPI_master
add wave -group SPI_MASTER -color MediumOrchid spi_tb/DUT_Master/TXD0 
add wave -group SPI_MASTER -color MediumOrchid -radix ASCII spi_tb/DUT_Master/cmsdk_apb_subsystem_instance/UART0/reg_tx_buf

add wave -divider SPI_slave
add wave -group UART_RECEIVE -color Cyan spi_tb/DUT_Slave/RXD1 
add wave -group UART_RECEIVE -color Cyan -radix ASCII spi_tb/DUT_Slave/cmsdk_apb_subsystem_instance/UART1/reg_rx_buf

add wave -divider SPI
add wave -group SPI -color Gold spi_tb/MOSI
add wave -group SPI -color Gold spi_tb/DUT/SCK_clk
add wave -group SPI -color Gold spi_tb/DUT/SS0
add wave -group SPI -color Gold -radix ASCII spi_tb/DUT/cmsdk_apb_subsystem_instance/SPI/DATA_SHIFT_REG

add wave -divider GPIO
add wave -group GPIO -color Magenta -radix ASCII spi_tb/DUT/PORTOUT

run -all



