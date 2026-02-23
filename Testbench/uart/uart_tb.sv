module uart_tb();
  
parameter Clock_PERIOD = 10 ; // change depending on system clock

reg        PCLK_TB;
reg        PCLKG_TB;
reg        PRESETn_TB;
reg        PSEL_TB;
reg [11:2] PADDR_TB;
reg        PENABLE_TB;
reg        PWRITE_TB;
reg [31:0] PWDATA_TB;
reg  [3:0] ECOREVNUM_TB;
reg        RXD_TB;

wire [31:0] PRDATA_TB;
wire        PREADY_TB;
wire        PSLVERR_TB;
wire        TXD_TB;
wire        TXEN_TB;
wire        BAUDTICK_TB;
wire        TXINT_TB;
wire        RXINT_TB;
wire        TXOVRINT_TB;
wire        RXOVRINT_TB;
reg         CTS_TB; 
wire        RTS_TB; 
wire        UARTINT_TB;
 
//////////////////// instantiate  /////////////////////

 cmsdk_apb_uart DUT (
 .PCLK(PCLK_TB),
 .PCLKG(PCLKG_TB),
 .PRESETn(PRESETn_TB),
 .PSEL(PSEL_TB),
 .PADDR(PADDR_TB),
 .PENABLE(PENABLE_TB),
 .PWRITE(PWRITE_TB),
 .PWDATA(PWDATA_TB),
 .ECOREVNUM(ECOREVNUM_TB),
 .PRDATA(PRDATA_TB),
 .PREADY(PREADY_TB),
 .PSLVERR(PSLVERR_TB),
 .RXD(RXD_TB),
 .TXD(TXD_TB),
 .TXEN(TXEN_TB),
 .BAUDTICK(BAUDTICK_TB),
 .TXINT(TXINT_TB),
 .RXINT(RXINT_TB),
 .TXOVRINT(TXOVRINT_TB),
 .RXOVRINT(RXOVRINT_TB),
 .CTS(CTS_TB), 
 .RTS(RTS_TB),
 .UARTINT(UARTINT_TB)
 );
 
////////////////////////////// CLOCK GENERATOR //////////////////////


always #(Clock_PERIOD/2)  PCLK_TB = ~PCLK_TB ;
always #(Clock_PERIOD/2)  PCLKG_TB = ~PCLKG_TB ;

////////////////////////////// intial block /////////////////
bit [19:0] divisor;

initial
begin
  
$dumpfile("APB.vcd") ;       
$dumpvars; 

INITIALISE();
RESET();

divisor = 'd16;
CTS_TB = 'b1;

////////////////////////// baud div value/////////////////////////

APB_WRITE(divisor, 'h4); //setting the baud div value = 16
#(Clock_PERIOD)

///////////////////////// Transmitting Data /////////////////////////////////

divisor = 'd16;
APB_WRITE(divisor, 'h4); //setting the baud div value = 16
#(Clock_PERIOD)
 
APB_WRITE('b10101, 10'h002);  // enbaling transmitting of data by puting the value 01 into the control register      
//also enabling tx interrupt and tx overrun interupt
#(Clock_PERIOD)


APB_WRITE('b11001101, 'h0); // taking input data by adding value in PWRITE regester and puting value 0 into the control register ( write data ) 
#(Clock_PERIOD*(10*16))

/////////////// case overrun TX ///////////////

APB_WRITE('b10101, 10'h002);  // enbaling transmitting of data by puting the value 01 into the control register      
#(Clock_PERIOD)

APB_WRITE('b11001101, 'h0); // taking input data by adding value in PWRITE regester and puting value 0 into the control register ( write data ) 
#(Clock_PERIOD*(6*16))
APB_WRITE('b10011101, 'h0);
#(Clock_PERIOD*(2*16))
APB_WRITE('b10000001, 'h0);
#(Clock_PERIOD*(16*16))

////////////////////////// Recieving data //////////////////////////////


APB_WRITE('b111010, 10'h002); // enbaling recieving of data by puting the value 01 into the control register 
//also enabling rx interrupt and rx overrun interupt
#(Clock_PERIOD)

APB_READ();
Recieve_data ('b1100100100);  // recieving data through RX input port
#(Clock_PERIOD*(8*30)) ////////////////////////////


///////////////Case RX overrun///////////////////

APB_WRITE('b111010, 10'h002); // enbaling recieving of data by puting the value 01 into the control register 
//also enabling rx interrupt and rx overrun interupt
//also enabling tx overrun interupt
#(Clock_PERIOD)
Recieve_data ('b1100110100);  
#(Clock_PERIOD)
Recieve_data ('b1110110100);  
#(Clock_PERIOD)
Recieve_data ('b1101010100);  
#(Clock_PERIOD)
Recieve_data ('b1100110100);  

////////////////////error writing in read only/////////////////////

#(30*Clock_PERIOD);
PADDR_TB = 10'h001;
PWRITE_TB = 1;
PWDATA_TB = 'b11;
#(20*Clock_PERIOD);


/////////////////////recieving after error//////////////////////////////

APB_WRITE('b111010, 10'h002); // enbaling recieving of data by puting the value 01 into the control register 
//also enabling rx interrupt and rx overrun interupt
#(Clock_PERIOD)

APB_READ();
Recieve_data ('b1100100100);  // recieving data through RX input port
#(Clock_PERIOD*(8*16))


//////////////////error when setting baud div less than 16/////////////////

APB_WRITE('d12, 'h4);
#(Clock_PERIOD*(2*16))


#(1000*Clock_PERIOD);
$stop;
end



///////////////////////////////////Tasks////////////////////////////////


///////////////////////////////////Task reset////////////////////////
task RESET ;
 begin
  PRESETn_TB = 1'b1;
  #(Clock_PERIOD)
  PRESETn_TB = 1'b0;
  #(19*Clock_PERIOD)
  PRESETn_TB = 1'b1;
 end
endtask

////////////////////// Task initialise///////////////////////////////// 

task INITIALISE ;
begin
  PCLK_TB      = 0;
  PCLKG_TB     = 0;
  PSEL_TB      = 1; 
  PADDR_TB     = 0;
  PENABLE_TB   = 0;
  PWRITE_TB    = 0;
  ECOREVNUM_TB = 0;
  PWDATA_TB    = 0;
  RXD_TB       = 1;
end
endtask

/////////////////////////Task Writing////////////////////////
task APB_WRITE ;
  input [31:0] Data ;
  input [11:2] Address ;
  begin
    PADDR_TB  = Address ;
    PWRITE_TB = 1;
    PENABLE_TB = 0;
    PWDATA_TB = Data ;
    PSEL_TB      = 1;
    
    #(Clock_PERIOD);
    PENABLE_TB = 1;

    #(Clock_PERIOD);
    PENABLE_TB = 0;
    PSEL_TB    = 0;
    PWRITE_TB = 0;
    
  end
endtask

///////////////////////////////Task Read ///////////////////////
task APB_READ ;
  begin
    @(posedge PCLKG_TB); 
    PADDR_TB = 'h0;
    PSEL_TB    = 1;
    PENABLE_TB =0;
    PWRITE_TB = 0;
  end
endtask

///////////////////////////////Task Recieving data ///////////////////////

task Recieve_data ;
  input [9:0] data ;
   int i;
  begin
    for (i = 0 ; i < 10 ; i = i+1)
    begin
      RXD_TB = data[i] ;
      #(divisor*Clock_PERIOD);
    end
  end
endtask

endmodule
