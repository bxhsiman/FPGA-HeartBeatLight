//呼吸灯驱动
//create by siman 2024/3/11

module LED_mode2_driver(
    input clk,
    input rst_n,
    input [3:0] led_select, // 选择哪个LED灯呼吸
    output reg [7:0] led_out // 8个LED的输出
);
    reg [8:0] counter;
    reg [3:0] brightness;
    wire [7:0] led_mask;

    // Generate the mask for the selected LED
    assign led_mask = 8'b00000001 << led_select;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            led_out <= 8'b0;
            counter <= 9'd0;
            brightness <= 4'd0;
        end
        else begin
            if (counter < 300) begin
                // First 300 clock cycles, increase brightness
                if (brightness < 15) begin
                    brightness <= brightness + 1;
                end
            end
            else if (counter >= 300 && counter < 600) begin
                // Next 300 clock cycles, decrease brightness
                if (brightness > 0) begin
                    brightness <= brightness - 1;
                end
            end
            
            // Reset counter to loop brightness change
            if (counter >= 599) begin
                counter <= 9'd0;
            end
            else begin
                counter <= counter + 1;
            end

            // Apply brightness to the selected LED(s)
            if (brightness > (counter % 16)) begin
                led_out <= led_mask; // Use mask to light up selected LED
            end else begin
                led_out <= 8'd0; // Turn off LEDs not matching the brightness criteria
            end
        end
    end
endmodule
