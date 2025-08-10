module RAM ( 
    input clk , 
    input rst_n , 
    input [9:0] din , 
    input rx_valid , 
    output reg [7:0] dout , 
    output reg tx_valid 
) ; 

parameter  MEM_DEPTH = 256 ; 
parameter ADDR_SIZE = 8 ;

reg [7:0] mem [MEM_DEPTH - 1 : 0] ; 
reg [ADDR_SIZE - 1: 0] read_add ; 
reg [ADDR_SIZE - 1: 0] write_add ;

always @(posedge clk ) begin 
    if (!rst_n) begin
        dout <= 0 ; 
        tx_valid <= 0 ;
    end
    else begin 
        tx_valid <= 0 ; 
        if (rx_valid) begin 
            case (din [9:8]) 
                2'b00 : begin 
                    write_add <= din [7:0] ;
                end
                2'b01 : begin
                    mem [write_add] <= din [7:0] ; 
                end
                2'b10 : begin  
                    read_add <= din [7:0] ; 
                end
                2'b11 : begin  
                    dout <= mem [read_add] ;
                    tx_valid <= 1 ; 
                end
            endcase
        end
    end
end
endmodule