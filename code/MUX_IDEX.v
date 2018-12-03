module MUX_IDEX(
    hazzardflush_i,
    IDflush_i,
    WB_i,
    M_i,
    EX_i,
    zero_i,
    WB_o,
    M_o,
    EX_o
);

input	hazzardflush_i, IDflush_i;
input	[1:0]	WB_i, M_i, EX_i, zero_i;
output	reg	[1:0]	WB_o, M_o, EX_o;

always @(*) begin
	if (hazzardflush_i || IDflush_i) begin
		WB_o = zero_i;
		M_o = zero_i;
		EX_o = zero_i;
	end
	else begin
		WB_o = WB_i;
		M_o = M_i;
		EX_o = EX_i;
	end
end

endmodule