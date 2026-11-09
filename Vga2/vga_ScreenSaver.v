`timescale 1ns / 1ps

module vga_ScreenSaver (
    input wire vidon,
    input wire [9:0] hc, vc,
    input wire [11:0] M,
    input wire [9:0] C1, R1,
    output wire [15:0] rom_addr16,
    output reg [3:0] red, green, blue
);

    parameter hbp = 10'd144;
    parameter vbp = 10'd31;
    parameter W = 240;
    parameter H = 160;

    wire [10:0] xpix, ypix;
    wire [16:0] rom_addr1, rom_addr2;
    reg spriteon;

    assign ypix = vc - vbp - R1;
    assign xpix = hc - hbp - C1;

    assign rom_addr1 = {ypix, 7'b0000000} + {1'b0, ypix, 6'b000000} + {2'b00, ypix, 5'b00000} + {3'b000, ypix, 4'b0000};
    assign rom_addr2 = rom_addr1 + {8'b00000000, xpix};
    assign rom_addr16 = rom_addr2[15:0];

    always @(*) begin
        if ((hc >= C1 + hbp + 2) && (hc < C1 + hbp + W) && (vc >= R1 + vbp) && (vc < R1 + vbp + H))
            spriteon = 1'b1;
        else
            spriteon = 1'b0;
    end

    always @(*) begin
        red = 4'h0;
        green = 4'h0;
        blue = 4'h0;

        if ((spriteon == 1'b1) && (vidon == 1'b1)) begin
            red = M[11:8];
            green = M[7:4];
            blue = M[3:0];
        end
    end

endmodule
