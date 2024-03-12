//呼吸灯驱动
//create by siman 2024/3/11

module LED_mode2_driver(
    input clk,
    input rst_n,
    output reg [7:0] led_out // 8个LED的输出
);
    reg [11:0] counter = 0; // 用于计数当前LED状态持续的周期数
    reg [2:0] current_led = 0; // 用于跟踪当前点亮的LED，3位可以表示0到7的范围
    
    reg [11:0] duty; // 用于指示当前LED的亮度
    reg [11:0] duty_counter; //占空比计数器

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // 异步复位
            duty = 12'd0;
            counter = 12'd0;
            current_led = 8'd0;
        end
        else begin
            if (counter < 1200) begin
                // 前300个周期内，LED占空比依次增加
                counter = counter + 1;
                if(counter % 40 == 0) begin
                    duty = duty + 1;
                end
            end
            else if (counter == 2400) begin
                counter = 12'd0;
                current_led = (current_led == 8'd7) ? 8'd0 : (current_led + 1);
            end
            else begin
                // 后300个周期内，LED占空比依次减小
                counter = counter + 1;
                if(counter % 40 == 0) begin
                    duty = duty - 1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            led_out = 8'b0000_0000;
            duty_counter = 8'd0;
        end
        else if(duty_counter < 5)begin
            duty_counter = duty_counter + 1;
            led_out = (duty_counter <= duty) ? (1 << current_led) : (8'b0000_0000); 
        end
        else begin
            duty_counter = 8'd0;
        end
    end
endmodule