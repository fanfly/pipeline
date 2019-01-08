module CPU
(
  input clock_i,
  input flush_i
);

/* Control Signal */
wire clock;
wire flush;
wire stall;
wire hazard;
wire branch;
wire [1:0] rs1_forward;
wire [1:0] rs2_forward;

wire [2:0] control_EX_in_ID;
wire [2:0] control_EX_in_EX;

wire [1:0] control_MEM_in_ID;
wire [1:0] control_MEM_in_EX;
wire [1:0] control_MEM_in_MEM;

wire [1:0] control_WB_in_ID;
wire [1:0] control_WB_in_EX;
wire [1:0] control_WB_in_MEM;
wire [1:0] control_WB_in_WB;

wire [2:0] ALU_control;

/* Data */
wire [31:0] rs1_data_ID;
wire [31:0] rs2_data_ID;
wire [31:0] rs1_data_EX;
wire [31:0] rs2_data_EX;
wire [31:0] rs1_data_EX_1;
wire [31:0] rs2_data_EX_1;
wire [31:0] rs1_data_EX_2;
wire [31:0] rs2_data_EX_2;

wire [31:0] immediate_ID;
wire [31:0] immediate_EX;

wire [31:0] ALU_data1;
wire [31:0] ALU_data2;

wire [31:0] result_EX;
wire [31:0] result_MEM;
wire [31:0] result_WB;

wire [31:0] data_written_EX;
wire [31:0] data_written_MEM;
wire [31:0] data_read_MEM;
wire [31:0] data_read_WB;

wire [31:0] rd_data_WB;

/* PC */
wire [31:0] pc_added;
wire [31:0] pc_after_branch;
wire [31:0] pc_init;
wire [31:0] pc_IF;
wire [31:0] pc_ID;

/* Instruction */
wire [31:0] inst_IF;
wire [31:0] inst_ID;
wire [31:0] inst_EX;
wire [31:0] inst_MEM;
wire [31:0] inst_WB;

wire [4:0] rd_addr_IF;
wire [4:0] rd_addr_ID;
wire [4:0] rd_addr_EX;
wire [4:0] rd_addr_MEM;
wire [4:0] rd_addr_WB;

/* Cache */
wire cache_enable;
wire cache_write;

wire [4:0] cache_index_written;
wire [4:0] cache_index_read;

wire cache_valid_written;
wire cache_valid_read;

wire cache_dirty_written;
wire cache_dirty_read;

wire [21:0] cache_tag_written;
wire [21:0] cache_tag_read;

wire [255:0] cache_data_written;
wire [255:0] cache_data_read;

/* Memory */
wire memory_enable;
wire memory_write;
wire memory_ack;

wire [31:0] memory_addr;

wire [255:0] memory_data_written;
wire [255:0] memory_data_read;

/* Connection */
assign clock = clock_i;
assign flush = flush_i;
assign ALU_data1 = rs1_data_EX_2;
assign data_written_EX = rs2_data_EX_2;

assign rd_addr_IF = inst_IF[11:7];
assign rd_addr_ID = inst_ID[11:7];
assign rd_addr_EX = inst_EX[11:7];
assign rd_addr_MEM = inst_MEM[11:7];
assign rd_addr_WB = inst_WB[11:7];

/* IF: Instruction Fetch */
MUX32 MUXPC
(
  .select_i(branch),
  .data1_i(pc_after_branch),
  .data2_i(pc_added),
  .data_o(pc_init)
);

PC PC
(
  .clock_i(clock),
  .flush_i(flush),
  .enable_i(!stall && !hazard),
  .pc_i(pc_init),
  .pc_o(pc_IF)
);

Adder AdderCommon
(
  .data1_i(pc_IF),
  .data2_i(32'd4),
  .data_o(pc_added)
);

InstructionMemory InstructionMemory
(
  .pc_i(pc_IF),
  .inst_o(inst_IF)
);

/* ID: Instruction Decode */
IFID IFID
(
  .clock_i(clock),
  .flush_i(flush || branch),
  .enable_i(!stall && !hazard),
  .pc_i(pc_IF),
  .inst_i(inst_IF),
  .pc_o(pc_ID),
  .inst_o(inst_ID)
);

Registers Registers
(
  .clock_i(clock),
  .flush_i(flush),
  .write_i(control_WB_in_WB[1]),
  .rs1_addr_i(inst_ID[19:15]),
  .rs2_addr_i(inst_ID[24:20]),
  .rd_addr_i(inst_WB[11:7]),
  .rd_data_i(rd_data_WB),
  .rs1_data_o(rs1_data_ID),
  .rs2_data_o(rs2_data_ID)
);

HazardDetection HazardDetection
(
  .rs1_addr_ID_i(inst_ID[19:15]),
  .rs2_addr_ID_i(inst_ID[24:20]),
  .rd_addr_EX_i(inst_EX[11:7]),
  .memory_read_EX_i(control_MEM_in_EX[1]),
  .hazard_o(hazard)
);

Control Control
(
  .clock_i(clock),
  .flush_i(flush),
  .enable_i(!stall),
  .op_i(inst_ID[6:0]),
  .rs1_data_i(rs1_data_ID),
  .rs2_data_i(rs2_data_ID),
  .control_EX_o(control_EX_in_ID),
  .control_MEM_o(control_MEM_in_ID),
  .control_WB_o(control_WB_in_ID),
  .branch_o(branch)
);

Immediate Immediate
(
  .inst_i(inst_ID),
  .immediate_o(immediate_ID)
);

Adder AdderBranch
(
  .data1_i(pc_ID),
  .data2_i(immediate_ID << 1),
  .data_o(pc_after_branch)
);

/* EX: Execution */
IDEX IDEX
(
  .clock_i(clock),
  .flush_i(flush),
  .enable_i(!stall),
  .control_EX_i(control_EX_in_ID),
  .control_MEM_i(control_MEM_in_ID),
  .control_WB_i(control_WB_in_ID),
  .immediate_i(immediate_ID),
  .inst_i(inst_ID),
  .rs1_data_i(rs1_data_ID),
  .rs2_data_i(rs2_data_ID),
  .control_EX_o(control_EX_in_EX),
  .control_MEM_o(control_MEM_in_EX),
  .control_WB_o(control_WB_in_EX),
  .immediate_o(immediate_EX),
  .inst_o(inst_EX),
  .rs1_data_o(rs1_data_EX),
  .rs2_data_o(rs2_data_EX)
);

ALUControl ALUControl
(
  .ALU_op_i(control_EX_in_EX[2:1]),
  .funct_i({inst_EX[31:25], inst_EX[14:12]}),
  .ALU_control_o(ALU_control)
);

ALU ALU
(
  .ALU_control_i(ALU_control),
  .data1_i(ALU_data1),
  .data2_i(ALU_data2),
  .result_o(result_EX)
);

Forwarding Forwarding
(
  .control_WB_in_MEM_i(control_WB_in_MEM),
  .control_WB_in_WB_i(control_WB_in_WB),
  .rs1_addr_i(inst_EX[19:15]),
  .rs2_addr_i(inst_EX[24:20]),
  .rd_addr_MEM_i(inst_MEM[11:7]),
  .rd_addr_WB_i(inst_WB[11:7]),
  .rs1_forward_o(rs1_forward),
  .rs2_forward_o(rs2_forward)
);

MUX32 MUXForwardWB1
(
  .select_i(rs1_forward[0]),
  .data1_i(result_WB),
  .data2_i(rs1_data_EX),
  .data_o(rs1_data_EX_1)
);

MUX32 MUXForwardMEM1
(
  .select_i(rs1_forward[1]),
  .data1_i(result_MEM),
  .data2_i(rs1_data_EX_1),
  .data_o(rs1_data_EX_2)
);

MUX32 MUXForwardWB2
(
  .select_i(rs2_forward[0]),
  .data1_i(result_WB),
  .data2_i(rs2_data_EX),
  .data_o(rs2_data_EX_1)
);

MUX32 MUXForwardMEM2
(
  .select_i(rs2_forward[1]),
  .data1_i(result_MEM),
  .data2_i(rs2_data_EX_1),
  .data_o(rs2_data_EX_2)
);

MUX32 MUXImmediate
(
  .select_i(control_EX_in_EX[0]),
  .data1_i(immediate_EX),
  .data2_i(rs2_data_EX_2),
  .data_o(ALU_data2)
);

/* MEM: Memory */
EXMEM EXMEM
(
  .clock_i(clock),
  .flush_i(flush),
  .enable_i(!stall),
  .control_MEM_i(control_MEM_in_EX),
  .control_WB_i(control_WB_in_EX),
  .inst_i(inst_EX),
  .result_i(result_EX),
  .data_i(data_written_EX),
  .control_MEM_o(control_MEM_in_MEM),
  .control_WB_o(control_WB_in_MEM),
  .inst_o(inst_MEM),
  .result_o(result_MEM),
  .data_o(data_written_MEM)
);

CacheController CacheController
(
  .clock_i(clock),
  .flush_i(flush),
  .stall_o(stall),
  .addr_i(result_MEM),
  .data_i(data_written_MEM),
  .read_i(control_MEM_in_MEM[1]),
  .write_i(control_MEM_in_MEM[0]),
  .data_o(data_read_MEM),
  .cache_valid_i(cache_valid_read),
  .cache_dirty_i(cache_dirty_read),
  .cache_tag_i(cache_tag_read),
  .cache_data_i(cache_data_read),
  .cache_enable_o(cache_enable),
  .cache_write_o(cache_write),
  .cache_index_o(cache_index_written),
  .cache_valid_o(cache_valid_written),
  .cache_dirty_o(cache_dirty_written),
  .cache_tag_o(cache_tag_written),
  .cache_data_o(cache_data_written),
  .memory_ack_i(memory_ack),
  .memory_data_i(memory_data_read),
  .memory_enable_o(memory_enable),
  .memory_write_o(memory_write),
  .memory_addr_o(memory_addr),
  .memory_data_o(memory_data_written)
);

Cache Cache
(
  .clock_i(clock),
  .enable_i(cache_enable),
  .write_i(cache_write),
  .index_i(cache_index_written),
  .valid_i(cache_valid_written),
  .dirty_i(cache_dirty_written),
  .tag_i(cache_tag_written),
  .data_i(cache_data_written),
  .valid_o(cache_valid_read),
  .dirty_o(cache_dirty_read),
  .tag_o(cache_tag_read),
  .data_o(cache_data_read)
);

DataMemory DataMemory
(
  .clock_i(clock),
  .flush_i(flush),
  .enable_i(memory_enable),
  .write_i(memory_write),
  .addr_i(memory_addr),
  .data_i(memory_data_written),
  .ack_o(memory_ack),
  .data_o(memory_data_read)
);

/* WB: Write Back */
MEMWB MEMWB
(
  .clock_i(clock),
  .flush_i(flush),
  .enable_i(!stall),
  .control_WB_i(control_WB_in_MEM),
  .inst_i(inst_MEM),
  .result_i(result_MEM),
  .data_i(data_read_MEM),
  .control_WB_o(control_WB_in_WB),
  .inst_o(inst_WB),
  .result_o(result_WB),
  .data_o(data_read_WB)
);

MUX32 MUXWB
(
  .select_i(control_WB_in_WB[0]),
  .data1_i(data_read_WB),
  .data2_i(result_WB),
  .data_o(rd_data_WB)
);

endmodule
