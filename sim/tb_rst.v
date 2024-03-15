`timescale 1ns / 1ps

module rst_tb;

    reg clk;          // 12MHz
    reg [3:0] key_in;
    wire rst_n;

    // 实例化被测试的模块
    rst uut(
        .key_input(key_in),
        .rst_n(rst_n)
    );

    initial begin
        $dumpfile("wave_rst.vcd");        //生成的vcd文件名称
        $dumpvars(0, rst_tb);             //tb模块名称
    end

    // 生成12MHz时钟
    initial begin
        clk = 0;
        forever #41.6667 clk = ~clk; // 12MHz时钟周期为83.3333ns, 半周期为41.6667ns
    end

    // 初始化测试
    initial begin
        $display("Start testing rst");
        // 输入0
        key_in = 4'b1111;
        #100 
        // 输入1
        key_in = 4'b1110;
        #100
        // 输入F
        key_in = 4'b0000;
        #100;
        $finish;
    end

endmodule
