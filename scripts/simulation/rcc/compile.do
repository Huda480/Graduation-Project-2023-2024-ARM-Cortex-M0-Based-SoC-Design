#Add project files
do ../../scripts/simulation/rcc/add_files.do

#Create new library
vlib ../../sim_scratch/rcc/rcc_rtl

#Mapping library
vmap work ../../sim_scratch/rcc/rcc_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/rcc/transcript -suppress 2263  -work ../../sim_scratch/rcc/rcc_rtl -F ../../scripts/simulation/rcc/compile_list.f
