module Forwarding
(
  input [1:0] control_WB_in_MEM_i,
  input [1:0] control_WB_in_WB_i,
  input [4:0] rs1_addr_i,
  input [4:0] rs2_addr_i,
  input [4:0] rd_addr_MEM_i,
  input [4:0] rd_addr_WB_i,
  output [1:0] rs1_forward_o,
  output [1:0] rs2_forward_o
);

assign reg_write_MEM = control_WB_in_MEM_i[1];
assign reg_write_WB = control_WB_in_WB_i[1];

assign rs1_forward_MEM = reg_write_MEM && (rd_addr_MEM_i != 5'b0)
    && (rd_addr_MEM_i == rs1_addr_i);
assign rs1_forward_WB = !rs1_forward_MEM && reg_write_WB && (rd_addr_WB_i != 5'b0)
    && (rd_addr_WB_i == rs1_addr_i);

assign rs2_forward_MEM = reg_write_MEM && (rd_addr_MEM_i != 5'b0)
    && (rd_addr_MEM_i == rs2_addr_i);
assign rs2_forward_WB = !rs1_forward_MEM && reg_write_WB && (rd_addr_WB_i != 5'b0)
    && (rd_addr_WB_i == rs2_addr_i);

assign rs1_forward_o = {rs1_forward_MEM, rs1_forward_WB};
assign rs2_forward_o = {rs2_forward_MEM, rs2_forward_WB};

endmodule
