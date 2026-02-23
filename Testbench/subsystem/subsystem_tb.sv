module subsystem_tb ();
//AHB inputs
bit HCLK;
bit HRESETn;
bit [1:0] HTRANS;
bit [2:0] HSIZE;
bit [3:0] HPROT;
bit [15:0] HADDR;
bit [31:0] HWDATA;
bit HSEL;
bit HWRITE;
bit HREADY;
//APB inputs 
bit PCLK;
bit PCLKG;
bit PRESETn;
bit RXD0;
bit RXD1;
bit EXTIN;
//AHB outputs
bit  [31:0] HRDATA;
bit  HREADYOUT;
bit  HRESP;
//APB outputs
bit  TXD0;
bit  TXD1;
bit  watchdog_interrupt;
bit  watchdog_reset;
bit  [13:0] subsystem_interrupt;

cmsdk_apb_subsystem DUT (
.HCLK(HCLK),
.HRESETn(HRESETn),
.HTRANS(HTRANS),
.HSIZE(HSIZE),
.HPROT(HPROT),
.HADDR(HADDR),
.HWDATA(HWDATA),
.HSEL(HSEL),
.HWRITE(HWRITE),
.HREADY(HREADY), 
.PCLK(PCLK),
.PCLKG(PCLKG),
.PRESETn(PRESETn),
.RXD0(RXD0),
.RXD1(RXD1),
.EXTIN(EXTIN),
.HRDATA(HRDATA),
.TIMCLK(PCLK),
.HREADYOUT(HREADYOUT),
.HRESP(HRESP),
.TXD0(TXD0),
.TXD1(TXD1),
.watchdog_interrupt(watchdog_interrupt),
.watchdog_reset(watchdog_reset),
.subsystem_interrupt(subsystem_interrupt)
);

////////////////////CLOCK GENERATION////////////////////

localparam AHB_CLK = 2;
localparam APB_CLK = 4;

always #(AHB_CLK/2) HCLK = ~HCLK;
always #(APB_CLK/2) PCLK = ~PCLK;
always #(APB_CLK/2) PCLKG = ~PCLKG;
////////////////////INTERNAL UART REGISTER ADDRESS////////////////////

localparam [9:0] UART_DATA = 10'h0;
localparam [9:0] UART_STATE = 10'h1;
localparam [9:0] UART_CTRL = 10'h2;
localparam [9:0] UART_INTCLEAR = 10'h3;
localparam [9:0] UART_INTSTATUS = 10'h3;
localparam [9:0] UART_BAUDDIV = 10'h4;

////////////////////INTERNAL TIMER REGISTER ADDRESS////////////////////

localparam [9:0] TIMER_CTRL = 10'h0;
localparam [9:0] TIMER_VALUE = 10'h1;
localparam [9:0] TIMER_RELOAD = 10'h2;
localparam [9:0] TIMER_INTSTATUS = 10'h3;
localparam [9:0] TIMER_INTCLR = 10'h3;

////////////////////INTERNAL DUALTIMER REGISTER ADDRESS////////////////////

localparam [9:0] TIMER1LOAD = 10'h0;
localparam [9:0] TIMER1VALUE = 10'h1;
localparam [9:0] TIMER1CONTROL = 10'h2;
localparam [9:0] TIMER1INTCLR = 10'h3;
localparam [9:0] TIMER1RIS = 10'h4;
localparam [9:0] TIMER1MIS = 10'h5;
localparam [9:0] TIMER1BGLOAD = 10'h6;

localparam [9:0] TIMER2LOAD = 10'h8;
localparam [9:0] TIMER2VALUE = 10'h9;
localparam [9:0] TIMER2CONTROL = 10'hA;
localparam [9:0] TIMER2INTCLR = 10'hB;
localparam [9:0] TIMER2RIS = 10'hC;
localparam [9:0] TIMER2MIS = 10'hD;
localparam [9:0] TIMER2BGLOAD = 10'hE;

////////////////////INTERNAL WATCHDOG REGISTER ADDRESS////////////////////

localparam [9:0] WDOGLOAD = 10'h0;
localparam [9:0] WDOGVALUE = 10'h1;
localparam [9:0] WDOGCONTROL = 10'h2;
localparam [9:0] WDOGINTCLR = 10'h3;
localparam [9:0] WDOGRIS = 10'h4;
localparam [9:0] WDOGMIS = 10'h5;
localparam [9:0] WDOGLOCK= 10'h300;

////////////////////PERIPHERAL ADDRESS////////////////////

localparam [3:0] UART0 = 4'b0000;
localparam [3:0] WATCHDOG = 4'b0001;
localparam [3:0] TIMER = 4'b0010;
localparam [3:0] UART1 = 4'b0100;
localparam [3:0] DUALTIEMR = 4'b0101;



////////////////////TASK PARAMETERS////////////////////

logic [31:0] data_array_tb[];
logic [15:0] address_array_tb[];
logic        write_array_tb[];
logic [1:0]  trans_array_tb[];
logic [2:0]  size_array_tb[];
logic        sel_array_tb[];

task initilaize;
begin
HRESETn <= 1'b1;
HCLK <= 1'b0;
HSEL <= 1'b1;
HADDR <= 16'b0;
HWDATA <= 32'b0;
HWRITE <= 1'b0;
HSIZE <= 2'b0;
HPROT <= 3'b0;
HTRANS <= 2'b0;
HREADY <= 1'b1;

PRESETn <= 1'b1;
PCLK <= 1'b0;
PCLKG <= 1'b0;
RXD0 <= 1'b0;
RXD1 <= 1'b0;
EXTIN <= 1'b1;
repeat(4)
@(posedge PCLK);
end
endtask

task reset;
begin
    PRESETn <= 1'b0;
    HRESETn <= 1'b0;
    repeat(5)
    @(posedge PCLK);
    PRESETn <= 1'b1;
    HRESETn <= 1'b1;
    repeat(5)
    @(posedge PCLK);
end
endtask

task AHB_Master;
  input logic [31:0] data_array[];
  input logic [15:0] address_array[];
  input logic        write_array[];
  input logic [1:0] trans_array[];
  input logic [2:0] size_array[];
  input logic       sel_array[];

  
  // Address and Data Phase
  @(posedge HCLK);

  HADDR <= address_array[0];
  HWRITE <= write_array[0];
  HTRANS <= trans_array[0];
  HSIZE <= size_array[0];
  HSEL <= sel_array[0];

  @(posedge HCLK);
  
  
  for (int i = 1; i < address_array.size(); i++) begin
    // Wait for Hready
    while (!HREADYOUT) begin
      @(posedge HCLK);
    end
    if (write_array[i-1]) begin
        HWDATA <= data_array[i-1];
      end

    HADDR <= address_array[i];
    HWRITE <= write_array[i];
    HTRANS <= trans_array[i];
    HSIZE <= size_array[i];
    HSEL <= sel_array[i];

    @(posedge HCLK);
  

  end
  while (!HREADYOUT) begin
      @(posedge HCLK);
    end

  @(posedge HCLK);
  if (write_array[address_array.size()-1]) begin
    HWDATA <= data_array[address_array.size()-1];
  end
  
endtask



initial
begin
$dumpfile("subsystem.vcd") ;       
$dumpvars;

initilaize();
reset();

  data_array_tb       =   {32'b1001, 32'd70, 32'd17, 32'h18082704,32'd1,32'd90};    
  address_array_tb    =   {{TIMER,TIMER_CTRL,2'b00},{TIMER,TIMER_VALUE,2'b00},{TIMER,TIMER_INTSTATUS,2'b00},
                           {TIMER,TIMER_VALUE,2'b00},{WATCHDOG,WDOGLOCK,2'b00},{WATCHDOG,WDOGLOAD,2'b00}};        
  write_array_tb      =   {1,1,1,0,1,1};    
  trans_array_tb      =   {2'b10, 2'b10, 2'b10, 2'b10,2'b10,2'b10};    
  size_array_tb       =   {3'b010, 3'b010, 3'b010, 3'b010,3'b010,3'b010};
  sel_array_tb        =   {1,1,0,1,1,1};

   AHB_Master(data_array_tb
    ,address_array_tb
    ,write_array_tb
    ,trans_array_tb
    ,size_array_tb
    ,sel_array_tb);

    #1000;
    $stop;


end
endmodule