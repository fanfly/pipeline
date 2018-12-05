module MUX_EXMEM1(
    control_i,
    WB_i,
    zero_i,
    WB_o
);

input	control_i;
input	[1:0]	WB_i, zero_i;
output	reg	[1:0]	WB_o;

always @(*) begin
	if (~control_i) begin
		WB_o = WB_i;
	end
	else begin
		WB_o = zero_i;
	end
end

endmodule