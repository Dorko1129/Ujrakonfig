`timescale 1ns / 1ps

module traffic_lights_top (
    input wire CLK100MHZ,
    input wire BTNC,
    output wire [5:0] LED,
    output wire LED17_R,
    output wire LED17_G,
    output wire LED17_B,
    output wire LED16_R,
    output wire LED16_G,
    output wire LED16_B
);

    wire clk3;
    wire [5:0] lights_bus;

    assign LED = lights_bus;

    clkdiv U1 (
        .clk(CLK100MHZ),
        .clr(BTNC),
        .clk3(clk3)
    );

    traffic U2 (
        .clk(clk3),
        .clr(BTNC),
        .lights(lights_bus)
    );

    rgb_driver U3 (
        .clk(CLK100MHZ),
        .lamp_state(lights_bus[5:3]),
        .led_r(LED17_R),
        .led_g(LED17_G),
        .led_b(LED17_B)
    );

    rgb_driver U4 (
        .clk(CLK100MHZ),
        .lamp_state(lights_bus[2:0]),
        .led_r(LED16_R),
        .led_g(LED16_G),
        .led_b(LED16_B)
    );

endmodule
