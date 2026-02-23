module gpio_tb ();
   bit                 HCLK;      // system bus clock
   bit                 HRESETn;   // system bus reset
   bit                 FCLK;      // system bus clock
   bit                 HSEL;      // AHB peripheral select
   bit                 HREADY;    // AHB ready input
   bit  [1:0]          HTRANS;    // AHB transfer type
   bit  [2:0]          HSIZE;     // AHB hsize
   bit                 HWRITE;    // AHB hwrite
   bit [11:0]          HADDR;     // AHB address bus
   bit [31:0]          HWDATA;    // AHB write data bus
   bit [3:0]           ECOREVNUM; // Engineering-change-order revision bits
   bit                 HREADYOUT; // AHB ready output to S->M mux
   bit                 HRESP;     // AHB response
   bit [31:0]          HRDATA;
   bit                 HBURST;
   wire [15:0]        TOTAL_OUT;
   bit [15:0]          GPIOINT;
   bit                 COMBINT;
   
 ////////////////////INSTANTIATION////////////////////
    
    GPIO_HW DUT (
 	    .HCLK(HCLK),
	    .HRESETn(HRESETn),
	    .FCLK(HCLK),
	    .HSEL(HSEL),
	    .HREADY(HREADY),
	    .HTRANS(HTRANS),
	    .HSIZE(HSIZE),
	    .HWRITE(HWRITE),
	    .HADDR(HADDR),
	    .HWDATA(HWDATA),
	    .ECOREVNUM('b0),
	    .HREADYOUT(HREADYOUT),
	    .HRESP(HRESP),
	    .HRDATA(HRDATA),
		.PORT_IN_OUT(TOTAL_OUT),
	    .GPIOINT(GPIOINT),
	    .COMBINT(COMBINT)
	    
	    );
		
////////////////////CLOCK GENERATION////////////////////

localparam  CLK_PERIOD = 10 ;

always #(CLK_PERIOD/2)  HCLK = ~HCLK ; 

////////////////////INTERNAL REGISTER ADDRESS////////////////////

localparam DATA = 12'h0;
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
localparam INTSTATUS = 12'h38;

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
input [9:0] address;
input write ;
input [31:0] data;
begin
    @(posedge HCLK)
    HTRANS = 'b10;
    HSIZE = 3'b10;
    HADDR <= address;
    HWRITE <= write;
	HSEL <= 1'b1;
	@(posedge HCLK)
    HWDATA <= data;
    @(posedge HCLK)
    HSEL <= 1'b0;
end
endtask

/////////////////////////////// INITIALISE //////////// 
initial
begin
    initialize();
    reset();
	#(CLK_PERIOD*10);

    HREADY = 1;
    AHB_TRANS(OUTENSET,1,'h000f);
	#(CLK_PERIOD);
	AHB_TRANS(DATAOUT,1,'h000f);
	#(CLK_PERIOD);
	AHB_TRANS(INTENSET,1,'h000a);
	#(CLK_PERIOD);
	AHB_TRANS(INTTYPESET,1,'h000f);
	#(CLK_PERIOD);
	AHB_TRANS(DATAOUT,1,'h0000);
	#(CLK_PERIOD);
	AHB_TRANS(INTSTATUS,0,'h0000);
		#(CLK_PERIOD);
	AHB_TRANS(INTSTATUS,1,'h000f);
    #(100*CLK_PERIOD);
    $stop;
end

endmodule
