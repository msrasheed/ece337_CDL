//Byte counter for USB CDL RX

module RX_byte_counter (clk,
                        n_rst,
                        count_enable,
			clear,
                        byte_done);

  input wire clk;
  input wire n_rst;
  input wire count_enable;
   input wire clear;
   output wire byte_done;

  wire [3:0] count_out;
   reg 	     last_rollover;
   reg      clear_counter;
   
  flex_counter #(.NUM_CNT_BITS(4)) counter_25
                (.clk(clk),
                .n_rst(n_rst),
                .count_enable(count_enable),
                .rollover_val(4'd8),
                .rollover_flag(byte_done),
                .count_out(count_out),
                 .clear(clear_counter));
   
   always_comb begin
      clear_counter = (clear || byte_done);
   end

   always_ff @ (posedge clk, negedge n_rst) begin
      if (n_rst == 1'b0) begin
	 last_rollover <= 1'b0;
      end else begin
	 last_rollover <= byte_done;
      end
   end
   
   
endmodule
