module encoder(input wire clk, input wire n_rst, input wire serial_in, input wire encoder_in, input wire[2:0] state_val, output reg d_plus, output reg d_minus);


//Next State Register Values for d plus and d minus
reg next_d_plus;
reg next_d_minus;
reg next_remember_plus;
reg next_remember_minus;
reg remember_plus;
reg remember_minus;
reg go;

always_comb OUTPUT_LOGIC:

begin
next_remember_plus = remember_plus;
next_remember_minus = remember_minus;

if (encoder_in == 1'b1) begin
next_remember_plus = d_plus;
next_remember_minus = d_minus;
next_d_plus = ~(d_plus);
next_d_minus = ~(d_minus);

end
else begin
if (go == 1'b1) begin
	if (serial_in == 1'b0) begin
		next_d_plus = ~(remember_plus);
		next_d_minus = ~(remember_minus);
	end
	else if (serial_in == 1'b1) begin
		next_d_plus = remember_plus;
		next_d_minus = remember_minus;
	end
end
else begin
if (state_val == 3'd0)  begin

	next_d_plus = 1'b1;
	next_d_minus = 1'b0;
end
else if (state_val == 3'd1 || state_val == 3'd2 || state_val == 3'd3 || state_val == 3'd4 || state_val == 3'd5) begin

	if (serial_in == 1'b0) begin
		next_d_plus = ~(d_plus);
		next_d_minus = ~(d_minus);
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

end

always_ff @(posedge clk, negedge n_rst) begin
if (n_rst == 1'b0) begin
d_plus <= 1'b1;
d_minus <= 1'b0;
go <= 1'b0;
remember_plus <= 1'b1;
remember_minus <= 1'b0;
end

else begin
	if (encoder_in == 1'b1)
		go <= 1'b1;
	else
		go <= 1'b0;

	d_plus <= next_d_plus;
	d_minus <= next_d_minus;
	remember_plus <= next_remember_plus;
	remember_minus <= next_remember_minus;
	
end
end



endmodule
