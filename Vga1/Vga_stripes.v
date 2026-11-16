`timescale 1ns / 1ps

module vga_stripes (
    input  wire        vidon,
    input  wire [9:0]  hc,
    input  wire [9:0]  vc,
    input  wire [0:31] M,
    input  wire [7:0]  sw,
    output wire [3:0]  rom_addr4,
    output reg  [3:0]  red,
    output reg  [3:0]  green,
    output reg  [3:0]  blue
);

    parameter hbp = 10'd144;
    parameter vbp = 10'd31;

    // ========================================================
    // 1. HÁTTÉR CSÍKOK (29. dia feladatai)
    // ========================================================
    // SW[0]: 0 = Vízszintes csíkok, 1 = Függőleges csíkok
    wire [9:0] stripe_coord = (sw[0]) ? (hc - hbp) : (vc - vbp);

    // SW[1]: Csíkszélesség (0 = 16 pixel, 1 = 32 pixel)
    wire stripe_bit = (sw[1]) ? stripe_coord[5] : stripe_coord[4];

    // SW[2]: 0 = 2 szín (Piros/Zöld), 1 = 3 szín (Piros/Zöld/Kék)
    wire [9:0] div_coord = (sw[1]) ? (stripe_coord >> 5) : (stripe_coord >> 4);
    wire [1:0] mod3 = div_coord % 3;

    reg [3:0] bg_r, bg_g, bg_b;

    always @(*) begin
        bg_r = 4'h0;
        bg_g = 4'h0;
        bg_b = 4'h0;

        if (sw[2] == 1'b1) begin
            // 3 színű csíkok
            case (mod3)
                2'd0: bg_r = 4'hF; // Piros
                2'd1: bg_g = 4'hF; // Zöld
                2'd2: bg_b = 4'hF; // Kék
                default: bg_r = 4'hF;
            endcase
        end else begin
            // 2 színű csíkok (Piros és Zöld váltakozva)
            bg_r = {4{stripe_bit}};
            bg_g = {4{~stripe_bit}};
            bg_b = 4'h0;
        end
    end

    // ========================================================
    // 2. ELŐTÉR BETŰK (40. dia feladatai)
    // ========================================================
    // SW[3]: Betűméret (0 = 1x méret: 32x16, 1 = 2x méret: 64x32 zoom)
    wire [10:0] W = (sw[3]) ? 11'd64 : 11'd32;
    wire [10:0] H = (sw[3]) ? 11'd32 : 11'd16;

    // SW[6], SW[7]: Kezdőpont dinamikus eltolása
    wire [10:0] C1 = (sw[6]) ? 11'd280 : 11'd100; // X koordináta
    wire [10:0] R1 = (sw[7]) ? 11'd220 : 11'd80;  // Y koordináta

    wire [10:0] rel_x = hc - hbp - C1;
    wire [10:0] rel_y = vc - vbp - R1;

    // Nagyítás esetén a mintavételezési koordinátákat felezzük
    wire [10:0] sample_x = (sw[3]) ? (rel_x >> 1) : rel_x;
    wire [10:0] sample_y = (sw[3]) ? (rel_y >> 1) : rel_y;

    assign rom_addr4 = sample_y[3:0];

    // Aktív sprite terület vizsgálata
    wire spriteon = (hc >= C1 + hbp) && (hc < C1 + hbp + W) &&
                    (vc >= R1 + vbp) && (vc < R1 + vbp + H);

    wire pixel_bit = M[sample_x[4:0]];

    // SW[4]: Színmód (0 = Fehér betűk, 1 = Betűnként eltérő szín)
    wire [1:0] char_index = sample_x[4:3]; // 4 darab 8 pixeles karakteroszlop

    // ========================================================
    // 3. PIXEL GENERÁLÁS (RÉTEGEZÉS)
    // ========================================================
    always @(*) begin
        red   = 4'h0;
        green = 4'h0;
        blue  = 4'h0;

        if (vidon == 1'b1) begin
            if (spriteon && pixel_bit) begin
                // Előtér: Betűk kirajzolása
                if (sw[4] == 1'b1) begin
                    case (char_index)
                        2'd0: begin red = 4'hF; green = 4'h0; blue = 4'h0; end // 1. betű: Piros
                        2'd1: begin red = 4'h0; green = 4'hF; blue = 4'h0; end // 2. betű: Zöld
                        2'd2: begin red = 4'h0; green = 4'h0; blue = 4'hF; end // 3. betű: Kék
                        2'd3: begin red = 4'hF; green = 4'hF; blue = 4'h0; end // 4. betű: Sárga
                    endcase
                end else begin
                    red   = 4'hF;
                    green = 4'hF;
                    blue  = 4'hF;
                end
            end else begin
                // Háttér: Csíkok kirajzolása
                red   = bg_r;
                green = bg_g;
                blue  = bg_b;
            end
        end
    end

endmodule
