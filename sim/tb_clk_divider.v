`timescale 1ns / 1ps

module clk_divider_tb;

    reg clk;          // 12MHz
    reg rst_n;
    reg [3:0] period; // 4'd1: 2400Hz, 4d'2: 1200Hz, 4d'3: 800Hz, 4d'4: 600Hz
    wire  clk_out;

    // 实例化被测试的模块
    clk_divider uut(
        .clk(clk),
        .rst_n(rst_n),
        .period(period), // 2400Hz
        .clk_out(clk_out)

    );

    initial begin
        $dumpfile("wave_clk_divider.vcd");        //生成的vcd文件名称
        $dumpvars(0, clk_divider_tb);             //tb模块名称
    end

    // 生成12000MHz时钟
    initial begin
        clk = 0;
        forever #0.0416667 clk = ~clk; // 12MHz时钟周期为83.3333ns, 半周期为41.6667ns
    end

    // 初始化测试
    initial begin
        $display("Start testing clk_divider"); 
        // 重置
        #100
        rst_n = 0;
        #100;
        rst_n = 1;
        #100;

        // 2400Hz
        period = 4'd1;
        #100000
        // 1200Hz
        period = 4'd2;
        #100000
        // 800Hz
        period = 4'd3;
        #100000
        // 600Hz
        period = 4'd4;
        #100000
        
        #100;
        $finish;
    end

endmodule
