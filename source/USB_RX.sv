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
  wire [15:0] SR_data;
  wire ignore_bit;
   wire en_sample;
   wire clear_byte_count;
      

  RX_ControlFSM controller (.clk(clk),
                            .n_rst(n_rst),
                            .eop(eop),
                            .decoded_bit(decoded_bit),
                            .pass_5_bit(pass_5_bit),
                            .pass_16_bit(pass_16_bit),
                            .byte_done(byte_done),
                            .sr_val(SR_data),
                            .en_buffer(en_buffer),
                            .RX_PID(RX_packet),
                            .clear_crc(clear_crc),
			    .clear_byte_count(clear_byte_count));

  RX_SR shift_register (.clk(clk),
                        .n_rst(n_rst),
                        .shift_strobe(en_sample),
                        .serial_in(decoded_bit),
                        .ignore_bit(ignore_bit),
                        .RX_packet_data(SR_data));

  RX_byte_counter byte_counter (.clk(clk),
                                .n_rst(n_rst),
                                .count_enable(en_sample),
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
			     .next_enable(en_sample),
                             .ignore_bit(ignore_bit));

  RX_decoder decoder (.clk(clk),
                      .n_rst(n_rst),
                      .d_plus(d_plus),
                      .d_minus(d_minus),
		      .en_sample(en_sample),
                      .decoded(decoded_bit),
                      .eop(eop));

  assign store_RX_packet_data = byte_done && en_buffer;
 
//TODO need to add CRC modules

  crc_16bit_chk crc16 (.clk(clk),
		       .n_rst(n_rst),
		       .clear(clear_crc),
		       .serial_in(decoded_bit),
		       .shift_en(en_sample),
		       .pass(pass_16_bit));

  crc_5bit_chk crc5 (.clk(clk),
		       .n_rst(n_rst),
		       .clear(clear_crc),
		       .serial_in(decoded_bit),
		       .shift_en(en_sample),
		       .pass(pass_5_bit));
endmodule
