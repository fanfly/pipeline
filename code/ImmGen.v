module ImmGen(
    data_i,
    data_o
);

input	reg	[31:0]	data_i;
output	reg	[31:0]	data_o;

wire	[6:0]	opcode;

always @(*) begin
	data_o = 32'd0;
	if (opcode == 7'b0010011) begin
		//addi
		data_o[11:0] = data_i[31:20];
	end
	else if (opcode == 7'b0100011) begin
		//sw
		data_o[4:0] = data_i[4:0];
		data_o[11:5] = data_i[31:25];
	end
	else if (opcode == 7'b0000011) begin
		//ld
		data_o[11:0] = data_i[31:20];
	end
	else if (opcode == 7'b1100011) begin
		//beq
		data_o[4:1] = data_i[11:8];
		data_o[10:5] = data_i[30:25];
		data_o[11] = data_i[7];
		data_o[12] = data_i[31];
	end
end

endmodule