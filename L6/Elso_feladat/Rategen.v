`timescale 1ns / 1ps

module rategen (
    input wire clk,
    input wire rst,
    output wire cy
);

    reg [26:0] Q;

    always @(posedge clk) begin
        if (rst | cy)
            Q <= 27'd0;
        else
            Q <= Q + 27'd1;
    end

    assign cy = (Q == 27'd99999999);

endmodule
