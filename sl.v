`timescale 1ps/1ps
// shift left
module sl (input [7:0] A,
           input [2:0] B,
           output [7:0] r);

    wire [7:0] l1 = (B[0] == 1)? {A[6:0], 1'b0} : A;
    wire [7:0] l2 = (B[1] == 1)? {l1[5:0], 2'b0} : l1;
    wire [7:0] l4 = (B[2] == 1)? {l2[3:0], 4'b0} : l2;
    
    assign r = l4;

endmodule
