module Data_Memory (
input   wire            clk,
input   wire            rst,
input   wire            WE,
input   wire    [31:0]  A,
input   wire    [31:0]  WD,
output  wire    [31:0]  RD,
output  wire    [15:0]  test_value
);

// Memory Dimensions
reg [31:0] memory [0:99];

integer i ;

always @(posedge clk or negedge rst)
 begin
   if(!rst)
    begin
        for(i=0 ; i<100 ; i=i+1)
         begin
            memory[i] <= 32'b0 ;
         end
    end
   else if(WE)
    begin
        memory[A] <= WD ;
    end
 end
 
assign RD = memory[A] ;

assign test_value = memory[0][15:0] ;

endmodule