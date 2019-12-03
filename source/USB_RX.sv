//USB RX CDL Top Level module

module USB_RX(clk,
              n_rst,
              d_plus,
              d_minus,
              RX_packet,
              store_RX_packet_data,
              RX_packet_data);

  input wire clk;
  input wire n_rst;
  input wire d_plus;
  input wire d_minus;
  output wire [2:0] RX_packet;
  output wire store_RX_packet_data;
  output wire [7:0] RX_packet_data;

  wire eop;
  wire decoded_bit;
  wire pass_5_bit;
  wire pass_16_bit;
  wire byte_done;
  wire en_buffer;
  wire clear_crc;
  wire [23:0] SR_data;
  wire ignore_bit;
   wire en_sample;
   wire clear_byte_count;

   reg 	delayed_en_sample;
   reg very_delayed_en_sample;
   reg delayed_eop;
   
   always_ff @ (posedge clk, negedge n_rst) begin
      if (n_rst == 1'b0) begin
	 delayed_en_sample <= 1'b0;
	 very_delayed_en_sample <= 1'b0;
	 delayed_eop <= 1'b0;
      end else begin
	 delayed_en_sample <= en_sample;
	 very_delayed_en_sample <= delayed_en_sample && !ignore_bit;
	 delayed_eop <= eop;
      end
   end
   
  RX_ControlFSM controller (.clk(clk),
                            .n_rst(n_rst),
                            .eop(eop),
                            .decoded_bit(decoded_bit),
                            .pass_5_bit(pass_5_bit),
                            .pass_16_bit(pass_16_bit),
                            .byte_done(byte_done),
                            .sr_val(SR_data),
			    .shift_en(delayed_en_sample),
                            .en_buffer(en_buffer),
                            .RX_PID(RX_packet),
                            .clear_crc(clear_crc),
			    .clear_byte_count(clear_byte_count));

  RX_SR shift_register (.clk(clk),
                        .n_rst(n_rst),
                        .shift_strobe(very_delayed_en_sample),
                        .serial_in(decoded_bit),
                        .ignore_bit(ignore_bit),
                        .RX_packet_data(SR_data));

  RX_byte_counter byte_counter (.clk(clk),
                                .n_rst(n_rst),
                                .count_enable(very_delayed_en_sample),
				.clear(clear_byte_count),
                                .byte_done(byte_done));

  RX_timer timer (.clk(clk),
                  .n_rst(n_rst),
                  .d_plus(d_plus),
                  .d_minus(d_minus),
                  .en_sample(en_sample));

  RX_bit_stuff_detector bsd (.clk(clk),
                             .n_rst(n_rst),
                             .decoded_bit(decoded_bit),
			     .next_enable(delayed_en_sample),
                             .ignore_bit(ignore_bit));

  RX_decoder decoder (.clk(clk),
                      .n_rst(n_rst),
                      .d_plus(d_plus),
                      .d_minus(d_minus),
		      .en_sample(en_sample),
                      .decoded(decoded_bit),
                      .eop(eop));

  assign store_RX_packet_data = byte_done && en_buffer;
   assign RX_packet_data = {SR_data[16],SR_data[17],SR_data[18],SR_data[19],SR_data[20],SR_data[21],SR_data[22],SR_data[23]};
   
  crc_16bit_chk crc16 (.clk(clk),
		       .n_rst(n_rst),
		       .clear(clear_crc),
		       .serial_in(decoded_bit),
		       .shift_en(very_delayed_en_sample && !delayed_eop),
		       .pass(pass_16_bit));

  crc_5bit_chk crc5 (.clk(clk),
		       .n_rst(n_rst),
		       .clear(clear_crc),
		       .serial_in(decoded_bit),
		       .shift_en(very_delayed_en_sample && !delayed_eop),
		       .pass(pass_5_bit));
endmodule
