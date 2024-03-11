//拨码开关译码模块
module sw(
    input [3:0] sw_i,
    output reg [3:0] sw_o
);

    always @(*) begin
        case (sw_i)
            4'b0001: sw_o = 4'b0001; // 第一个开关打开
            4'b0010: sw_o = 4'b0010; // 第二个开关打开
            4'b0100: sw_o = 4'b0011; // 第三个开关打开
            4'b1000: sw_o = 4'b0100; // 第四个开关打开
            // 添加更多状态以匹配您的设计需求
            default: sw_o = 4'b1111; // 多个开关打开或没有开关打开
        endcase
    end

endmodule
