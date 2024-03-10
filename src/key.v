//按钮锁存模块
//created by siman 2024/3/11

module key (
    input clk,
    input rst_n,
    input [3:0] key_in,
    output [3:0] key_out
);
    reg [3:0] key_reg;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            key_reg <= 4'b0;
        end
        else begin
            key_reg <= key_in;
        end
    end
    assign key_out = key_reg;

endmodule