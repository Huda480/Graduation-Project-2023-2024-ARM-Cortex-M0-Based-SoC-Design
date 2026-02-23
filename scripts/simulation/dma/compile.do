#Add project files
do ../../scripts/simulation/dma/add_files.do

#Create new library
vlib ../../sim_scratch/dma/dma_rtl

#Mapping library
vmap work ../../sim_scratch/dma/dma_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/dma/transcript -suppress 2263  -work ../../sim_scratch/dma/dma_rtl -F ../../scripts/simulation/dma/compile_list.f  +define+SIMULATION  
