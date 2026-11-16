`timescale 1ns / 1ps

module tl_top (
    input wire CLK100MHZ,
    input wire BTNC,
    output wire [2:0] LED,
    output wire [6:0] a_to_g,
    output wire dp,
    output wire [7:0] an
);

    wire cy_wire;
    wire [3:0] timer_wire;

    rategen U1 (
        .clk(CLK100MHZ),
        .rst(BTNC),
        .cy(cy_wire)
    );

    TL U2 (
        .clk(CLK100MHZ),
        .rst(BTNC),
        .ce(cy_wire),
        .led(LED),
        .timer(timer_wire)
    );

    hex7seg U3 (
        .x(timer_wire),
        .a_to_g(a_to_g),
        .dp(dp),
        .an(an)
    );

endmodule
