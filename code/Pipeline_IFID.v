module Pipeline_IFID(
    clk_i,
    hazzardflush_i,
    controlflush_i,
    instaddr_i,
    inst_i,
    instaddr_o,
    inst_o
);

input	clk_i, hazzardflush_i, controlflush_i;
input	[31:0]	instaddr_i, inst_i;
output	reg	[31:0]	instaddr_o = 32'd0, inst_o = 32'd0;

reg hazzardflush_buffer, controlflush_buffer;
reg	[31:0]	instaddr_buffer, inst_buffer;

always @(posedge clk_i) begin
	instaddr_buffer <= instaddr_i;
	inst_buffer <= inst_i;
    hazzardflush_buffer <= hazzardflush_i;
    controlflush_buffer <= controlflush_i;
end

always @(negedge clk_i) begin
	instaddr_o <= controlflush_buffer ? 1'b0 : hazzardflush_buffer ? instaddr_o : instaddr_buffer;
	inst_o <=  controlflush_buffer ? 1'b0 : hazzardflush_buffer ? inst_o : inst_buffer;
end

endmodule