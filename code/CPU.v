module CPU
(
    clk_i,
    rst_i,
    start_i
);

// Ports
input   clk_i;
input   start_i;
input   rst_i;

wire    [31:0]  IF_instaddr;
wire    [31:0]  ID_inst, ID_signExtend, ID_data1, ID_data2;
wire    [1:0]   EX_M;
wire    [2:0]   EX_EX;
wire    [31:0]  EX_inst, EX_MUXALUdata2;
wire    [1:0]   MEM_WB;
wire    [1:0]   MEM_M;
wire    [31:0]  MEM_ALUdata, MEM_inst;
wire    [1:0]   WB_WB;
wire    [31:0]  WB_data, WB_inst;

MUX_PC MUX_PC(
    .Branch_i   (Control.Jump_o),
    .pc0_i      (Add_PC.data_o),
    .pc1_i      (Add_Branch.data_o),
    .pc_o       ()
);

PC PC(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .rst_i      (rst_i),
    .pc_i       (MUX_PC.pc_o),
    .PCflush_i  (HazzardDetection.PCflush_o),
    .pc_o       (IF_instaddr)
);

Add_PC Add_PC(
    .data1_i    (IF_instaddr),
    .data2_i    (32'd4),
    .data_o     ()
);

Instruction_Memory Instruction_Memory(
    .instaddr_i     (IF_instaddr), 
    .inst_o         ()
);

/*------------ IF/ID ------------*/

Pipeline_IFID Pipeline_IFID(
    .clk_i          (clk_i),
    .hazzardflush_i (HazzardDetection.IFIDflush_o),
    .controlflush_i (Control.IFIDflush_o),
    .instaddr_i     (PC.pc_o),
    .inst_i         (Instruction_Memory.inst_o),
    .instaddr_o     (),
    .inst_o         (ID_inst)
);

ImmGen ImmGen(
    .data_i     (ID_inst),
    .data_o     (ID_signExtend)
);

Add_Branch Add_Branch(
    .data1_i    (ID_signExtend),
    .data2_i    (Pipeline_IFID.instaddr_o),
    .data_o     ()
);

Registers Registers(
    .rs1_i          (ID_inst[19:15]),
    .rs2_i          (ID_inst[24:20]),
    .writeaddr_i    (WB_inst[11:7]),
    .writedata_i    (WB_data),
    .RegWrite_i     (WB_WB[1]),
    .data1_o        (ID_data1),
    .data2_o        (ID_data2)
);

HazzardDetection HazzardDetection(
    .IFIDinst_i     (ID_inst),
    .IDEXinst_i     (EX_inst),
    .MemRead_i      (EX_M[1]),
    .PCflush_o      (),
    .IFIDflush_o    (),
    .IDflush_o      ()
);

Control Control(
    .inst_i         (ID_inst),
    .data1_i        (ID_data1),
    .data2_i        (ID_data2),
    .IFIDflush_o    (),
    .WB_o           (),
    .M_o            (),
    .EX_o           (),
    .Jump_o         ()
);

MUX_IDEX MUX_IDEX(
    .hazzardflush_i (HazzardDetection.IDflush_o),
    .WB_i           (Control.WB_o),
    .M_i            (Control.M_o),
    .EX_i           (Control.EX_o),
    .WB_o           (),
    .M_o            (),
    .EX_o           ()
);

/*------------ ID/EX ------------*/

Pipeline_IDEX Pipeline_IDEX(
    .clk_i          (clk_i),
    .WB_i           (MUX_IDEX.WB_o),
    .M_i            (MUX_IDEX.M_o),
    .EX_i           (MUX_IDEX.EX_o),
    .data1_i        (ID_data1),
    .data2_i        (ID_data2),
    .signExtend_i   (ID_signExtend),
    .rs1_i          (ID_inst[19:15]),
    .rs2_i          (ID_inst[24:20]),
    .inst_i         (ID_inst),
    .WB_o           (),
    .M_o            (EX_M),
    .EX_o           (EX_EX),
    .data1_o        (),
    .data2_o        (),
    .signExtend_o   (),
    .rs1_o          (),
    .rs2_o          (),
    .inst_o         (EX_inst)
);

MUX_ALU1 MUX_ALU1(
    .ForwardA_i (ForwardingUnit.ForwardA_o),
    .data1_i    (Pipeline_IDEX.data1_o),
    .dataWB_i   (WB_data),
    .dataFor_i  (MEM_ALUdata),
    .data1_o    ()
);

MUX_ALU2 MUX_ALU2(
    .ForwardB_i (ForwardingUnit.ForwardB_o),
    .data2_i    (Pipeline_IDEX.data2_o),
    .dataWB_i   (WB_data),
    .dataFor_i  (MEM_ALUdata),
    .data2_o    (EX_MUXALUdata2)
);

MUX_ALUSrc  MUX_ALUSrc(
    .data1_i    (EX_MUXALUdata2),
    .data2_i    (Pipeline_IDEX.signExtend_o),
    .ALUSrc_i   (EX_EX[0]),
    .data_o     ()
);

ALU_Control ALU_Control(
    .ALUOp_i    (EX_EX[2:1]),
    .inst_i     (EX_inst),
    .ALUCtr_o   ()
);

ALU ALU(
    .ALUCtr_i   (ALU_Control.ALUCtr_o),
    .data1_i    (MUX_ALU1.data1_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .data_o     ()
);

ForwardingUnit ForwardingUnit(
    .EXMEMinst_i        (MEM_inst),
    .EXMEMwb_i          (MEM_WB),
    .MEMWBinst_i        (WB_inst),
    .MEMWBwb_i          (WB_WB),
    .rs1_i              (Pipeline_IDEX.rs1_o),
    .rs2_i              (Pipeline_IDEX.rs2_o),
    .ForwardA_o         (),
    .ForwardB_o         ()
);

/*------------ EX/MEM ------------*/

Pipeline_EXMEM Pipeline_EXMEM(
    .clk_i          (clk_i),
    .WB_i           (Pipeline_IDEX.WB_o),
    .M_i            (EX_M),
    .ALUdata_i      (ALU.data_o),
    .MUXALUdata2_i  (EX_MUXALUdata2),
    .inst_i         (EX_inst),
    .WB_o           (MEM_WB),
    .M_o            (MEM_M),
    .ALUdata_o      (MEM_ALUdata),
    .MUXALUdata2_o  (),
    .inst_o         (MEM_inst)
);

Data_Memory Data_Memory(
    .MemRead_i      (MEM_M[1]),
    .MemWrite_i     (MEM_M[0]),
    .address_i      (MEM_ALUdata),
    .data_i         (Pipeline_EXMEM.MUXALUdata2_o),
    .data_o         ()
);

/*------------ MEM/WB ------------*/

Pipeline_MEMWB Pipeline_MEMWB(
    .clk_i          (clk_i),
    .WB_i           (MEM_WB),
    .data_i         (Data_Memory.data_o),
    .ALUdata_i      (MEM_ALUdata),
    .inst_i         (MEM_inst),
    .WB_o           (WB_WB),
    .data_o         (),
    .ALUdata_o      (),
    .inst_o         (WB_inst)
);

MUX_WB MUX_WB(
    .MemtoReg_i     (WB_WB[0]),
    .data_i         (Pipeline_MEMWB.data_o),
    .ALUdata_i      (Pipeline_MEMWB.ALUdata_o),
    .writedata_o    (WB_data)
);

endmodule