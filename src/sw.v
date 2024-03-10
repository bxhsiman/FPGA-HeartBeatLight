//拨码开关译码模块
module sw(
    input [7:0] sw_i,
    output [7:0] sw_o
);
    assign sw_o = sw_i;

endmodule