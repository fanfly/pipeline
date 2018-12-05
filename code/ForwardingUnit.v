module ForwardingUnit(
    EXMEMinst_i,
    EXMEMwb_i,
    MEMWBinst_i,
    MEMWBwb_i,
    rs1_i,
    rs2_i,
    ForwardA_o,
    ForwardB_o
);

input	[31:0]	EXMEMinst_i, MEMWBinst_i;
input	[1:0]	EXMEMwb_i, MEMWBwb_i;
input	[4:0]	rs1_i, rs2_i;

output	reg	[1:0]	ForwardA_o = 2'b00, ForwardB_o = 2'b00;

wire	EXMEMRegWrite, MEMWBRegWrite;
wire 	[4:0]	EXMEMRegisterRd, MEMWBRegisterRd;

assign EXMEMRegWrite = EXMEMwb_i[1];
assign MEMWBRegWrite = MEMWBwb_i[1];
assign EXMEMRegisterRd = EXMEMinst_i[11:7];
assign MEMWBRegisterRd = MEMWBinst_i[11:7];

always @(*) begin
	if (EXMEMRegWrite && (EXMEMRegisterRd != 5'd0) && (EXMEMRegisterRd == rs1_i)) begin
		ForwardA_o = 2'b10;
	end
	else if (MEMWBRegWrite && (MEMWBRegisterRd != 5'd0) && (MEMWBRegisterRd == rs1_i)) begin
		ForwardA_o = 2'b01;
	end
	else begin
		ForwardA_o = 2'b00;
	end

	if (EXMEMRegWrite && (EXMEMRegisterRd != 5'd0) && (EXMEMRegisterRd == rs2_i)) begin
		ForwardB_o = 2'b10;
	end
	else if (MEMWBRegWrite && (MEMWBRegisterRd != 5'd0) && (MEMWBRegisterRd == rs2_i)) begin
		ForwardB_o = 2'b01;
	end
	else begin
		ForwardB_o = 2'b00;
	end
end

endmodule