`timescale 1ns / 1ps

module vga_tb;

    // Tesztbemenetek
    reg clk;
    reg btnc;
    reg [7:0] sw;

    // Megfigyelendő VGA kimenetek
    wire vga_hs;
    wire vga_vs;
    wire [3:0] vga_r;
    wire [3:0] vga_g;
    wire [3:0] vga_b;

    // Főmodul példányosítása
    vga_stripes_top uut (
        .CLK100MHZ(clk),
        .BTNC(btnc),
        .SW(sw),
        .VGA_HS(vga_hs),
        .VGA_VS(vga_vs),
        .VGA_R(vga_r),
        .VGA_G(vga_g),
        .VGA_B(vga_b)
    );

    // 100 MHz-es bemeneti órajel generálása (10 ns periódus: 5 ns alacsony, 5 ns magas)
    always #5 clk = ~clk;

    initial begin
        // 1. Kezdőállapot: Reset bekapcsolva
        clk = 0;
        btnc = 1;
        sw = 8'b00000000;

        // Reset felengedése 100 ns után
        #100;
        btnc = 0;

        // 2. Alapállapot futtatása (Vízszintes csíkok, "DMH" felirat, 1x méret)
        #80000; // ~2 teljes vízszintes sor ideje (2 * 32 us)

        // 3. Függőleges csíkok + 2x betűméret bekapcsolása (SW[0]=1, SW[3]=1)
        sw = 8'b00001001;
        #80000;

        // 4. "INFO" felirat + többszínű betűk bekapcsolása (SW[5]=1, SW[4]=1)
        sw = 8'b00111001;
        #80000;

        $finish;
    end

endmodule
