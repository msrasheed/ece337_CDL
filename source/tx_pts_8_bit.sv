// $Id: $
// File name:   pts_8_bit.sv
// Created:     9/14/2018
// Author:      Tim Pritchett
// Lab Section: 9999
// Version:     1.0  Initial Design Entry
// Description: 8-bit LSB Parallel to Serial shift register
//              (Defaults size, Non-default direction for Flex PtS SR)

module tx_pts_8_bit
(
  input wire clk,
  input wire n_rst,
  input wire shift_enable,
  input wire load_enable,
  input wire [7:0] parallel_in,
  output reg serial_out 
);

  tx_flex_pts_sr #(
    .SHIFT_MSB(0)
  )
  CORE(
    .clk(clk),
    .n_rst(n_rst),
    .parallel_in(parallel_in),
    .shift_enable(shift_enable),
    .load_enable(load_enable),
    .serial_out(serial_out)
  );

endmodule