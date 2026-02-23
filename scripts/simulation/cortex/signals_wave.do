quit -sim
vsim cortex_tb -voptargs=+acc
#
add wave cortex_tb/DUT/SYS_FCLK
add wave cortex_tb/DUT/HCLK
add wave cortex_tb/DUT/HRESETn 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HSELM7         
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HADDRM7        
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HTRANSM7       
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HWRITEM7       
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HSIZEM7        
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HBURSTM7       
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HPROTM7        
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HWDATAM7       
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HRDATAM7       
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HMASTLOCKM7    
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HREADYMUXM7    
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HREADYOUTM7    
add wave cortex_tb/DUT/dma_included/dma_and_wifi/HRESPM7	
add wave cortex_tb/DUT/rx_irq_wifi
add wave cortex_tb/DUT/tx_irq_wifi 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/DMA_WRITE_REQ 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/DMA_WRITE_ACK 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/DMA_READ_REQ 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/DMA_READ_ACK
#
add wave -divider RCC
#
add wave cortex_tb/DUT/RCC_instance/SYS_FCLK
add wave cortex_tb/DUT/RCC_instance/HCLK      
add wave cortex_tb/DUT/RCC_instance/clk_100_MHz
add wave cortex_tb/DUT/RCC_instance/clk_50_MHz
add wave cortex_tb/DUT/RCC_instance/clk_20_MHz_WIFI	
#
add wave -divider WIFI_AHB
#
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/AHB_Slave_inist/*
#
add wave -divider WIFI_SLICER
#
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/data_slicing_inist/*
#
add wave -divider WIFI_SHARED_MEM
#
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/shared_memory/*
#
add wave -divider WIFI_TX
#
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/data_in 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/valid_in
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/valid_out
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/data_out_re
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/data_out_im
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/finish_scr
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/start_read
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/done
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/Tx_irq
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/en_Tx_irq 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/clear_Tx_irq 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/enable_chain
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/tx/clear_tx
#
add wave -divider WIFI_RX
#
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/valid_in
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/data_in_re
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/data_in_im
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/en_Rx_irq 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/clear_Rx_irq 
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/rx_irq
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/data_out
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/valid_out
add wave cortex_tb/DUT/dma_included/dma_and_wifi/phy_wifi_instance/top_wifi/top/rx/clear_rx
#bluetooth
view -new wave
#
add wave -divider BLE
#
add wave cortex_tb/DUT/phy_ble_instance/tx_dma_req 
add wave cortex_tb/DUT/phy_ble_instance/tx_dma_ack 
add wave cortex_tb/DUT/phy_ble_instance/rx_dma_req 
add wave cortex_tb/DUT/phy_ble_instance/dma_mode 
add wave cortex_tb/DUT/phy_ble_instance/dma_ack 
add wave cortex_tb/DUT/phy_ble_instance/clk_6945_KHz 
add wave cortex_tb/DUT/phy_ble_instance/clk_3472_KHz
#
add wave -divider BLE_AHB
#
add wave cortex_tb/DUT/phy_ble_instance/AHB_Slave_inst/*
#
add wave -divider BLE_SLICER
#
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/data_slicer_inst/*
#
add wave -divider BLE_SHARED_MEM
#
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/shared_mem/*
#
add wave -divider BLE_TX
#
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/valid_out 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/valid_in 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/tx_irq_en 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/tx_irq_clear 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/tx_irq 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/data_out_re 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/data_out_im 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/data_in 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/tx/clk
#
add wave -divider BLE_RX
#
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/valid_out 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/valid_in 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/rx_irq 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/rx_dma_req_flag 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/rx_dma_req 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/dma_mode 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/data_out 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/data_in_re 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/data_in_im 
add wave cortex_tb/DUT/phy_ble_instance/tx_rx_bt_inst/txrx/rx/clk
#
view -new wave
#
add wave -divider UART1
#
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART1/RTS 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART1/DMA_RX_REQ 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART1/DMA_RX_DONE 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART1/DMA_RX_ACK
#
add wave -divider U1_RX_FIFO
#
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART1/RX_FIFO/mem
#
add wave -divider UART0
#
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART0/DMA_TX_REQ 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART0/DMA_TX_DONE 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART0/DMA_TX_ACK 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART0/CTS
#
add wave -divider U0_TX_FIFO
#
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/UART0/TX_FIFO/mem
#
add wave -divider SPI
#
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/WRITE_ACK 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/TXINT 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/TX_FIFO_SEL_CMD 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/TDR 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/SS 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/SEL_CMD 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/S_SCK 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/S_MOSI 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/S_MISO 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/RXINT 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/RX_REG 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/RX_FIFO_SEL_CMD 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/READ_ACK 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/RDR 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/PWRITE 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/PWDATA 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/PSEL 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/PREADY 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/PRDATA 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/PENABLE 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/PCLK 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/PADDR 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/FIFO_SEL_DATA 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/DMA_WRITE_REQ 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/DMA_WRITE_DONE 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/DMA_WRITE_ACK 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/DMA_READ_REQ 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/DMA_READ_DONE 
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/DMA_READ_ACK
#
add wave -divider SPI_FIFO_TX
#
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/FIFO_TX/mem
#
add wave -divider SPI_FIFO_RX
#
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/SPI_INCLUDED/SPI/FIFO_RX/mem
#
add wave -divider DMA
#
add wave cortex_tb/DUT/dma_included/DMA_instance/clk_i 
add wave cortex_tb/DUT/dma_included/DMA_instance/rst_i
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HADDR 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HWDATA 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HRDATA 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HWRITE 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HSIZE 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HBURST 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HPROT 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HTRANS 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HREADY 
add wave cortex_tb/DUT/dma_included/DMA_instance/m0HRESP
#
add wave -divider DMA_CH0
#
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/pointer 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/pointer_s 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_txsz 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_adr0 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_adr1 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_am0 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_am1 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_INTEN 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_csr_CTRL 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_csr_REQ 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_csr_INTCLEAR 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_txsz_update 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_adr0_update 
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[0]/channel_rf/ch_adr1_update
#
add wave -divider DMA_CH1
#
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/pointer
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/pointer_s
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_txsz
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_adr0
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_adr1
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_am0
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_am1
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_INTEN
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_csr_CTRL
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_csr_REQ
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_csr_INTCLEAR
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_txsz_update
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_adr0_update
add wave cortex_tb/DUT/dma_included/DMA_instance/REG_FILE/genblk1[1]/channel_rf/ch_adr1_update
#
add wave -divider DMA_ENGINE
#
add wave cortex_tb/DUT/dma_included/DMA_instance/DMA_ENGINE/state 
add wave cortex_tb/DUT/dma_included/DMA_instance/DMA_ENGINE/next_state
add wave cortex_tb/DUT/dma_included/DMA_instance/DMA_ENGINE/MEM/Address 
add wave cortex_tb/DUT/dma_included/DMA_instance/DMA_ENGINE/MEM/Memory
add wave cortex_tb/DUT/dma_included/DMA_instance/DMA_ENGINE/burst_counter 
add wave cortex_tb/DUT/dma_included/DMA_instance/DMA_ENGINE/burst
add wave cortex_tb/DUT/dma_included/DMA_instance/CHANNEL_SELECT/ch_sel
add wave cortex_tb/DUT/dma_included/DMA_instance/CHANNEL_SELECT/req_i
add wave cortex_tb/DUT/dma_included/DMA_instance/dma_req_i 
add wave cortex_tb/DUT/dma_included/DMA_instance/dma_ack_o 
add wave cortex_tb/DUT/dma_included/DMA_instance/ack_for_req
add wave cortex_tb/DUT/dma_included/DMA_instance/ch_done_all_transfer
#
add wave -divider AFIFO
#
add wave cortex_tb/DUT/cmsdk_apb_subsystem_instance/ASYNC_FIFO_DONE/*
#
run -all