module Pipeline_IDEX(
    clk_i,
    WB_i,
    M_i,
    EX_i,
    data1_i,
    data2_i,
    signExtend_i,
    rs1_i,
    rs2_i,
    inst_i,
    WB_o,
    M_o,
    EX_o,
    data1_o,
    data2_o,
    signExtend_o,
    rs1_o,
    rs2_o,
    inst_o
);

input   clk_i;
input   [1:0]   WB_i, M_i;
input   [2:0]   EX_i;
input   [31:0]  inst_i, data1_i, data2_i, signExtend_i;
input   [4:0]   rs1_i, rs2_i;
output  reg     [1:0]   WB_o, M_o;
output  reg     [2:0]   EX_o;
output  reg     [31:0]  data1_o, data2_o, signExtend_o, inst_o;
output  reg     [4:0]   rs1_o, rs2_o;

reg    [1:0]   WB_buffer, M_buffer;
reg    [2:0]   EX_buffer;
reg    [31:0]  data1_buffer, data2_buffer, signExtend_buffer, inst_buffer;
reg    [4:0]   rs1_buffer, rs2_buffer;

always @(posedge clk_i) begin
    WB_buffer <= WB_i;
    M_buffer <= M_i;
    EX_buffer <= EX_i;
    data1_buffer <= data1_i;
    data2_buffer <= data2_i;
    signExtend_buffer <= signExtend_i;
    inst_buffer <= inst_i;
    rs1_buffer <= rs1_i;
    rs2_buffer <= rs2_i;
end

always @(negedge clk_i) begin
    WB_o <= WB_buffer;
    M_o <= M_buffer;
    EX_o <= EX_buffer;
    data1_o <= data1_buffer;
    data2_o <= data2_buffer;
    signExtend_o <= signExtend_buffer;
    inst_o <= inst_buffer;
    rs1_o <= rs1_buffer;
    rs2_o <= rs2_buffer;
end

endmodule