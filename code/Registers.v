module Registers(
    rs1_i,
    rs2_i,
    writeaddr_i,
    writedata_i,
    RegWrite_i,
    data1_o,
    data2_o,
);

input	RegWrite_i;
input	[5:0]	rs1_i, rs2_i;
input   [31:0]  writeaddr_i, writedata_i;
output	[31:0]	data1_o, data2_o;

reg 	[31:0]	register 	[0:31];

assign data1_o = register[rs1_i];
assign data2_o = register[rs2_i];

always @(*) begin
	if(RegWrite_i)
		register[writeaddr_i] <= writedata_i;
end

endmodule