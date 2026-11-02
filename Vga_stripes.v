`timescale 1ns / 1ps

module vga_stripes (
    input  wire       vidon,
    input  wire [9:0] hc,
    input  wire [9:0] vc,
    output reg  [3:0] red,
    output reg  [3:0] green,
    output reg  [3:0] blue
);

    always @(*) begin
        red   = 4'h0;
        green = 4'h0;
        blue  = 4'h0;

        if (vidon == 1'b1) begin
            // Ha vc[4] == 1 -> Piros, ha vc[4] == 0 -> Zöld
            red   = {4{vc[4]}};
            green = {4{~vc[4]}};
            blue  = 4'h0;
        end
    end

endmodule
