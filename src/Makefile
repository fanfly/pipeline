VERILOG = iverilog
SRC = testbench.v \
	CPU.v \
	PC.v \
	adder.v MUX32.v \
	control.v ALU_control.v ALU.v \
	immediate.v \
	instruction_memory.v registers.v data_memory.v \
	cache.v cache_controller.v \
	IF_ID.v ID_EX.v EX_MEM.v MEM_WB.v \
	forwarding.v hazard_detection.v

.PHONY: clean

testbench: $(SRC)
	$(VERILOG) -o testbench $(SRC)

clean:
	rm -f testbench
