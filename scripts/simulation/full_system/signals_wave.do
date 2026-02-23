quit -sim
vsim full_system_tb glbl -voptargs=+acc -suppress 2718
#
add wave full_system_tb/DUT/SYS_1/SYS_FCLK
add wave full_system_tb/DUT/SYS_1/HCLK
add wave full_system_tb/DUT/SYS_1/HRESETn 
#
add wave -divider RCC
#
add wave full_system_tb/DUT/SYS_1/RCC_instance/SYS_FCLK
add wave full_system_tb/DUT/SYS_1/RCC_instance/HCLK      
add wave full_system_tb/DUT/SYS_1/RCC_instance/clk_100_MHz
add wave full_system_tb/DUT/SYS_1/RCC_instance/clk_50_MHz
add wave full_system_tb/DUT/SYS_1/RCC_instance/clk_20_MHz_WIFI	
#
#bluetooth
#
add wave -divider BLE_TOP
#
add wave full_system_tb/DUT/SYS_1/phy_ble_instance/*
#
add wave -divider BLE_AHB
#
add wave full_system_tb/DUT/SYS_1/phy_ble_instance/AHB_Slave_inst/*
#
add wave -divider BLE_SLICER
#
add wave full_system_tb/DUT/SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/data_slicer_inst/*
#
add wave -divider BLE_SHARED_MEM
#
add wave full_system_tb/DUT/SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/*
#
add wave -divider BLE_TX
#
add wave full_system_tb/DUT/SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/tx/*
#
add wave -divider BLE_RX
#
add wave full_system_tb/DUT/SYS_1/phy_ble_instance/tx_rx_bt_inst/txrx/rx/*
#
#
add wave -divider UART1
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/UART1/*
#
add wave -divider U1_RX_FIFO
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/UART1/RX_FIFO/mem
#
add wave -divider UART0
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/UART0/*
#
add wave -divider U0_TX_FIFO
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/UART0/TX_FIFO/mem
#
add wave -divider SPI
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/*
#
add wave -divider SPI_FIFO_TX
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/FIFO_TX/mem
#
add wave -divider SPI_FIFO_RX
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/FIFO_RX/mem
#
add wave -divider DMA
#
add wave full_system_tb/DUT/SYS_1/dma_included/HADDRS1 
add wave full_system_tb/DUT/SYS_1/dma_included/HWDATAS1 
add wave full_system_tb/DUT/SYS_1/dma_included/HWRITES1 
add wave full_system_tb/DUT/SYS_1/dma_included/HSIZES1
add wave full_system_tb/DUT/SYS_1/dma_included/HBURSTS1 
add wave full_system_tb/DUT/SYS_1/dma_included/HPROTS1
add wave full_system_tb/DUT/SYS_1/dma_included/HTRANSS1 
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/m0HRDATA 
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/m0HREADY 
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/m0HRESP
#
add wave -divider DMA_CH0
#
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/*
#
add wave -divider DMA_CH1
#
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/*
add wave -divider DMA_ENGINE
#
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/DMA_ENGINE/*
#
add wave -divider DMA_MEMORY
#
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/DMA_ENGINE/memory/*
#
add wave -divider DMA_not_engine
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/CHANNEL_SELECT/ch_sel
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/CHANNEL_SELECT/req_i
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/dma_req_i 
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/dma_ack_o 
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/ack_for_req
add wave full_system_tb/DUT/SYS_1/dma_included/DMA_instance/ch_done_all_transfer
###################################################
view -new wave
#
add wave full_system_tb/DUT/SYS_2/SYS_FCLK
add wave full_system_tb/DUT/SYS_2/HCLK
add wave full_system_tb/DUT/SYS_2/HRESETn 
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HSELM7         
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HADDRM7        
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HTRANSM7       
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HWRITEM7       
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HSIZEM7        
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HBURSTM7       
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HPROTM7        
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HWDATAM7       
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HRDATAM7       
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HMASTLOCKM7    
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HREADYMUXM7    
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HREADYOUTM7    
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/HRESPM7	
add wave full_system_tb/DUT/SYS_2/rx_irq_wifi
add wave full_system_tb/DUT/SYS_2/tx_irq_wifi 
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/DMA_WRITE_REQ 
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/DMA_WRITE_ACK 
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/DMA_READ_REQ 
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/DMA_READ_ACK
#
add wave -divider RCC
#
add wave full_system_tb/DUT/SYS_2/RCC_instance/SYS_FCLK
add wave full_system_tb/DUT/SYS_2/RCC_instance/HCLK      
add wave full_system_tb/DUT/SYS_2/RCC_instance/clk_100_MHz
add wave full_system_tb/DUT/SYS_2/RCC_instance/clk_50_MHz
add wave full_system_tb/DUT/SYS_2/RCC_instance/clk_20_MHz_WIFI	
#
add wave -divider WIFI_AHB
#
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/AHB_Slave_inist/*
#
add wave -divider WIFI_SLICER
#
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/WIFI_TOP/data_slicing_inist/*
#
add wave -divider WIFI_SHARED_MEM
#
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/WIFI_TOP/shared_memory/*
#
add wave -divider WIFI_FIFO_TOP
#
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/WIFI_TOP/shared_memory/async_fifo_top/*
#
add wave -divider WIFI_FIFO_WRITE_POINTER
#
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/WIFI_TOP/shared_memory/async_fifo_top/FIFO_Write_Pointer_F1/*
#
#
add wave -divider WIFI_FIFO_READ_POINTER
#
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/WIFI_TOP/shared_memory/async_fifo_top/FIFO_R_Pointer_F2/*
#
add wave -divider WIFI_TX
#
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/WIFI_TOP/tx/*
#
add wave -divider WIFI_RX
#
add wave full_system_tb/DUT/SYS_2/dma_included/dma_and_wifi/phy_wifi_instance/WIFI_TOP/rx/*
#bluetooth
#
add wave -divider BLE_TOP
#
add wave full_system_tb/DUT/SYS_2/phy_ble_instance/*
#
add wave -divider BLE_AHB
#
add wave full_system_tb/DUT/SYS_2/phy_ble_instance/AHB_Slave_inst/*
#
add wave -divider BLE_SLICER
#
add wave full_system_tb/DUT/SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/data_slicer_inst/*
#
add wave -divider BLE_SHARED_MEM
#
add wave full_system_tb/DUT/SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/*
#
add wave -divider BLE_TX
#
add wave full_system_tb/DUT/SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/tx/*
#
add wave -divider BLE_RX
#
add wave full_system_tb/DUT/SYS_2/phy_ble_instance/tx_rx_bt_inst/txrx/rx/*
#
#
add wave -divider UART1
#
add wave full_system_tb/DUT/SYS_2/cmsdk_apb_subsystem_instance/UART1/*
#
add wave -divider U1_RX_FIFO
#
add wave full_system_tb/DUT/SYS_2/cmsdk_apb_subsystem_instance/UART1/RX_FIFO/mem
#
add wave -divider UART0
#
add wave full_system_tb/DUT/SYS_2/cmsdk_apb_subsystem_instance/UART0/*
#
add wave -divider U0_TX_FIFO
#
add wave full_system_tb/DUT/SYS_2/cmsdk_apb_subsystem_instance/UART0/TX_FIFO/mem
#
add wave -divider SPI
#
add wave full_system_tb/DUT/SYS_2/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/*
#
add wave -divider SPI_FIFO_TX
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/FIFO_TX/mem
#
add wave -divider SPI_FIFO_RX
#
add wave full_system_tb/DUT/SYS_1/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/FIFO_RX/mem
#
add wave -divider DMA
#
add wave full_system_tb/DUT/SYS_2/dma_included/HADDRS1
add wave full_system_tb/DUT/SYS_2/dma_included/HWDATAS1 
add wave full_system_tb/DUT/SYS_2/dma_included/HWRITES1 
add wave full_system_tb/DUT/SYS_2/dma_included/HSIZES1
add wave full_system_tb/DUT/SYS_2/dma_included/HBURSTS1 
add wave full_system_tb/DUT/SYS_2/dma_included/HPROTS1
add wave full_system_tb/DUT/SYS_2/dma_included/HTRANSS1 
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/m0HRDATA 
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/m0HREADY 
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/m0HRESP
#
add wave -divider DMA_CH0
#
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/*
#
add wave -divider DMA_CH1
#
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/*
#
add wave -divider DMA_ENGINE
#
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/DMA_ENGINE/*
#
add wave -divider DMA_MEMORY
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/DMA_ENGINE/memory/*
#
#
add wave -divider DMA_not_engine
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/CHANNEL_SELECT/ch_sel
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/CHANNEL_SELECT/req_i
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/dma_req_i 
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/dma_ack_o 
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/ack_for_req
add wave full_system_tb/DUT/SYS_2/dma_included/DMA_instance/ch_done_all_transfer
#
#
run -all