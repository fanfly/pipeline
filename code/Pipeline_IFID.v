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

reg	[31:0]	instaddr_buffer, inst_buffer;

always @(posedge clk_i) begin
	instaddr_buffer <= instaddr_i;
	inst_buffer <= inst_i;
end

always @(negedge clk_i) begin
	instaddr_o <= controlflush_i ? 1'b0 : hazzardflush_i ? instaddr_o : instaddr_buffer;
	inst_o <=  controlflush_i ? 1'b0 : hazzardflush_i ? inst_o : inst_buffer;
end

endmodule