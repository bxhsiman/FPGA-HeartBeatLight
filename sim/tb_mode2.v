`timescale 1ns / 1ps

module mode2_tb;

    reg clk;          // 12MHz
    reg rst_n;
    wire [7:0] led;

    // 实例化被测试的模块
    LED_mode2_driver uut(
        .clk(clk),
        .rst_n(rst_n),
        .led_out(led)
    );

    initial begin
        $dumpfile("wave_mode2.vcd");        //生成的vcd文件名称
        $dumpvars(0, mode2_tb);    //tb模块名称
    end

    // 生成12MHz时钟
    initial begin
        clk = 0;
        forever #41.6667 clk = ~clk; // 12MHz时钟周期为83.3333ns, 半周期为41.6667ns
    end

    // 初始化测试
    initial begin
        $display("Start testing mode2 driver"); 
        // 重置
        #100
        rst_n = 0;
        #100;
        rst_n = 1;
        #100;

        #1000000;
        $finish;
    end

endmodule
