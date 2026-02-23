#Add project files 
do ../../scripts/simulation/uart/add_files.do

#Create new library
vlib ../../sim_scratch/uart/uart_rtl

#Mapping library
vmap work ../../sim_scratch/uart/uart_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/uart/transcript -suppress 2263  -work ../../sim_scratch/uart/uart_rtl -F ../../scripts/simulation/uart/compile_list.f
