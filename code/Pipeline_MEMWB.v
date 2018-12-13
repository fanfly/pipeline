module Pipeline_MEMWB(
	clk_i,
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
input	[1:0]	WB_i;
input	[31:0]	data_i, ALUdata_i, inst_i;
output	reg		[1:0]	WB_o;
output	reg 	[31:0]	data_o, ALUdata_o, inst_o;

reg     [1:0]   WB_buffer;
reg     [31:0]  data_buffer, ALUdata_buffer, inst_buffer;

always @(posedge clk_i or negedge clk_i) begin
    if (clk_i) begin
        WB_buffer <= WB_i;
        data_buffer <= data_i;
        ALUdata_buffer <= ALUdata_i;
        inst_buffer <= inst_i;
    end
    if (!clk_i) begin
        WB_o <= WB_buffer;
        data_o <= data_buffer;
        ALUdata_o <= ALUdata_buffer;
        inst_o <= inst_buffer;
    end
end

endmodule