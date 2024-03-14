//心跳灯驱动
// Created by siman 2024/3/11

module LED_mode1_driver 
#(
    parameter PERIOD = 2400  //1s BASE PERIOD
) 
(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);

    reg [11:0] counter = 0; 
    reg [2:0] current_led = 0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // 异步复位
            counter <= 10'd0;
            current_led <= 8'd0;
            led_out <= 8'b0000_0000; // 初始化时所有LED熄灭
        end
        else begin
            if (counter < PERIOD / 4) begin
                led_out <= 1 << current_led;
                counter <= counter + 1;
            end
            else if (counter >= PERIOD / 4 && counter < PERIOD / 2) begin
                led_out <= 8'b0000_0000;
                counter <= counter + 1;
            end
            else if (counter >= PERIOD / 2 && counter < PERIOD / 4 * 3) begin
                led_out <= 1 << current_led;
                counter <= counter + 1;
            end
            else if (counter >= PERIOD / 2 && counter < PERIOD / 4 * 3) begin
                led_out <= 8'b0000_0000;
                counter <= counter + 1;
            end
            else begin
                counter <= 10'd0;
                current_led <= current_led + 1;
                if (current_led >= 7) begin
                    // 确保current_led循环回0
                    current_led <= 8'd0;
                end
            end
        end
    end
endmodule
