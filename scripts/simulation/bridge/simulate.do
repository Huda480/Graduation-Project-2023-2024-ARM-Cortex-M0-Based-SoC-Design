do ../../scripts/simulation/bridge/Compile.do

vsim -voptargs=+acc bridge_test



add wave -divider AHB_signals
add wave -group AHB bridge_test/DUT/HCLK
add wave -group AHB bridge_test/DUT/HRESETn
add wave -group AHB -color Gold bridge_test/DUT/HSEL            
add wave -group AHB -color Gold bridge_test/DUT/HADDR
add wave -group AHB -color Gold bridge_test/DUT/HWDATA
add wave -group AHB -color Gold bridge_test/DUT/HRDATA
add wave -group AHB -color Gold bridge_test/DUT/HWRITE
add wave -group AHB -color Gold bridge_test/DUT/HSIZE
add wave -group AHB -color Gold bridge_test/DUT/HBURST
add wave -group AHB -color Gold bridge_test/DUT/HPROT
add wave -group AHB -color Gold bridge_test/DUT/HTRANS
add wave -group AHB -color Gold bridge_test/DUT/HMASTLOCK
add wave -group AHB -color Gold bridge_test/DUT/HREADYOUT
add wave -group AHB -color Gold bridge_test/DUT/HREADY
add wave -group AHB -color Gold bridge_test/DUT/HRESP


add wave -divider APB_signals
add wave -group APB bridge_test/DUT/PCLK
add wave -group APB bridge_test/DUT/PRESETn
add wave -group APB -color Magenta bridge_test/DUT/PSEL 
add wave -group APB -color Magenta bridge_test/DUT/PENABLE 
add wave -group APB -color Magenta bridge_test/DUT/PPROT 
add wave -group APB -color Magenta bridge_test/DUT/PWRITE 
add wave -group APB -color Magenta bridge_test/DUT/PSTRB 
add wave -group APB -color Magenta bridge_test/DUT/PADDR 
add wave -group APB -color Magenta bridge_test/DUT/PWDATA 
add wave -group APB -color Magenta bridge_test/DUT/PRDATA 
add wave -group APB -color Magenta bridge_test/DUT/PREADY 
add wave -group APB -color Magenta bridge_test/DUT/PSLVERR

run -all



