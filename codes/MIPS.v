module MIPS (
input   wire            CLK,
input   wire            Reset,
output  wire    [15:0]  test_value
);

// Internal connections
wire    [31:0]  PCPlus4;
wire    [31:0]  PCBranch;
wire    [31:0]  SignImm;
wire    [31:0]  Instr;
wire    [27:0]  out0shift;
wire    [31:0]  out1shift;
wire    [31:0]  out3mux;

// ALU unit
wire    [31:0]  SrcA;
wire    [31:0]  SrcB_mux;
wire            Zero;
wire    [31:0]  ALUResult;
wire            PCSrc;

// Register File Unit
wire    [31:0]  RD2;
wire    [31:0]  Result;
wire    [4:0]   WriteReg;

// Data Memory Unit
wire    [31:0]  RD;

// Program Counter Unit
wire    [31:0]  pc_in;
wire    [31:0]  PC;

// Control unit 
wire            MemtoReg;
wire            Branch;
wire    [2:0]   ALUControl;
wire            ALUSrc;
wire            MemWrite;
wire            RegDest;
wire            RegWrite;
wire            Jump;

///////////////////// ALU /////////////////////
ALU U0_ALU (
.SrcA(SrcA),
.SrcB(SrcB_mux),
.ALUControl(ALUControl),
.Zero(Zero),
.ALUResult(ALUResult)
);

///////////////////// Program Counter /////////////////////
Program_Counter U0_PC (
.pc_in(pc_in),
.clk(CLK),
.rst(Reset),
.PC(PC)
);

///////////////////// Instruction Memory /////////////////////
instruction_memory #(.data_width(32),.depth(100)) U0_Inst_Mem (
.PC(PC),
.Instr(Instr)
);

///////////////////// Register File /////////////////////
Register_File U0_RegFile (
.clk(CLK),
.rst(Reset),
.WE3(RegWrite),
.A1(Instr[25:21]),
.A2(Instr[20:16]),
.A3(WriteReg),
.WD3(Result),
.RD1(SrcA),
.RD2(RD2)
);

///////////////////// Data Memory /////////////////////
Data_Memory U0_Data_Mem (
.clk(CLK),
.rst(Reset),
.WE(MemWrite),
.A(ALUResult),
.WD(RD2),
.RD(RD),
.test_value(test_value)
);

///////////////////// Control Unit /////////////////////
Control_Unit U0_Ctrl_Unit (
.Opcode(Instr[31:26]),
.Funct(Instr[5:0]),
.ALUControl(ALUControl),
.jump(Jump),
.memWrite(MemWrite),
.regWrite(RegWrite),
.regDest(RegDest),
.aluSrc(ALUSrc),
.memtoReg(MemtoReg),
.Branch(Branch)
);

///////////////////// Sign Extend /////////////////////
Sign_Extend U0_Signxtend (
.Instr(Instr[15:0]),
.SignImm(SignImm)
);

///////////////////// Shift Left Twice /////////////////////
shift_left_twice # ( .data_width(28)) U0_Shift_left (
.in({2'b00,Instr[25:0]}),
.out(out0shift)
);

shift_left_twice U1_Shift_left (
.in(SignImm),
.out(out1shift)
);

///////////////////// Adder /////////////////////
Adder U0_Add (
.A(PC),
.B(32'b100),
.C(PCPlus4)
);

Adder U1_Add (
.A(out1shift),
.B(PCPlus4),
.C(PCBranch)
);

///////////////////// MUX /////////////////////
MUX U0_MUX (
.sel(ALUSrc),
.In1(RD2),
.In2(SignImm),
.out(SrcB_mux)
);

MUX U1_MUX (
.sel(MemtoReg),
.In1(ALUResult),
.In2(RD),
.out(Result)
);

MUX U2_MUX (
.sel(Jump),
.In1(out3mux),
.In2({PCPlus4[31:28],out0shift}),
.out(pc_in)
);

MUX U3_MUX (
.sel(PCSrc),
.In1(PCPlus4),
.In2(PCBranch),
.out(out3mux)
);

MUX # ( .data_width(5)) U4_MUX (
.sel(RegDest),
.In1(Instr[20:16]),
.In2(Instr[15:11]),
.out(WriteReg)
);

///////////////////// AND Gate /////////////////////
And_gate U0_AND (
.Branch(Branch),
.Zero(Zero),
.out(PCSrc)
);

endmodule