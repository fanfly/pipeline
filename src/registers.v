module Registers
(
	input clock_i,
  input flush_i,
  input write_i,
  input [4:0] rs1_addr_i,
  input [4:0] rs2_addr_i,
  input [4:0] rd_addr_i,
  input [31:0] rd_data_i,
  output [31:0] rs1_data_o,
  output [31:0] rs2_data_o
);

reg [31:0] register [0:31];
integer i;

assign rs1_data_o = register[rs1_addr_i];
assign rs2_data_o = register[rs2_addr_i];

always @(posedge clock_i or posedge flush_i) begin
  if (flush_i) begin
    for (i = 0; i < 32; i = i + 1) begin
      register[i] <= 32'b0;
    end
  end
	else if (write_i) begin
    register[rd_addr_i] <= rd_data_i;
  end
end

endmodule
