//拨码开关译码模块
// created by siman 2024/3/12
module sw(
    input [3:0] sw_i,
    output reg [3:0] sw_o
);

    always @(*) begin
        case (sw_i)
            4'b0001: sw_o = 4'b0001; 
            4'b0010: sw_o = 4'b0010; 
            4'b0100: sw_o = 4'b0011; 
            4'b1000: sw_o = 4'b0100; 
            default: sw_o = 4'b1111; // if input is invalid, display F
        endcase
    end

endmodule
