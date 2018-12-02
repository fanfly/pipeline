module CPU
(
    clk_i,
    start_i
);

// Ports
input               clk_i;
input               start_i;

wire    [31:0]  IF_instaddr;
wire    [31:0]  ID_instaddr, ID_inst, ID_option, sign_Extend;
wire    [31:0]  EX_inst, EX_MUXALUdata2;
wire    [31:0]  MEM_ALUdata, MEM_inst, MEM_WB;
wire    [31:0]  WB_data, WB_WB, WB_inst;

MUX_PC MUX_PC(
    .pc0_i      (Add_PC.data_o),
    .pc1_i      (Add_Branch.data_o),
    .pc_o       ()
);

PC PC(
    .clk_i      (clk_i),
    .start_i    (start_i),
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

IFID_pipeline IFID_pipeline(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .hazzardflush_i (HazzardDetection.IFIDflush_o),
    .controlflush_i (Control.IFID_flush),
    .instaddr_i     (PC.pc_o),
    .inst_i         (Instruction_Memory.inst_o),
    .instaddr_o     (ID_instaddr),
    .inst_o         (ID_inst)
)

HazzardDetection HazzardDetection(
    .IFIDinst_i     (ID_inst),
    .IDEXinst_i     (EX_inst),
    .hazzardflush_i (IDEX_pipeline.hazzardflush_o),
    .PCflush_o      (),
    .IFIDflush_o    (),
    .instflush_o    (),
    .mux8_o         (),
    .Flush_o        ()
);

Control Control(
    .inst_i     (ID_inst),
    .IFflush_o  (),
    .IDflush_o  (),
    .EXflush_o  (),
    .WB_o       (),
    .M_o        (),
    .EX_o       (),
    .Jump_o     (),
    .Branch_o   ()
);

Add_Branch Add_Branch(
    .data_i     (sign_Extend),
    .instaddr_i (ID_instaddr),
    .data_o     ()
);

Registers Registers(
    .rs1_i          (ID_inst[19:25]),
    .rs2_i          (ID_inst[24:20]),
    .writeaddr_i    (WB_inst),
    .writedata_i    (WB_data),
    .RegWrite_i     (WB_WB)
    .data1_o        (),
    .data2_o        ()
);

ImmGen ImmGen(
    .data_i     (IFID_pipeline.inst_o),
    .data_o     (sign_Extend)
);

MUX_IDEX MUX_IDEX(
    .instflush_i    (HazzardDetection.instflush_o),
    .IDflush_i      (Control.IDflush_o),
    .inst_i         (Control.inst_o),
    .zero_i         (32'd0),
    .Option_o       (ID_option)
);  

/*------------ ID/EX ------------*/

IDEX_pipeline IDEX_pipeline(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .WB_i           (Control.WB_o),
    .M_i            (Control.M_o),
    .EX_i           (Control.EX_o),
    .instaddr_i     (ID_instaddr),
    .data1_i        (Registers.data1_o),
    .data2_i        (Registers.data2_o),
    .sign_Extend_i  (sign_Extend),
    .rs1_i          (ID_inst[19:25]),
    .rs2_i          (ID_inst[24:20]),
    .inst_i         (ID_inst),
    .WB_o           (),
    .M_o            (),
    .data1_o        (),
    .data2_o        (),
    .rs1_o          (),
    .rs2_o          (),
    .inst_o         (EX_inst)
);

MUX_EXMEM1 MUX_EXMEM1(
    .control_i  (Control.EXflush_o),
    .WB_i       (IDEX_pipeline.WB_o),
    .zero_i     (32'd0),
    .WB_o       (),  
);

MUX_EXMEM2 MUX_EXMEM2(
    .control_i  (Control.EXflush_o),
    .M_i        (IDEX_pipeline.M_o),
    .zero_i     (32'd0),
    .M_o        ()
);

MUX_ALU1 MUX_ALU1(
    .control_i  (ForwardingUnit.MUXALU1control_o),
    .data1_i    (IDEX_pipeline.data1_i),
    .dataWB_i   (WB_data),
    .dataFor_i  (MEM_ALUdata),
    .data1_o    (),
);

MUX_ALU2 MUX_ALU2(
    .control_i  (ForwardingUnit.MUXALU2control_o),
    .data2_i    (IDEX_pipeline.data2_i),
    .dataWB_i   (WB_data),
    .dataFor_i  (MEM_ALUdata),
    .data2_o    (EX_MUXALUdata2),
);

ALU ALU(
    .data1_i    (MUX_ALU1.data1_o),
    .data2_i    (EX_MUXALUdata2),
    .data_o     (),
);

ForwardingUnit ForwardingUnit(
    .EXMEMinst_i        (MEM_inst),
    .EXMEMwb_i          (MEM_WB),
    .MEMWBinst_i        (WB_inst),
    .MEMWBwb_i          (WB_WB),
    .rs1_i              (ID_inst[19:25]),
    .rs2_i              (ID_inst[24:20]),
    .MUXALU1control_o   (),
    .MUXALU2control_o   (),
);

/*------------ EX/MEM ------------*/

EXMEM_pipeline EXMEM_pipeline(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .WB_i           (MUX_EXMEM1.WB_o),
    .M_i            (MUX_EXMEM2.M_o),
    .ALUdata_i      (ALU.data_o),
    .MUXALUdata2_i  (EX_MUXALUdata2),
    .inst_i         (EX_inst),
    .WB_o           (MEM_WB),
    .ALUdata_o      (MEM_ALUdata),
    .MUXALUdata2_o  (),
    .inst_o         (MEM_inst)
);

DataMemory DataMemory(
    .ALUdata_i      (MEM_ALUdata),
    .MUXALUdata2_i  (EXMEM_pipeline.MUXALUdata2_o),
    .readData_o     ()
);

/*------------ MEM/WB ------------*/

MEMWB_pipeline MEMWB_pipeline(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .WB_i           (MEM_WB),
    .data_i         (DataMemory.readData_o),
    .ALUdata_i      (MEM_ALUdata),
    .inst_i         (MEM_inst),
    .WB_o           (WB_WB),
    .data_o         (),
    .ALUdata_o      (),
    .inst_o         (WB_inst)
);

MUX_WB MUX_WB(
    .MemtoReg_i     (WB_WB),
    .data_i         (MEMWB_pipeline.data_o),
    .ALUdata_i      (MEMWB_pipeline.ALUdata_o);
    .writedata_o    (WB_data)
);

endmodule