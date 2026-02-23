/*
=========================================================================================
				Standard :	WIFI
				Block name :	Testbench
=========================================================================================
		MCS1 : encoder 1/2 + no puncturing + interleaver 48 + bpsk mapper
		MCS2 : encoder 1/2 + puncturer 3/4 + interleaver 48 + bpsk mapper
		MCS3 : encoder 1/2 + no puncturing + interleaver 96 + qpsk mapper
		MCS4 : encoder 1/2 + puncturer 3/4 + interleaver 96 + qpsk mapper
		MCS5 : encoder 1/2 + no puncturing + interleaver 192 + 16qam mapper
		MCS6 : encoder 1/2 + puncturer 3/4 + interleaver 192 + 16qam mapper
		MCS7 : encoder 1/3 + no puncturing + interleaver 288 + 64qam mapper
		MCS8 : encoder 1/3 + puncturer 2/3 + interleaver 288 + 64qam mapper
				MCS7 & MCS8 are not implemented
*/
//=======================================================================================
`define MCS3
`ifdef MCS1
	`define rate1		11
	`define rate2		11
	`define length1		100
	`define length2		850
	`define pads1		18
	`define pads2		18
`elsif MCS2
	`define rate1		15
	`define rate2		15
	`define length1		444
	`define length2		534
	`define pads1		26
	`define pads2		26
`elsif MCS3
	`define rate1		5
	`define rate2		5
	`define length1		500
	`define length2		850
	`define pads1		10
	`define pads2		42
`elsif MCS4
	`define rate1		7
	`define rate2		7
	`define length1		444
	`define length2		534
	`define pads1		26
	`define pads2		26
`elsif MCS5
	`define rate1		9
	`define rate2		9
	`define length1		594
	`define length2		834
	`define pads1		26
	`define pads2		26
`elsif MCS6
	`define rate1		11
	`define rate2		11
	`define length1		894
	`define length2		1254
	`define pads1		26
	`define pads2		26
`endif
`timescale 1ns/1ps
//=======================================================================================
module tb_wifi  #(parameter PUNCTURER=0, INTERLEAVER=96 , MAPPER=4)();
	//===============================================================================	
	reg clk;
    reg reset;
   // reg mode; // will be edited and taken from configuraion register
    reg HWRITE;
    reg HREADY; 
    reg HSEL;
    reg [31:0] HADDR; 
    reg [31:0]  HWDATA;
    reg [1:0] HTRANS;
    reg [2:0] HBURST; 
    reg [2:0] HSIZE;
    wire [31:0] HRDATA;
    wire  HRESP;
    wire HREADYOUT;
    wire rx_irq,Tx_irq;

	//===============================================================================	
	parameter [3:0] rate1 		= `rate1;
	parameter [3:0] rate2 		= `rate2;
	parameter [11:0] length1 	= `length1;
	parameter [11:0] length2 	= `length2;
	parameter [15:0] pads1 		= `pads1;
	parameter [15:0] pads2 		= `pads2;
	parameter [14:0] PSDU1 		= length1 * 8;
	parameter [14:0] PSDU2 		= length2 * 8;
	parameter reserved		= 0;
	parameter N 			= 64; 
	parameter index_width 		= $clog2(N);
	parameter scaling_width 	= 6;
	parameter fraction_width 	= 9;
	parameter full_width 		= 12;
	//===============================================================================	
	reg [11:0] hrdata_im;
	reg [11:0] hrdata_re;
	reg [31:0] wifi_hrdata;
	reg first_valid_out;
	reg second_valid_out;
	reg[full_width - fraction_width - 1 : 0] int_real,int_img;
	reg[fraction_width - 1 : 0] fr_real,fr_img;
	reg first_file;
	reg second_file;
	integer i;
	reg [31:0] counter ;
	integer ifile1,ofile11,ofile12,ofile13,ofile14,ofile15,ofile16,ofile17,ofile18,ofile19,ofile31,ofile32,ofile33,ofile34,ofile34_1,ofile34_2,ofile35,ofile36,ofile37,ofile38,ofile39;
	integer ifile2,ofile21,ofile22,ofile23,ofile24,ofile25,ofile26,ofile27,ofile28,ofile29,ofile41,ofile42,ofile43,ofile44,ofile44_1,ofile44_2,ofile45,ofile46,ofile47,ofile48,ofile49;
	integer output_file,ofileout;
	integer scramb_in_file, enoder_in_file, punct_in_file,inter_in_file,mapper_in_file,ofdm_in_re_file,ofdm_in_img_file;
	//===============================================================================
	  integer input_data_ahb, input_address_ahb,input_Rdaddress_ahb, data_reg, addr_reg;
	  integer el3b_fel_loop;
	//===============================================================================
	reg [11:0] addr_count;
	reg first_addr;
	reg flag_irq;
	reg [31:0] tmp;
	//===============================================================================	
	(* keep_hierarchy = "yes" *)
        WIFI_AHB_TOP dut(
            .clk_200_MHz(clk),
            .reset(reset),
            //.mode(mode), // will be edited and taken from configuraion register
            .HWRITE(HWRITE), 
            .HSEL(HSEL),
            .HREADY(HREADY),
            .HADDR(HADDR), 
            .HWDATA(HWDATA),
            .HTRANS(HTRANS),
            .HBURST(HBURST), 
            .HSIZE(HSIZE),
            .HRDATA(HRDATA),
            .HRESP(HRESP), 
            .HREADYOUT(HREADYOUT),
            .Tx_irq(Tx_irq),
            .rx_irq(rx_irq)
         );
	//===============================================================================	
	initial
	begin
		el3b_fel_loop 	= 	0;
		ifile1  		= $fopen("inputfile1.txt","w");
		ofile11 		= $fopen("outputfile11_hdlModel.txt","w");
		ofile12 		= $fopen("outputfile12_hdlModel.txt","w");
		ofile13 		= $fopen("outputfile13_hdlModel.txt","w");
		ofile14 		= $fopen("outputfile14_hdlModel.txt","w");
		ofile15 		= $fopen("outputfile15_hdlModel.txt","w");
		ofile16 		= $fopen("outputfile16_hdlModel.txt","w");
		ofile17 		= $fopen("outputfile17_hdlModel.txt","w");
		ofile18 		= $fopen("outputfile18_hdlModel.txt","w");
		ofile19 		= $fopen("outputfile19_hdlModel.txt","w");
		ofile31 		= $fopen("outputfile31_descrambler.txt","w");
		ofile32 		= $fopen("outputfile32_decoder.txt","w");
		ofile33 		= $fopen("outputfile33_deinterleaver..txt","w");
		ofile34_1 		= $fopen("outputfile34_1_before_demap_re.txt","w");
		ofile34_2 		= $fopen("outputfile34_2_before_demap_im.txt","w");
		ofile34 		= $fopen("outputfile34_demapper.txt","w");
		ofile35			= $fopen("outputfile35_fft_real.txt","w");
		ofile36 		= $fopen("outputfile36_fft_imag.txt","w");
		ofile37			= $fopen("outputfile37_packet_divider_real.txt","w");
		ofile38			= $fopen("outputfile38_packet_divider_imag.txt","w");
		ofile39			= $fopen("outputfile39_Depuncturer.txt","w");
        scramb_in_file  =  $fopen("scramb_in_file.txt","w");
		enoder_in_file   =  $fopen("enoder_in_file.txt","w");
		punct_in_file    =  $fopen("punct_in_file.txt","w");
		inter_in_file    =  $fopen("inter_in_file.txt","w");
		mapper_in_file    =  $fopen("mapper_in_file.txt","w");
		ofdm_in_re_file   =  $fopen("ofdm_in_re_file.txt","w");
		ofdm_in_img_file   =  $fopen("ofdm_in_img_file.txt","w");

		input_data_ahb    = $fopen("ahb_hwdata.txt","r");
		input_address_ahb    = $fopen("ahb_haddress.txt","r");
		input_Rdaddress_ahb = $fopen("ahb_haddress_read.txt","r");
        data_reg         = $fopen("ahb_reg_hwdata.txt","r");
        addr_reg        = $fopen("ahb_reg_addr.txt","r");
        
		ifile2  		= $fopen("inputfile2.txt","w");
		ofile21 		= $fopen("outputfile21_hdlModel.txt","w");
		ofile22 		= $fopen("outputfile22_hdlModel.txt","w");
		ofile23 		= $fopen("outputfile23_hdlModel.txt","w");
		ofile24 		= $fopen("outputfile24_hdlModel.txt","w");
		ofile25 		= $fopen("outputfile25_hdlModel.txt","w");
		ofile26 		= $fopen("outputfile26_hdlModel.txt","w");
		ofile27 		= $fopen("outputfile27_hdlModel.txt","w");
		ofile28 		= $fopen("outputfile28_hdlModel.txt","w");
		ofile29 		= $fopen("outputfile29_hdlModel.txt","w");
		ofileout        = $fopen("filetotal.txt","w");
		output_file		= $fopen("output.txt","w");
		ofile41 		= $fopen("outputfile41_descrambler.txt","w");
		ofile42 		= $fopen("outputfile42_decoder.txt","w");
		ofile43 		= $fopen("outputfile43_deinterleaver..txt","w");
		ofile44_1 		= $fopen("outputfile44_1_before_demap_re.txt","w");
		ofile44_2 		= $fopen("outputfile44_2_before_demap_im.txt","w");   
		ofile44 		= $fopen("outputfile44_demapper.txt","w");
		ofile45			= $fopen("outputfile45_fft_real.txt","w");
		ofile46 		= $fopen("outputfile46_fft_imag.txt","w");
		ofile47			= $fopen("outputfile47_packet_divider_real.txt","w");
		ofile48			= $fopen("outputfile48_packet_divider_imag.txt","w");
		ofile49			= $fopen("outputfile49_Depuncturer.txt","w");
		first_valid_out 	= 0;
		second_valid_out 	= 0;
		first_file		= 0;
		second_file		= 0;
	end
	//===============================================================================	
	initial
	begin
		clk 			= 0;
		forever #2.5 clk 	= ~clk;
	end
	//===============================================================================	
	initial
	begin
		//=======================================================================	
		reset 			= 0;
		flag_irq = 1'b1;
		HWRITE		= 0;
		first_addr = 1'b1;
		HREADY = 0;
		HBURST = 0;
		HSEL = 1'b0;
		//mode <= 1 ;
    	HSIZE = 'd2;
		HTRANS = 'b10;
		#18 reset 		= 0;
		first_file		= 1;
		counter			= 0; /////////////////////////////
		#44 reset 		= 1;
		#500; 
		//hwdata	[counter]	<= rate1[0];
		//counter				<= counter + 1 ;
 
		//=======================================================================	
		  @(posedge dut.clk_100_MHz)
	     HSEL <= 1'b1;
	     HWRITE		<= 1'b1;
	     tmp =  $fscanf(addr_reg, "%h\n", HADDR);
	    while (!$feof(data_reg)) begin
		el3b_fel_loop = 1; 
		 @(posedge dut.clk_100_MHz)
		 tmp = $fscanf(data_reg, "%b\n", HWDATA);
	     tmp = $fscanf(addr_reg, "%h\n", HADDR);
		end 
		el3b_fel_loop = 2; 
        #10 HWRITE <= 0;
        HSEL <= 1'b0;
        #1000;
	      @(posedge dut.clk_100_MHz)
	     HSEL <= 1'b1;
	     HWRITE		<= 1'b1;
	     tmp = $fscanf(input_address_ahb, "%h\n", HADDR);
	    while (!$feof(input_data_ahb)) begin 
		el3b_fel_loop = 3;
		 @(posedge dut.clk_100_MHz)
		tmp = $fscanf(input_data_ahb, "%b\n", HWDATA);
	    tmp =  $fscanf(input_address_ahb, "%h\n", HADDR);
		end 
		el3b_fel_loop = 4;
        #10 HWRITE <= 0;
        HSEL <= 1'b0;
       
		//=======================================================================	
		#10000000;
		
		//=======================================================================	
		first_file		<= 0;
		second_file		<= 1;
		#30 HWRITE		<= 1; 
		HWDATA			<= rate2[0];
		//=======================================================================	
		for (i=1;i<=3;i=i+1) 					//Rate (4 bits)
		begin
			#20   HWDATA	<= rate2[i]; 
			$fwrite(ifile2,"%b\n",HWDATA);
		end 
		//=======================================================================	
			#20   HWDATA	<= reserved;
			$fwrite(ifile2,"%b\n",HWDATA);			//reserved (1 bits)
		//=======================================================================	
		for (i=0;i<=11;i=i+1) 					//Length (12 bits)
		begin
			#20   HWDATA	<= length2[i]; 
			$fwrite(ifile2,"%b\n",HWDATA);
		end 
		//=======================================================================	
		for (i=1;i<=7;i=i+1) 					//parity and tail bits (7 bits)
		begin
			#20   HWDATA	<= $random; 
			$fwrite(ifile2,"%b\n",HWDATA);
		end 
		//=======================================================================	
		for (i=1;i<=PSDU2+16;i=i+1) 				//service and PSDU
		begin
			#20   HWDATA	<= $random; 
			$fwrite(ifile2,"%b\n",HWDATA);
		end 
		//=======================================================================	
		for (i=1;i<=6;i=i+1) 					//tail bits (6 bits)
		begin
			#20   HWDATA	<= 0; 
			$fwrite(ifile2,"%b\n",HWDATA);
		end 
		//=======================================================================	
		for (i=1;i<=pads2;i=i+1) 				//PADS
		begin
			#20   HWDATA	<= 0; 
			$fwrite(ifile2,"%b\n",HWDATA);
		end 
		//=======================================================================	
			#20 $fwrite(ifile2,"%b\n",HWDATA);
			HWRITE	<= 0;
		//=======================================================================	
		#1000000000	$stop;
		//=======================================================================	
	end 
	//=======================================================================
	
	//=============================================================================	
	always @ (posedge dut.clk_50_MHz)
	begin
		if (dut.top_wifi.top.tx.scrambler.valid_out==1 && first_file==1)  $fwrite(ofile11,"%b\n",dut.top_wifi.top.tx.scrambler.data_out);
		if (dut.top_wifi.top.tx.scrambler.valid_out==1 && second_file==1) $fwrite(ofile21,"%b\n",dut.top_wifi.top.tx.scrambler.data_out);
	end
	//===============================================================================
	always @ (posedge dut.clk_50_MHz)
	begin
		if (dut.top_wifi.top.tx.scrambler.valid_in==1 && first_file==1)  $fwrite(scramb_in_file,"%b\n",dut.top_wifi.top.tx.scrambler.data_in);
	end
	//===============================================================================	
	always @ (posedge dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.encoder.valid_out==1 && first_file==1)  $fwrite(ofile12,"%b\n",dut.top_wifi.top.tx.encoder.data_out);
		if (dut.top_wifi.top.tx.encoder.valid_out==1 && second_file==1) $fwrite(ofile22,"%b\n",dut.top_wifi.top.tx.encoder.data_out);
	end
	//===============================================================================
	always @ (posedge dut.clk_50_MHz)
	begin
		if (dut.top_wifi.top.tx.encoder.valid_in==1 && first_file==1)  $fwrite(enoder_in_file,"%b\n",dut.top_wifi.top.tx.encoder.data_in);
	end
	//===============================================================================	
	always @ (posedge dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.puncturer.valid_out==1 && first_file==1)  $fwrite(ofile13,"%b\n",dut.top_wifi.top.tx.puncturer.data_out);
		if (dut.top_wifi.top.tx.puncturer.valid_out==1 && second_file==1) $fwrite(ofile23,"%b\n",dut.top_wifi.top.tx.puncturer.data_out);
	end
	//===============================================================================		
 always @ (posedge dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.puncturer.valid_in==1 && first_file==1)  $fwrite(punct_in_file,"%b\n",dut.top_wifi.top.tx.puncturer.data_in);
	end
	//===============================================================================	
	always @ (posedge dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.interleaver.valid_out ==1 && first_file==1) $fwrite(ofile14,"%b\n",dut.top_wifi.top.tx.interleaver.data_out);
		if (dut.top_wifi.top.tx.interleaver.valid_out==1 && second_file==1) $fwrite(ofile24,"%b\n",dut.top_wifi.top.tx.interleaver.data_out);
	end
	//===============================================================================	
	always @ (posedge dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.interleaver.valid_in ==1 && first_file==1) $fwrite(inter_in_file,"%b\n",dut.top_wifi.top.tx.interleaver.data_in);
	end
	//===============================================================================	
	always @ (posedge dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.mapper.valid_out==1 && first_file==1)  $fwrite(ofile15,"%b\n",dut.top_wifi.top.tx.mapper.mod_out_re);
		if (dut.top_wifi.top.tx.mapper.valid_out==1 && second_file==1) $fwrite(ofile25,"%b\n",dut.top_wifi.top.tx.mapper.mod_out_re);
	end
	 //===============================================================================	
	always @ (posedge dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.mapper.valid_in==1 && first_file==1)  $fwrite(mapper_in_file,"%b\n",dut.top_wifi.top.tx.mapper.data_in);
	end
	//===============================================================================	
 
		always @ (posedge dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.mapper.valid_out==1 && first_file==1)  $fwrite(ofile16,"%b\n",dut.top_wifi.top.tx.mapper.mod_out_im);
		if (dut.top_wifi.top.tx.mapper.valid_out==1 && second_file==1) $fwrite(ofile26,"%b\n",dut.top_wifi.top.tx.mapper.mod_out_im);
	end
	//==============================================================================	
	always @ (posedge  dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.tx.top_ofdm.valid_out ==1 && first_file==1)  $fwrite(ofile17,"%b\n",dut.top_wifi.top.tx.top_ofdm.data_out_re);
		if (dut.top_wifi.top.tx.top_ofdm.valid_out ==1 && second_file==1) $fwrite(ofile27,"%b\n",dut.top_wifi.top.tx.top_ofdm.data_out_re);
	end
	 //==============================================================================	
	always @ (posedge  dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.top_ofdm.valid_in ==1 && first_file==1)  $fwrite(ofdm_in_re_file,"%b\n",dut.top_wifi.top.tx.top_ofdm.data_in_re);
	end
	//==============================================================================	
	always @ (posedge  dut.clk_100_MHz)
	begin
		if (dut.top_wifi.top.tx.top_ofdm.valid_in ==1 && first_file==1)  $fwrite(ofdm_in_img_file,"%b\n",dut.top_wifi.top.tx.top_ofdm.data_in_im);
	end
	//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.tx.top_ofdm.valid_out ==1 && first_file==1)  $fwrite(ofile18,"%b\n",dut.top_wifi.top.tx.top_ofdm.data_out_im);
		if (dut.top_wifi.top.tx.top_ofdm.valid_out ==1 && second_file==1) $fwrite(ofile28,"%b\n",dut.top_wifi.top.tx.top_ofdm.data_out_im);
		//if (dut.valid_out ==1) $fwrite(ofileout,"%b\n",dut.data_out);
	end
	//===============================================================================	
 
	/*always @ (posedge dut.clk_50_MHz)
	begin
		if (dut.top_wifi.top.tx.valid_out==1) mode <= 0;
	end*/
	//===============================================================================	
	always @ (posedge dut.clk_100_MHz)
	begin
		if(Tx_irq && flag_irq)
		begin
		 @(posedge dut.clk_100_MHz)
	     HSEL <= 1'b1;
	     HWRITE		<= 1'b1;
	     HADDR <= 'h0;
		@(posedge dut.clk_100_MHz) HWDATA <= 'b01;
		HADDR <= 'h8;
		@(posedge dut.clk_100_MHz) HWDATA <= 'b01; 
		#10 HWRITE <= 0;
        HSEL <= 1'b0;
        flag_irq <= 1'b0;
		end
		
	end
		//===============================================================================		
	always @ (posedge dut.clk_100_MHz)
	begin
			@(posedge dut.top_wifi.top.rx.RX_deserializer_inist.rx_irq);
			      @(posedge dut.clk_100_MHz)
                 HSEL <= 1'b1;
                 HWRITE		<= 1'b1;
                 HADDR <= 'h8;
                @(posedge dut.clk_100_MHz) HWDATA <= 'b10;
                #10 HWRITE <= 0;
                HSEL <= 1'b0;
    end
		//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if(dut.top_wifi.top.tx.valid_out == 1 && first_file==1)
		begin
			int_real = dut.top_wifi.top.tx.data_out_re[(full_width - 1) -: (full_width - fraction_width)];
			int_img  = dut.top_wifi.top.tx.data_out_im[(full_width - 1) -: (full_width - fraction_width)];
			fr_real  = dut.top_wifi.top.tx.data_out_re[(fraction_width - 1) -: fraction_width];
			fr_img   = dut.top_wifi.top.tx.data_out_im[(fraction_width - 1) -: fraction_width];
			$fwrite(ofile19,"%b.%b\n",int_real,fr_real);
			$fwrite(ofile19,"%b.%b\n",int_img,fr_img);
		end
		if(dut.top_wifi.top.tx.valid_out == 1 && second_file==1)
		begin
			int_real = dut.top_wifi.top.tx.data_out_re[(full_width - 1) -: (full_width - fraction_width)];
			int_img  = dut.top_wifi.top.tx.data_out_im[(full_width - 1) -: (full_width - fraction_width)];
			fr_real  = dut.top_wifi.top.tx.data_out_re[(fraction_width - 1) -: fraction_width];
			fr_img   = dut.top_wifi.top.tx.data_out_im[(fraction_width - 1) -: fraction_width];
			$fwrite(ofile29,"%b.%b\n",int_real,fr_real);
			$fwrite(ofile29,"%b.%b\n",int_img,fr_img);
		end
	end
	
	//=============================================================================	
	always @ (posedge dut.clk_50_MHz)
	begin
		if (dut.top_wifi.top.rx.top_rx.descrambler.valid_out==1 )  $fwrite(ofile31,"%b\n",dut.top_wifi.top.rx.top_rx.descrambler.data_out);
		if (dut.top_wifi.top.rx.top_rx.descrambler.valid_out==1 ) $fwrite(ofile41,"%b\n",dut.top_wifi.top.rx.top_rx.descrambler.data_out);
	end
 
	//===============================================================================	
	always @ (posedge dut.clk_50_MHz)
	begin
		if (dut.top_wifi.top.rx.top_rx.decoder.valid_out==1 )  $fwrite(ofile32,"%b\n",dut.top_wifi.top.rx.top_rx.decoder.data_out);
		if (dut.top_wifi.top.rx.top_rx.decoder.valid_out==1 ) $fwrite(ofile42,"%b\n",dut.top_wifi.top.rx.top_rx.decoder.data_out);
	end
 
	//===============================================================================	
	always @ (posedge dut.clk_50_MHz)
	begin
		if (dut.top_wifi.top.rx.top_rx.depuncturer.valid_out==1 && first_file==1)  $fwrite(ofile39,"%b\n",dut.top_wifi.top.rx.top_rx.depuncturer.data_out);
		if (dut.top_wifi.top.rx.top_rx.depuncturer.valid_out==1 && second_file==1) $fwrite(ofile49,"%b\n",dut.top_wifi.top.rx.top_rx.depuncturer.data_out);
	end
 
	//===============================================================================	
	always @ (posedge dut.clk_50_MHz)
	begin
		if (dut.top_wifi.top.rx.top_rx.deinterleaver.valid_out==1 )  $fwrite(ofile33,"%b\n",dut.top_wifi.top.rx.top_rx.deinterleaver.data_out);
		if (dut.top_wifi.top.rx.top_rx.deinterleaver.valid_out==1 ) $fwrite(ofile43,"%b\n",dut.top_wifi.top.rx.top_rx.deinterleaver.data_out);
	end
 
	//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.rx.top_rx.demapper.stack_control.valid_out==1 && first_file==1)  $fwrite(ofile34_1,"%b\n",dut.top_wifi.top.rx.top_rx.demapper.stack_control.data_out_real);
		if (dut.top_wifi.top.rx.top_rx.demapper.stack_control.valid_out==1 && second_file==1) $fwrite(ofile44_1,"%b\n",dut.top_wifi.top.rx.top_rx.demapper.stack_control.data_out_real);
	end
 
	//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.rx.top_rx.demapper.stack_control.valid_out==1 && first_file==1)  $fwrite(ofile34_2,"%b\n",dut.top_wifi.top.rx.top_rx.demapper.stack_control.data_out_imag);
		if (dut.top_wifi.top.rx.top_rx.demapper.stack_control.valid_out==1 && second_file==1) $fwrite(ofile44_2,"%b\n",dut.top_wifi.top.rx.top_rx.demapper.stack_control.data_out_imag);
	end	
 
	//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.rx.top_rx.demapper.valid_out==1 && first_file==1)  $fwrite(ofile34,"%b\n",dut.top_wifi.top.rx.top_rx.demapper.data_out);
		if (dut.top_wifi.top.rx.top_rx.demapper.valid_out==1 && second_file==1) $fwrite(ofile44,"%b\n",dut.top_wifi.top.rx.top_rx.demapper.data_out);
	end	
 
	//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.rx.top_rx.control_fft.valid_out==1 && first_file==1)  $fwrite(ofile35,"%b\n",dut.top_wifi.top.rx.top_rx.control_fft.data_out_real);
		if (dut.top_wifi.top.rx.top_rx.control_fft.valid_out==1 && second_file==1) $fwrite(ofile45,"%b\n",dut.top_wifi.top.rx.top_rx.control_fft.data_out_real);
	end
 
	//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.rx.top_rx.control_fft.valid_out==1 && first_file==1)  $fwrite(ofile36,"%b\n",dut.top_wifi.top.rx.top_rx.control_fft.data_out_imag);
		if (dut.top_wifi.top.rx.top_rx.control_fft.valid_out==1 && second_file==1) $fwrite(ofile46,"%b\n",dut.top_wifi.top.rx.top_rx.control_fft.data_out_imag);
	end	
 
	//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.rx.top_rx.packet_div.valid_out==1 && first_file==1)  $fwrite(ofile37,"%b\n",dut.top_wifi.top.rx.top_rx.packet_div.data_out_re);
		if (dut.top_wifi.top.rx.top_rx.packet_div.valid_out==1 && second_file==1) $fwrite(ofile47,"%b\n",dut.top_wifi.top.rx.top_rx.packet_div.data_out_re);
	end
 
	//===============================================================================	
	always @ (posedge dut.clk_20_MHz_WIFI)
	begin
		if (dut.top_wifi.top.rx.top_rx.packet_div.valid_out==1 && first_file==1)  $fwrite(ofile38,"%b\n",dut.top_wifi.top.rx.top_rx.packet_div.data_out_im);
		if (dut.top_wifi.top.rx.top_rx.packet_div.valid_out==1 && second_file==1) $fwrite(ofile48,"%b\n",dut.top_wifi.top.rx.top_rx.packet_div.data_out_im);
	end

 
	//===============================================================================
	//===============================================================================	
	always @(posedge dut.clk_20_MHz_WIFI)
	begin
		if(dut.top_wifi.top.rx.top_rx.descrambler.valid_out == 1 && first_valid_out == 0)	first_valid_out = 1; 
		if(first_valid_out == 1 && dut.top_wifi.top.rx.top_rx.descrambler.valid_out == 0)	
		begin
			$fclose(ifile1);	
			$fclose(ifile2);	
			$fclose(ofile11);	
			$fclose(ofile12);	
			$fclose(ofile13);	
			$fclose(ofile14);	
			$fclose(ofile15);	
			$fclose(ofile16);	
			$fclose(ofile17);	
			$fclose(ofile18);	
			$fclose(ofile19);	
			$fclose(ofile21);	
			$fclose(ofile22);	
			$fclose(ofile23);	
			$fclose(ofile24);	
			$fclose(ofile25);	
			$fclose(ofile26);	
			$fclose(ofile27);	
			$fclose(ofile28);	
			$fclose(ofile29);		
			$fclose(ofile31);	
			$fclose(ofile32);	
			$fclose(ofile33);	
			$fclose(ofile34);
			$fclose(ofile34_1);
			$fclose(ofile34_2);	
			$fclose(ofile35);	
			$fclose(ofile36);	
			$fclose(ofile37);	
			$fclose(ofile38);	
			$fclose(ofile39);	
			$fclose(ofile41);	
			$fclose(ofile42);	
			$fclose(ofile43);	
			$fclose(ofile44);
			$fclose(ofile44_1);
			$fclose(ofile44_2);	
			$fclose(ofile45);	
			$fclose(ofile46);	
			$fclose(ofile47);	
			$fclose(ofile48);	
			$fclose(ofile49);	
			$fclose(output_file);	
			$fclose(ofileout);
			$fclose(scramb_in_file);
			$fclose(enoder_in_file);
			$fclose(punct_in_file);
			$fclose(inter_in_file);
			$fclose(mapper_in_file);
			$fclose(ofdm_in_re_file);
			$fclose(ofdm_in_img_file);
			$fclose(input_data_ahb);
			$fclose(input_address_ahb);
			el3b_fel_loop = 5;
			#1000;
			el3b_fel_loop = 6;
			while (!$feof(input_Rdaddress_ahb)) begin
				el3b_fel_loop = 7;
			 @(posedge dut.clk_100_MHz)
			 HSEL <= 1'b1;
			 HWRITE <= 0;
		    tmp = $fscanf(input_Rdaddress_ahb, "%h\n", HADDR);
			end 
			el3b_fel_loop = 8;

			#20 HSEL <= 1'b0;
			$fclose(input_Rdaddress_ahb);
			
			#1000;
			el3b_fel_loop = 9;
		$stop;
			//if(dut.top_wifi.top.rx.RX_deserializer_inist.rx_irq == 1'b1) begin	
		end
		
	end


			
	//===============================================================================	
endmodule