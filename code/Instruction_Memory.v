module Instruction_Memory(
    instaddr_i,
    inst_o
);

input	[31:0]	instaddr_i;
output	[31:0]	inst_o;

reg		[31:0]	memory 	[0:255];

assign  inst_o = memory[instaddr_i>>2];

endmodule