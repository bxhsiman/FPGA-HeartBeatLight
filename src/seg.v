//段码屏译码模块
//by ChatGpt 2024/2/06
module seg_display (
    input clk,
    input rst_n,
    input [7:0] value,  // 8-bit input value (0-255) 
    output [8:0] seg1,  // 9-segment display for the first digit
    output [8:0] seg2   // 9-segment display for the second digit
);
    // 4-bit values for each hex digit
    wire [3:0] digit1 = value[7:4]; // High nibble
    wire [3:0] digit2 = value[3:0]; // Low nibble

    // Convert 4-bit values to 9-segment display
    nine_seg_decoder decoder1(.binary_value(digit1), .seg(seg1));
    nine_seg_decoder decoder2(.binary_value(digit2), .seg(seg2));

endmodule

// Module to convert 4-bit binary to 9-segment display
module nine_seg_decoder (
    input [3:0] binary_value,
    output reg [8:0] seg
);

    // Convert binary to 9-segment (assuming common anode display)
    always @(binary_value) begin
        case (binary_value)
            4'h0: seg = 9'b111111000; // 0
            4'h1: seg = 9'b011000000; // 1
            4'h2: seg = 9'b110110100; // 2
            4'h3: seg = 9'b111100100; // 3
            4'h4: seg = 9'b011001100; // 4
            4'h5: seg = 9'b101101100; // 5
            4'h6: seg = 9'b101111100; // 6
            4'h7: seg = 9'b111000000; // 7
            4'h8: seg = 9'b111111100; // 8
            4'h9: seg = 9'b111101100; // 9
            4'hA: seg = 9'b111011100; // A
            4'hB: seg = 9'b001111100; // b
            4'hC: seg = 9'b100111000; // C
            4'hD: seg = 9'b011110100; // d
            4'hE: seg = 9'b100111100; // E
            4'hF: seg = 9'b100011100; // F
            default: seg = 9'b000000001; // Blank display for undefined values
        endcase
    end
endmodule
