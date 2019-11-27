module tx_counter(input wire clk, input wire n_rst, input wire cnt_up, input wire clear, output reg one_k_samples);


reg [9:0] count_out_samples;
tx_flex_counter#(
    .NUM_CNT_BITS(10)
    ) SAMPLE_COUNTER( .clk(clk), .n_rst(n_rst), .rollover_val(10'b1111101001), .count_enable(cnt_up), .clear(clear),.rollover_flag(one_k_samples), .count_out(count_out_samples));

endmodule

