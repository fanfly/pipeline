module PC
(
  input clock_i,
  input flush_i,
  input enable_i,
  input [31:0] pc_i,
  output [31:0] pc_o
);

reg [31:0] pc;

assign pc_o = pc;

always @(posedge clock_i or posedge flush_i) begin
  if (flush_i) begin
    pc <= 32'b0;
  end
  else if (enable_i) begin
    pc <= pc_i;
  end
end

endmodule
