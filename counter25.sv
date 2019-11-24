`timescale 1ns / 100ps
module counter25 (input wire clk, input wire n_rst, input wire count_enable, input wire clear, output reg roll_over, output reg [4:0] count_out, output reg flag);

  
reg [4:0] next_count_out;
reg next_roll_over;
reg [3:0] count_bit;
reg next_flag;
reg [3:0] next_count_bit;

always_comb 
begin 
	if (count_enable == 1'b0) begin
       	 	next_count_out = count_out;          // Disable this value when the bit stuffer confirms 6 consequetive 1s                                                                                                                                   
	end

	else if (clear == 1'b1) begin
		next_count_out = '0;

        end
	else if (count_out == 5'd24) begin
        	next_count_out = '0;
        end
	else begin
		next_count_out = count_out + 1;
		
	end
        
end

always_comb 
begin 
        next_flag = 1'b0;
        next_count_bit = count_bit;
        next_roll_over = roll_over;

	if (count_out == 5'd7) begin
       	next_roll_over = 1'b1;
        next_count_bit = count_bit + 4'd1;
        end
        else if(count_out == 5'd15) begin
        next_roll_over = 1'b1;
        next_count_bit = count_bit + 4'd1;
        end
        else if(count_out == 5'd24) begin
        next_roll_over = 1'b1;
        next_count_bit = count_bit + 4'd1;
        end
        
        if(count_bit == 4'd7) begin
        next_flag = 1'd1;
        next_count_bit = '0;
        end
end


always_ff @(posedge clk, negedge n_rst) begin

if (n_rst == 1'b0) begin
roll_over <= '0;
count_out <= '0;
count_bit <= '0;
flag <= '0;
end

else begin
roll_over <= next_roll_over;
count_out <= next_count_out;
count_bit <= next_count_bit;
flag <= next_flag;
end

end

endmodule

	














































































































































 