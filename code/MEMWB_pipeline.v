module MEMWB_pipeline
(
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

input			clk_i, start_i, WB_i;
input	[31:0]	data_i, ALUdata_i, inst_i;
output	reg				WB_o;
output	reg 	[31:0]	data_o, ALUdata_o, inst_o;

always @(posedge clk_i or negedge clk_i) begin
	WB_o = WB_i;
	data_o = data_i;
	ALUdata_o = ALUdata_il;
	inst_o = inst_i;
end

endmodule