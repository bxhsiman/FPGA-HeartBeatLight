//爆闪灯驱动
//create by siman 2024/3/11

module LED_mode4_driver (
    input clk,
    input rst_n,
    input [7:0] led_select,
    output reg [7:0] led_out
);
    reg [6:0] counter;
    reg [7:0] led_mask; 

    // Generate the mask for the selected LED
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_mask <= 8'b0;
        end
        else begin
            if (counter < 300) begin //CLK: 600Hz / 2
                led_mask <= 8'b1111_0000;
            end
            else begin
                led_mask <= 8'b0000_1111;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_out <= 8'b0;
            counter <= 7'd0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 200) begin //CLK: 600Hz / 3
                // Toggle the selected LED
                led_out <= (led_out & ~led_mask) | ((~led_out) & led_mask);
                counter <= 7'd0;
            end
        end
    end 


endmodule 