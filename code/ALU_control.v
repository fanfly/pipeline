module ALUControl
(
  input [1:0] ALU_op_i,
  input [9:0] funct_i,
  output [2:0] ALU_control_o
);

reg [2:0] ALU_control;

parameter MEMORY = 2'b00;
parameter BRANCH = 2'b01;
parameter COMMON = 2'b10;
parameter IMMEDIATE = 2'b11;

parameter FUNCT_ADD = 10'b0000000000;
parameter FUNCT_SUB = 10'b0100000000;
parameter FUNCT_MUL = 10'b0000001000;
parameter FUNCT_OR  = 10'b0000000110;
parameter FUNCT_AND = 10'b0000000111;

parameter CTRL_ADD = 3'b000;
parameter CTRL_SUB = 3'b001;
parameter CTRL_MUL = 3'b010;
parameter CTRL_OR  = 3'b100;
parameter CTRL_AND = 3'b101;

assign ALU_control_o = ALU_control;

always @(ALU_op_i or funct_i) begin
  case (ALU_op_i)
  MEMORY: begin
    ALU_control <= CTRL_ADD;
  end
  BRANCH: begin
    ALU_control <= CTRL_SUB;
  end
  COMMON: begin
    case (funct_i)
    FUNCT_ADD: begin
      ALU_control <= CTRL_ADD;
    end
    FUNCT_SUB: begin
      ALU_control <= CTRL_SUB;
    end
    FUNCT_MUL: begin
      ALU_control <= CTRL_MUL;
    end
    FUNCT_OR: begin
      ALU_control <= CTRL_OR;
    end
    FUNCT_AND: begin
      ALU_control <= CTRL_AND;
    end
    endcase
  end
  IMMEDIATE: begin
    ALU_control <= CTRL_ADD;
  end
  endcase
end

endmodule
