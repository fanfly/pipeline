module PC(
    clk_i,
    start_i,
    //rst_i,
    pc_i,
    PCflush_i,
    pc_o
);

input	clk_i, start_i, PCflush_i;
//input	rst_i;
input	[31:0]	pc_i;
output 	reg		[31:0]	pc_o;

reg	[31:0]	pc_buffer;

always @(negedge clk_i) begin
	if (~start_i) begin
		pc_o <= 32'b0;
	end
	else begin
		if ((start_i && PCflush_i == 1'b0)) begin
			pc_o <= pc_i;
		end
		else begin
			pc_o <= pc_o;
		end
	end
end

endmodule