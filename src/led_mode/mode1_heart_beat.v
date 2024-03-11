//心跳灯驱动
// Created by siman 2024/3/11

module LED_mode1_driver (
    input clk,
    input rst_n,
    input [3:0] led_select,
    output reg [7:0] led_out
);
    reg [6:0] counter;
    wire [7:0] led_mask; 

    // Generate the mask for the selected LED
    assign led_mask = 8'b00000001 << led_select;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_out <= 8'b0;
            counter <= 7'd0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 300) begin //CLK: 600Hz / 2
                // Toggle the selected LED
                led_out <= (led_out & ~led_mask) | ((~led_out) & led_mask);
                counter <= 7'd0;
            end
        end
    end 
endmodule