module IFID_pipeline(
    clk_i,
    start_i,
    hazzardflush_i,
    controlflush_i,
    instaddr_i,
    inst_i,
    instaddr_o,
    inst_o
)

input	clk_i, start_i, hazzardflush_i, controlflush_i;
input	[31:0]	instaddr_i, inst_i;
output	reg	[31:0]	instaddr_o, inst_o;

always @(posedge clk_i) begin
	if (start_i) begin
		if (hazzardflush_i || controlflush_i) begin
			instaddr_o = 32'd0;
			inst_o = 32'd0;
		end
		else begin	
			instaddr_o = instaddr_i;
			inst_o = inst_i;
		end
	end
	else begin
		instaddr_o = 32'd0;
		inst_o = 32'd0;
	end
end