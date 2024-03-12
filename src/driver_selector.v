//闪灯模式选择器
//create by siman 2024/3/11

module driver_selector(
    input clk,
    input rst_n,
    input [7:0]  led_select,
    input [3:0]  mode_select,
    output reg [7:0]  signal 
);
    wire [31:0] dirvers_signal;

    //implennt the drivers 
    LED_mode1_driver driver1(
        .clk(clk),
        .rst_n(rst_n),
        .led_out(dirvers_signal[7:0])
    );
    LED_mode2_driver driver2(
        .clk(clk),
        .rst_n(rst_n),
        .led_out(dirvers_signal[15:8])
    );
    LED_mode3_driver driver3(
        .clk(clk),
        .rst_n(rst_n),
        .led_select(led_select),
        .led_out(dirvers_signal[23:16])
    );
    LED_mode4_driver driver4(
        .clk(clk),
        .rst_n(rst_n),
        .led_select(led_select),
        .led_out(dirvers_signal[31:24])
    );

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            signal <= 8'b1111_1111;
        end
        else
            case (mode_select)
                4'b0001: begin
                    signal <= ~dirvers_signal[7:0];
                end
                4'b0010: begin
                    signal <= ~dirvers_signal[15:8];
                end
                4'b0011: begin
                    signal <= ~dirvers_signal[23:16];
                end
                4'b0100: begin
                    signal <= ~dirvers_signal[31:24];
                end
                default: begin
                    signal <= 8'b1111_1111;
                end
            endcase
    end

endmodule   