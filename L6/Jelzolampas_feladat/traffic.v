`timescale 1ns / 1ps

module traffic (
    input wire clk,
    input wire clr,
    output reg [5:0] lights
);

    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;
    parameter S6 = 3'b110;
    parameter S7 = 3'b111;

    parameter SEC5 = 4'b1111;
    parameter SEC1 = 4'b0011;

    reg [2:0] state;
    reg [3:0] count;

    always @(posedge clk or posedge clr) begin
        if (clr == 1'b1) begin
            state <= S0;
            count <= 4'd0;
        end else begin
            case (state)
                S0: begin
                    if (count < SEC5) begin
                        state <= S0;
                        count <= count + 4'd1;
                    end else begin
                        state <= S1;
                        count <= 4'd0;
                    end
                end
                S1: begin
                    if (count < SEC1) begin
                        state <= S1;
                        count <= count + 4'd1;
                    end else begin
                        state <= S2;
                        count <= 4'd0;
                    end
                end
                S2: begin
                    if (count < SEC1) begin
                        state <= S2;
                        count <= count + 4'd1;
                    end else begin
                        state <= S3;
                        count <= 4'd0;
                    end
                end
                S3: begin
                    if (count < SEC1) begin
                        state <= S3;
                        count <= count + 4'd1;
                    end else begin
                        state <= S4;
                        count <= 4'd0;
                    end
                end
                S4: begin
                    if (count < SEC5) begin
                        state <= S4;
                        count <= count + 4'd1;
                    end else begin
                        state <= S5;
                        count <= 4'd0;
                    end
                end
                S5: begin
                    if (count < SEC1) begin
                        state <= S5;
                        count <= count + 4'd1;
                    end else begin
                        state <= S6;
                        count <= 4'd0;
                    end
                end
                S6: begin
                    if (count < SEC1) begin
                        state <= S6;
                        count <= count + 4'd1;
                    end else begin
                        state <= S7;
                        count <= 4'd0;
                    end
                end
                S7: begin
                    if (count < SEC1) begin
                        state <= S7;
                        count <= count + 4'd1;
                    end else begin
                        state <= S0;
                        count <= 4'd0;
                    end
                end
                default: begin
                    state <= S0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            S0: lights = 6'b001100;
            S1: lights = 6'b010100;
            S2: lights = 6'b100100;
            S3: lights = 6'b100110;
            S4: lights = 6'b100001;
            S5: lights = 6'b100010;
            S6: lights = 6'b100100;
            S7: lights = 6'b110100;
            default: lights = 6'b001100;
        endcase
    end

endmodule
