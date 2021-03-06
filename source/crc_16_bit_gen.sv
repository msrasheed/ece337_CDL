// $Id: $
// File name:   crc_16-bit_gen.sv
// Created:     11/10/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .


module crc_16_bit_gen (
		input wire clk,
		input wire n_rst,
		input wire clear,
		input wire serial_in,
		input wire shift_en,
		output reg [15:0] crc
                     );

reg [15:0] Q, next_Q;
reg test;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    Q <= 16'hffff;
  end else begin
    Q <= next_Q;
  end
end

always_comb begin
  next_Q = Q;
  test = Q[15] ^ serial_in;

  if (clear == 1'b1) begin
    next_Q = 16'hffff;
  end else if (shift_en == 1'b1) begin
    next_Q = Q << 1;
    if (test == 1'b1) begin
      next_Q = next_Q ^ 16'h8005;
    end else begin
    end
  end

  crc = ~Q;
end
endmodule

