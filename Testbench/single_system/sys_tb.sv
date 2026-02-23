`timescale 1ns/1ps
module sys_tb ();
                                        

	parameter int  RE_IM_SIZE_BLE = 12;

	logic 					SYS_FCLK;
  logic 					RESETn;
	logic 					phy_ble_clk;
	//UART
	logic					RXD0;
 	logic					RXD1;
 	logic					TXD0;
  logic					TXD1;
	logic					RTS0;
	logic					RTS1;
  logic					CTS0;
	logic					CTS1;
	logic			 		EXTIN;
  //SPI
	logic					M_SCK;
	logic					M_MOSI;
	logic					M_MISO;
	logic					S_MISO;
  logic					S_MOSI;
	logic					SS;
	logic					S_SCK;
  logic					SS0;
	logic					SS1;
	logic					SS2;
	logic					SS3;
	//GPIO
	wire  [16-1:0]  PORTIN;
	wire [16-1:0]	PORTOUT;

  //DATA FROM OTHER SYSTEM TO RX
  logic 						valid_in_mem_re_ble;
  logic [RE_IM_SIZE_BLE-1:0] 	data_in_re_to_rx_ble;
  logic					    valid_in_mem_im_ble;
  logic [RE_IM_SIZE_BLE-1:0] 	data_in_im_to_rx_ble;
  
  //DATA TO OTHER SYSTEM
  logic 						valid_out_mem_re_ble;
  logic [RE_IM_SIZE_BLE-1:0] data_out_re_to_rx_ble;
  logic 						valid_out_mem_im_ble;
  logic [RE_IM_SIZE_BLE-1:0] data_out_im_to_rx_ble;


localparam clk_period     = 10 ; //20
localparam pclk			      = 10*2 ; //20*2 
//phy clk
localparam phy_clk_period = 18 ;
localparam wifi_clk_period = 5 ;


reg first_valid_out;

SYSTEM_TOP DUT (.*);

  integer ifile1,ofile11,ofile12,ofile13,ofile14,ofile15,ofile16,ofile17,ofile18,ofile19,ofile31,ofile32,ofile33,ofile34,ofile34_1,ofile34_2,ofile35,ofile36,ofile37,ofile38,ofile39;
	integer ifile2,ofile21,ofile22,ofile23,ofile24,ofile25,ofile26,ofile27,ofile28,ofile29,ofile41,ofile42,ofile43,ofile44,ofile44_1,ofile44_2,ofile45,ofile46,ofile47,ofile48,ofile49;
	integer output_file,ofileout;


  integer i;
/*
assign  SYSTEM_OUT[10] = RXD1 ;
assign  SYSTEM_OUT[12] = CTS0 ;
*/
task receive ;
  input  [9:0] data ;
  integer i;
  begin
    for (i = 0 ; i < 10 ; i = i+1)
    begin
      RXD1 = data[i] ;
      repeat(32)
      #(pclk);
    end
  end
endtask

task uart_test;
  begin
    //UART_Transmit (
    receive({1'b1, 8'h55, 1'b0}); 
    receive({1'b1, 8'h41, 1'b0}); 
    receive({1'b1, 8'h52, 1'b0}); 
    receive({1'b1, 8'h54, 1'b0}); 
    receive({1'b1, 8'h28, 1'b0});
    /*receive({1'b1, 8'h4E, 1'b0}); 
    receive({1'b1, 8'h61, 1'b0}); 
    receive({1'b1, 8'h64, 1'b0}); 
    receive({1'b1, 8'h65, 1'b0}); 
    receive({1'b1, 8'h65, 1'b0}); 
    receive({1'b1, 8'h6E, 1'b0}); */
    receive({1'b1, 8'h4B, 1'b0}); 
    receive({1'b1, 8'h61, 1'b0}); 
    receive({1'b1, 8'h72, 1'b0}); 
    receive({1'b1, 8'h65, 1'b0}); 
    receive({1'b1, 8'h65, 1'b0});
    receive({1'b1, 8'h6D, 1'b0});

    receive({1'b1, 8'h29, 1'b0}); 

    receive({1'b1, 8'h00, 1'b0});
  end
endtask

task spi_test;
  begin
    //UART_Transmit (
    receive({1'b1, 8'h53, 1'b0}); 
    receive({1'b1, 8'h50, 1'b0}); 
    receive({1'b1, 8'h49, 1'b0});  
    
    receive({1'b1, 8'h28, 1'b0});

    //Hello
    /*receive({1'b1, 8'h48, 1'b0}); 
    receive({1'b1, 8'h65, 1'b0}); 
    receive({1'b1, 8'h6C, 1'b0}); 
    receive({1'b1, 8'h6C, 1'b0}); 
    receive({1'b1, 8'h6F, 1'b0});*/
    receive({1'b1, 8'h4B, 1'b0}); 
    receive({1'b1, 8'h61, 1'b0}); 
    receive({1'b1, 8'h72, 1'b0}); 
    receive({1'b1, 8'h65, 1'b0}); 
    receive({1'b1, 8'h65, 1'b0});
    receive({1'b1, 8'h6D, 1'b0});

    //)
    receive({1'b1, 8'h29, 1'b0});
    receive({1'b1, 8'h00, 1'b0});
  end
endtask

task gpio_test;
  begin
    //UART_Transmit (
    //receive({1'b1, 8'h53, 1'b0}); 
    receive({1'b1, 8'h47, 1'b0}); 
    receive({1'b1, 8'h50, 1'b0});
    receive({1'b1, 8'h49, 1'b0}); 
    receive({1'b1, 8'h4F, 1'b0}); 
    
    receive({1'b1, 8'h28, 1'b0});

    //5A
    receive({1'b1, 8'h5A, 1'b0}); 

    //)
    receive({1'b1, 8'h29, 1'b0});
    receive({1'b1, 8'h00, 1'b0});
  end
endtask

/*

//Clock generation
initial begin
  HCLK =   0;
  forever begin
    #(clk_period/2) HCLK = !HCLK;
  end
end

*/

//Phy Clock generation
initial begin
  phy_ble_clk =   0;
  forever begin
    #(phy_clk_period/2) phy_ble_clk = !phy_ble_clk ;
  end
end

initial begin
  SYS_FCLK =   0;
  forever begin
    #(wifi_clk_period/2.0) SYS_FCLK = !SYS_FCLK ;
  end
end

initial begin

  //ifile1      <= $fopen("inputfile1_x.txt","w");
  //ofile18 		<= $fopen("outputfile18_hdlModel.txt","w");

  first_valid_out = 0;

  RESETn = 0;
  EXTIN = 1;
  #100;
  RESETn = 1;
  #20_000_000;
  $stop;

end

/*
always @ (posedge DUT.dma_included.dma_and_wifi.phy_wifi_instance.clk_20_MHz_WIFI)
	begin
		if (DUT.dma_included.dma_and_wifi.phy_wifi_instance.top_wifi.top.tx.top_ofdm.valid_out ==1 )  $fwrite(ofile18,"%b\n",DUT.dma_included.dma_and_wifi.phy_wifi_instance.top_wifi.top.tx.top_ofdm.data_out_im);
	//	if (DUT.phy_wifi_instance.top_wifi.top.tx.top_ofdm.valid_out ==1 ) $fwrite(ofile28,"%b\n",DUT.phy_wifi_instance.top_wifi.top.tx.top_ofdm.data_out_im);
	//	if (DUT.phy_wifi_instance.top_wifi.valid_out ==1) $fwrite(ofileout,"%b\n",DUT.phy_wifi_instance.top_wifi.data_out);
	end



  always @ (posedge DUT.dma_included.dma_and_wifi.phy_wifi_instance.clk_50_MHz)
    begin
        if (DUT.dma_included.dma_and_wifi.phy_wifi_instance.top_wifi.top.start_read==1)  
          $fwrite(ifile1,"%b\n",DUT.dma_included.dma_and_wifi.phy_wifi_instance.top_wifi.top.data_in);

        end



	always @(posedge DUT.dma_included.dma_and_wifi.phy_wifi_instance.clk_20_MHz_WIFI)
	begin
		if(DUT.dma_included.dma_and_wifi.phy_wifi_instance.top_wifi.top.valid_out == 1 && first_valid_out == 0)	
    first_valid_out = 1; 
		if(first_valid_out == 1 && DUT.dma_included.dma_and_wifi.phy_wifi_instance.top_wifi.top.valid_out == 0)	
		begin
      $fclose(ofile18);
      $fclose(ifile1);
    end
  end
     */        
endmodule  
