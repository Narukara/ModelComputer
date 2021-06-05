`include "ALU.v"
`include "PC.v"
`include "decoder.v"
`include "reg_file.v"
`include "ROM.v"
`timescale 1ps/1ps
module main ();
    
    reg CLK;
    initial begin
        CLK = 1'b1;
        repeat (416) begin
            #100 CLK = ~CLK;
        end
    end
    
    wire [7:0] nPC, PCout;
    PC pc(nPC, CLK, PCout);

    wire [7:0] PC_1;
    adder add(PCout, 8'b0, 1'b1, PC_1, );
    
    wire [15:0] code;
    ROM rom(PCout, code);
    
    wire [2:0] PC_MUX, ALU_OP;
    wire [1:0] REG_MUX;
    wire Bias_MUX, REG_WE, A_MUX, RAM_WE;
    decoder dec(code[15:12], PC_MUX, Bias_MUX, REG_WE, REG_MUX, A_MUX, ALU_OP, RAM_WE);
    
    wire [7:0] WD, D1, D2;
    reg_file rf(CLK, REG_WE, code[11:8], code[7:4], code[3:0], WD, D1, D2);

    wire [1:0] PC_MUX_;
    assign PC_MUX_[0] = PC_MUX[1];
    assign PC_MUX_[1] = PC_MUX[2] & (PC_MUX[1] | (PC_MUX[0] ~^ D2[0]));
    assign nPC =
    (PC_MUX_ == 2'b 00)? PC_1 :
    (PC_MUX_ == 2'b 01)? code[7:0]:
    (PC_MUX_ == 2'b 10)? code[11:4]:
    D2;

    wire [3:0] bias = (Bias_MUX)? code[11:8] : code[7:4];
    wire [7:0] bias_ex = {bias[3], bias[3], bias[3], bias[3], bias[3:0]};

    wire [7:0] R;
    ALU alu((A_MUX)? bias_ex : D1, D2, ALU_OP, R);

    assign WD =
    (REG_MUX == 2'b11)? R :
    (REG_MUX == 2'b01)? code[7:0] :
    (REG_MUX == 2'b10)? PC_1 :
    8'b0;  // RAM_D

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            wire [7:0] register = rf.register[i];
        end
    endgenerate

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end
    
endmodule
