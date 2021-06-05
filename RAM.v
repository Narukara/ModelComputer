`timescale 1ps/1ps
module RAM (input CLK,
            input WE,
            input [7:0] WD,
            input [7:0] RA_WA,
            output [7:0] D);
    
    reg [7:0] ram [255:0];

    assign D = ram[RA_WA];

    always @(negedge CLK) begin
        if (WE) begin
            #10 ram[RA_WA] <= WD;
        end
    end

endmodule
