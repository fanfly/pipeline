module Data_Memory(
	clk_i,
    MemRead_i,
    MemWrite_i,
    address_i,
    data_i,
    data_o
);

input	clk_i;
input	MemRead_i, MemWrite_i;
input	[31:0]	address_i, data_i;
output	reg	[31:0]	data_o;

reg	[7:0]	memory 	[0:31];

always @(*) begin
	if (MemRead_i) begin
		data_o = memory[address_i];
	end
end

always @(negedge clk_i) begin
	if (MemWrite_i) begin
		memory[address_i] = data_i;
		data_o = data_i;
	end
end

endmodule