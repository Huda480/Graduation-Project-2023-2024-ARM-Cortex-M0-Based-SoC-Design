#Include unisim library
vlib unisim 
vmap unisim ../../unisim

#Add project files
do ../../scripts/simulation/cortex/add_files.do

#Create new library
vlib ../../sim_scratch/cortex/cortex_rtl

#Mapping library
vmap work ../../sim_scratch/cortex/cortex_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
# Note: this command may not work as expected.
# If it fails, compile manually using your simulation tool.
vlog -vopt +acc -libmap unisim -l ../../sim_scratch/cortex/transcript -suppress 2263  -work ../../sim_scratch/cortex/cortex_rtl -F ../../scripts/simulation/cortex/compile_list.f
