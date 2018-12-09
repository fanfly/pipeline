module Registers(
	clk_i,
    rs1_i,
    rs2_i,
    writeaddr_i,
    writedata_i,
    RegWrite_i,
    data1_o,
    data2_o,
);

input	RegWrite_i;
input	clk_i;
input	[4:0]	rs1_i, rs2_i, writeaddr_i;
input   [31:0]  writedata_i;
output	[31:0]	data1_o, data2_o;

reg 	[31:0]	register 	[0:31];

assign data1_o = register[rs1_i];
assign data2_o = register[rs2_i];

always @(posedge clk_i) begin
	if(RegWrite_i && writeaddr_i != 5'b0)
		register[writeaddr_i] <= writedata_i;
end

endmodule