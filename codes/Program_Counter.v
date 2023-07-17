module Program_Counter (
input   wire    [31:0]  pc_in ,
input   wire            clk ,
input   wire            rst ,
output  reg     [31:0]  PC
);

always @(posedge clk or negedge rst)
 begin
    if(!rst)
     begin
        PC <= 32'b0 ;
     end
    else
     begin
        PC <= pc_in ;
     end
 end
 
endmodule
