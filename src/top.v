module top (
    input clk,          //12MHz
    input [3:0] sw_input,
    input [3:0] key_input,
    output [7:0] led,
    output [8:0] seg1,  // 9-segment display for the first digit
    output [8:0] seg2   // 9-segment display for the second digit
);
    wire [3:0] key_reg;
    wire clk_divided;

    //例化周期输入
    key key_inst(
        .clk(clk),
        .rst_n(1'b1),
        .key_in(key_input),
        .key_out(key_reg)
    );
    //例化时钟
    clk_divider clk_divider_inst(
        .clk(clk),
        .rst_n(1'b1),
        .period(key_reg),
        .clk_out(clk_divided)
    );


    //例化数码管
    seg_display seg_display_inst(
        .clk(clk),
        .rst_n(1'b1),
        .value({key_reg, sw_input}),
        .seg1(seg1),
        .seg2(seg2)
    );

    wire [7:0] led_select;

    //例化LED选择状态机
    led_selector led_selector_inst(
        .clk(clk_divided),
        .rst_n(1'b1),
        .led_select(led_select)
    );

    //例化驱动器
    driver_selector driver_selector_inst(
        .clk(clk_divided),
        .rst_n(1'b1),
        .led_select(led_select),
        .mode_select(key_reg),
        .signal(led)
    );

endmodule