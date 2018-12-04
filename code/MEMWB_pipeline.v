module MEMWB_pipeline(
	clk_i,
    start_i,
    WB_i,
    data_i,
    ALUdata_i,
    inst_i,
    WB_o,
    data_o,
    ALUdata_o,
    inst_o
);

input			clk_i, start_i;
input	[2:0]	WB_i;
input	[31:0]	data_i, ALUdata_i, inst_i;
output	reg		[2:0]	WB_o;
output	reg 	[31:0]	data_o, ALUdata_o, inst_o;

always @(posedge clk_i) begin
	if (start_i) begin
		WB_o = WB_i;
		data_o = data_i;
		ALUdata_o = ALUdata_i;
		inst_o = inst_i;
	end
	else begin
		WB_o = 2'd0;
		data_o = 32'd0;
		ALUdata_o = 32'd0;
		inst_o = 32'd0;
	end
end

endmodule