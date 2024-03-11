//按钮锁存模块
//created by siman 2024/3/11

module key (
    input clk,
    input rst_n,
    input [3:0] key_in,
    output reg [3:0] key_out
);
    reg [3:0] last_valid_value;
    
    initial begin
        last_valid_value = 4'b0001;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            key_out <= 4'b0001; // 重置时默认输出1
            last_valid_value <= 4'b0001; // 同时重置上一个有效值为1
        end
        else begin
            case (~key_in) // 假设低电平为按键按下
                4'b0001: begin // 第一个按键被按下
                    key_out <= 4'b0001;
                    last_valid_value <= 4'b0001;
                end
                4'b0010: begin // 第二个按键被按下
                    key_out <= 4'b0010;
                    last_valid_value <= 4'b0010;
                end
                4'b0100: begin // 第三个按键被按下
                    key_out <= 4'b0011;
                    last_valid_value <= 4'b0011;
                end
                4'b1000: begin // 第四个按键被按下
                    key_out <= 4'b0100;
                    last_valid_value <= 4'b0100;
                end
                4'b0000: begin // 没有按键被按下，保持上一个有效值
                    key_out <= last_valid_value;
                end
                default: begin // 任何其他组合（即多个按键同时被按下）
                    key_out <= 4'b1111; // 显示F
                end
            endcase
        end
    end

endmodule