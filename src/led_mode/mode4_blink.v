//爆闪灯驱动
//create by siman 2024/3/11

module LED_mode4_driver (
    input clk,
    input rst_n,
    output reg [7:0] led_out
);
    reg [12:0] counter;
    reg [7:0] led_mask; 

    // Generate the mask for the selected LED
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_mask = 8'b0;
        end
        else begin
            if (counter <= 1201) begin //CLK: 2400Hz / 2
                led_mask = 8'b1111_0000;
            end
            else begin
                led_mask = 8'b0000_1111;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_out = 8'b0;
            counter = 12'd0;
        end
        else begin
            counter = counter + 1;
            if (counter % 200 == 0) begin //CLK: 1200Hz / 6
                // Toggle the selected LED
                led_out = led_out ^ led_mask;
            end
            if (counter == 2400) begin
                counter = 12'd0;
            end
        end
    end 


endmodule 