`timescale 1ps/1ps
module decoder (input [3:0] op,
                output [2:0] PC_MUX,
                output Bias_MUX,
                output REG_WE,
                output [1:0] REG_MUX,
                output A_MUX,
                output [2:0] ALU_OP,
                output RAM_WE);
    
    assign PC_MUX[0] = op[0];
    assign PC_MUX[1] = op[3] & op[1] & ~op[0];
    assign PC_MUX[2] = op[3] & op[2] & ~(op[0] & op[1]);

    assign Bias_MUX = &op;

    assign REG_WE = ~(op[2] & op[3]);

    assign REG_MUX = {~op[3], ~op[3]} | op[1:0];

    assign A_MUX = op[3];

    assign ALU_OP = {~&op, ~&op, ~&op} & op[2:0];

    assign RAM_WE = &op;

endmodule