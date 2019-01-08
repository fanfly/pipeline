module Immediate
(
  input [31:0] inst_i,
  output [31:0] immediate_o
);

reg [11:0] immediate;

wire [6:0] op;
wire op_lw;
wire op_sw;
wire op_beq;
wire op_addi;

assign op = inst_i[6:0];
assign immediate_o = {(immediate[11] == 1'b1 ? 20'b1 : 20'b0), immediate};

assign op_lw     = (op == 7'b0000011);
assign op_sw     = (op == 7'b0100011);
assign op_beq    = (op == 7'b1100011);
assign op_addi   = (op == 7'b0010011);
assign op_common = (op == 7'b0110011);

always @(*) begin
  if (op_addi || op_lw) begin
    immediate = inst_i[31:20];
  end
  else if (op_sw) begin
    immediate = {inst_i[31:25], inst_i[11:7]};
  end
  else if (op_beq) begin
    immediate = {inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8]};
  end
  else begin
    immediate = 12'b0;
  end
end

endmodule
