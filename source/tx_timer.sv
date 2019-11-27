module tx_timer(input wire clk, input wire enable_timer, input disable_timer,  input wire n_rst, output reg shift_strobe, output reg [3:0] bit_count, input wire clear_timer, output reg byte_complete, output reg flag);


// The first value for NUM_CNT_BITS to be overwritten by the value of bit period. Defines how many clock cycles between consecutive bits

reg shift_strobe_bit_counter;    // count enable from the first counter, resulting in an average speed of 25/3 -> 3 rollovers in 25 clock cycles
reg [4:0] count_out_ticks;

tx_counter25 CLOCK_COUNT(.clk(clk), .n_rst(n_rst), .count_enable(enable_timer), .clear(clear_timer), .roll_over(shift_strobe_bit_counter), .count_out(count_out_ticks), .flag(flag), .disable_timer(disable_timer));

// The second value of the NUM_CNT_BITS to be overwritten by data size. Defines how many data bits are to be read
tx_flex_counter#(
    .NUM_CNT_BITS(4)
    ) BIT_COUNTER( .clk(clk), .n_rst(n_rst), .rollover_val(4'd8), .count_enable(shift_strobe_bit_counter), .clear(clear_timer), .rollover_flag(byte_complete), .count_out(bit_count));


 assign shift_strobe = shift_strobe_bit_counter;
endmodule

