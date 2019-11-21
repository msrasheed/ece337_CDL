module encoder(input wire clk, input wire n_rst, input wire serial_in, input wire encoder_in, input wire[2:0] state_val, output reg d_plus, output reg d_minus);


//Next State Register Values for d plus and d minus
reg next_d_plus;
reg next_d_minus;


always_comb OUTPUT_LOGIC:

begin

if (encoder_in == 1'b1) begin

next_d_plus = !(d_plus);
next_d_minus = !(d_minus);

end

else begin

if (state_val == 3'd0)  begin

	next_d_plus = 1'b1;
	next_d_minus = 1'b0;
end
else if (state_val == 3'd1 || state_val == 3'd2 || state_val == 3'd3 || state_val == 3'd4 || state_val == 3'd5) begin

	if (serial_in == 1'b0) begin
		next_d_plus = !(d_plus);
		next_d_minus = !(d_minus);
	end
	else if (serial_in == 1'b1) begin
		next_d_plus = d_plus;
		next_d_minus = d_minus;
	end

end
else if(state_val == 3'd6 || state_val == 3'd7) begin
	next_d_plus = 1'b0;
	next_d_minus = 1'b0;
end
end

end

always_ff @(posedge clk, negedge n_rst) begin
if (n_rst == 1'b0) begin
d_plus <= 1'b1;
d_minus <= 1'b0;
end

else begin
d_plus <= next_d_plus;
d_minus <= next_d_minus;
end
end



endmodule
