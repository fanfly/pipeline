module Control
(
  input clock_i,
  input flush_i,
  input enable_i,
  input [6:0] op_i,
  input [31:0] rs1_data_i,
  input [31:0] rs2_data_i,
  output [2:0] control_EX_o,
  output [1:0] control_MEM_o,
  output [1:0] control_WB_o,
  output branch_o
);

wire op_lw;
wire op_sw;
wire op_beq;
wire op_addi;
wire op_common; // and, or, add, sub, mul

reg [2:0] control_EX;
reg [1:0] control_MEM;
reg [1:0] control_WB;

// EX
wire [1:0] ALU_op;
wire ALU_imm;

// MEM
wire memory_read;
wire memory_write;

// WB
wire reg_write;
wire memory_to_reg;

assign op_lw     = (op_i == 7'b0000011);
assign op_sw     = (op_i == 7'b0100011);
assign op_beq    = (op_i == 7'b1100011);
assign op_addi   = (op_i == 7'b0010011);
assign op_common = (op_i == 7'b0110011);

assign ALU_op        = {(op_common || op_addi), (op_beq || op_addi)};
assign ALU_imm       = op_lw || op_sw || op_addi;
assign memory_read   = op_lw;
assign memory_write  = op_sw;
assign reg_write     = op_lw || op_addi || op_common;
assign memory_to_reg = op_lw;

assign control_EX_o  = control_EX;
assign control_MEM_o = control_MEM;
assign control_WB_o  = control_WB;
assign branch_o      = op_beq && (rs1_data_i == rs2_data_i);

always @(posedge flush_i) begin
  control_EX <= 3'b0;
  control_MEM <= 2'b0;
  control_WB <= 2'b0;
end

always @(*) begin
  if (enable_i) begin
    control_EX <= {ALU_op, ALU_imm};
    control_MEM <= {memory_read, memory_write};
    control_WB <= {reg_write, memory_to_reg};
  end
end

endmodule
