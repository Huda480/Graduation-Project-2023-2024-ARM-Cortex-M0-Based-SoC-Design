do ../../scripts/simulation/dma/Compile.do

vsim -voptargs=+acc dma_test 

add wave -divider clk_reset
add wave  dma_test/DUT/clk_i
add wave  dma_test/DUT/rst_n_i

add wave -divider dma_signals

add wave -group DMA -group DMA_SLAVE -color Gold dma_test/DUT/s0HSEL     
add wave -group DMA -group DMA_SLAVE -color Gold dma_test/DUT/s0HADDR    
add wave -group DMA -group DMA_SLAVE -color Gold dma_test/DUT/s0HWDATA   
add wave -group DMA -group DMA_SLAVE -color Gold dma_test/DUT/s0HRDATA   
add wave -group DMA -group DMA_SLAVE -color Gold dma_test/DUT/s0HWRITE      
add wave -group DMA -group DMA_SLAVE -color Gold dma_test/DUT/s0HREADYOUT
add wave -group DMA -group DMA_SLAVE -color Gold dma_test/DUT/s0HRESP

add wave -group DMA -group DMA_MASTER -color Magenta dma_test/DUT/m0HSEL     
add wave -group DMA -group DMA_MASTER -color Magenta dma_test/DUT/m0HADDR    
add wave -group DMA -group DMA_MASTER -color Magenta dma_test/DUT/m0HWDATA   
add wave -group DMA -group DMA_MASTER -color Magenta dma_test/DUT/m0HRDATA   
add wave -group DMA -group DMA_MASTER -color Magenta dma_test/DUT/m0HWRITE        
add wave -group DMA -group DMA_MASTER -color Magenta dma_test/DUT/m0HTRANS   
add wave -group DMA -group DMA_MASTER -color Magenta dma_test/DUT/m0HRESP 

add wave -group DMA dma_test/DUT/dma_req_i 
add wave -group DMA dma_test/DUT/dma_nd_i  
add wave -group DMA dma_test/DUT/dma_ack_o 
add wave -group DMA dma_test/DUT/dma_rest_i
add wave -group DMA dma_test/DUT/irqa_o    
add wave -group DMA dma_test/DUT/irqb_o     


add wave -group DMA -group DMA_CONFIG -color pink dma_test/DUT/wb_dma0/u0/csr


add wave -group DMA -group CH0 -color Cyan dma_test/DUT/wb_dma0/u0/ch0_csr
add wave -group DMA -group CH0 -color Cyan dma_test/DUT/wb_dma0/u0/ch0_txsz
add wave -group DMA -group CH0 -color Cyan dma_test/DUT/wb_dma0/u0/ch0_adr0
add wave -group DMA -group CH0 -color Cyan dma_test/DUT/wb_dma0/u0/ch0_adr1


add wave -divider dsram_signals



add wave -group DSRAM -color yellowgreen dma_test/DATA_SRAM_TOP_instance/HSEL     
add wave -group DSRAM -color yellowgreen dma_test/DATA_SRAM_TOP_instance/HTRANS   
add wave -group DSRAM -color yellowgreen dma_test/DATA_SRAM_TOP_instance/HWRITE   
add wave -group DSRAM -color yellowgreen dma_test/DATA_SRAM_TOP_instance/HADDR    
add wave -group DSRAM -color yellowgreen dma_test/DATA_SRAM_TOP_instance/HWDATA   
add wave -group DSRAM -color yellowgreen dma_test/DATA_SRAM_TOP_instance/HRDATA   
add wave -group DSRAM -color yellowgreen dma_test/DATA_SRAM_TOP_instance/HREADYOUT

run -all



