//Byte counter for USB CDL RX

module RX_byte_counter (clk,
                        n_rst,
                        count_enable,
                        byte_done);

  input wire clk;
  input wire n_rst;
  input wire count_enable;
  output wire byte_done;

  wire clear;
  wire [3:0] count_out;

  flex_counter #(.NUM_CNT_BITS(4)) counter_25
                (.clk(clk),
                .n_rst(n_rst),
                .count_enable(count_enable),
                .rollover_val(4'd8),
                .rollover_flag(byte_done),
                .count_out(count_out),
                .clear(clear));

endmodule
