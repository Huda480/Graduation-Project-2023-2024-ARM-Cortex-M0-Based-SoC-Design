/////////////////////////////////////////////////////////////////////
////  AHB DMA slave interface                                    ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
module ahb_dma_slave (
clk_i,
rst_n_i,
sHADDR,
sHWDATA,
sHWRITE,
sHREADYOUT,
sHSIZE,
sHBURST,
sHSEL,
sHTRANS,
sHRDATA,
sHRESP,
sHREADY,
sHPROT,
slave_write_data,
slave_write_address,
slave_read_address,
slave_write_enable,
slave_read_enable,
slave_read_data,
slave_error);
//==========================================================================
// Inputs & Outputs
//==========================================================================
input           clk_i;
input	        rst_n_i;
input   [31:0]  sHADDR;
input   [31:0]  sHWDATA;
input           sHWRITE;
input   [ 2:0]  sHSIZE;
input   [ 2:0]  sHBURST;
input           sHSEL;
input   [ 1:0]  sHTRANS;
input           sHREADY;
input   [ 3:0]  sHPROT;
output          sHREADYOUT;
output  [31:0]  sHRDATA;
output          sHRESP;
output  [31:0]  slave_write_data;
output  [31:0]  slave_write_address;
output  [31:0]  slave_read_address;
output          slave_write_enable;
output          slave_read_enable;
input   [31:0]  slave_read_data;
input           slave_error;
//==========================================================================
// Internal signls
//==========================================================================
    reg        HSEL_REG;
    reg [31:0] HADDR_REG;
    reg        HWRITE_REG;
    reg [2:0]  HSIZE_REG;
    reg [31:0] HWDATA_REG;
    reg [31:0] HRDATA_REG;
    reg [1:0]  HTRANS_REG;
//==========================================================================
// Main code
//==========================================================================
    assign slave_write_address   = HADDR_REG;
    assign slave_read_address    = (sHSEL & !sHWRITE)? sHADDR : 32'b0;
    assign slave_write_enable    = HWRITE_REG && HSEL_REG;
    assign slave_read_enable     = !sHWRITE && sHSEL;
    assign slave_write_data      = HWDATA_REG;
    assign sHRDATA               = HRDATA_REG;
    assign sHREADYOUT            = 1'b1;
    assign sHRESP                = slave_error;
    /////////////////////////////////////////////////////////////////////
    always@(posedge clk_i or negedge rst_n_i)
    begin
        if(!rst_n_i)
        HSEL_REG <= 1'b0 ;
        else
        HSEL_REG <= sHSEL;
    end
    /////////////////////////////////////////////////////////////////////
    always@(posedge clk_i or negedge rst_n_i)
    begin
        if(!rst_n_i)
        HADDR_REG <= 32'b0;
        else if(sHSEL)
        HADDR_REG <= sHADDR;
        else
        HADDR_REG <= 32'b0;
    end
    /////////////////////////////////////////////////////////////////////
    always@(posedge clk_i or negedge rst_n_i)
    begin
        if(!rst_n_i)
        HWRITE_REG <= 1'b0;
        else if(sHSEL)
        HWRITE_REG <= sHWRITE;
        else
        HWRITE_REG <= 1'b0;
    end
    /////////////////////////////////////////////////////////////////////
    always@(posedge clk_i or negedge rst_n_i)
    begin
        if(!rst_n_i)
        HSIZE_REG <= 3'b0;
        else if(sHSEL)
        HSIZE_REG <= sHSIZE;
        else
        HSIZE_REG <= 3'b0;
    end
    /////////////////////////////////////////////////////////////////////
    always_comb
    begin
        if(HSEL_REG && HWRITE_REG)
        begin
        case(HSIZE_REG)
        3'b0: HWDATA_REG <= {24'b0,sHWDATA[7:0]};
        3'b1: HWDATA_REG <= {16'b0,sHWDATA[15:0]};
        default:HWDATA_REG <= sHWDATA;
        endcase
        end
        else
        HWDATA_REG <= 32'b0 ;
    end
    /////////////////////////////////////////////////////////////////////
    always_comb
    begin
        if(HSEL_REG && !HWRITE_REG)
        begin
        case(HSIZE_REG)
        3'b0: HRDATA_REG <= {24'b0,slave_read_data[7:0]};
        3'b1: HRDATA_REG <= {16'b0,slave_read_data[15:0]};
        default:HRDATA_REG <= slave_read_data;
        endcase
        end
        else
        HRDATA_REG <= 32'b0 ;
    end

endmodule
