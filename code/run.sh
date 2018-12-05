iverilog -o myCPU testbench.v CPU.v Add_Branch.v Add_PC.v ALU_Control.v ALU.v Control.v Data_Memory.v ForwardingUnit.v HazzardDetection.v ImmGen.v Instruction_Memory.v MUX_ALU1.v MUX_ALU2.v MUX_ALUSrc.v MUX_EXMEM1.v MUX_EXMEM2.v MUX_IDEX.v MUX_PC.v MUX_WB.v PC.v Pipeline_IFID.v Pipeline_IDEX.v Pipeline_EXMEM.v Pipeline_MEMWB.v Registers.v
#vvp myCPU
