module Pipeline_EXMEM(
    clk_i,
    WB_i,
    M_i,
    ALUdata_i,
    MUXALUdata2_i,
    inst_i,
    WB_o,
    M_o,
    ALUdata_o,
    MUXALUdata2_o,
    inst_o
);

input   clk_i;
input   [1:0]   WB_i, M_i;
input   [31:0]  ALUdata_i, MUXALUdata2_i, inst_i;

output  reg     [1:0]   WB_o, M_o;
output  reg     [31:0]  ALUdata_o, MUXALUdata2_o, inst_o;

reg    [1:0]   WB_buffer, M_buffer;
reg    [31:0]  ALUdata_buffer, MUXALUdata2_buffer, inst_buffer;

always @(posedge clk_i or negedge clk_i) begin
    if (clk_i) begin
        WB_buffer <= WB_i;
        M_buffer <= M_i;
        ALUdata_buffer <= ALUdata_i;
        MUXALUdata2_buffer <= MUXALUdata2_i;
        inst_buffer <= inst_i;
    end
    if (!clk_i) begin
        WB_o <= WB_buffer;
        M_o <= M_buffer;
        ALUdata_o <= ALUdata_buffer;
        MUXALUdata2_o <= MUXALUdata2_buffer;
        inst_o <= inst_buffer;
    end
    
end

endmodule