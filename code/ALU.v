module ALU(
    ALUCtr_i,
    data1_i,
    data2_i,
    data_o
);

input	[2:0]	ALUCtr_i;
input	[31:0]	data1_i, data2_i;
output	reg	[31:0]	data_o;

always @(*) begin
	if (ALUCtr_i == 3'b000) begin
		data_o = data1_i + data2_i;
	end
	else if (ALUCtr_i == 3'b001) begin
		data_o = data1_i - data2_i;
	end
	else if (ALUCtr_i == 3'b010) begin
		data_o = data1_i * data2_i;
	end
	else if (ALUCtr_i == 3'b100) begin
		data_o = data1_i | data2_i;
	end
	else if (ALUCtr_i == 3'b101) begin
		data_o = data1_i & data2_i;
	end
end

endmodule