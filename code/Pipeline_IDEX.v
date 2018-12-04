module Pipeline_IDEX(
    clk_i,
    start_i,
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

input   clk_i, start_i;
input   [1:0]   WB_i, M_i;
input   [2:0]   EX_i;
input   [31:0]  inst_i, data1_i, data2_i, signExtend_i;
input   [5:0]   rs1_i, rs2_i;
output  reg     [1:0]   WB_o, M_o;
output  reg     [2:0]   EX_o;
output  reg     [31:0]  data1_o, data2_o, signExtend_o, inst_o;
output  reg     [5:0]   rs1_o, rs2_o;

always @(posedge clk_i) begin
    if (start_i) begin
        WB_o = WB_i;
        M_o = M_i;
        EX_o = EX_i;
        data1_o = data1_i;
        data2_o = data2_i;
        signExtend_o = signExtend_i;
        inst_o = inst_i;
        rs1_o = rs1_i;
        rs2_o = rs2_i;
    end
    else begin
        WB_o = 2'd0;
        M_o = 2'd0;
        EX_o = 2'd0;
        data1_o = 32'd0;
        data2_o = 32'd0;
        signExtend_o = 32'd0;
        inst_o = 32'd0;
        rs1_o = 6'd0;
        rs2_o = 6'd0;
    end
end