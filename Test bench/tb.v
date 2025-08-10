module tb2 () ; 

reg clk ; 
reg rst_n ; 
wire MISO ; 
reg MOSI , SS_n ;  

SPI_WRAPPER DUT (
    MOSI , clk ,  rst_n , SS_n , MISO
) ; 

initial begin
     clk = 0 ; 
     forever begin
        #1 clk = ~clk ; 
     end
end

initial begin
    $readmemh ("mem.dat" , DUT.RAM_inst.mem) ; 
    rst_n = 0 ; 
    @(negedge clk ) ; 
    rst_n = 1 ;  
    SS_n = 0 ; 
    @(negedge clk ) ;
    MOSI = 0 ;            //writte mode
    @(negedge clk ) ; 
    repeat (8) begin      // writing address 
        MOSI = 1 ; 
        @(negedge clk ) ; 
    end
    repeat (2) begin     
        MOSI = 0 ;       
        @ (negedge clk );
    end
    SS_n = 1 ; 
    @ (negedge clk ) ; 
    SS_n = 0 ;     
    @ (negedge clk ) ; 
    MOSI = 0 ;            //writte mode
    @(negedge clk ) ; 
    repeat (4) begin      //write data 
        MOSI = 0 ; 
        @(negedge clk ) ;
        MOSI = 1 ;
        @(negedge clk ) ;
    end
    MOSI = 1 ; 
    @ (negedge clk ) ; 
    MOSI = 0 ; 
    @ (negedge clk ) ; 
    SS_n = 1  ; 
    @ (negedge clk) ;
    SS_n = 0 ; 
    @ (negedge clk) ; 
    MOSI = 1 ;           // reading mode
    @ (negedge clk) ; 
    repeat (8) begin     // reading address 
        MOSI = 1 ; 
        @(negedge clk ) ; 
    end
    MOSI = 0 ; 
    @ (negedge  clk ) ; 
    MOSI = 1 ; 
    @ (negedge clk) ;
    SS_n = 1  ; 
    @ (negedge clk) ;
    SS_n = 0 ; 
    @ (negedge clk) ; 
    MOSI = 1 ;          // reading mode
    repeat (10) begin   // reading dummies 
        MOSI = 1 ; 
        @(negedge clk ) ; 
    end
    repeat (10) @(negedge clk) ; 
     SS_n = 1  ; 
    repeat(3)@ (negedge clk) ;
    $stop ; 
end
endmodule 