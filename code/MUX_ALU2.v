module MUX_ALU2(
    ForwardB_i,
    data2_i,
    dataWB_i,
    dataFor_i,
    data2_o
);

input	[1:0]	ForwardB_i;
input	[31:0]	data2_i, dataWB_i, dataFor_i;
output	reg		[31:0]	data2_o;

always @(*) begin
	if (ForwardB_i == 2'b00) begin
		data2_o = data2_i;
	end
	else if (ForwardB_i == 2'b01) begin
		data2_o = dataWB_i;
	end
	else if (ForwardB_i == 2'b10) begin
		data2_o = dataFor_i;
	end
end

endmodule