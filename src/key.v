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
            key_out <= 4'b0001; // default value
            last_valid_value <= 4'b0001; 
        end
        else begin
            case (~key_in) 
                4'b0001: begin 
                    key_out <= 4'b0001;
                    last_valid_value <= 4'b0001;
                end
                4'b0010: begin 
                    key_out <= 4'b0010;
                    last_valid_value <= 4'b0010;
                end
                4'b0100: begin 
                    key_out <= 4'b0011;
                    last_valid_value <= 4'b0011;
                end
                4'b1000: begin 
                    key_out <= 4'b0100;
                    last_valid_value <= 4'b0100;
                end
                4'b0000: begin // keep the last valid value
                    key_out <= last_valid_value;
                end
                default: begin // if input is invalid, display F
                    key_out <= 4'b1111; // 显示F
                end
            endcase
        end
    end

endmodule