//心跳灯驱动
// Created by siman 2024/3/11

module LED_mode1_driver (
    input clk,
    input rst_n,
    output reg led_out 
);
    reg [6:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_out <= 1'b0;
            counter <= 7'd0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 300) begin //CLK: 600Hz / 2
                led_out <= ~led_out;
                counter <= 7'd0;
            end
        end
    end 

endmodule