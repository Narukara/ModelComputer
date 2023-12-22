`timescale 1ps/1ps
// shift right
module sr (input [7:0] A,
           input [2:0] B,
           output [7:0] r);
    
    wire [7:0] pre = {1'b0, A[7:1]};
    wire [7:0] r1 = (B[0] == 1)? {A[7], pre[7:1]} : pre;
    wire [7:0] r2 = (B[1] == 1)? {A[7], A[7], r1[7:2]} : r1;
    wire [7:0] r4 = (B[2] == 1)? {A[7], A[7], A[7], A[7], r2[7:4]} : r2;

    assign r = r4;

endmodule
