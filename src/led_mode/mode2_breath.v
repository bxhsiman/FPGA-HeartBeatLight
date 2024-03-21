//呼吸灯驱动
//create by siman 2024/3/11

module LED_mode2_driver
#(
    parameter PERIOD = 240000  //1s BASE PERIOD
)
(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);
    reg [31:0] counter = 0; 
    reg [2:0] current_led = 0; 
    
    reg [31:0] duty;
    reg [31:0] duty_counter; 

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            duty = 32'd0;
            counter = 12'd0;
            current_led = 8'd0;
        end
        else begin
            if (counter <= PERIOD / 4) begin
                // First PERIOD / 4 cycles, the LED duty cycle increases
                counter = counter + 1;
                if(counter % 60 == 0) begin
                    duty = duty + 1;
                end
            end
            else if (counter > PERIOD / 4 && counter <= PERIOD / 2) begin
                // The next PERIOD / 4 cycles, the LED duty cycle decreases
                counter = counter + 1;
                if(counter % 60 == 0) begin
                    duty = duty - 1;
                end
            end
            else if (counter > PERIOD / 2 && counter <= PERIOD / 4 * 3) begin
                // The next PERIOD / 4 cycles, the LED duty cycle increases
                counter = counter + 1;
                if(counter % 60 == 0) begin
                    duty = duty + 1;
                end
            end
            else if (counter > PERIOD / 4 * 3 && counter < PERIOD) begin
                // The next PERIOD / 4 cycles, the LED duty cycle decreases
                counter = counter + 1;
                if(counter % 60 == 0) begin
                    duty = duty - 1;
                end
            end
            else if (counter == PERIOD) begin
                counter = 32'd0;
                current_led = current_led + 1;
            end

        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            led_out = 8'b0000_0000;
            duty_counter = 32'd0;
        end
        else begin
            duty_counter = duty_counter >= PERIOD / 8 / 60  ? 0 : duty_counter + 1;
            led_out = (duty_counter <= duty) ? (1 << current_led) : (8'b0000_0000); 
        end
    end
endmodule