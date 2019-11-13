// $Id: 0029653436
// File name:   flex_counter.sv
// Created:     9/17/2019
// Author:      Ryan Pearson
// Lab Section: 337-04



`timescale 1ns / 100ps

module flex_counter
#(
parameter NUM_CNT_BITS = 4
)
(
clk, n_rst, clear, count_enable, rollover_val, count_out, rollover_flag
);

	input wire clk;
	input wire n_rst;
	input wire clear;
	input wire count_enable;
	input wire [NUM_CNT_BITS - 1:0] rollover_val;
	output reg [NUM_CNT_BITS - 1:0] count_out;
	output reg rollover_flag;
	reg [NUM_CNT_BITS - 1:0] next_count;
	reg next_rollover_flag;
	

	always_comb begin
		next_rollover_flag = 1'b0;
		next_count = count_out;
		if (clear == 1'b1) begin
			next_count = '0;
		end else if (count_enable == 1'b1) begin
			if (count_out == rollover_val) begin 
				next_count = 1'b1;
			end else begin
				next_count = count_out + 1;
			end
		end
		if (next_count == rollover_val) begin
			next_rollover_flag = 1'b1;
		end
	end

	always_ff @ (posedge clk, negedge n_rst) begin
		if (n_rst == 1'b0) begin
			count_out <= '0;
			rollover_flag <= 1'b0;
		end else begin
			count_out <= next_count;
			rollover_flag <= next_rollover_flag;
		end
	end

endmodule