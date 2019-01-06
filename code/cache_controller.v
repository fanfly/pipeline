module CacheController
(
  // Clock, Flush and Stall
  input clock_i,
  input flush_i,
  output stall_o,
  // To Upper Layer
  input [31:0] addr_i,
  input [31:0] data_i,
  input read_i,
  input write_i,
  output [31:0] data_o,
  // To Cache
  input cache_valid_i,
  input cache_dirty_i,
  input [21:0] cache_tag_i,
  input [255:0] cache_data_i,
  output cache_enable_o,
  output cache_write_o,
  output [4:0] cache_index_o,
  output cache_valid_o,
  output cache_dirty_o,
  output [21:0] cache_tag_o,
  output [255:0] cache_data_o,
  // To Lower Layer
  input memory_ack_i,
  input [255:0] memory_data_i,
  output memory_enable_o,
  output memory_write_o,
  output [31:0] memory_addr_o,
  output [255:0] memory_data_o
);

parameter STATE_IDLE = 3'h0;
parameter STATE_CHECK = 3'h1;
parameter STATE_WRITE_BACK = 3'h2;
parameter STATE_ALLOCATE = 3'h3;
parameter STATE_ALLOCATE_FINISHED = 3'h4;

reg [2:0] state;
reg read;
reg write;
reg [31:0] addr;
reg [31:0] data;

reg [255:0] cache_data;
reg [31:0] memory_addr;

wire [255:0] mask;
wire [255:0] data_offset;

wire request;
wire hit;
wire [21:0] tag;
wire [4:0] index;
wire [4:0] offset;

assign request = read_i || write_i;
assign hit = cache_valid_i && (tag == cache_tag_i);
assign tag = addr[31:10];
assign index = addr[9:5];
assign offset = addr[4:0];

assign cache_enable_o = (state != STATE_IDLE);
assign cache_write_o = (state == STATE_ALLOCATE_FINISHED) ||
    (state == STATE_CHECK && hit && write);
assign cache_valid_o = 1'b1;
assign cache_dirty_o = (state == STATE_CHECK && hit);
assign cache_tag_o = tag;
assign cache_index_o = index;
assign cache_data_o = state == STATE_ALLOCATE ? memory_data_i : cache_data;

assign mask = write ? ~(256'b11111111 << (offset * 8)) : ~256'b0;
assign data_offset = {224'b0, data} << (offset * 8);

assign memory_enable_o = (state == STATE_WRITE_BACK || state == STATE_ALLOCATE);
assign memory_write_o = (state == STATE_WRITE_BACK);
assign memory_addr_o = memory_addr;
assign memory_data_o = cache_data;

assign stall_o = cache_enable_o;
assign data_o = (read && !stall_o) ? data : 32'b0;

always @(posedge clock_i or posedge flush_i) begin
  if (flush_i) begin
    state <= STATE_IDLE;
    read <= 1'b0;
    write <= 1'b0;
    addr <= 32'b0;
    data <= 32'b0;
    cache_data <= 256'b0;
    memory_addr <= 32'b0;
  end
  else begin
    case (state)
    STATE_IDLE: begin
      read = read_i;
      write = write_i;
      if (request) begin
        state <= STATE_CHECK;
        addr = addr_i;
        if (write) begin
          data = data_i;
        end
      end
    end
    STATE_CHECK: begin
      if (cache_valid_i && (tag == cache_tag_i)) begin
        /* Hit */
        state <= STATE_IDLE;
        if (write) begin
          cache_data = (cache_data_i & mask) | data_offset;
        end
        else if (read) begin
          cache_data = cache_data_i;
          data = cache_data >> (offset * 8);
        end
      end
      else begin
        /* Miss */
        if (cache_dirty_i) begin
          state <= STATE_WRITE_BACK;
          cache_data <= cache_data_i;
        end
        else begin
          state <= STATE_ALLOCATE;
        end
        memory_addr <= {cache_tag_i, index, 5'b0};
      end
    end
    STATE_WRITE_BACK: begin
      if (memory_ack_i) begin
        state <= STATE_ALLOCATE;
      end
    end
    STATE_ALLOCATE: begin
      state <= STATE_ALLOCATE_FINISHED;
      cache_data = memory_data_i;
    end
    STATE_ALLOCATE_FINISHED: begin
      state <= STATE_CHECK;
    end
    endcase
  end
end

endmodule
