module flex_pts_sr
#( parameter NUM_BITS = 4, parameter SHIFT_MSB = 1)

(input wire clk, input wire n_rst, input shift_enable, input wire [NUM_BITS - 1:0] parallel_in, input wire load_enable, output reg serial_out);


reg [NUM_BITS - 1:0] next_parallel_out;
reg [NUM_BITS - 1:0] parallel_out;

always_comb NEXT_STATE_LOGIC:

begin

	next_parallel_out = parallel_out;

	if (load_enable == 1) begin

         next_parallel_out = parallel_in;

         end

        else begin

		if(shift_enable == 1) begin
			
			if(SHIFT_MSB == 1 ) begin
				
				next_parallel_out = {parallel_out[NUM_BITS - 2:0], 1'b1};
                         end
 			
			else if (SHIFT_MSB == 0) begin

				next_parallel_out = {1'b1, parallel_out[NUM_BITS - 1:1]};

			end
		end
	end
             
 end

always_ff @(posedge clk, negedge n_rst) begin

	if(n_rst ==  1'b0) begin
        
         parallel_out <= '1;
        
        end

        else begin
		
	parallel_out <= next_parallel_out;

       end

end

assign serial_out = parallel_out[NUM_BITS -1];

endmodule

