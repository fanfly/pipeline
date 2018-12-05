module HazzardDetection(
    IFIDinst_i,
    IDEXinst_i,
    MemRead_i,
    PCflush_o,
    IFIDflush_o,
    IDflush_o
);

input	[31:0]	IFIDinst_i, IDEXinst_i;
input			MemRead_i;
output	reg		PCflush_o = 1'b0, IFIDflush_o = 1'b0, IDflush_o = 1'b0;
wire	[4:0]	IFID_rs1, IFID_rs2, IDEX_rd;


assign IDEX_rd = IDEXinst_i[11:7];
assign IFID_rs1 = IFIDinst_i[19:15];
assign IFID_rs2 = IFIDinst_i[24:20];

always @(*) begin
	if (MemRead_i && (IDEX_rd == IFID_rs1 || IDEX_rd == IFID_rs2)) begin
		PCflush_o = 1'b1;
		IFIDflush_o = 1'b1;
		IDflush_o = 1'b1;
	end
	else begin
		PCflush_o = 1'b0;
		IFIDflush_o = 1'b0;
		IDflush_o = 1'b0;
	end
end

endmodule