module ALU
(
  input [2:0] ALU_control_i,
  input [31:0] data1_i,
  input [31:0] data2_i,
  output [31:0] result_o
);

reg [31:0] result;

parameter ADD = 3'b000;
parameter SUB = 3'b001;
parameter MUL = 3'b010;
parameter OR  = 3'b100;
parameter AND = 3'b101;

assign result_o = result;

always @(*) begin
  case (ALU_control_i)
  ADD: begin
    result <= data1_i + data2_i;
  end
  SUB: begin
    result <= data1_i - data2_i;
  end
  MUL: begin
    result <= data1_i * data2_i;
  end
  OR: begin
    result <= data1_i | data2_i;
  end
  AND: begin
    result <= data1_i & data2_i;
  end
  endcase
end

endmodule
