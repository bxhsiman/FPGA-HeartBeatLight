//心跳灯驱动
// Created by siman 2024/3/11

module LED_mode1_driver (
    input clk,
    input rst_n,
    input [7:0] led_select,
    output reg [7:0] led_out
);
    reg [8:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_out <= 8'b0;
            counter <= 9'd0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 300) begin //CLK: 600Hz / 2
                // 将ledout中 led_select对应的值修改，其余置1 
                led_out <= (led_out & ~(8'b00000001 << led_select)) | ((~led_out) & (8'b00000001 << led_select));
                counter <= 9'd0;
            end
        end
    end 
endmodule