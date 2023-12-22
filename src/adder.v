`timescale 1ps/1ps
module adder (input [7:0] A,
              input [7:0] B,
              input C0,
              output [7:0] R,
              output C);

    assign {C, R} = A + B + C0;

endmodule
