module LED_mode3_driver(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);

reg [31:0] counter = 0;
reg [31:0] pwm_counter[7:0];
reg [31:0] pwm_duty[7:0];
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
        if (counter >= 30000) begin
            counter <= 0;
            current_led <= (current_led - 1) % 8; // change to next led
            pwm_duty[current_led] <= 900; 
            pwm_duty[(current_led + 1) % 8] <= pwm_duty[(current_led + 1) % 8] > 50 ? pwm_duty[(current_led + 1) % 8] - 250 : 0;
            pwm_duty[(current_led + 2) % 8] <= pwm_duty[(current_led + 2) % 8] > 50 ? pwm_duty[(current_led + 2) % 8] - 250 : 0;
            pwm_duty[(current_led + 3) % 8] <= pwm_duty[(current_led + 3) % 8] > 50 ? pwm_duty[(current_led + 3) % 8] - 100 : 0;
            pwm_duty[(current_led + 4) % 8] <= pwm_duty[(current_led + 4) % 8] > 50 ? pwm_duty[(current_led + 4) % 8] - 100 : 0;
            pwm_duty[(current_led + 5) % 8] <= pwm_duty[(current_led + 5) % 8] > 50 ? pwm_duty[(current_led + 5) % 8] - 50 : 0;
            pwm_duty[(current_led + 6) % 8] <= pwm_duty[(current_led + 6) % 8] > 50 ? pwm_duty[(current_led + 6) % 8] - 50 : 0;
            pwm_duty[(current_led + 7) % 8] <= pwm_duty[(current_led + 7) % 8] > 50 ? pwm_duty[(current_led + 7) % 8] - 50 : 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
end

// PWM OUTPUT
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 8; i++) begin
            pwm_counter[i] <= 0;
        end
        led_out <= 0;
    end else begin
        for (i = 0; i < 8; i++) begin
            pwm_counter[i] <= pwm_counter[i] >= 900 ? 0 : pwm_counter[i] + 1;
            led_out[i] <= (pwm_counter[i] < pwm_duty[i]) ? 1 : 0;
        end
    end
end

endmodule
