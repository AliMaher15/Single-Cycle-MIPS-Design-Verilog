module shift_left_twice #(
    parameter data_width = 32
)
(
input   wire    [data_width-1:0]    in,
output  wire    [data_width-1:0]    out
);

assign out = in<<2 ;

endmodule