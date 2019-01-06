module Cache
(
  input clock_i,
  input enable_i,
  input write_i,
  input [4:0] index_i,
  input valid_i,
  input dirty_i,
  input [21:0] tag_i,
  input [255:0] data_i,
  output valid_o,
  output dirty_o,
  output [21:0] tag_o,
  output [255:0] data_o
);

reg valid [0:31];
reg dirty [0:31];
reg [21:0] tag [0:31];
reg [255:0] data [0:31];

assign valid_o = enable_i ? valid[index_i] : 1'b0;
assign dirty_o = enable_i ? dirty[index_i] : 1'b0;
assign tag_o = enable_i ? tag[index_i] : 22'b0;
assign data_o = enable_i ? data[index_i] : 256'b0;

always @(*) begin
  if (enable_i && write_i) begin
    valid[index_i] <= valid_i;
    dirty[index_i] <= dirty_i;
    tag[index_i] <= tag_i;
    data[index_i] <= data_i;
  end
end

endmodule
