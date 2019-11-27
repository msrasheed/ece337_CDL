// $Id: $
// File name:   ahb_slave_cntrlr.sv
// Created:     11/10/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .

module ahb_slave_cntrlr(
			input wire clk,
			input wire n_rst,
			input wire hsel,
			input wire hresp,
			input wire [1:0] htran,
			output reg enable
                       );

localparam IDLE = 2'b00;
localparam DBURST = 2'b01;
localparam NSEQ = 2'b10;
localparam SBURST = 2'b11;

typedef enum bit {IDLES, ACTIVE} stateType;
stateType state, next_state;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    state <= IDLES;
  end else begin
    state <= next_state;
  end
end

always_comb begin
next_state = state;
case (state)
IDLES: begin
        if (hsel == 1'b1 && htran != IDLE) begin
          next_state = ACTIVE;
        end
        end
ACTIVE: begin
        if (htran == IDLE || hresp == 1'b1) begin
          next_state = IDLES;
        end
        end
endcase
end

always_comb begin
enable = 1'b0;
if (state == ACTIVE) begin
  enable = 1'b1;
end
end

endmodule
