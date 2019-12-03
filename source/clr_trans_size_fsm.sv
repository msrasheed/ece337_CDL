// $Id: $
// File name:   clr_trans_size_fsm.sv
// Created:     11/10/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .

module clr_trans_size_fsm (
		input wire clk,
		input wire n_rst,
		input wire tx_trans_act,
		input wire buff_resv,
		output reg tx_pack_ds_clr
                          );

typedef enum bit [1:0] {IDLE, WAIT1, WAIT2, CLEAR} stateType;
stateType state, next_state;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

always_comb begin
  next_state = state;
  case (state)
    IDLE: begin
           if (buff_resv == 1'b1) begin
             next_state = WAIT1;
           end
           end
    WAIT1: begin
           if (tx_trans_act == 1'b1) begin
             next_state = WAIT2;
           end
           end
    WAIT2: begin
           if (tx_trans_act == 1'b0) begin
             next_state = CLEAR;
           end
           end
    CLEAR: begin
             next_state = IDLE;
           end
  endcase

  tx_pack_ds_clr = 1'b0;
  if (state == CLEAR) begin
    tx_pack_ds_clr = 1'b1;
  end
end

endmodule
