`timescale 1ns / 1ps

module clock_pulse (
    input wire inp,
    input wire clk,
    input wire clr,
    output wire outp
);

    reg delay1, delay2, delay3;

    always @(posedge clk or posedge clr) begin
        if (clr == 1'b1) begin
            delay1 <= 1'b0;
            delay2 <= 1'b0;
            delay3 <= 1'b0;
        end else begin
            delay1 <= inp;
            delay2 <= delay1;
            delay3 <= delay2;
        end
    end

    assign outp = delay1 & delay2 & ~delay3;

endmodule
