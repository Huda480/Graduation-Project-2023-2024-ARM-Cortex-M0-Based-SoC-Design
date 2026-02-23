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
#AHB system

#Gpio
project addfile ../../RTL/ahb_peripherals/gpio/ahb_pkg.sv
project addfile ../../RTL/ahb_peripherals/gpio/cmsdk_ahb_gpio.sv
project addfile ../../RTL/ahb_peripherals/gpio/cmsdk_ahb_to_iop.sv
project addfile ../../RTL/ahb_peripherals/gpio/cmsdk_iop_gpio.sv

# Compression
project addfile ../../RTL/ahb_peripherals/compression/compression_package.sv
project addfile ../../RTL/ahb_peripherals/compression/segmentation_pkg.sv
project addfile ../../RTL/ahb_peripherals/compression/dct_pkg.sv
project addfile ../../RTL/ahb_peripherals/compression/adaptive_thresholding.sv
project addfile ../../RTL/ahb_peripherals/compression/block_compression.sv
project addfile ../../RTL/ahb_peripherals/compression/clipping.sv
project addfile ../../RTL/ahb_peripherals/compression/compression_deserializer.sv
project addfile ../../RTL/ahb_peripherals/compression/ctrlunit.sv
project addfile ../../RTL/ahb_peripherals/compression/inputaddunit.sv
project addfile ../../RTL/ahb_peripherals/compression/intdct.sv
project addfile ../../RTL/ahb_peripherals/compression/mcm_2d_dct.sv
project addfile ../../RTL/ahb_peripherals/compression/muxN.sv
project addfile ../../RTL/ahb_peripherals/compression/outputaddunit.sv
project addfile ../../RTL/ahb_peripherals/compression/quantizationstage.sv
project addfile ../../RTL/ahb_peripherals/compression/quantize_func.sv
project addfile ../../RTL/ahb_peripherals/compression/segmentation_controller.sv
project addfile ../../RTL/ahb_peripherals/compression/segmentation_memory.sv
project addfile ../../RTL/ahb_peripherals/compression/shiftaddunit.sv
project addfile ../../RTL/ahb_peripherals/compression/transpose_mem.sv
project addfile ../../RTL/ahb_peripherals/compression/segmentation_top.sv
project addfile ../../RTL/ahb_peripherals/compression/Compression_Memory.sv
project addfile ../../RTL/ahb_peripherals/compression/Compression_TOP.sv
project addfile ../../RTL/ahb_peripherals/compression/ahb_to_compressor.sv

#DMA
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_ch_arb.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_ch_pri_enc.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_ch_rf.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_ch_sel.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_inc30r.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_master_if.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_pri_enc_sub.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_rf.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_slv_if.sv
project addfile ../../RTL/ahb_peripherals/dma/ahb_dma_top.sv
project addfile ../../RTL/ahb_peripherals/dma/enginne.sv
project addfile ../../RTL/ahb_peripherals/dma/FIFO_dma.sv
project addfile ../../RTL/ahb_peripherals/dma/grant_arbiter.sv
project addfile ../../RTL/ahb_peripherals/dma/mem_dma.sv
project addfile ../../RTL/ahb_peripherals/dma/mux.sv
project addfile ../../RTL/ahb_peripherals/dma/not_mux.sv
project addfile ../../RTL/ahb_peripherals/dma/or_opt.sv
project addfile ../../RTL/ahb_peripherals/dma/req_arbiter.sv

#Memory
project addfile ../../RTL/ahb_peripherals/memory/cmsdk_ahb_to_sram.sv
project addfile ../../RTL/ahb_peripherals/memory/cmsdk_fpga_sram.sv
project addfile ../../RTL/ahb_peripherals/memory/RAM_TOP.sv

#bluetooth
project addfile ../../RTL/ahb_peripherals/phy_ble/address_decoder.v
project addfile ../../RTL/ahb_peripherals/phy_ble/ASYNC_FIFO_RAM.v
project addfile ../../RTL/ahb_peripherals/phy_ble/bt_wrapper.v
project addfile ../../RTL/ahb_peripherals/phy_ble/clock_mux.v
project addfile ../../RTL/ahb_peripherals/phy_ble/FIFO_RPTR.v
project addfile ../../RTL/ahb_peripherals/phy_ble/FIFO_TOP.v
project addfile ../../RTL/ahb_peripherals/phy_ble/FIFO_WPTR.v
project addfile ../../RTL/ahb_peripherals/phy_ble/inter_ram.v
project addfile ../../RTL/ahb_peripherals/phy_ble/parallel_in_serial_out.v
project addfile ../../RTL/ahb_peripherals/phy_ble/Read_Pointer_Sync.v
project addfile ../../RTL/ahb_peripherals/phy_ble/RegFile.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_demodulator_DQPSK_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_header_decoder_repetition_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_header_dehec_checker_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_header_dehec_top_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_header_dehec_top_controlled_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_header_receiver_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_payload_decoder_hamming_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_payload_decoder_top_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_payload_decrc_checker_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_payload_decrc_top_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_payload_decrc_top_controlled_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_payload_receiver_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/rx_top_rx.v
project addfile ../../RTL/ahb_peripherals/phy_ble/serial_in_parallel_out.v
project addfile ../../RTL/ahb_peripherals/phy_ble/shared_mem_top.v
project addfile ../../RTL/ahb_peripherals/phy_ble/slave.sv
project addfile ../../RTL/ahb_peripherals/phy_ble/slicer.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_crc_fifo.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_finished_generator_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_input_segmentation.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_payload_encoder_concat_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_payload_encoder_segmentation_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_ram_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_top_chain.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_top_chain_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/txrx_whitening_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_header_encoder_repetition_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_header_hec_generator_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_header_hec_top_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_header_hec_top_controlled_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_header_transmitter_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_modulator_DQPSK_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_payload_crc_generator_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_payload_crc_top_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_payload_crc_top_controlled_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_payload_encoder_hamming_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_payload_encoder_top_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_payload_transmitter_bluetooth.v
project addfile ../../RTL/ahb_peripherals/phy_ble/tx_top_tx.v
project addfile ../../RTL/ahb_peripherals/phy_ble/Write_Pointer_Sync.v

#Wifi
project addfile ../../RTL/ahb_peripherals/phy_wifi/ACS.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/ACSUNIT.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/BIT_SYNC.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/BMG.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/clk_distribute.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/clock_mux.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/COMPARATOR.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/control.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/control_depuncture34_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/decoder_fifo.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/demapper_16QamMod_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/demapper_bpskMod_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/demapper_qpskMod_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/descrambler.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/dummy_fifo.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/ENC.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/fft.vhd
project addfile ../../RTL/ahb_peripherals/phy_wifi/fft_controller.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/FIFO_ASYNC_RAM_WIFI.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/fifo_descrambler.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/fifo_fft.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/FIFO_R_Pointer.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/FIFO_Sync_R2W.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/FIFO_Sync_W2R.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/FIFO_TOP_WIFI.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/FIFO_Write_Pointer.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/HARD_DIST_CALC.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/ifft.vhd
project addfile ../../RTL/ahb_peripherals/phy_wifi/METRICMEMORY.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/packet_divider_last_symbol.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/parallel_in_serial_out.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/RAMINTERFACE.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/ram_demap.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/ram_model.vhd
project addfile ../../RTL/ahb_peripherals/phy_wifi/ram_survivor_decoder_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/rom_pilotsGenerator_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/RX_deserializer.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/RX_in_mem.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/rx_top_deinterleaver192_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/rx_top_deinterleaver48_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/rx_top_deinterleaver96_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/rx_top_deinterleaver_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/rx_top_depuncture34_dummy_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/rx_top_depuncturer_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/rx_top_rx_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/shared_mem_top.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/stack_controller.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/stack_demap.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/top_controlled_viterbi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/top_controller.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/top_demap.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/top_demapper_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/top_depuncture34_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/top_descrambler.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/top_pilotsGenerator_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/top_ram_demap.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/traceback_decoder_wifi.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/VITERBIDECODER.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/viterbi_buffer.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_Addr_Decode.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_Data_Slicing.sv
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_IFFT_Controller_16.vhd
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_IFFT_Controller_2.vhd
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_IFFT_Controller_4.vhd
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_Reg_File.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_RX_sipo_16QamMod.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_RX_sipo_qpskMod.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_RX_TOP.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TXRX_interleaver_fifo.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_control_puncture34.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_convolutionHalf.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_dummy_fifo_pun.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_long_preabmle.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_mapper_16QamMod.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_mapper_bpskMod.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_mapper_fifo.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_mapper_qpskMod.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_ptos_convolutionHalf.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_puncturer_fifo.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_scrambler_serializer.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_short_preabmle.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_sipo_16QamMod.vhd
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_sipo_qpskMod.vhd
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_topControlled_bpskMapper.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_topmodule_convolutionHalf.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_convo.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_ifft_controller.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_interleaver.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_interleaver192.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_interleaver48.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_interleaver96.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_mapper.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_ofdm.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_preamble.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_puncture34.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_puncture34controllerd.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_puncture34_dummy.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_puncturer.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_top_Scrambler.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TX_TOP.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/slave.sv
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_TOP.v
project addfile ../../RTL/ahb_peripherals/phy_wifi/WIFI_AHB_TOP.v

#RCC
project addfile ../../RTL/ahb_peripherals/rcc/CLK_DIV.sv
project addfile ../../RTL/ahb_peripherals/rcc/RESET_SYNC.sv
project addfile ../../RTL/ahb_peripherals/rcc/RCC.sv
project addfile ../../RTL/ahb_peripherals/rcc/ahb_to_RCC.sv

################################################################
#Bus matrix

#without DMA and WIFI
project addfile ../../RTL/busmatrix/AHB_BusMatrix_BLE/AHB_Arbiter_BLE.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_BLE/AHB_BusMatrix_BLE.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_BLE/AHB_BusMatrix_BLE_default_slave.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_BLE/AHB_BusMatrix_BLE_lite.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_BLE/AHB_DecoderStage_BLES0.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_BLE/AHB_InputStage_BLE.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_BLE/AHB_OutputStage_BLE.v

project addfile ../../RTL/busmatrix/AHB_BusMatrix_COMP/AHB_Arbiter_COMP.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_COMP/AHB_BusMatrix_COMP.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_COMP/AHB_BusMatrix_COMP_default_slave.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_COMP/AHB_BusMatrix_COMP_lite.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_COMP/AHB_DecoderStage_COMPS0.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_COMP/AHB_InputStage_COMP.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_COMP/AHB_OutputStage_COMP.v

#with DMA and without WIFI
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_BLE/AHB_Arbiter_DMA_BLE.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_BLE/AHB_BusMatrix_DMA_BLE.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_BLE/AHB_BusMatrix_DMA_BLE_default_slave.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_BLE/AHB_BusMatrix_DMA_BLE_lite.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_BLE/AHB_DecoderStage_DMA_BLES0.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_BLE/AHB_DecoderStage_DMA_BLES1.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_BLE/AHB_InputStage_DMA_BLE.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_BLE/AHB_OutputStage_DMA_BLE.v

project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_COM/AHB_Arbiter_DMA_COM.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_COM/AHB_BusMatrix_DMA_COM.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_COM/AHB_BusMatrix_DMA_COM_default_slave.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_COM/AHB_BusMatrix_DMA_COM_lite.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_COM/AHB_DecoderStage_DMA_COMS0.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_COM/AHB_DecoderStage_DMA_COMS1.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_COM/AHB_InputStage_DMA_COM.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_COM/AHB_OutputStage_DMA_COM.v

#with DMA and WIFI
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_PHY/AHB_Arbiter_DMA_PHY.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_PHY/AHB_BusMatrix_DMA_PHY.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_PHY/AHB_BusMatrix_DMA_PHY_default_slave.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_PHY/AHB_BusMatrix_DMA_PHY_lite.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_PHY/AHB_DecoderStage_DMA_PHYS0.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_PHY/AHB_DecoderStage_DMA_PHYS1.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_PHY/AHB_InputStage_DMA_PHY.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_DMA_PHY/AHB_OutputStage_DMA_PHY.v

#with WIFI and without DMA 
project addfile ../../RTL/busmatrix/AHB_BusMatrix_PHY/AHB_Arbiter_PHY.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_PHY/AHB_BusMatrix_PHY.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_PHY/AHB_BusMatrix_PHY_default_slave.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_PHY/AHB_BusMatrix_PHY_lite.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_PHY/AHB_DecoderStage_PHYS0.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_PHY/AHB_InputStage_PHY.v
project addfile ../../RTL/busmatrix/AHB_BusMatrix_PHY/AHB_OutputStage_PHY.v

################################################################
#Cortex

project addfile ../../RTL/cortex/cortexm0ds_logic.v
project addfile ../../RTL/cortex/CORTEXM0INTEGRATION.v

################################################################
#Top module
project addfile ../../RTL/top/SYSTEM_TOP.sv

################################################################
#Full system
project addfile ../../RTL/FULL_SYSTEM/full_system.sv

################################################################
#Full system testbench
project addfile ../../Testbench/full_system/full_system_tb.sv
