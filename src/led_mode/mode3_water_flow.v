//流水灯驱动
//create by siman 2024/3/11

module LED_mode3_driver(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);

// counter
reg [11:0] counter = 0;

// PWM parameters
reg [11:0] pwm_counter[7:0];     // define PWM counter for each LED
reg [11:0] pwm_duty[7:0];        // define PWM duty for each LED

// LED selector
reg [2:0] current_led; // define the LED selector

integer i;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        current_led <= 3'd0;
    end
    else if(counter < 2400) begin
        counter <= counter + 1;
    end
    else begin
        counter <= 12'd0;
        current_led <= current_led - 1;
        pwm_duty[current_led - 1] <= 12'd2400;
        for(i = 0; i < 4; i++) begin
            if(pwm_duty[current_led + i] >= 60) pwm_duty[current_led + i] <= pwm_duty[current_led + i] - 60;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        for(i = 0; i < 7; i++) begin
            pwm_counter[i] <= 12'd0;
        end
        led_out <= 8'b0000_0000;
    end
    else begin
        for(i = 0; i < 7; i++) begin
            led_out[i] <= (pwm_counter[i] < pwm_duty[i]) ? 1'd0 : 1'd1;
            pwm_counter[i] <= (pwm_counter[i] >= 12'd2400) ? 12'd0 : (pwm_counter[i] + 1);
        end
        
    end
end








endmodule

