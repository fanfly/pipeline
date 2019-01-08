module IDEX
(
  input clock_i,
  input flush_i,
  input enable_i,
  input [2:0] control_EX_i,
  input [1:0] control_MEM_i,
  input [1:0] control_WB_i,
  input [31:0] immediate_i,
  input [31:0] inst_i,
  input [31:0] rs1_data_i,
  input [31:0] rs2_data_i,
  output [2:0] control_EX_o,
  output [1:0] control_MEM_o,
  output [1:0] control_WB_o,
  output [31:0] immediate_o,
  output [31:0] inst_o,
  output [31:0] rs1_data_o,
  output [31:0] rs2_data_o
);

reg [2:0] control_EX;
reg [1:0] control_MEM;
reg [1:0] control_WB;
reg [31:0] immediate;
reg [31:0] inst;
reg [31:0] rs1_data;
reg [31:0] rs2_data;

assign control_EX_o = control_EX;
assign control_MEM_o = control_MEM;
assign control_WB_o = control_WB;
assign immediate_o = immediate;
assign inst_o = inst;
assign rs1_data_o = rs1_data;
assign rs2_data_o = rs2_data;

always @(posedge flush_i) begin
  control_EX <= 3'b0;
  control_MEM <= 2'b0;
  control_WB <= 2'b0;
  immediate <= 32'b0;
  inst <= 32'b0;
  rs1_data <= 32'b0;
  rs2_data <= 32'b0;
end

always @(posedge clock_i) begin
  if (enable_i) begin
    control_EX <= control_EX_i;
    control_MEM <= control_MEM_i;
    control_WB <= control_WB_i;
    immediate <= immediate_i;
    inst <= inst_i;
    rs1_data <= rs1_data_i;
    rs2_data <= rs2_data_i;
  end
end

endmodule
