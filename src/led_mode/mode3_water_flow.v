module LED_mode3_driver(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);
// PWM PERIOD == 10
reg [11:0] counter = 0;
reg [11:0] pwm_counter[7:0];
reg [11:0] pwm_duty[7:0];
reg [2:0] current_led = 0;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        current_led <= 0;
        for (i = 0; i < 8; i++) begin
            pwm_duty[i] <= 0;
        end
    end else begin
        if (counter >= 2400) begin
            counter <= 0;
            current_led <= (current_led + 1) % 8; // 循环移动LED指示灯
                pwm_duty[current_led] <= 40; 
                pwm_duty[(current_led - 1) % 8] <= pwm_duty[(current_led + 1) % 8] - 10 ;
                pwm_duty[(current_led - 2) % 8] <= pwm_duty[(current_led + 1) % 8] - 10 ;
                pwm_duty[(current_led - 3) % 8] <= pwm_duty[(current_led + 1) % 8] - 10 ;
                pwm_duty[(current_led - 4) % 8] <= pwm_duty[(current_led + 1) % 8] - 10 ;
                //注意一开始为0的情况  TBD

        end else begin
            counter <= counter + 1;
        end

        // 每40个周期更新一次占空比
        if (counter % 40 == 0) begin
            for (i = 0; i < 8; i++) begin
                if (pwm_duty[i] > 0) begin
                    pwm_duty[i] <= pwm_duty[i] - 60;
                    if (pwm_duty[i] < 0) pwm_duty[i] <= 0; // 确保占空比不会变成负数
                end
            end
        end
    end
end

// 输出PWM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 8; i++) begin
            pwm_counter[i] <= 0;
        end
        led_out <= 0;
    end else begin
        for (i = 0; i < 8; i++) begin
            led_out[i] <= (pwm_counter[i] < pwm_duty[i]) ? 1 : 0;
            pwm_counter[i] <= (pwm_counter[i] + 1) % 600;
        end
    end
end

endmodule
