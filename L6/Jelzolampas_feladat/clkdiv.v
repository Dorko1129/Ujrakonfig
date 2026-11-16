`timescale 1ns / 1ps

module clkdiv (
    input wire clk,
    input wire clr,
    output wire clk3
);

    reg [24:0] q;

    always @(posedge clk or posedge clr) begin
        if (clr == 1'b1)
            q <= 25'd0;
        else
            q <= q + 25'd1;
    end

    assign clk3 = q[24];

endmodule
