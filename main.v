`include "ALU.v"
`include "PC.v"
`include "decoder.v"
`include "reg_file.v"
`include "ROM.v"
`include "RAM.v"
`timescale 1ps/1ps
module main ();
    
    reg CLK;
    initial begin
        CLK = 1'b1;
        repeat (4096) begin
            #100 CLK = ~CLK;
        end
    end
    
    wire [7:0] nPC, PCout; // next PC, now PC
    PC pc(nPC, CLK, PCout);

    wire [7:0] PC_1; // PC + 1
    adder add(PCout, 8'b0, 1'b1, PC_1, );
    
    wire [15:0] instr; // instruction from ROM
    ROM rom(PCout, instr);
    
    // all control signal
    wire [2:0] PC_MUX, ALU_OP;
    wire [1:0] REG_MUX;
    wire Bias_MUX, REG_WE, A_MUX, RAM_WE;
    decoder dec(instr[15:12], PC_MUX, Bias_MUX, REG_WE, REG_MUX, A_MUX, ALU_OP, RAM_WE);
    
    wire [7:0] WD, D1, D2; // data to be write, data1(read), data2(read)
    reg_file rf(CLK, REG_WE, instr[11:8], instr[7:4], instr[3:0], WD, D1, D2);

    wire [1:0] PC_MUX_;
    assign PC_MUX_[0] = PC_MUX[1];
    assign PC_MUX_[1] = PC_MUX[2] & (PC_MUX[1] | (PC_MUX[0] ~^ D2[0]));
    assign nPC =
    (PC_MUX_ == 2'b 00)? PC_1 :         // +1
    (PC_MUX_ == 2'b 01)? instr[7:0]:    // jal
    (PC_MUX_ == 2'b 10)? instr[11:4]:   // jif
    D2;                                 // jr

    wire [3:0] bias = (Bias_MUX)? instr[11:8] : instr[7:4];
    wire [7:0] bias_ex = {bias[3], bias[3], bias[3], bias[3], bias[3:0]}; // bias extended

    wire [7:0] R; // result
    ALU alu((A_MUX)? bias_ex : D1, D2, ALU_OP, R);

    wire [7:0] RAM_D; // data(read)
    RAM ram(CLK, RAM_WE, D1, R, RAM_D);

    assign WD =
    (REG_MUX == 2'b11)? R :             // Result from ALU
    (REG_MUX == 2'b01)? instr[7:0] :    // Immediate number
    (REG_MUX == 2'b10)? PC_1 :          // PC + 1
    RAM_D;                              // data from RAM

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
