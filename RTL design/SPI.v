module SPI (
    input MOSI ,  
    input SS_n , 
    input clk , 
    input rst_n , 
    output reg [9:0] rx_data , 
    output reg rx_valid , 
    input  tx_valid , 
    input  [7:0] tx_data ,
    output reg MISO
) ; 

parameter IDLE = 3'b000 ; 
parameter WRITE = 3'b001 ;
parameter CHK_CMD= 3'b010 ;
parameter READ_ADD = 3'b011 ;
parameter READ_DATA  = 3'b100 ;

reg addr_check ;           // To check if available read address   
reg [3:0] counter_up  ;
reg [7:0] tx_data_reg ;
reg output_available ;     // High during reading data 
(* fsm_encoding = "one_hot" *)
reg [2:0] cs , ns ;       // Current and nesxt state

always @ (posedge clk) begin    // State memory           
    if (!rst_n) 
        cs <= IDLE ; 
    else 
        cs <= ns ; 
end

always @ (*) begin        // Next state logic 
    case (cs) 
        IDLE : begin 
            if (SS_n) 
                ns = IDLE ; 
            else 
                ns = CHK_CMD ; 
        end
        CHK_CMD : begin 
            if (MOSI) begin 
                if (addr_check) 
                    ns = READ_DATA ; 
                else 
                    ns = READ_ADD ; 
            end 
            else 
                ns = WRITE ; 
        end
        WRITE : begin 
            if (SS_n) 
                ns = IDLE ; 
            else 
                ns = WRITE ; 
        end
        READ_ADD : begin 
            if (SS_n) 
                ns = IDLE ; 
            else 
                ns = READ_ADD ; 
        end
        READ_DATA : begin 
            if (SS_n) 
                ns = IDLE ; 
            else 
                ns = READ_DATA ; 
        end
        default : ns = IDLE ; 
    endcase
end

always @ (posedge clk ) begin   //new output logic
    case (cs) 
        IDLE : begin 
            rx_valid <= 0 ; 
            rx_data <= 0 ; 
            counter_up <= 0 ; 
            output_available <= 0 ;
            MISO <= 0 ;
        end
        WRITE : begin 
            if (counter_up == 9 )  begin 
                rx_data [counter_up] <= MOSI ;
                counter_up <= 0 ; 
                rx_valid <= 1 ; 
            end
            else begin 
                rx_data [counter_up] <= MOSI ; 
                counter_up <= counter_up + 1 ; 
                rx_valid <= 0 ; 
            end
        end
        READ_ADD : begin 
            if (counter_up == 9 )  begin 
                rx_data [counter_up] <= MOSI ;
                counter_up <= 0 ; 
                rx_valid <= 1 ; 
            end
            else begin 
                rx_data [counter_up] <= MOSI ; 
                counter_up <= counter_up + 1 ; 
                rx_valid <= 0 ; 
                addr_check <= 1 ; 
            end
        end
        READ_DATA : begin 
            if (tx_valid ) begin 
                output_available <= 1 ;
                tx_data_reg <= tx_data ; 
                counter_up <= 0 ;
            end
            else if (output_available)begin 
                if (counter_up == 7 )  begin
                    MISO <= tx_data_reg  [7 - counter_up ] ;
                    counter_up <= 0 ; 
                end
                else begin 
                    MISO <= tx_data_reg  [7 - counter_up ] ;
                    counter_up <= counter_up + 1 ; 
                end
            end
            else begin
                if (counter_up == 9 )  begin 
                    rx_data [counter_up] <= MOSI ;
                    counter_up <= 0 ; 
                    rx_valid <= 1 ; 
                end
                else begin 
                    rx_data [counter_up] <= MOSI ; 
                    counter_up <= counter_up + 1 ; 
                    rx_valid <= 0 ; 
                    addr_check <= 0 ; 
                end
            end
        end
    endcase 
    
end
endmodule
