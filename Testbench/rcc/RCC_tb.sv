module rcc_tb ();
    bit          HCLK;      // system bus clock
    bit          HRESETn;   // system bus reset
    bit          HSEL;      // AHB peripheral select
    bit          HREADY;    // AHB ready input
    bit    [1:0] HTRANS;    // AHB transfer type
    bit    [2:0] HSIZE;     // AHB hsize
    bit          HWRITE;    // AHB hwrite
    bit   [31:0] HADDR;     // AHB address bus
    bit   [31:0] HWDATA;    // AHB write data bus
    bit          HREADYOUT; // AHB ready output to S->M mux
    bit          HRESP;     // AHB response
    bit   [31:0] HRDATA;    // AHB readbit
    bit          APB_ACTIVE;//for PCLKG
    bit          PCLK;
    bit          PCLKG;
    bit          PRESETn;
    bit          TIMCLK;
    bit          WDOGCLK;
    bit          WDOGRESn;
    bit          FCLK;

   
 ////////////////////INSTANTIATION////////////////////
    
    ahb_to_RCC DUT (.*);
		
////////////////////CLOCK GENERATION////////////////////

localparam  CLK_PERIOD = 10 ;

always #(CLK_PERIOD/2)  HCLK = ~HCLK ; 

////////////////////INTERNAL REGISTER ADDRESS////////////////////

/*localparam DATA = 12'h0;
localparam DATAOUT = 12'h4;
localparam OUTENSET = 12'h10;  
localparam OUTENCLR = 12'h14;
localparam ALTFUNCSET = 12'h18;
localparam ALTFUNCCLR = 12'h1c;
localparam INTENSET = 12'h20;
localparam INTENCLR = 12'h24;
localparam INTTYPESET = 12'h28;
localparam INTTYPECLR = 12'h2c;
localparam INTPOLSET = 12'h30;
localparam INTPOLCLR = 12'h34;
localparam INTSTATUS = 12'h38;*/

////////////////////INITIALIZATION////////////////////

task initialize ;
begin
  HCLK<= 0;
  HRESETn<= 0;
  HADDR<= 0; 
  HSEL<= 0;
  HREADY<= 1;
  HTRANS<= 0;
  HSIZE<= 0;
  HWRITE<= 0;
  HWDATA<= 0;
end
endtask

////////////////////RESET////////////////////

task reset;
begin
    HRESETn <= 1'b1;
    #(CLK_PERIOD);
    HRESETn <= 1'b0;
    #(CLK_PERIOD);
    HRESETn <= 1'b1;
end
endtask


////////////////////TRANSFER USING APB TRANSFER////////////////////

task AHB_TRANS ;
input [15:0] address;
input write ;
input [31:0] data;
input [2:0] size;
input sel;
begin
    @(posedge HCLK)
    HTRANS = 'b10;
    HSIZE = size;
    HADDR <= address;
    HWRITE <= write;
	HSEL <= sel;
	@(posedge HCLK)
    HWDATA <= data;
    HSEL <= 1'b0;
end
endtask

/////////////////////////////// INITIALISE //////////// 
initial
begin
    HREADY = 1;
    APB_ACTIVE = 1'b0;
    initialize();
    reset();
	#(CLK_PERIOD*10);

    //AHB_TRANS(address,write,data,size,sel)
    AHB_TRANS(32'h8000,1,'h00040208,0,1);
	#(20*CLK_PERIOD);
    APB_ACTIVE = 1'b1;
	AHB_TRANS(32'b01011110,1,'h00162616,0,1);
	#(20*CLK_PERIOD);
    APB_ACTIVE = 1'b0;
	AHB_TRANS(32'h8000,1,'hdeadbeef,0,0);
	#(20*CLK_PERIOD);
    APB_ACTIVE = 1'b1;
	AHB_TRANS(32'h8000,1,'h00040208,0,1);
	#(20*CLK_PERIOD);
    APB_ACTIVE = 1'b0;
	AHB_TRANS(32'h8000,0,'h00040208,2,1);
	#(20*CLK_PERIOD);
    APB_ACTIVE = 1'b1;
	AHB_TRANS(32'h8000,1,'h00060802,2,1);
	#(50*CLK_PERIOD);
    APB_ACTIVE = 1'b0;
	AHB_TRANS(32'h8000,1,'h00040404,0,1);
    #(1000*CLK_PERIOD);
    $stop;
end

endmodule
