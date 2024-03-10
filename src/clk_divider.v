module clk_divider #(
   parameter   clk_freq = 12_000_000 // 12MHz
) 
(
    input         clk,
    input         rst_n,
    input [1:0]   period, // 00: 600Hz, 01: 300Hz, 10: 200Hz, 11: 150Hz 
    output reg    clk_out
);
    reg [31:0] counter;
    reg [31:0] period_values [3:0];

    // Initialize period values
    initial begin
        period_values[0] = clk_freq / 600 / 2;
        period_values[1] = clk_freq / 300 / 2;
        period_values[2] = clk_freq / 200 / 2;
        period_values[3] = clk_freq / 150 / 2;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            counter <= counter + 1;
            case (period)
                2'b00: begin
                    if (counter == period_values[0]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                2'b01: begin
                    if (counter == period_values[1]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                2'b10: begin
                    if (counter == period_values[2]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                2'b11: begin
                    if (counter == period_values[3]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
            endcase
        end
    end
endmodule
