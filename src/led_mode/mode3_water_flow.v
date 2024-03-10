//流水灯驱动
//create by siman 2024/3/11

module LED_mode3_driver(
    input clk,
    input rst_n,
    input [7:0] led_select,
    output reg [7:0] led_out
);

// PWM parameters
localparam MAX_PWM_COUNT = 600; // define the maximum PWM count
reg [9:0] pwm_counter[7:0];     // define PWM counter for each LED
reg [9:0] pwm_duty[7:0];        // define PWM duty for each LED

// PWM counter and duty update
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            pwm_counter[i] <= 0;
            led_out[i] <= 0;
        end
    end else begin
        // PWM counter update
        for (i = 0; i < 8; i = i + 1) begin
            if (pwm_counter[i] >= MAX_PWM_COUNT)
                pwm_counter[i] <= 0;
            else
                pwm_counter[i] <= pwm_counter[i] + 1;

            // update led state
            if (pwm_counter[i] < pwm_duty[i])
                led_out[i] <= 1;
            else
                led_out[i] <= 0;
        end
    end
end

// update duty
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            pwm_duty[i] <= 8'd0;
        end
    end
    else begin
        // reset pwm_duty
        for (i = 0; i < 8; i = i + 1) begin
            pwm_duty[i] <= 8'd0;
        end

        // set different duty for different LED
        for (i = 0; i < 8; i = i + 1) begin
            if (led_select[i] == 1'b1) begin
                pwm_duty[i] <= 10'd600;
                pwm_duty[(i + 7) % 8] <= 10'd450; // 75%亮度
                pwm_duty[(i + 6) % 8] <= 10'd300; // 50%亮度
                pwm_duty[(i + 5) % 8] <= 10'd150; // 25%亮度
            end
        end
    end
end

endmodule
