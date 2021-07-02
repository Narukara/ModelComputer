`timescale 1ps/1ps
module RAM (input CLK,
            input WE,           // write enable
            input [7:0] WD,     // data to be write
            input [7:0] RA_WA,  // read/write address
            output [7:0] D);    // data(read)
    
    reg [7:0] ram [255:0];
    
    assign D = ram[RA_WA];
    
    always @(negedge CLK) begin
        if (WE) begin
            #10 ram[RA_WA] <= WD;
        end
    end
    
endmodule
