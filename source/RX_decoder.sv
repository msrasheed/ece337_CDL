//Decoder module for CDL USB RX

module RX_decoder (clk,
                n_rst,
                d_plus,
                d_minus,
                decoded,
                eop);

  input wire clk;
  input wire n_rst;
  input wire d_plus;
  input wire d_minus;
  output reg decoded;
  output reg eop;

  reg next_decoded;
  reg next_eop;
  reg value;
  reg next_value;

  always_comb begin //comb block for incoming values
    next_value = value; //Set default value to prevent latches
    next_eop = 1'b0;

    if (d_plus == 1'b1 && d_minus == 1'b0) begin
      next_value = 1;
    end else if (d_plus == 1'b0 && d_minus == 1'b1) begin
      next_value = 1'b0;
    end else if (d_plus == 1'b0 && d_minus == 1'b0) begin
      next_eop = 1'b1;
    end
  end

  always_comb begin //comb block for decoding
    next_decoded = 1'b1; //set default to prevent latches
    if (next_value == value) begin
      next_decoded = 1'b1;
    end else if (next_value == value) begin
      next_decoded = 1'b0;
    end
  end

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 1'b0) begin
      value <= 1'b0;
      decoded <= 1'b0;
      eop <= 1'b0;
    end else begin
      value <= next_value;
      decoded <= next_decoded;
      eop <= next_eop;
    end
  end
endmodule
