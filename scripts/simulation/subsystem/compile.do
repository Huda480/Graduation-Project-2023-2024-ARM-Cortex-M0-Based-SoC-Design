#Add project files
do ../../scripts/simulation/subsystem/add_files.do

#Create new library
vlib ../../sim_scratch/subsystem/subsystem_rtl

#Mapping library
vmap work ../../sim_scratch/subsystem/subsystem_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/subsystem/transcript -suppress 2263  -work ../../sim_scratch/subsystem/subsystem_rtl -F ../../scripts/simulation/subsystem/compile_list.f
