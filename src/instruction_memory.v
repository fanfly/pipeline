module InstructionMemory
(
  input [31:0] pc_i,
  output [31:0] inst_o
);

reg [31:0] inst [0:511];
integer i;

assign inst_o = inst[pc_i >> 2];

endmodule
