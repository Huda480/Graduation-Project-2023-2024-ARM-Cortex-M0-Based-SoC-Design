#Add project files
do ../../scripts/simulation/dual_timer/add_files.do

#Create new library
vlib ../../sim_scratch/dual_timer/dual_timer_rtl

#Mapping library
vmap work ../../sim_scratch/dual_timer/dual_timer_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/dual_timer/transcript -suppress 2263  -work ../../sim_scratch/dual_timer/dual_timer_rtl -F ../../scripts/simulation/dual_timer/compile_list.f
