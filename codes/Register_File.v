module Register_File (
input   wire            clk,
input   wire            rst,
input   wire            WE3,
input   wire    [4:0]   A1,
input   wire    [4:0]   A2,
input   wire    [4:0]   A3,
input   wire    [31:0]  WD3,
output  wire    [31:0]  RD1,
output  wire    [31:0]  RD2
);

// Reg Dimensions
reg [31:0] regfile [0:99];

integer i ;

always @(posedge clk or negedge rst)
 begin
   if(!rst)
    begin
        for(i=0 ; i<100 ; i=i+1)
         begin
            regfile[i] <= 32'b0 ;
         end
    end
   else if(WE3)
    begin
        regfile[A3] <= WD3 ;
    end
 end
 
assign RD1 = regfile[A1] ;
assign RD2 = regfile[A2] ;


endmodule