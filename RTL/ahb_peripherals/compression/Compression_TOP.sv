module Compression_TOP 
#(
    //=======================================================   
    // Parameters                                               
    //======================================================= 
    parameter int OUT_WIDTH         = 16,       //  DCT Output Width.
    parameter int IN_WIDTH          = 8,        //  DCT Input Width.
    parameter int DIM               = 8,        //  Row/Column Dimension.
    parameter int MEM_UNCOMP_DEPTH  = 8192,     //  Uncompressed Image Memory Depth.
    parameter int AHB_WIDTH         = 32 ,       //  AHB Bus Width.
    parameter     IMG1 = "C:/Users/20155/OneDrive - Faculty of Engineering Ain Shams University/Desktop/compress/image1.txt"  ,
    parameter     IMG2 = "C:/Users/20155/OneDrive - Faculty of Engineering Ain Shams University/Desktop/compress/image2.txt"  ,
    parameter     IMG3 = "C:/Users/20155/OneDrive - Faculty of Engineering Ain Shams University/Desktop/compress/image3.txt"  ,
    parameter     IMG4 = "C:/Users/20155/OneDrive - Faculty of Engineering Ain Shams University/Desktop/compress/image4.txt"  ,
    parameter     IMG5 = "C:/Users/20155/OneDrive - Faculty of Engineering Ain Shams University/Desktop/compress/image5.txt"  ,
    parameter     IMG6 = "C:/Users/20155/OneDrive - Faculty of Engineering Ain Shams University/Desktop/compress/image6.txt"  ,
    parameter     IMG7 = "C:/Users/20155/OneDrive - Faculty of Engineering Ain Shams University/Desktop/compress/image7.txt"  ,
    parameter     IMG8 = "C:/Users/20155/OneDrive - Faculty of Engineering Ain Shams University/Desktop/compress/image8.txt"   
)
(
    //======================================================= 
    // Controls   
    //=======================================================     
    input wire logic            clk,
    input wire logic            rst,
    //=======================================================   
    // Inputs
    //=======================================================   
    input wire logic            enable,
    //=======================================================   
    // Outputs
    //=======================================================      
    output logic [AHB_WIDTH-1:0]    wr_data,
    output logic                    valid_out
    //=======================================================    
);
	//=======================================================
	// Local Parameters
	//=======================================================
    localparam int ROW_COUNTER_WIDTH = $clog2(DIM);
    localparam int INDEX_WIDTH = ROW_COUNTER_WIDTH <<1;
	//=======================================================
	// Segmentation Signals
	//=======================================================
    logic segmentation_valid_out;
    logic [IN_WIDTH-1:0] segmentation_data_out   [DIM];
	//=======================================================
    // DCT Signals
	//=======================================================    
    logic signed [OUT_WIDTH-1:0] dct_out [DIM];
    logic valid_out_dct, finish;
	//=======================================================
    // Thresholding Signals     
	//=======================================================
    logic signed [OUT_WIDTH-1:0] max_values [4];
    logic [INDEX_WIDTH-1:0] index[4];
    logic signed [OUT_WIDTH-1:0] dc_value;
    logic valid_out_thresholding;
	//=======================================================
    // Compression Signals 
	//=======================================================
    logic [7:0] data_out_compression;
    logic counter_reduction;
    logic valid_out_compression;
    //=======================================================
    // Segmentation
    //=======================================================
    segmentation_top 
    #(
        .DIM      (DIM)  ,
        .DEPTH    (MEM_UNCOMP_DEPTH),
        .WIDTH    (IN_WIDTH),
        .IMG1 (IMG1 ),
        .IMG2 (IMG2 ),
        .IMG3 (IMG3 ),
        .IMG4 (IMG4 ),
        .IMG5 (IMG5 ),
        .IMG6 (IMG6 ),
        .IMG7 (IMG7 ),
        .IMG8 (IMG8 )           
    ) image_segmentation_top_inst 
    (
        .clk      (clk), 
        .rst      (rst),
        .enable   (enable), 
        .we(1'b0),
        .din(), 
        .valid_out(segmentation_valid_out),
        .data_out (segmentation_data_out)  
    );

    //=======================================================
    // DCT
    //=======================================================
    mcm_2d_dct 
    #(
        .IN_WIDTH (IN_WIDTH ),
        .WIDTH    (OUT_WIDTH),
        .DIM      (DIM      )
    ) mcm_2d_dct_inst 
    (
        .clk      (clk),
        .rst      (rst),
        .valid_in (segmentation_valid_out),
        .in_val   (segmentation_data_out),
        .out_val_reg  (dct_out),
        .valid_out_reg(valid_out_dct),
        .finish   (finish)
    );

	//=======================================================
    // Adaptive Thresholding
    //=======================================================
    adaptive_thresholding 
    #(
        .WIDTH(OUT_WIDTH), 
        .DEPTH(DIM)
    ) 
    thresholding 
    (
        .clk(clk),
        .rst(rst),
        .data_in(dct_out),
        .valid_in(valid_out_dct),
        .max_values(max_values),
        .index(index),
        .dc_value(dc_value),
        .valid_out(valid_out_thresholding)
    );

	//=======================================================
    // Block Compression
    //=======================================================
    block_compression 
    #(
        .WIDTH(OUT_WIDTH),
        .DEPTH(12)
    )
    compression 
    (
        .clk(clk),
        .rst(rst),
        .data_in(max_values),
        .index_in(index),
        .valid_in(valid_out_thresholding),
        .data_out(data_out_compression),
        .counter_reduction(counter_reduction),
        .valid_out(valid_out_compression)
    );

	//=======================================================
    // Deserializer
    //=======================================================
    compression_deserializer 
    #(
        .WIDTH(OUT_WIDTH),
        .AHB_WIDTH(AHB_WIDTH)
    ) 
    deserializer 
    (
        .clk(clk),
        .rst(rst),
        .data_in(data_out_compression),
        .dc_value_in(dc_value),
        .counter_zero(counter_reduction),
        .valid_in_thresholding(valid_out_thresholding),
        .valid_in_compression(valid_out_compression),
        .data_out(wr_data),
        .valid_out(valid_out)
    );

    //=======================================================

endmodule