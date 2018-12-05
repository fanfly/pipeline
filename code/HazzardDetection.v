module HazzardDetection(
    IFIDinst_i     (ID_inst),
    IDEXinst_i     (EX_inst),
    hazzardflush_i (EX_M),
    PCflush_o      (),
    IFIDflush_o    (),
    IDflush_o      ()
);

input	[31:0]	IFIDinst_i, IDEXinst_i;
input	hazzardflush_i;

output	reg		PCflush_o, IFIDflush_o, IDflush_o;

wire	[4:0]	IFID_rs1, IFID_rs2, IDEX_rd;

always @(*) begin
	IDEX_rd = IDEXinst_i[11:7];
	IFID_rs1 = IFIDinst_i[19:15];
	IFID_rs2 = IFIDinst_i[24:20];
	if (hazzardflush_i && (IDEX_rd == IFID_rs1 || IDEX_rd == IFID_rs2)) begin
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