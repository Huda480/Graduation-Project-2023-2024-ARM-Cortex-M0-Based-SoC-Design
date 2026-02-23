module bridge_test ();
bit                        HRESETn;
bit                        HCLK;
bit                        HSEL;
bit     [15:0]             HADDR;
bit     [31:0]             HWDATA;
bit     [31:0]             HRDATA;
bit                        HWRITE;
bit     [2:0]              HSIZE;
bit     [2:0]              HBURST;
bit     [3:0]              HPROT;
bit     [1:0]              HTRANS;
bit                        HMASTLOCK;
bit                        HREADYOUT;
bit                        HREADY;
bit                        HRESP;
 //APB Master Interface
bit                        PRESETn;
bit                        PCLK;
bit                        PSEL;
bit                        PENABLE;
bit     [2:0]              PPROT;
bit                        PWRITE;
bit     [32/8-1:0]         PSTRB;
bit     [15:0]             PADDR;
bit     [31:0]             PWDATA;
bit     [31:0]             PRDATA;
bit                        PREADY;
bit                        PSLVERR;

APB_Bridge DUT (
    .HRESETn    (HRESETn),
    .HCLK       (HCLK),
    .HSEL       (HSEL),
    .HADDR      (HADDR),
    .HWDATA     (HWDATA),
    .HRDATA     (HRDATA),
    .HWRITE     (HWRITE),
    .HSIZE      (HSIZE),
    .HBURST     (HBURST),
    .HPROT      (HPROT),
    .HTRANS     (HTRANS),
    .HMASTLOCK  (HMASTLOCK),
    .HREADYOUT  (HREADYOUT),
    .HREADY     (HREADY),
    .HRESP      (HRESP),
    .PRESETn    (PRESETn),
    .PCLK       (PCLK),
    .PSEL       (PSEL),
    .PENABLE    (PENABLE),
    .PPROT      (PPROT),
    .PWRITE     (PWRITE),
    .PSTRB      (PSTRB),
    .PADDR      (PADDR),
    .PWDATA     (PWDATA),
    .PRDATA     (PRDATA),
    .PREADY     (PREADY),
    .PSLVERR    (PSLVERR)
);


localparam AHB_CLK = 2;
localparam APB_CLK = 32;

always #(AHB_CLK/2) HCLK = ~HCLK;
always #(APB_CLK/2) PCLK = ~PCLK;


logic [31:0] data_array_tb[];
logic [15:0] address_array_tb[];
logic        write_array_tb[];
logic [1:0]  trans_array_tb[];
logic [2:0]  burst_array_tb[];
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
HBURST <= 2'b0;
HPROT <= 3'b0;
HTRANS <= 2'b0;
HMASTLOCK <= 2'b0;
HREADY <= 1'b1;
PRESETn <= 1'b1;
PCLK <= 1'b0;
PRDATA <= 32'b0;
PREADY <= 1'b1;
PSLVERR <= 1'b0;
repeat(4)
@(posedge PCLK);
end
endtask

task reset;
begin
    PRESETn <= 1'b0;
    HRESETn <= 1'b0;
    repeat(5)
    @(posedge HCLK);
    PRESETn <= 1'b1;
    HRESETn <= 1'b1;
    repeat(5)
    @(posedge HCLK);
end
endtask

task AHB_Master;
  input logic [31:0] data_array[];
  input logic [15:0] address_array[];
  input logic        write_array[];
  input logic [1:0] trans_array[];
  input logic [2:0] burst_array[];
  input logic [2:0] size_array[];
  input logic       sel_array[];

  
  // Address and Data Phase
  @(posedge HCLK);

  HADDR <= address_array[0];
  HWRITE <= write_array[0];
  HTRANS <= trans_array[0];
  HBURST <= burst_array[0];
  HSIZE <= size_array[0];
  HSEL <= sel_array[0];

  @(posedge HCLK);
  
  
  for (int i = 1; i < address_array.size(); i++) 
  begin
    // Wait for Hready
    while (!HREADYOUT) 
    begin
      @(posedge HCLK);
    end
    if (write_array[i-1]) 
    begin
        HWDATA <= data_array[i-1];
    end

    HADDR <= address_array[i];
    HWRITE <= write_array[i];
    HTRANS <= trans_array[i];
    HBURST <= burst_array[i];
    HSIZE <= size_array[i];
    HSEL <= sel_array[i];

    @(posedge HCLK);

  end
  while (!HREADYOUT) 
  begin
      @(posedge HCLK);
  end

  @(posedge HCLK);
  if (write_array[address_array.size()-1]) 
  begin
    HWDATA <= data_array[address_array.size()-1];
  end
  
endtask


initial begin
    $dumpfile("bridge_tb.vcd");
    $dumpvars;
    
    initilaize();
    reset();

    data_array_tb       =   {32'hABCDABCD, 32'h12341234, 32'd17, 32'h18082704,32'd1,32'd2,32'd3};    
    address_array_tb    =   {16'h4002,16'h2028,16'h1379,16'h5254,16'h207A,16'h3501,16'h1720};        
    write_array_tb      =   {1,1,0,1,1,0,0};    
    trans_array_tb      =   {2'b10, 2'b10, 2'b10, 2'b10,2'b10,2'b10,2'b10};    
    burst_array_tb      =   {0,0,0,0,0,0,0};    
    size_array_tb       =   {3'b010, 3'b010, 3'b010, 3'b010,3'b010,3'b010,3'b010};
    sel_array_tb        =   {1,0,1,1,1,1,0};

    AHB_Master(data_array_tb
    ,address_array_tb
    ,write_array_tb
    ,trans_array_tb
    ,burst_array_tb
    ,size_array_tb
    ,sel_array_tb);

    #100;
    $stop;

end


endmodule