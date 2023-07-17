module And_gate (
input   wire    Branch,
input   wire    Zero,
output  wire    out
);

assign out = Branch & Zero ;

endmodule