//16 bit lsb shift register for USB CDL RX

module RX_SR (clk, n_rst, shift_strobe, serial_in, ignore_bit, RX_packet_data);
  input wire clk;
  input wire n_rst;
  input wire shift_strobe;
  input wire serial_in;
  input wire ignore_bit;
  output wire [15:0] RX_packet_data;

//  reg next_shift_en;
//   reg next_next_shift_en;
   reg shift_en;
/*
  always_comb begin
     shift_en = shift_strobe && (!ignore_bit);
  end
*/
   assign shift_en = shift_strobe;

/*   always_ff @ (posedge clk, negedge n_rst) begin //to delay shift signal by 1 clock cycle
      if (n_rst == 1'b0) begin
	 shift_en <= 1'b0;
      end else begin
	 shift_en <= next_shift_en;
	 next_shift_en <= next_next_shift_en;
      end
   end
*/   

  flex_stp_sr #(.NUM_BITS(16), .SHIFT_MSB(1)) shift_register
              (.clk(clk),
               .n_rst(n_rst),
               .shift_enable(shift_en),
               .serial_in(serial_in),
               .parallel_out(RX_packet_data));

endmodule
