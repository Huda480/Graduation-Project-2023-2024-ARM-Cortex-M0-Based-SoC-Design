#Add project files
do ../../scripts/simulation/watchdog/add_files.do

#Create new library
vlib ../../sim_scratch/watchdog/watchdog_rtl

#Mapping library
vmap work ../../sim_scratch/watchdog/watchdog_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/watchdog/transcript -suppress 2263  -work ../../sim_scratch/watchdog/watchdog_rtl -F ../../scripts/simulation/watchdog/compile_list.f
