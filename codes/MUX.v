module MUX #(
    parameter data_width = 32
)
(
input   wire                        sel,
input   wire    [data_width-1:0]    In1,
input   wire    [data_width-1:0]    In2,    
output  wire    [data_width-1:0]    out
);

assign out = (sel) ? In2 : In1 ;

endmodule
