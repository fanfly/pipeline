module Control(
    inst_i,
    data1_i,
    data2_i,
    IFIDflush_o,
    WB_o,
    M_o,
    EX_o,
    Jump_o
);

input   [31:0]      inst_i, data1_i, data2_i;
output  reg         IFIDflush_o = 1'b0, Jump_o = 1'b0;
output  reg [2:0]   EX_o;
output  reg [1:0]   M_o, WB_o;

wire    [6:0]    inst;

assign inst = inst_i[6:0];

always @(*) begin
    if (inst == 7'b0000011) begin
        //lw
        EX_o = 3'b001;
        M_o = 2'b10;
        WB_o = 2'b11;
        Jump_o = 1'b0;
        IFIDflush_o = 1'b0;
    end
    else if (inst == 7'b0100011) begin
        //sw
        EX_o = 3'b001;
        M_o = 2'b01;
        WB_o = 2'b00;
        Jump_o = 1'b0;
        IFIDflush_o = 1'b0;
    end
    else if (inst == 7'b1100011) begin
        //beq
        if (data1_i == data2_i) begin
            EX_o = 3'b010;
            M_o = 2'b00;
            WB_o = 2'b00;
            Jump_o = 1'b1;
            IFIDflush_o = 1'b1;
        end
        else begin
            EX_o = 3'b010;
            M_o = 2'b00;
            WB_o = 2'b00;
            Jump_o = 1'b0;
            IFIDflush_o = 1'b0;
        end
    end
    else if (inst == 7'b0110011) begin
        //R-format
        EX_o = 3'b100;
        M_o = 2'b00;
        WB_o = 2'b10;
        Jump_o = 1'b0;
        IFIDflush_o = 1'b0;
    end
    else if (inst == 7'b0010011) begin
        //addi 
        EX_o = 3'b111;
        M_o = 2'b00;
        WB_o = 2'b10;
        Jump_o = 1'b0;
        IFIDflush_o = 1'b0;
    end
    else begin
        EX_o = 3'b000;
        M_o = 2'b00;
        WB_o = 2'b00;
        Jump_o = 1'b0;
        IFIDflush_o = 1'b0;
    end
end

endmodule