module MIPS_tb();

reg             clk_tb;
reg             rst_tb;
wire    [15:0]  test_tb;


MIPS DUT (
.CLK(clk_tb),
.Reset(rst_tb),
.test_value(test_tb)
);

initial
 begin
  forever #5  clk_tb = ~clk_tb ;
 end
 
initial
 begin
clk_tb = 1'b1;
rst_tb = 1'b1;
#10
rst_tb = 1'b0;
#10
rst_tb = 1'b1;
#1000
$stop;
 end 
 
endmodule