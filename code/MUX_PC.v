module MUX_PC(
	Branch_i,
    pc0_i,
    pc1_i,
    pc_o
);

input	Branch_i;
input	[31:0]	pc0_i, pc1_i;
output	[31:0]	pc_o;

assign pc_o = (Branch_i == 1'b0)? pc0_i: pc1_i;

endmodule