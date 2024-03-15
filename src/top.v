module top (
    input clk,          //12MHz
    input [3:0] sw_input,
    input [3:0] key_input,
    output [7:0] led,
    output [8:0] seg1,  // 9-segment display for the first digit
    output [8:0] seg2   // 9-segment display for the second digit
);
    wire [3:0] key_reg;
    wire [3:0] sw_input_reg;
    wire clk_divided;
    wire rst_n;

    //例化复位逻辑
    rst rst_inst(
        .key_input(key_input),
        .rst_n(rst_n)
    );
    
    //例化模式输入
    key key_inst(
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_input),
        .key_out(key_reg)
    );
    //周期输入
    sw sw_inst(
        .sw_i(sw_input),
        .sw_o(sw_input_reg)
    );

    //例化时钟
    clk_divider clk_divider_inst(
        .clk(clk),
        .rst_n(rst_n),
        .period(sw_input_reg),
        .clk_out(clk_divided)
    );


    //例化数码管
    seg_display seg_display_inst(
        .clk(clk),
        .rst_n(rst_n),
        .value({key_reg, sw_input_reg}),
        .seg1(seg1),
        .seg2(seg2)
    );

    //例化驱动器
    driver_selector driver_selector_inst(
        .clk(clk_divided),
        .rst_n(rst_n),
        .mode_select(key_reg),
        .signal(led)
    );

endmodule