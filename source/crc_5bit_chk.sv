// $Id: $
// File name:   crc_5bit_chk.sv
// Created:     11/10/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .

module src_5bit_chk (
		input wire clk,
		input wire n_rst,
		input wire clear,
		input wire serial_in,
		input wire shift_en,
		output reg pass
                     );

reg [4:0] Q, next_Q;
reg test;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    Q <= 5'b00000;
  end else begin
    Q <= next_Q;
  end
end

always_comb begin
  next_Q = Q;
  test = Q[4] ^ serial_in;

  if (clear == 1'b1) begin
    next_Q = 5'b00000;
  end else if (shift_en == 1'b1) begin
    next_Q = Q << 1;
    if (test == 1'b1) begin
      next_Q = next_Q ^ 5'b00101;
    end else begin
    end
  end

  pass = Q == 5'b01100;
end

endmodule
