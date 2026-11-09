`timescale 1ns / 1ps

module bounce (
    input wire clk,
    input wire clr,
    input wire go,
    input wire [7:0] sw,
    output wire [9:0] c1,
    output wire [9:0] r1
);

    reg signed [10:0] clv, rlv;
    reg signed [10:0] dcv, drv;
    reg calc;

    wire [9:0] C1max;
    assign C1max = (sw[2] == 1'b1) ? 10'd200 : 10'd400;

    parameter R1max = 10'd320;

    wire signed [10:0] step_val;
    assign step_val = 11'sd1 + {9'd0, sw[1:0]};

    always @(posedge clk or posedge clr) begin
        if (clr == 1'b1) begin
            clv <= 11'sd80;
            rlv <= 11'sd140;
            dcv <= 11'sd1;
            drv <= -11'sd1;
            calc <= 1'b0;
        end else if (go == 1'b1) begin
            calc <= 1'b1;
        end else if (calc == 1'b1) begin
            if (clv <= 0)
                dcv <= (sw[3] == 1'b1) ? (step_val + 11'sd1) : step_val;
            else if (clv >= C1max)
                dcv <= (sw[3] == 1'b1) ? -(step_val + 11'sd1) : -step_val;

            if (rlv <= 0)
                drv <= step_val;
            else if (rlv >= R1max)
                drv <= -step_val;

            clv <= clv + dcv;
            rlv <= rlv + drv;
        end
    end

    assign c1 = clv[9:0];
    assign r1 = rlv[9:0];

endmodule
