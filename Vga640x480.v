`timescale 1ns / 1ps

module vga_640x480 (
    input  wire       clk,       // 25 MHz órajel
    input  wire       clr,       // Reset (BTNC)
    output reg        hsync,     // Vízszintes szinkronjel
    output reg        vsync,     // Függőleges szinkronjel
    output reg  [9:0] hc,        // Vízszintes pixelszámláló (0..799)
    output reg  [9:0] vc,        // Függőleges sorszámláló (0..520)
    output reg        vidon      // Aktív képernyőterület jelzés
);

    // Időzítési paraméterek (640x480 @ 60Hz, 25 MHz órajel mellett)
    parameter hpixels = 10'd800; // Teljes sor hossza (128 + 16 + 640 + 16)
    parameter vlines  = 10'd521; // Képkocka sorainak száma (2 + 29 + 480 + 10)
    
    parameter hbp = 10'd144;     // Vízszintes szinkron + back porch (128 + 16)
    parameter hfp = 10'd784;     // Képtartalom vége (144 + 640)
    parameter vbp = 10'd31;      // Függőleges szinkron + back porch (2 + 29)
    parameter vfp = 10'd511;     // Képtartalom vége (31 + 480)

    reg vsenable;

    // Vízszintes számláló
    always @(posedge clk or posedge clr) begin
        if (clr == 1'b1) begin
            hc <= 10'd0;
            vsenable <= 1'b0;
        end else begin
            if (hc == hpixels - 1'b1) begin
                hc <= 10'd0;
                vsenable <= 1'b1; // Sor végén engedélyezzük a sorszámláló léptetését
            end else begin
                hc <= hc + 1'b1;
                vsenable <= 1'b0;
            end
        end
    end

    // Függőleges számláló
    always @(posedge clk or posedge clr) begin
        if (clr == 1'b1) begin
            vc <= 10'd0;
        end else if (vsenable == 1'b1) begin
            if (vc == vlines - 1'b1)
                vc <= 10'd0;
            else
                vc <= vc + 1'b1;
        end
    end

    // HSYNC generálása (aktív alacsony a Sync Pulse alatt: 0..127)
    always @(*) begin
        if (hc < 10'd128)
            hsync = 1'b0;
        else
            hsync = 1'b1;
    end

    // VSYNC generálása (aktív alacsony a Sync Pulse alatt: 0..1)
    always @(*) begin
        if (vc < 10'd2)
            vsync = 1'b0;
        else
            vsync = 1'b1;
    end

    // Aktív videóterület kapuzása
    always @(*) begin
        if ((hc >= hbp) && (hc < hfp) && (vc >= vbp) && (vc < vfp))
            vidon = 1'b1;
        else
            vidon = 1'b0;
    end

endmodule
