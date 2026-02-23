#Include unisim library
# Create and map the UNISIM library
vlib unisim 
vmap unisim ../../unisim

#Add project files
do ../../scripts/simulation/full_system/add_files.do

# Create and map the work library for your RTL
vlib work
vmap work ./work

# Compile RTL sources
# Note: this command may not work as expected.
# If it fails, compile manually using your simulation tool.
vlog -f ../../scripts/simulation/full_system/flist.list

# Run simulation
vsim full_system_tb -voptargs=+acc
