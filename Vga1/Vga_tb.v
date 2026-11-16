`timescale 1ns / 1ps

module vga_tb;

    reg clk;
    reg btnc;
    reg [7:0] sw;


    wire vga_hs;
    wire vga_vs;
    wire [3:0] vga_r;
    wire [3:0] vga_g;
    wire [3:0] vga_b;


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


    always #5 clk = ~clk;

    initial begin

        clk = 0;
        btnc = 1;
        sw = 8'b00000000;
        
        #100;
        btnc = 0;

        #80000;


        sw = 8'b00001001;
        #80000;

        sw = 8'b00111001;
        #80000;

        $finish;
    end

endmodule
