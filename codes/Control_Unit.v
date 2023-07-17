module Control_Unit (
input   wire    [5:0]   Opcode,
input   wire    [5:0]   Funct,
output  reg     [2:0]   ALUControl,
output  reg             jump,
output  reg             memWrite,
output  reg             regWrite,
output  reg             regDest,
output  reg             aluSrc,
output  reg             memtoReg,
output  reg             Branch
);


// internal signals
reg [1:0]   ALUOp ;

localparam  loadWord      = 6'b10_0011,
            storeWord     = 6'b10_1011,
            rType         = 6'b00_0000,
            addImmediate  = 6'b00_1000,
            branchIfEqual = 6'b00_0100,
            jump_inst     = 6'b00_0010;

localparam  add = 6'b10_0000,
            sub = 6'b10_0010,
            slt = 6'b10_1010,
            mul = 6'b01_1100;

// Main Decoder
always @(*)
 begin
 jump     = 1'b0;
 memWrite = 1'b0;
 regWrite = 1'b0;
 regDest  = 1'b0;
 aluSrc   = 1'b0;
 memtoReg = 1'b0;
 Branch   = 1'b0;
 ALUOp      = 2'b00;
    case(Opcode)
    loadWord:      begin
                    regWrite = 1'b1;
                    aluSrc   = 1'b1;
                    memtoReg = 1'b1;
                end
    storeWord:     begin
                    memWrite = 1'b1;
                    aluSrc   = 1'b1;
                    memtoReg = 1'b1;
                end
    rType:         begin
                    ALUOp      = 2'b10;
                    regWrite = 1'b1;
                    regDest  = 1'b1;
                end
    addImmediate:  begin
                    regWrite = 1'b1;
                    aluSrc   = 1'b1;
                end
    branchIfEqual: begin
                    ALUOp    = 2'b01;
                    Branch = 1'b1;
                end
    jump_inst:     begin
                    jump = 1'b1;
                end
    default :      begin
                    jump     = 1'b0;
                    memWrite = 1'b0;
                    regWrite = 1'b0;
                    regDest  = 1'b0;
                    aluSrc   = 1'b0;
                    memtoReg = 1'b0;
                    Branch   = 1'b0;
                    ALUOp      = 2'b00;
                end
    endcase
 end

// ALU Decoder
always @(*)
 begin
   case(ALUOp)
   2'b00: ALUControl = 3'b010;
   2'b01: ALUControl = 3'b100;
   2'b10: begin
            case(Funct)
            add: ALUControl = 3'b010;
            sub: ALUControl = 3'b100;
            slt: ALUControl = 3'b110;
            mul: ALUControl = 3'b101;
            default: ALUControl = 3'b010;
            endcase
        end
   default: ALUControl = 3'b010;
   endcase
 end

endmodule