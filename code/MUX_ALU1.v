module MUX_ALU1(
    .ForwardA_i,
    .data1_i,
    .dataWB_i,
    .dataFor_i,
    .data1_o
);

input	[1:0]	ForwardA_i;
input	[31:0]	data1_i, dataWB_i, dataFor_i;
output	reg		[31:0]	data1_o;

always @(*) begin
	if (ForwardA_i == 2'b00) begin
		data1_o = data1_i;
	end
	else if (ForwardA_i == 2'b01) begin
		data1_o = dataWB_i;
	end
	else if (ForwardA_i == 2'b10) begin
		data1_o = dataFor_i;
	end
end