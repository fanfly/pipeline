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
output	[31:0]	data_o;

reg	[7:0]	memory 	[0:31];

assign data_o = (MemRead_i == 1'b1)? memory[address_i] : 32'b0;

always @(posedge clk_i) begin
	if (MemWrite_i == 1'b1) begin
		memory[address_i] = data_i;
	end
end

endmodule