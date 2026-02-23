#Add project files
do ../../scripts/simulation/gpio/add_files.do

#Create new library
vlib ../../sim_scratch/gpio/gpio_rtl

#Mapping library
vmap work ../../sim_scratch/gpio/gpio_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../../sim_scratch/gpio/transcript -suppress 2263  -work ../../sim_scratch/gpio/gpio_rtl -F ../../scripts/simulation/gpio/compile_list.f
