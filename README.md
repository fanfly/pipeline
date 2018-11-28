# pipeline

## Structure

```
pipeline
└── code
    │   # testbench and core
    ├── testbench.v
    ├── cpu.v
    │
    │   # modules
    ├── pc.v
    ├── instruction_memory.v
    ├── registers.v
    ├── data_memory.v
    ├── alu.v
    ├── alu_control.v
    ├── sign_extend.v
    ├── control.v
    ├── forward.v
    ├── hazard_detect.v
    ├── mux32.v
    └── mux5.v
```

## Instructions

### Main Control

| Instruction | inst[6:0] | ALUOp | ALUSrc | Branch | MemRead | MemWrite | RegWrite | MemtoReg |
| :---------: | :-------: | :---: | :----: | :----: | :-----: | :------: | :------: | :------: |
|     lw      |  0000011  |  00   |   1    |   0    |    1    |    0     |    1     |    1     |
|     sw      |  0100011  |  00   |   1    |   0    |    0    |    1     |    0     |    0     |
|     beq     |  1100011  |  01   |   0    |   1    |    0    |    0     |    0     |    0     |
|  R-format   |  0110011  |  10   |   0    |   0    |    0    |    0     |    1     |    0     |
|    addi     |  0010011  |  11   |   0    |   0    |    0    |    0     |    1     |    0     |

### ALU Control

| Instruction | ALUOp | funct7  | funct3 | ALUCtr |
| :---------: | :---: | :-----: | :----: | :----: |
|     lw      |  00   |         |        |  000   |
|     sw      |  00   |         |        |  000   |
|     beq     |  01   |         |        |  001   |
|     add     |  10   | 0000000 |  000   |  000   |
|     sub     |  10   | 0100000 |  000   |  001   |
|     mul     |  10   | 0000001 |  000   |  010   |
|     or      |  10   | 0000000 |  110   |  100   |
|     and     |  10   | 0000000 |  111   |  101   |
|    addi     |  11   |         |        |  000   |

### ALU

| ALUCtr |   Operation    |
| :----: | :------------: |
|  000   |    addition    |
|  001   |  subtraction   |
|  010   | multiplication |
|  100   |   logical OR   |
|  101   |  logical AND   |

