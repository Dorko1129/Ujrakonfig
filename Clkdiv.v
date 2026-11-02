`timescale 1ns / 1ps

module clkdiv (
    input  wire clk,
    input  wire clr,
    output wire clk190,
    output wire clk25m,
    output wire clk3
);
    reg [24:0] q;

    always @(posedge clk or posedge clr) begin
        if (clr == 1'b1)
            q <= 25'd0;
        else
            q <= q + 1'b1;
    end

    assign clk190 = q[18]; // 190 Hz
    assign clk25m = q[1];  // 100 MHz / 4 = 25 MHz
    assign clk3   = q[24]; // ~3 Hz
endmodule
