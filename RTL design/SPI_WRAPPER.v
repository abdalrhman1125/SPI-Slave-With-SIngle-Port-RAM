module SPI_WRAPPER (
    input MOSI ,  
    input clk  , 
    input rst_n , 
    input SS_n ,
    output MISO 
) ; 

parameter  MEM_DEPTH = 256 ; 
parameter ADDR_SIZE = 8 ; 

wire [9:0] rx_data ; 
wire rx_valid ; 
wire [7:0] tx_data ; 
wire tx_valid ; 

SPI SPI_SLAVE_inst (
    .clk(clk), 
    .rst_n(rst_n) , 
    .SS_n(SS_n) , 
    .MOSI(MOSI) , 
    .rx_data(rx_data) , 
    .rx_valid (rx_valid) , 
    .tx_valid (tx_valid) , 
    .tx_data (tx_data) ,
    .MISO (MISO) 
) ; 

RAM #(.MEM_DEPTH(MEM_DEPTH ) ,.ADDR_SIZE(ADDR_SIZE) ) RAM_inst  (
    .clk(clk) , 
    .rst_n (rst_n) , 
    .din(rx_data) , 
    .rx_valid(rx_valid) , 
    .dout(tx_data) ,
    .tx_valid(tx_valid) 
) ; 

endmodule