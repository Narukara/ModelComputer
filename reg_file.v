`timescale 1ps/1ps
module reg_file (input CLK,
                 input WE,          // write enable
                 input [3:0] WA,    // write address
                 input [3:0] RA1,   // read  address 1
                 input [3:0] RA2,   // read  address 2
                 input [7:0] WD,    // data to be write
                 output [7:0] D1,   // data(read) 1
                 output [7:0] D2);  // data(read) 2
    
    reg [7:0] register [15:0];
    initial begin
        register[0] = 8'b0; // zero register
    end

    assign D1 = register[RA1];
    assign D2 = register[RA2];

    always @(negedge CLK) begin
        if (WE && WA != 0) begin    // zero register is read-only
            #10 register[WA] = WD;
        end
    end

endmodule
