module tx_timer(input wire clk, input wire disable_timer, input wire n_rst, output reg shift_strobe, output reg [3:0] bit_count, input wire clear_timer);


// The first value for NUM_CNT_BITS to be overwritten by the value of bit period. Defines how many clock cycles between consecutive bits

reg shift_enable_timer1;     // Shift enable for Timer 1
reg shift_enable_timer2;                // Shift enable for Timer 2


flex_counter#(
    .NUM_CNT_BITS(5)
    ) CLOCK_COUNTER( .clk(clk), .n_rst(n_rst), .rollover_val(5'd27), .count_enable(!disable_timer), .clear(clear_timer),
  .rollover_flag(shift_strobe), .count_out(count_out_clock));

// The second value of the NUM_CNT_BITS to be overwritten by data size. Defines how many data bits are to be read
flex_counter#(
    .NUM_CNT_BITS(4)
    ) BIT_COUNTER( .clk(clk), .n_rst(n_rst), .rollover_val(4'd10), .count_enable(shift_strobe), .clear(clear_timer),
  .rollover_flag(packet_done_out), .count_out(bit_count));

assign shift
endmodule
