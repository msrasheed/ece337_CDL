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

  RX_ControlFSM controller (.clk(clk),
                            .n_rst(n_rst)
                            .eop(eop),
                            .decoded_bit(decoded_bit),
                            .pass_5_bit(pass_5_bit),
                            .pass_16_bit(pass_16_bit),
                            .byte_done(byte_done),
                            .sr_val(SR_data),
                            .en_buffer(en_buffer),
                            .RX_PID(RX_packet),
                            .clear_crc(clear_crc));

  RX_SR shift_register (.clk(clk),
                        .n_rst(n_rst),
                        .shift_strobe(en_sample),
                        .serial_in(decoded_bit),
                        .ignore_bit(ignore_bit),
                        .RX_packet_data(SR_data));

  RX_byte_counter byte_counter (.clk(clk),
                                .n_rst(n_rst),
                                .count_enable(en_sample),
                                .byte_done(byte_done));

  RX_timer timer (.clk(clk),
                  .n_rst(n_rst),
                  .d_plus(d_plus),
                  .d_minus(d_minus),
                  .en_sample(en_sample));

  RX_bit_stuff_detector bsd (.clk(clk),
                             .(n_rst(n_rst),
                             .decoded_bit(decoded_bit),
                             .ignore_bit(ignore_bit));

  RX_decoder decoder (.clk(clk),
                      .n_rst(n_rst),
                      .d_plus(d_plus),
                      .d_minus(d_minus),
                      .decoded(decoded_bit),
                      .eop(eop));

//TODO need to assign and for the store data enable
//TODO need to add CRC modules

endmodule
