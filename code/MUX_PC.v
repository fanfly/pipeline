module MUX_PC(
	Branch_i,
    pc0_i,
    pc1_i,
    pc_o
);

input	Branch_i;
input	[31:0]	pc0_i, pc1_i;
output	[31:0]	pc_o;

always @(*) begin
	if (~Branch_i) begin
		pc_o = pc0_i;
	end
	else begin
		pc_o = pc1_i;
	end
end
endmodule