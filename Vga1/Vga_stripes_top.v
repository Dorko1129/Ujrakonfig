`timescale 1ns / 1ps

module vga_stripes_top (
    input  wire        CLK100MHZ,
    input  wire        BTNC,
    input  wire [7:0]  SW,
    output wire        VGA_HS,
    output wire        VGA_VS,
    output wire [3:0]  VGA_R,
    output wire [3:0]  VGA_G,
    output wire [3:0]  VGA_B
);

    wire clk25;
    wire clr;
    wire vidon;
    wire [9:0]  hc, vc;
    wire [0:31] M;
    wire [3:0]  rom_addr4;

    assign clr = BTNC;

    // 1. Órajelosztó: 100 MHz -> 25 MHz
    clkdiv U1 (
        .clk(CLK100MHZ),
        .clr(clr),
        .clk190(),
        .clk25m(clk25),
        .clk3()
    );

    // 2. VGA vezérlő és szinkronizáció
    vga_640x480 U2 (
        .clk(clk25),
        .clr(clr),
        .hsync(VGA_HS),
        .vsync(VGA_VS),
        .hc(hc),
        .vc(vc),
        .vidon(vidon)
    );

    // 3. PROM memória ("DMH" vagy "INFO" kiválasztása SW[5]-tel)
    prom_DMH U4 (
        .sel(SW[5]),
        .addr(rom_addr4),
        .M(M)
    );

    // 4. Képtartalom megjelenítő (Csíkok + Betűk egyben)
    vga_stripes U3 (
        .vidon(vidon),
        .hc(hc),
        .vc(vc),
        .M(M),
        .sw(SW),
        .rom_addr4(rom_addr4),
        .red(VGA_R),
        .green(VGA_G),
        .blue(VGA_B)
    );

endmodule
