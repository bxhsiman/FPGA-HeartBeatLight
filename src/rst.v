//复位逻辑
//created by siman 2024/3/12

module rst(
    input [3:0] key_input,
    output rst_n
);

assign rst_n = (key_input == 4'b0000) ? 1'b0 : 1'b1;

endmodule