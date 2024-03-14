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
    end 
    else begin
        if (counter >= 300) begin
            counter <= 0;
            current_led <= (current_led - 1) % 8; // 循环移动LED指示灯
            pwm_duty[current_led] <= 8; 
            pwm_duty[(current_led + 1) % 8] <= pwm_duty[(current_led + 1) % 8] >= 2 ? pwm_duty[(current_led + 1) % 8] - 2 : 0;
            pwm_duty[(current_led + 2) % 8] <= pwm_duty[(current_led + 2) % 8] >= 2 ? pwm_duty[(current_led + 2) % 8] - 2 : 0;
            pwm_duty[(current_led + 3) % 8] <= pwm_duty[(current_led + 3) % 8] >= 2 ? pwm_duty[(current_led + 3) % 8] - 2 : 0;
            pwm_duty[(current_led + 4) % 8] <= pwm_duty[(current_led + 4) % 8] >= 2 ? pwm_duty[(current_led + 4) % 8] - 2 : 0;
        end
        else begin
            counter <= counter + 1;
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
            pwm_counter[i] <= pwm_counter[i] >= 8 ? 0 : pwm_counter[i] + 1;
            led_out[i] <= (pwm_counter[i] < pwm_duty[i]) ? 1 : 0;
        end
    end
end

endmodule
