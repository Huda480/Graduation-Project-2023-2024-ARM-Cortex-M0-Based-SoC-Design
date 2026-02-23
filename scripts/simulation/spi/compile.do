#Add project files
do ../../scripts/simulation/spi/add_files.do

#Create new library
vlib ../../sim_scratch/spi/spi_rtl

#Mapping library
vmap work ../../sim_scratch/spi/spi_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/spi/transcript -suppress 2263  -work ../sim_scratch/spi/spi_rtl -F ../../scripts/simulation/spi/compile_list.f
