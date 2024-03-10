//闪灯模式选择器
//create by siman 2024/3/11

module driver_selector(
    input clk,
    input rst_n,
    input [3:0] driver_input,
    input[3:0] mode_select,
    output reg signal 
);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            signal <= 1'b0;
        end
        else
            case (mode_select)
                4'b0000: begin
                    signal <= driver_input[0];
                end
                4'b0001: begin
                    signal <= driver_input[1];
                end
                4'b0010: begin
                    signal <= driver_input[2];
                end
                4'b0011: begin
                    signal <= driver_input[3];
                end
                default: begin
                    signal <= 1'b0;
                end

            endcase
    end

endmodule   