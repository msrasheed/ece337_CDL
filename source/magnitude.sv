module magnitude(input wire [16:0] in, output reg [15:0] out);

always_comb OUTPUT_LOGIC:
begin
if (in[16] == 1'b1) 
out = ~(in[15:0]) + 1;

else
out = in[15:0];
end

endmodule

