create_generated_clock -name SCK_SYS1 -source [get_pins SYS_1/RCC_instance/el3b_f_elclk/PCLK] -divide_by 2 [get_pins SYS_1/cmsdk_apb_subsystem_instance/SPI_INCLUDED.SPI/SPI/SPI_MASTER/SCK_reg/Q]

create_generated_clock -name SCK_SYS2 -source [get_pins SYS_2/RCC_instance/el3b_f_elclk/PCLK] -divide_by 2 [get_pins SYS_2/cmsdk_apb_subsystem_instance/SPI_INCLUDED.SPI/SPI/SPI_MASTER/SCK_reg/Q]