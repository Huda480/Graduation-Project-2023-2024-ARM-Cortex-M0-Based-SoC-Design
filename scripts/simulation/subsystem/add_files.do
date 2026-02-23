#Compilation list

################################################################
#APB_SUBSYTEM

#Bridge files
project addfile ../../RTL/ahb_peripherals/apb_subsystem/bridge/APB_Bridge.sv

#shared files
project addfile ../../RTL/ahb_peripherals/apb_subsystem/general/apb_pkg.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/general/FIFO.sv

#Dual timer files
project addfile ../../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers_frc.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers.sv

#SPI files
project addfile ../../RTL/ahb_peripherals/apb_subsystem/spi/spi_pkg.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/spi/apb_spi_interface.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/spi/spi_master.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/spi/spi_slave.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/spi/spi_top.sv

#Timer files
project addfile ../../RTL/ahb_peripherals/apb_subsystem/timer/cmsdk_apb_timer.sv

#Uart files
project addfile ../../RTL/ahb_peripherals/apb_subsystem/uart/cmsdk_apb_uart.sv

#Watchdog files
project addfile ../../RTL/ahb_peripherals/apb_subsystem/watchdog/cmsdk_apb_watchdog.sv

#Subsystem extras
project addfile ../../RTL/ahb_peripherals/apb_subsystem/subsystem_top/APB_decoder.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_apb_slave_mux.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_apb_subsystem.sv
project addfile ../../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_irq_sync.sv

################################################################
#testbench
project addfile ../../Testbench/subsystem/subsystem_tb.sv
################################################################














