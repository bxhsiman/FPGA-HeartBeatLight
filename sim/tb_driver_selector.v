`timescale 1ns / 1ps

module driver_selector_tb;

    reg clk;          // 12MHz
    reg rst_n;
    reg [3:0]  mode_select; // 4'b0001: Mode1, 4'b0010: Mode2, 4'b0011: Mode3, 4'b0100: Mode4
    wire  [7:0]  led;

    // 实例化被测试的模块
    driver_selector uut(
        .clk(clk),
        .rst_n(rst_n),
        .mode_select(mode_select), // 2400Hz
        .signal(led)

    );

    initial begin
        $dumpfile("wave_driver_selector.vcd");        //生成的vcd文件名称
        $dumpvars(0, driver_selector_tb);             //tb模块名称
    end

    // 生成12000MHz时钟
    initial begin
        clk = 0;
        forever #0.0416667 clk = ~clk; // 12MHz时钟周期为83.3333ns, 半周期为41.6667ns
    end

    // 初始化测试
    initial begin
        $display("Start testing driver_selector"); 
        // 重置
        #100
        rst_n = 0;
        #100;
        rst_n = 1;
        #100;

        //Mode1
        mode_select = 4'b0001;
        #1000
        //Mode2
        mode_select = 4'b0010;
        #1000
        //Mode3
        mode_select = 4'b0011;
        #1000
        //Mode4
        mode_select = 4'b0100;
        #1000
        //Modex
        mode_select = 4'b0101;
        
        
        #100;
        $finish;
    end

endmodule
