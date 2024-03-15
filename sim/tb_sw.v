`timescale 1ns / 1ps

module sw_tb;

    reg clk;          // 12MHz
    reg rst_n;
    reg [3:0] sw_in;
    wire[3:0] sw_out;

    // 实例化被测试的模块
    sw uut(
        .sw_i(sw_in),
        .sw_o(sw_out)
    );

    initial begin
        $dumpfile("wave_sw.vcd");        //生成的vcd文件名称
        $dumpvars(0, sw_tb);             //tb模块名称
    end

    // 生成12MHz时钟
    initial begin
        clk = 0;
        forever #41.6667 clk = ~clk; // 12MHz时钟周期为83.3333ns, 半周期为41.6667ns
    end

    // 初始化测试
    initial begin
        $display("Start testing sw"); 
        // 重置
        rst_n = 0;
        #100;
        rst_n = 1;
        #100;

        // 输入1
        sw_in = 4'b0001;
        #100
        // 输入2
        sw_in = 4'b0010;
        #100
        // 输入3
        sw_in = 4'b0100;
        #100
        // 输入4
        sw_in = 4'b1000;
        #100
        
        #100;
        $finish;
    end

endmodule
