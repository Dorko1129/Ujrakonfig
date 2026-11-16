`timescale 1ns / 1ps

module rgb_driver (
    input wire clk,
    input wire [2:0] lamp_state,
    output reg led_r,
    output reg led_g,
    output reg led_b
);

    reg [7:0] pwm_cnt;

    always @(posedge clk) begin
        pwm_cnt <= pwm_cnt + 8'd1;
    end

    wire pwm_25 = (pwm_cnt < 8'd64);
    wire pwm_10 = (pwm_cnt < 8'd25);

    always @(*) begin
        led_r = 1'b0;
        led_g = 1'b0;
        led_b = 1'b0;

        case (lamp_state)
            3'b100: begin
                led_r = pwm_25;
            end
            3'b110: begin
                led_r = pwm_25;
                led_g = pwm_10;
            end
            3'b010: begin
                led_r = pwm_25;
                led_g = pwm_25;
            end
            3'b001: begin
                led_g = pwm_25;
            end
            default: begin
                led_r = pwm_25;
            end
        endcase
    end

endmodule
