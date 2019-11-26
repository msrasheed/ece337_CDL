//Ryan Pearson

module flex_stp_sr
#(
parameter NUM_BITS = 4,
parameter SHIFT_MSB = 1
)(clk, n_rst, shift_enable, serial_in, parallel_out);
  input wire clk;
  input wire n_rst;
  input wire shift_enable;
  input wire serial_in;
  output reg [NUM_BITS - 1:0]parallel_out;
  reg [NUM_BITS - 1:0]next_out;

  always_comb begin
    next_out = parallel_out;
    if(shift_enable == 1'b1) begin
      if (SHIFT_MSB == 1'b1) begin
        next_out = {parallel_out[NUM_BITS - 2:0], serial_in};
      end else begin
        next_out = {serial_in, parallel_out[NUM_BITS - 1:1]};
      end
    end
  end

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 1'b0) begin
      parallel_out <= '1;
    end else begin
      parallel_out <= next_out;
    end
  end
endmodule    