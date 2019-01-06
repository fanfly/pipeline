`define CYCLE_TIME 50

module TestBench;

reg clock;
reg flush;

integer i;
integer counter;

integer file1;
integer file2;

CPU CPU
(
  .clock_i(clock),
  .flush_i(flush)
);

initial begin
  $dumpfile("record.vcd");
  $dumpvars(0, TestBench);
  for (i = 0; i < 512; i = i + 1) begin
    CPU.InstructionMemory.inst[i] = 32'b0;
  end
  
  for (i = 0; i < 512; i = i + 1) begin
    CPU.DataMemory.memory[i] = 256'b0;
  end
  for (i = 0; i < 32; i = i + 1) begin
    CPU.Cache.valid[i] = 1'b0;
    CPU.Cache.dirty[i] = 1'b0;
    CPU.Cache.tag[i] = 22'b0;
    CPU.Cache.data[i] = 256'b0;
  end
  for (i = 0; i < 32; i = i + 1) begin
    CPU.Registers.register[i] = 32'b0;
  end
  $readmemb("instruction.txt", CPU.InstructionMemory.inst);
  file1 = $fopen("output.txt") | 1;
  file2 = $fopen("cache.txt") | 1;
  
  counter <= 0;
  
  clock <= 1'b0;
  flush <= 1'b1;
  
  #(`CYCLE_TIME / 4)
  flush <= 1'b0;
end

always #(`CYCLE_TIME / 2) clock <= ~clock;

always @(posedge clock) begin
  if (counter == 150) begin
    $fdisplay(file1, "Flush cache!\n");
    for (i = 0; i < 32; i = i + 1) begin
      CPU.DataMemory.memory[{CPU.Cache.tag[i], i}] = CPU.Cache.data[i];
    end
  end
  if (counter > 150) begin
    $finish;
  end
  $fdisplay(file1, "cycle = %d, Start = %b", counter, 1'b1);
  $fdisplay(file1, "PC = %d", CPU.PC.pc_o);
  
  $fdisplay(file1, "Registers");
  $fdisplay(file1, "R0(r0) = %h, R8 (t0) = %h, R16(s0) = %h, R24(t8) = %h", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
	$fdisplay(file1, "R1(at) = %h, R9 (t1) = %h, R17(s1) = %h, R25(t9) = %h", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
	$fdisplay(file1, "R2(v0) = %h, R10(t2) = %h, R18(s2) = %h, R26(k0) = %h", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
	$fdisplay(file1, "R3(v1) = %h, R11(t3) = %h, R19(s3) = %h, R27(k1) = %h", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
	$fdisplay(file1, "R4(a0) = %h, R12(t4) = %h, R20(s4) = %h, R28(gp) = %h", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
	$fdisplay(file1, "R5(a1) = %h, R13(t5) = %h, R21(s5) = %h, R29(sp) = %h", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
	$fdisplay(file1, "R6(a2) = %h, R14(t6) = %h, R22(s6) = %h, R30(s8) = %h", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
	$fdisplay(file1, "R7(a3) = %h, R15(t7) = %h, R23(s7) = %h, R31(ra) = %h", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);
	
  $fdisplay(file1, "");
  $fdisplay(file1, "Cache: 0x0000 = %h", CPU.Cache.data[0]);
	$fdisplay(file1, "Cache: 0x0020 = %h", CPU.Cache.data[1]);
	$fdisplay(file1, "Cache: 0x0040 = %h", CPU.Cache.data[2]);
	$fdisplay(file1, "Cache: 0x0060 = %h", CPU.Cache.data[3]);
	$fdisplay(file1, "Cache: 0x0080 = %h", CPU.Cache.data[4]);
	$fdisplay(file1, "Cache: 0x00A0 = %h", CPU.Cache.data[5]);
	$fdisplay(file1, "Cache: 0x00C0 = %h", CPU.Cache.data[6]);
	$fdisplay(file1, "Cache: 0x00E0 = %h", CPU.Cache.data[7]);
  $fdisplay(file1, "");
  
  $fdisplay(file1, "Data Memory: 0x0000 = %h", CPU.DataMemory.memory[0]);
	$fdisplay(file1, "Data Memory: 0x0020 = %h", CPU.DataMemory.memory[1]);
	$fdisplay(file1, "Data Memory: 0x0040 = %h", CPU.DataMemory.memory[2]);
	$fdisplay(file1, "Data Memory: 0x0060 = %h", CPU.DataMemory.memory[3]);
	$fdisplay(file1, "Data Memory: 0x0080 = %h", CPU.DataMemory.memory[4]);
	$fdisplay(file1, "Data Memory: 0x00A0 = %h", CPU.DataMemory.memory[5]);
	$fdisplay(file1, "Data Memory: 0x00C0 = %h", CPU.DataMemory.memory[6]);
	$fdisplay(file1, "Data Memory: 0x00E0 = %h", CPU.DataMemory.memory[7]);
	$fdisplay(file1, "Data Memory: 0x0400 = %h", CPU.DataMemory.memory[32]);
	$fdisplay(file1, "");
  $fdisplay(file1, "");
  
  if (CPU.CacheController.state == 3'h1) begin // check hit or miss
    $fwrite(file2, "Cycle: %d, ", counter);
    if (CPU.CacheController.hit) begin
      if (CPU.CacheController.read) begin
        $fwrite(file2, "Read Hit  , ");
      end
      else if (CPU.CacheController.write) begin
        $fwrite(file2, "Write Hit , ");
      end
    end
    else begin
      if (CPU.CacheController.read) begin
        $fwrite(file2, "Read Miss , ");
      end
      else if (CPU.CacheController.write) begin
        $fwrite(file2, "Write Miss, ");
      end
    end
    $fwrite(file2, "Address: %h, ", CPU.CacheController.addr);
    if (CPU.CacheController.read) begin
      $fwrite(file2, "Read Data : %h", CPU.CacheController.data);
    end
    else if (CPU.CacheController.write) begin
      $fwrite(file2, "Write Data: %h", CPU.CacheController.data);
    end
    if (!CPU.CacheController.hit && CPU.CacheController.cache_dirty_i) begin
      $fwrite(file2, " (Write Back!)");
    end
    $fwrite(file2, "\n");
  end
  counter = counter + 1;
end

endmodule

