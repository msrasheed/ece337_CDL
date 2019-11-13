//16 bit lsb shift register for USB CDL RX

module RX_SR (clk, n_rst, shift_strobe, serial_in, ignore_bit, RX_packet_data);
  input wire clk;
  input wire n_rst;
  input wire shift_strobe;
  input wire serial_in;
  input wire ignore_bit;
  output wire [15:0] RX_packet_data;

  wire shift_en;

  always_comb begin
    shift_en = shift_strobe && (!ignore_bit);
  end

  flex_stp_sr #(.NUM_BITS(16), .SHIFT_MSB(0)) shift_register
              (.clk(clk),
               .n_rst(n_rst),
               .shift_enable(shift_en),
               .serial_in(serial_in),
               .parallel_out(packet_data);

endmodule
