//呼吸灯驱动
//create by siman 2024/3/11
[TBD] 再加入一个高速时钟用于PWM生成
module LED_mode2_driver(
    input clk,
    input rst_n,
    output reg [7:0] led_out // 8个LED的输出
);
    reg [9:0] counter = 0; // 用于计数当前LED状态持续的周期数
    reg [2:0] current_led = 0; // 用于跟踪当前点亮的LED，3位可以表示0到7的范围
    reg dir; // 用于指示当前LED的亮度变化方向
    reg [7:0] duty; // 用于指示当前LED的亮度
    reg [7:0] duty_counter; //占空比计数器

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // 异步复位
            dir <= 1'd0;
            counter <= 10'd0;
            current_led <= 8'd0;
            led_out <= 8'b0000_0000; // 初始化时所有LED熄灭
        end
        else begin
            if (counter == 300) begin
                // 前300个周期内，LED占空比依次增加
                dir <= 1'd1;
                counter <= counter + 1;
            end
            else if (counter == 600) begin
                dir <= 1'd0;
                counter <= 10'd0;
            end
        end
    end
endmodule