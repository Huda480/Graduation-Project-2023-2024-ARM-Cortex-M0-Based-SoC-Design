#Add project files
do ../../scripts/simulation/bridge/add_files.do

#Create new library
vlib ../../sim_scratch/bridge/bridge_rtl

#Mapping library
vmap work ../../sim_scratch/bridge/bridge_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/bridge/transcript -suppress 2263  -work ../../sim_scratch/bridge/bridge_rtl -F ../../scripts/simulation/bridge/compile_list.f
