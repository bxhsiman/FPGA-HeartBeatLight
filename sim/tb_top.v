`timescale 1ns / 1ps

module top_tb;

    reg clk;          // 12MHz
    reg [3:0] sw_input;
    reg [3:0] key_input;
    wire [7:0] led;
    wire [8:0] seg1;  // 9-segment display for the first digit
    wire [8:0] seg2;   // 9-segment display for the second digit

    // 实例化被测试的模块
    top uut(
        .clk(clk),
        .sw_input(sw_input),
        .key_input(key_input),
        .led(led),
        .seg1(seg1),
        .seg2(seg2)
    );

    initial begin
        $dumpfile("wave_top.vcd");        //生成的vcd文件名称
        $dumpvars(0, top_tb);    //tb模块名称
    end

    // 生成12MHz时钟
    initial begin
        clk = 0;
        forever #41.6667 clk = ~clk; // 12MHz时钟周期为83.3333ns, 半周期为41.6667ns
    end

    // 初始化测试
    initial begin
        // 初始化输入
        sw_input = 4'b0000;
        key_input = 4'b1111;
        // 重置
        #100;
        key_input = 4'b0000; // 模拟按下复位键
        // 等待一段时间后模拟按键和开关操作
        #100;
        key_input = 4'b1111; // 模拟释放所有键
        #100;
        sw_input = 4'b1000; // 模拟设置开关输入

    end

endmodule
