module EXMEM_pipeline(
    .clk_i,
    .start_i,
    .WB_i,
    .M_i,
    .ALUdata_i,
    .MUXALUdata2_i,
    .inst_i,
    .WB_o,
    .M_o,
    .ALUdata_o,
    .MUXALUdata2_o,
    .inst_o
);

input   clk_i, start_i;
input   [1:0]   WB_i, M_i;
input   [31:0]  ALUdata_i, MUXALUdata2_i, inst_i;

output  reg     [1:0]   WB_o, M_o;
output  reg     [31:0]  ALUdata_o, MUXALUdata2_o, inst_o;

always @(posedge clk_i) begin
    if (start_i) begin
        WB_o = WB_i;
        M_o = M_i;
        ALUdata_o = ALUdata_i;
        MUXALUdata2_o = MUXALUdata2_i;
        inst_o = inst_i;
    end
    else begin
        WB_o = 2'd0;
        M_o = 2'd0;
        ALUdata_o = 32'd0;
        MUXALUdata2_o = 32'd0;
        inst_o = 32'd0;
    end
end