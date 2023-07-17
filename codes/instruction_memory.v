module instruction_memory #(
	parameter data_width = 32,
	parameter depth = 100
)
(
	input	wire	[data_width-1:0]	PC,
	output	wire	[data_width-1:0]	Instr
);

reg [data_width-1:0] instruction_mem [0:depth-1];


initial 
    begin
        $readmemh ("Program_1_Machine_Code.txt", instruction_mem);
   end
   
assign Instr = instruction_mem[PC>>2];

endmodule