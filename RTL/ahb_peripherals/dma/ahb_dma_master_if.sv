/////////////////////////////////////////////////////////////////////
////  AHB DMA master interface                                   ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
module ahb_dma_master (
clk_i,
rst_n_i,
transfer_size,
address      ,
write_enable ,
write_data   ,
error        ,
read_data    ,
slave_wait   ,
burst_seq_transfer,
burst,
no_trnasfer,
mHSIZE,
mHRDATA,
mHRESP,
mHREADY,
mHWRITE,
mHBURST,
mHADDR,
mHTRANS,
mHWDATA,
seq_transfer_desc,
burst_desc,
no_trnasfer_linked_list_dascreptor,  
mHPROT);
//==========================================================================
// Inputs & Outputs
//==========================================================================
input              clk_i        ;
input	             rst_n_i      ;
input      [31:0]  mHRDATA      ;
input              mHRESP       ;
input              mHREADY      ;
output     [2:0]   mHSIZE       ;
output             mHWRITE      ;
output     [2:0]   mHBURST      ;
output     [31:0]  mHADDR       ;
output     [1:0]   mHTRANS      ;
output     [31:0]  mHWDATA      ;
output     [3:0]   mHPROT       ;
input      [2:0]   transfer_size;
input      [31:0]  address      ;
input              write_enable ;
input      [31:0]  write_data   ;
output             error        ;
output     [31:0]  read_data    ;
output             slave_wait   ;
input              burst_seq_transfer;
input      [2:0]   burst;
input              no_trnasfer;
input              seq_transfer_desc;
input              burst_desc;
input              no_trnasfer_linked_list_dascreptor;
//==========================================================================
// Internal signls
//==========================================================================
  reg             HWRITE_REG;
  reg [31:0]      HADDR_REG;
  reg [31:0]      HWDATA_REG,HWDATA_REG_REG;
  reg             HRESP_REG;
  reg [2:0]       HSIZE_REG;
  reg [31:0]      HRDATA_REG;
  reg [2:0]       HBURST_REG;
  reg [1:0]       HTRANS_REG;
  reg [1:0]       HTRANS_REG_REG;
//==========================================================================
// Main code
//==========================================================================
  always_comb
  begin
  if(!no_trnasfer || !no_trnasfer_linked_list_dascreptor)
  begin
    if(burst_seq_transfer || seq_transfer_desc)
    HTRANS_REG = 2'b11;
    else
    HTRANS_REG = 2'b10;
  end
  else
  HTRANS_REG = 2'b00;
  end

  always@(posedge clk_i or negedge rst_n_i)
  begin
    if(!rst_n_i)
    HTRANS_REG_REG <= 2'b0;
    else 
    HTRANS_REG_REG <= HTRANS_REG;
  end

  assign mHTRANS  =  HTRANS_REG_REG ;
  /////////////////////////////////////////////////////////////////////
  always_comb
  begin
      case(transfer_size)
        3'b0: begin
          HWDATA_REG_REG = {write_data[7:0],write_data[7:0],write_data[7:0],write_data[7:0]};
        end     
        3'b1:begin
          HWDATA_REG_REG = {write_data[15:0],write_data[15:0]};
        end
        default: HWDATA_REG_REG = write_data;
      endcase
  end
  /////////////////////////////////////////////////////////////////////
  always@(posedge clk_i or negedge rst_n_i)
  begin
    if(!rst_n_i)
    HADDR_REG <= 32'b0;
    else if(mHREADY)
    HADDR_REG <= address;
  end
  /////////////////////////////////////////////////////////////////////
  always@(posedge clk_i or negedge rst_n_i)
  begin
  if(!rst_n_i)
  begin
    HWRITE_REG <= 1'b0;
    HWDATA_REG <= 32'b0;
    HRESP_REG <= 1'b0 ;
  end
  else
  begin
    HRESP_REG <= mHRESP ;
    if(mHREADY)
    begin
    HWDATA_REG <= HWDATA_REG_REG ;
    end
    HWRITE_REG <= write_enable;
  end
  end 
  /////////////////////////////////////////////////////////////////////
  always@(posedge clk_i or negedge rst_n_i)
  begin
    if(!rst_n_i)
      HSIZE_REG <= 3'b0;
    else if(!no_trnasfer)
      HSIZE_REG <= transfer_size;
    else if(!no_trnasfer_linked_list_dascreptor)
      HSIZE_REG <= 3'b10;
    else  
      HSIZE_REG <= 3'b0;
  end
  /////////////////////////////////////////////////////////////////////
  always_comb
  begin
      case(mHSIZE)
        3'b0: begin
          case (HADDR_REG[1:0])
            2'b0  : HRDATA_REG = {24'b0,mHRDATA[7:0]};
            2'b1  : HRDATA_REG = {24'b0,mHRDATA[15:8]};
            2'b10 : HRDATA_REG = {24'b0,mHRDATA[23:16]};
            2'b11 : HRDATA_REG = {24'b0,mHRDATA[31:24]};
          endcase
        end     
        3'b1:begin
          case (HADDR_REG[1])
            1'b0 : HRDATA_REG = {16'b0,mHRDATA[15:0]};
            1'b1 : HRDATA_REG = {16'b0,mHRDATA[31:16]};
          endcase
        end
        default: HRDATA_REG = mHRDATA;
      endcase
  end
  /////////////////////////////////////////////////////////////////////
  always@(posedge clk_i or negedge rst_n_i)
  begin
    if(!rst_n_i)
    HBURST_REG <= 3'b0;
    else if(!no_trnasfer || !no_trnasfer_linked_list_dascreptor)
    begin 
      if(burst_desc)
        HBURST_REG <= 3'b11;//INCR4
      else
        HBURST_REG <= burst ;
    end
    else
      HBURST_REG <= 3'b0;
  end
  /////////////////////////////////////////////////////////////////////
  assign mHBURST       = HBURST_REG;
  assign mHWRITE       = HWRITE_REG;
  assign mHADDR        = address ;
  assign mHPROT        = 4'b0;
  assign mHWDATA       = HWDATA_REG ;
  assign error         = HRESP_REG;
  assign slave_wait    = !mHREADY;
  assign read_data     = HRDATA_REG;
  assign mHSIZE        = HSIZE_REG;

endmodule