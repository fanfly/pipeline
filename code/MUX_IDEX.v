module MUX_IDEX(
    hazzardflush_i,
    WB_i,
    M_i,
    EX_i,
    WB_o,
    M_o,
    EX_o
);

input	hazzardflush_i;
input	[1:0]	WB_i, M_i;
input	[2:0]	EX_i;
output	reg	[1:0]	WB_o, M_o;
output	reg	[2:0]	EX_o;

always @(*) begin
	if (hazzardflush_i) begin
		WB_o = 2'd0;
		M_o = 2'd0;
		EX_o = 3'd0;
	end
	else begin
		WB_o = WB_i;
		M_o = M_i;
		EX_o = EX_i;
	end
end

endmodule