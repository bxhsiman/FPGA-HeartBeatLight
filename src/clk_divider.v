module clk_divider 
#(
   parameter   clk_freq = 12_000_000 // 12MHz
) 
(
    input         clk,
    input         rst_n,
    input [3:0]   period, // 4'd1: 2400Hz, 4d'2: 1200Hz, 4d'3: 800Hz, 4d'4: 600Hz 
    output reg    clk_out
);
    reg [31:0] counter;
    reg [31:0] period_values [3:0];

    // Initialize period values
    initial begin
        period_values[0] = clk_freq / 2400 / 2;
        period_values[1] = clk_freq / 1200 / 2;
        period_values[2] = clk_freq / 800 / 2;
        period_values[3] = clk_freq / 600 / 2;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            counter <= counter + 1;
            case (period)
                4'd1: begin
                    if (counter == period_values[0]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                4'd2: begin
                    if (counter == period_values[1]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                4'd3: begin
                    if (counter == period_values[2]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                4'd4: begin
                    if (counter == period_values[3]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                default: begin
                    counter <= 0;
                    clk_out <= 0;
                end
            endcase
        end
    end
endmodule
