`timescale 1ns / 1ps

module seg_tb;

    reg         clk;          // 12MHz
    reg         rst_n;
    reg  [7:0]  value;
    wire [8:0]  seg1;
    wire [8:0]  seg2;  

    // 实例化被测试的模块
    seg_display uut(
        .clk(clk),
        .rst_n(rst_n),
        .value(value),
        .seg1(seg1),
        .seg2(seg2)
    );

    initial begin
        $dumpfile("wave_seg.vcd");        //生成的vcd文件名称
        $dumpvars(0, seg_tb);             //tb模块名称
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

        value = 8'h01;
        #1000
        value = 8'h23;
        #1000
        value = 8'h45;
        #1000
        value = 8'h67;
        #1000
        value = 8'h89;
        #1000
        value = 8'hAB;
        #1000
        value = 8'hCD;
        #1000
        value = 8'hEF;
        #1000

        
        $finish;
    end

endmodule
