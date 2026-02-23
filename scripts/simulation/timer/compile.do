#Add project files
do ../../scripts/simulation/timer/add_files.do

#Create new library
vlib ../../sim_scratch/timer/timer_rtl

#Mapping library
vmap work ../../sim_scratch/timer/timer_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/timer/transcript -suppress 2263  -work ../../sim_scratch/timer/timer_rtl -F ../../scripts/simulation/timer/compile_list.f
