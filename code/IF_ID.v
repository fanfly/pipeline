module IFID
(
  input clock_i,
  input flush_i,
  input enable_i,
  input [31:0] pc_i,
  input [31:0] inst_i,
  output [31:0] pc_o,
  output [31:0] inst_o
);

reg [31:0] pc;
reg [31:0] inst;

assign pc_o = pc;
assign inst_o = inst;

always @(posedge clock_i or posedge flush_i) begin
  if (flush_i) begin
    pc <= 32'b0;
    inst <= 32'b0;
  end
  else if (enable_i) begin
    pc <= pc_i;
    inst <= inst_i;
  end
end

endmodule
