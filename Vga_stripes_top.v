`timescale 1ns / 1ps

module vga_stripes_top (
    input  wire       CLK100MHZ,
    input  wire       BTNC,
    output wire       VGA_HS,
    output wire       VGA_VS,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B
);

    wire clk25;
    wire clr;
    wire vidon;
    wire [9:0] hc, vc;

    assign clr = BTNC;

    // Órajelosztó: 100 MHz -> 25 MHz
    clkdiv U1 (
        .clk(CLK100MHZ),
        .clr(clr),
        .clk190(),
        .clk25m(clk25),
        .clk3()
    );

    // VGA szinkronizáció
    vga_640x480 U2 (
        .clk(clk25),
        .clr(clr),
        .hsync(VGA_HS),
        .vsync(VGA_VS),
        .hc(hc),
        .vc(vc),
        .vidon(vidon)
    );

    // Képtartalom (Csíkok)
    vga_stripes U3 (
        .vidon(vidon),
        .hc(hc),
        .vc(vc),
        .red(VGA_R),
        .green(VGA_G),
        .blue(VGA_B)
    );

endmodule
