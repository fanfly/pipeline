module MUX_PC(
    pc0_i,
    pc1_i,
    pc_o
);

input	[31:0]	pc0_i, pc1_i;
output	[31:0]	pc_o;

always @(*) begin
	if (~pc1_i) begin
		pc_o = pc1_i;
	end
	else begin
		pc_o = pc0_i;
	end
end
endmodule