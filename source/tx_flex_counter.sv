`timescale 1ns / 100ps
module tx_flex_counter
#( parameter NUM_CNT_BITS = 4)

( input wire clk, input wire n_rst, input wire [NUM_CNT_BITS - 1:0] rollover_val, input wire count_enable, input wire clear,
  output reg rollover_flag, output reg [NUM_CNT_BITS - 1:0] count_out );

  
reg [NUM_CNT_BITS - 1:0] next_count;
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
	if (count_out == rollover_val - 1) begin
       	next_roll_over = 1'b1;
	end
end


always_ff @(posedge clk, negedge n_rst) 

	begin 
		if (n_rst == 1'b0) begin
       	 		count_out <= 0;
		end
      
		else begin
			count_out <= next_count;
        	end
		

end

always_ff @(posedge clk, negedge n_rst) 
	begin
		if (n_rst == 1'b0) begin
			rollover_flag <= 1'b0;
		end
                else begin
			rollover_flag <= next_roll_over;
		end
	end

endmodule 