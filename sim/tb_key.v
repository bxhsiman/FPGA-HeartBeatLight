`timescale 1ns / 1ps

module key_tb;

    reg clk;          // 12MHz
    reg rst_n;
    reg [3:0] key_in;
    wire[3:0] key_out;

    // 实例化被测试的模块
    key uut(
        .clk(clk),
        .rst_n(rst_n),
        .key_in (key_in), // 2400Hz
        .key_out(key_out)

    );

    initial begin
        $dumpfile("wave_key.vcd");        //生成的vcd文件名称
        $dumpvars(0, key_tb);             //tb模块名称
    end

    // 生成12MHz时钟
    initial begin
        clk = 0;
        forever #41.6667 clk = ~clk; // 12MHz时钟周期为83.3333ns, 半周期为41.6667ns
    end

    // 初始化测试
    initial begin
        $display("Start testing key"); 
        // 重置
        key_in = 4'b1111;
        #100
        rst_n = 0;
        #100;
        rst_n = 1;
        #100;

        // 输入1
        key_in = 4'b1110;
        #100
        key_in = 4'b1111;
        #100
        // 输入2
        key_in = 4'b1101;
        #100
        key_in = 4'b1111;
        #100
        // 输入3
        key_in = 4'b1011;
        #100
        key_in = 4'b1111;
        #100
        // 输入4
        key_in = 4'b0111;
        #100
        key_in = 4'b1111;
        #100

        // 输入无效
        key_in = 4'b1100;
        
        #100;
        $finish;
    end

endmodule
