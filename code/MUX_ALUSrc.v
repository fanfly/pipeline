module  MUX_ALUSrc(
    .data1_i,
    .data2_i,
    .ALUSrc_i,
    .data_o
);

input	ALUSrc_i;
input	[31:0]	data1_i, data2_i;
output	reg		[31:0]	data_o;

always @(*) begin
	if (~ALUSrc_i) begin
		data_o = data1_i;
	end
	else begin
		data_o = data2_i;
	end
end