module PC(
    clk_i,
    start_i,
    pc_i,
    PCflush_i,
    pc_o
);

input	clk_i, start_i, PCflush_i;
input	[31:0]	pc_i;
output 	reg		[31:0]	pc_o;

always @(posedge clk_i) begin
	if (~start_i) begin
		pc_o = 32'd0;
	end
	else begin
		if (~PCflush_i) begin
			pc_o = pc_i;
		end
		else begin
			pc_o = pc_o;
		end
	end
end
endmodule