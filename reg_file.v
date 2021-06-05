`timescale 1ps/1ps
module reg_file (input CLK,
                 input WE,
                 input [3:0] WA,
                 input [3:0] RA1,
                 input [3:0] RA2,
                 input [7:0] WD,
                 output [7:0] D1,
                 output [7:0] D2);
    
    reg [7:0] register [15:0];
    initial begin
        register[0] = 8'b0;
    end

    assign D1 = register[RA1];
    assign D2 = register[RA2];

    always @(negedge CLK) begin
        if (WE && WA != 0) begin
            #10 register[WA] = WD;
        end
    end

endmodule
