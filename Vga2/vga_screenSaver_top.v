`timescale 1ns / 1ps

module vga_screenSaver_top (
    input wire CLK100MHZ,
    input wire BTNL,
    input wire BTNC,
    input wire [7:0] SW,
    output wire VGA_HS,
    output wire VGA_VS,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B
);

    wire clk25, clk190, clr, vidon, go1;
    wire [9:0] hc, vc, C1, R1;
    wire [11:0] M;
    wire [15:0] rom_addr16;

    assign clr = BTNC;

    clkdiv U1 (
        .clk(CLK100MHZ),
        .clr(clr),
        .clk190(clk190),
        .clk25(clk25),
        .clk3()
    );

    vga_640x480 U2 (
        .clk(clk25),
        .clr(clr),
        .hsync(VGA_HS),
        .vsync(VGA_VS),
        .hc(hc),
        .vc(vc),
        .vidon(vidon)
    );

    vga_ScreenSaver U3 (
        .vidon(vidon),
        .hc(hc),
        .vc(vc),
        .M(M),
        .C1(C1),
        .R1(R1),
        .rom_addr16(rom_addr16),
        .red(VGA_R),
        .green(VGA_G),
        .blue(VGA_B)
    );

    loons240x160 U4 (
        .clka(clk25),
        .addra(rom_addr16),
        .douta(M)
    );

    clock_pulse U5 (
        .inp(BTNL),
        .clk(clk190),
        .clr(clr),
        .outp(go1)
    );

    bounce U6 (
        .clk(clk190),
        .clr(clr),
        .go(go1),
        .sw(SW),
        .c1(C1),
        .r1(R1)
    );

endmodule
