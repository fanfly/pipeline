module Adder
(
  input [31:0] data1_i,
  input [31:0] data2_i,
  output [31:0] data_o
);

assign data_o = data1_i + data2_i;

endmodule
