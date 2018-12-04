module ALU_Control(
    ALUOp_i,
    inst_i,
    ALUCtr_o
);

input	[1:0]	ALUOp_i;
input	[31:0]	inst_i;
output	reg	[2:0]	ALUCtr_o;

wire	[2:0]	funct3;
wire	[6:0]	funct7;

always @(*) begin
	if (ALUOp_i == 2'b00) begin
		ALUCtr_o = 3'b000;
	end
	else if (ALUOp_i == 2'b01) begin
		ALUCtr_o = 3'b001;
	end
	else if (ALUOp_i == 2'b10) begin
		funct7 = inst_i[31:25];
		funct3 = inst_i[14:12];
		if (funct7 == 7'b0000000 && funct3 == 3'b000 ) begin
			ALUCtr_o = 3'b000;
		end
		else if (funct7 == 7'b0100000 && funct3 == 3'b000) begin
			ALUCtr_o = 3'b001;
		end
		else if (funct7 == 7'b0000001 && funct3 == 3'b000) begin
			ALUCtr_o = 3'b010;
		end
		else if (funct7 == 7'b0000000 && funct3 == 3'b110) begin
			ALUCtr_o = 3'b100;
		end
		else if (funct7 == 7'b0000000 && funct3 == 3'b111) begin
			ALUCtr_o = 3'b111;
		end
	end
	else if (ALUOp_i == 2'b11) begin
		ALUCtr_o = 3'b000;
	end
end