//心跳灯驱动
// Created by siman 2024/3/11

module LED_mode1_driver (
    input clk,
    input rst_n,
    output reg [7:0] led_out
);

    reg [9:0] counter = 0; // 用于计数当前LED状态持续的周期数
    reg [2:0] current_led = 0; // 用于跟踪当前点亮的LED，3位可以表示0到7的范围

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // 异步复位
            counter <= 10'd0;
            current_led <= 8'd0;
            led_out <= 8'b0000_0000; // 初始化时所有LED熄灭
        end
        else begin
            if (counter < 300) begin
                // 前300个周期内，点亮当前LED
                led_out <= 1 << current_led;
                counter <= counter + 1;
            end
            else if (counter >= 300 && counter < 600) begin
                // 后300个周期内，熄灭当前LED
                led_out <= 8'b0000_0000;
                counter <= counter + 1;
            end
            else begin
                // 计数器达到600，重置计数器，准备切换到下一个LED
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
