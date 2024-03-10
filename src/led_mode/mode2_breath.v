//呼吸灯驱动
//create by siman 2024/3/11

module LED_mode2_driver(
    input clk,
    input rst_n,
    output reg led_out 
);
    reg [8:0] counter;
    reg [3:0] brightness;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            led_out <= 1'b0;
            counter <= 9'd0;
            brightness <= 4'd0;
        end
        else begin
            if (counter < 300) begin
                // First 300 clock cycles, led goes from darkest to brightest
                if (brightness < 15) begin
                    brightness <= brightness + 1;
                end
            end
            else if (counter >= 300 && counter < 600) begin
                // Last 300 clock cycles, led goes from brightest to darkest
                if (brightness > 0) begin
                    brightness <= brightness - 1;
                end
            end
            
            // output led
            if (brightness > counter % 16) begin
                led_out <= 1'b1;
            end
            else begin
                led_out <= 1'b0;
            end
            
            // counter increment
            counter <= counter + 1;
        end
    end
endmodule
