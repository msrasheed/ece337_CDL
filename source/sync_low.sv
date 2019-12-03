module sync_low(input wire clk, input wire n_rst, input wire async_in, output reg sync_out);

reg interim;

always_ff @(posedge clk, negedge n_rst) 

	begin 
		if (n_rst == 1'b0) begin
       	 	sync_out <= 1'b0;
		interim <= 1'b0;
		end

		else begin
		interim <= async_in;
		sync_out <= interim;
        	end

	end

endmodule

 
