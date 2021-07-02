`timescale 1ps/1ps
module PC (input [7:0] nPC,         // next PC (to be write)
           input CLK,
           output reg [7:0] out);   // PC now
    
    always @(negedge CLK) begin
        #10 out <= nPC;
    end

    initial begin
        out <= 8'b0;
    end

endmodule
