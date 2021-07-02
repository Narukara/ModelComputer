`include "sl.v"
`include "sr.v"
`include "adder.v"
`timescale 1ps/1ps
/**
/* Operation code
/* add 000
/* sub 100
/* and 001
/* nor 010
/* sft 011
/* gt  101
/* lt  110
/* eq  111
 **/
module ALU (input [7:0] A,
            input [7:0] B,
            input [2:0] op,  // operation code
            output [7:0] R); // result
    
    wire [7:0] notB = ~B;
    wire [7:0] B_or_notB = (op[2] == 0)? B : notB;
    wire [7:0] add_sub;
    adder a(A, B_or_notB, op[2], add_sub, );

    wire [7:0] and_ = A & B;

    wire [7:0] nor_ = ~(A | B);

    wire [7:0] lr, rr;
    sl l(A, B[2:0], lr);
    sr r(A, notB[2:0], rr);
    wire [7:0] s = (B[7] == 0)? lr : rr;

    wire [7:0] cal_r =
    (op[1:0] == 2'b00)? add_sub :
    (op[1:0] == 2'b01)? and_    :
    (op[1:0] == 2'b10)? nor_    :
    s;

    wire gt = A > B;
    wire lt = A < B;
    wire eq = A == B;
    wire [3:0] comp_temp = {eq, lt, gt, 1'b0};
    wire comp_r = comp_temp[op[1:0]];

    wire if_cal = ~((op[2] & op[0]) | (op[2] & op[1]));

    assign R = (if_cal == 1)? cal_r : {7'b0, comp_r};

endmodule
