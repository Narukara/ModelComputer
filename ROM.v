`timescale 1ps/1ps
module ROM (input [7:0] A,
            output [15:0] D);

    reg [15:0] rom [255:0];

    assign #10 D = rom[A];

    initial begin
        rom[0] = 16'b1001_0001_0000_0001;
        rom[1] = 16'b0000_0001_0001_0001;
        rom[2] = 16'b0000_0010_0001_0001;
        rom[3] = 16'b1110_0000_0000_0001;
    end

endmodule
