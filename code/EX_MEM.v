module EXMEM
(
  input clock_i,
  input flush_i,
  input enable_i,
  input [1:0] control_MEM_i,
  input [1:0] control_WB_i,
  input [31:0] inst_i,
  input [31:0] result_i,
  input [31:0] data_i,
  output [1:0] control_MEM_o,
  output [1:0] control_WB_o,
  output [31:0] inst_o,
  output [31:0] result_o,
  output [31:0] data_o
);

reg [1:0] control_MEM;
reg [1:0] control_WB;
reg [31:0] inst;
reg [31:0] result;
reg [31:0] data;

assign control_MEM_o = control_MEM;
assign control_WB_o = control_WB;
assign inst_o = inst;
assign result_o = result;
assign data_o = data;

always @(posedge flush_i) begin
  control_MEM <= 2'b0;
  control_WB <= 2'b0;
  inst <= 32'b0;
  result <= 32'b0;
  data <= 32'b0;
end

always @(posedge clock_i) begin
  if (enable_i) begin
    control_MEM <= control_MEM_i;
    control_WB <= control_WB_i;
    inst <= inst_i;
    result <= result_i;
    data <= data_i;
  end
end

endmodule
