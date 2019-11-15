`timescale 1ns / 100ps
module counter25 (input wire clk, input wire n_rst,input wire count_enable, input wire clear, output reg rollover_flag, output reg [4:0] count_out);

  
reg [4:0] next_count;
reg next_roll_over;
always_comb 
begin 
	if (count_enable == 1'b0) begin
       	 	next_count = count_out;          // Disable this value when the bit stuffer confirms 6 consequetive 1s                                                                                                                                   
	end

	else if (clear == 1'b1) begin
		next_count = 0;

        end
	else if (count_out == (rollover_val)) begin
                next_count = 1'b1;
	end
	else begin
		next_count = count_out + 1;
		
	end
end

always_comb 
begin 
        next_roll_over = 1'b0;

	if (count_out == 5'd8) 
       	next_roll_over = 1'b1;

        else if(count_out == 5'd16) 
        next_roll_over = 1'b1;

        else if(count_out == 5'd25) 
        next_roll_over = 1'b1;
end


always_ff @(posedge clk, negedge n_rst) 

	














































































































































 