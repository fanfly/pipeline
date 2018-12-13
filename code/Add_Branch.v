module Add_Branch(
    data1_i,
    data2_i,
    data_o
);

input	[31:0]	data1_i, data2_i;
output	reg	[31:0]	data_o;

always @(*) begin
	if (data1_i[11] == 1'b1) begin
		data_o = (data1_i << 1) + data2_i + 32'b11111111111111111110000000000000;	
	end
	else begin
		data_o = (data1_i << 1) + data2_i;
	end
end

endmodule