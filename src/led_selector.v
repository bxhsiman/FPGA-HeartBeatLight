//LED状态机
//create by siman 2024/3/11

module led_selector (
    input clk,
    input rst_n,
    output reg [7:0] led_select
);

    reg [9:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_select <= 8'b0000_0001;
            counter <= 10'd0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 'd600) begin //CLK: 600Hz
                led_select <= {led_select[6:0],led_select[7]};
                counter <= 10'd0;
            end
        end
    end

endmodule
