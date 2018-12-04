module MUX_EXMEM2(
    control_i,
    M_i,
    zero_i,
    M_o
);

input	control_i;
input	[1:0]	M_i, zero_i;
output	reg	[2:0]	M_o;

always @(*) begin
	if (~control_i) begin
		M_o = M_i;
	end
	else begin
		M_o = zero_i;
	end
end