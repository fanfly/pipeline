module Control(
    inst_i,
    data1_i,
    data2_i,
    IFflush_o,
    IDflush_o,
    EXflush_o,
    WB_o,
    M_o,
    EX_o,
    Jump_o
)

input   [31:0]  inst_i, data1_i, data2_i;
output  reg     IFflush_o, IDflush_o, EXflush_o, Jump_o;
output  reg [2:0]   EX_o;
output  reg [1:0]   M_o, WB_o;

wire    [6:0]    inst;

always @(*) begin
    inst = inst_i[6:0];
    if (inst == 7'b0000011) begin
        EX_o = 3'b001;
        M_o = 2'b10;
        WB_o = 2'b11;
        Jump_o = 1'b0;
        IFflush_o = 1'b0;
        IDflush_o = 1'b0;
        EXflush_o = 1'b0;
    end
    else if (inst == 7'b0100011) begin
        EX_o = 3'b001;
        M_o = 2'b01;
        WB_o = 2'b00;
        Jump_o = 1'b0;
        IFflush_o = 1'b0;
        IDflush_o = 1'b0;
        EXflush_o = 1'b0;
    end
    else if (inst == 7'b1100011) begin
        if (data1_i == data2_i) begin
            EX_o = 3'b010;
            M_o = 2'b00;
            WB_o = 2'b00;
            Jump_o = 1'b1;
            IFflush_o = 1'b1;
            IDflush_o = 1'b1;
            EXflush_o = 1'b1;
        end
        else begin
            EX_o = 3'b010;
            M_o = 2'b00;
            WB_o = 2'b00;
            Jump_o = 1'b0;
            IFflush_o = 1'b0;
            IDflush_o = 1'b0;
            EXflush_o = 1'b0;
        end
    end
    else if (inst == 7'b0110011) begin
        EX_o = 3'b100;
        M_o = 2'b00;
        WB_o = 2'b10;
        Jump_o = 1'b0;
        IFflush_o = 1'b0;
        IDflush_o = 1'b0;
        EXflush_o = 1'b0;
    end
    else if (inst == 7'b0010011) begin
        EX_o = 3'b110;
        M_o = 2'b00;
        WB_o = 2'b10;
        Jump_o = 1'b0;
        IFflush_o = 1'b0;
        IDflush_o = 1'b0;
        EXflush_o = 1'b0;
    end
    
end