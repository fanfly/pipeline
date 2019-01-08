module HazardDetection
(
  input [4:0] rs1_addr_ID_i,
  input [4:0] rs2_addr_ID_i,
  input [4:0] rd_addr_EX_i,
  input memory_read_EX_i,
  output hazard_o
);

assign hazard_o = memory_read_EX_i &&
    (rs1_addr_ID_i == rd_addr_EX_i || rs2_addr_ID_i == rd_addr_EX_i);

endmodule