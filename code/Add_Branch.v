module Add_Branch(
    data1_i,
    data2_i,
    data_o
);

input	[31:0]	data1_i, data2_i;
output	reg	[31:0]	data_o;

always @(*) begin
	data_o = (data1_i << 1) + data2_i;
end

endmodule