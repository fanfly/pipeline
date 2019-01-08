module DataMemory
(
	input clock_i,
  input flush_i,
  input enable_i,
  input write_i,
  input [31:0] addr_i,
  input [255:0] data_i,
  output ack_o,
  output [255:0] data_o
);

parameter STATE_IDLE = 1'b0;
parameter STATE_WAIT = 1'b1;

reg	[255:0]	memory [0:511];

reg [3:0] count;
reg state;
reg [255:0] data;

assign ack_o = (state == STATE_WAIT) && (count == 4'd9);
assign data_o = data;

always @(posedge clock_i or posedge flush_i) begin
  if (flush_i) begin
    count <= 4'd0;
    state <= STATE_IDLE;
    data <= 256'b0;
  end
  else begin
    case (state)
    STATE_IDLE: begin
      count <= 4'd0;
      if (enable_i) begin
        state <= STATE_WAIT;
      end
    end
    STATE_WAIT: begin
      count <= count + 1;
      if (count == 4'd9)  begin
        state <= STATE_IDLE;
        if (write_i) begin
          memory[addr_i >> 5] <= data_i;
        end
        else begin
          data <= memory[addr_i >> 5];
        end
      end
    end
    endcase
  end
end

endmodule
