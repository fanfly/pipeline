module MUX_WB(
    MemtoReg_i,
    data_i,
    ALUdata_i,
    writedata_o,
);

input	MemtoReg_i;
input	[31:0]	data_i, ALUdata_i;
output	reg 	[31:0]	writedata_o;

 always @(*) begin
 	if(MemtoReg_i) begin
 		output = data_i;
 	end
 	else begin
 		output = ALUdata_i;
 	end
 end

 endmodule