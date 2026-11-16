`timescale 1ns / 1ps

module TL (
    input wire clk,
    input wire rst,
    input wire ce,
    output reg [2:0] led,
    output reg [3:0] timer
);

    parameter PIROS = 2'b00;
    parameter PS    = 2'b01;
    parameter ZOLD  = 2'b10;
    parameter SARGA = 2'b11;

    reg [1:0] state_reg;
    reg [1:0] next_state;

    always @(posedge clk) begin
        if (rst)
            state_reg <= PIROS;
        else if (ce)
            state_reg <= next_state;
    end

    always @(*) begin
        case (state_reg)
            PIROS: begin
                if (timer == 4'd0)
                    next_state = PS;
                else
                    next_state = PIROS;
            end
            PS: begin
                if (timer == 4'd0)
                    next_state = ZOLD;
                else
                    next_state = PS;
            end
            ZOLD: begin
                if (timer == 4'd0)
                    next_state = SARGA;
                else
                    next_state = ZOLD;
            end
            SARGA: begin
                if (timer == 4'd0)
                    next_state = PIROS;
                else
                    next_state = SARGA;
            end
            default: next_state = PIROS;
        endcase
    end

    always @(posedge clk) begin
        if (rst)
            timer <= 4'd5;
        else if (ce) begin
            case (state_reg)
                PIROS: begin
                    if (timer == 4'd0)
                        timer <= 4'd2;
                    else
                        timer <= timer - 4'd1;
                end
                PS: begin
                    if (timer == 4'd0)
                        timer <= 4'd5;
                    else
                        timer <= timer - 4'd1;
                end
                ZOLD: begin
                    if (timer == 4'd0)
                        timer <= 4'd2;
                    else
                        timer <= timer - 4'd1;
                end
                SARGA: begin
                    if (timer == 4'd0)
                        timer <= 4'd5;
                    else
                        timer <= timer - 4'd1;
                end
            endcase
        end
    end

    always @(*) begin
        case (state_reg)
            PS:      led = 3'b110;
            PIROS:   led = 3'b100;
            SARGA:   led = 3'b010;
            ZOLD:    led = 3'b001;
            default: led = 3'b100;
        endcase
    end

endmodule
