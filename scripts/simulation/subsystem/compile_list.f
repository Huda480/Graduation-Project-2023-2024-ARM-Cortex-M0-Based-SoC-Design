#Compilation list

+incdir+../../RTL/ahb_peripherals/apb_subsystem/watchdog
+incdir+../../RTL/ahb_peripherals/apb_subsystem/dual_timer

################################################################
#APB_SUBSYTEM

#Bridge files
../../RTL/ahb_peripherals/apb_subsystem/bridge/APB_Bridge.sv

#shared files
../../RTL/ahb_peripherals/apb_subsystem/general/apb_pkg.sv
../../RTL/ahb_peripherals/apb_subsystem/general/FIFO.sv

#Dual timer files
../../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers_frc.sv
../../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers.sv

#SPI files
../../RTL/ahb_peripherals/apb_subsystem/spi/spi_pkg.sv
../../RTL/ahb_peripherals/apb_subsystem/spi/apb_spi_interface.sv
../../RTL/ahb_peripherals/apb_subsystem/spi/spi_master.sv
../../RTL/ahb_peripherals/apb_subsystem/spi/spi_slave.sv
../../RTL/ahb_peripherals/apb_subsystem/spi/spi_top.sv

#Timer files
../../RTL/ahb_peripherals/apb_subsystem/timer/cmsdk_apb_timer.sv

#Uart files
../../RTL/ahb_peripherals/apb_subsystem/uart/cmsdk_apb_uart.sv

#Watchdog files
../../RTL/ahb_peripherals/apb_subsystem/watchdog/cmsdk_apb_watchdog.sv

#Subsystem extras
../../RTL/ahb_peripherals/apb_subsystem/subsystem_top/APB_decoder.sv
../../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_apb_slave_mux.sv
../../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_apb_subsystem.sv
../../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_irq_sync.sv

################################################################
#testbench
../../Testbench/subsystem/subsystem_tb.sv
################################################################
























