// $Id: $
// File name:   ahb_slave.sv
// Created:     11/10/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .

module ahb_slave (
		input wire clk,
		input wire n_rst,
		input wire hsel,
		input wire [6:0] haddr,
		input wire [1:0] htrans,
		input wire [1:0] hsize,
		input wire hwrite,
		input wire [31:0] hwdata,
		input wire [2:0] hburst,

		output reg [31:0] hrdata,
		output reg hresp,
		output reg hready,

		input wire rx_data_ready,
		input wire rx_transfer_active,
		input wire rx_error,
		input wire tx_transfer_active,
		input wire tx_error,
		input wire [6:0] buffer_occupancy,
		input wire [31:0] rx_data,
	
		output reg buffer_reserved,
		output reg [6:0] tx_packet_data_size,
		output reg get_rx_data,
		output reg store_tx_data,
		output reg [31:0] tx_data,
		output reg [1:0] data_size
                 );

localparam SR = 7'h40;
localparam ER = 7'h42;
localparam BO = 7'h44

//buffering inputs
reg b_hwrite, b_hresp, c_hresp;
reg [1:0] b_hsize;
reg [6:0] b_haddr;
always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    b_hwrite <= 1'b0;
    b_hsize <= 2'b00;
    b_haddr <= '0;
    b_hresp <= 1'b0;
  end else begin 
    b_hwrite <= hwrite;
    b_hsize <= hsize;
    b_haddr <= haddr;
    b_hresp <= c_hresp;
  end
end

//HRESP determinator
always_comb begin
  c_hresp = 1'b0;
  if (hwrite == 1'b1) begin
    case({haddr[6:1], 1'b0})
      SR: c_hresp = 1'b1;
      ER: c_hresp = 1'b1;
      BO: c_hresp = 1'b1;
    endcase
  end
  if (haddr > 7'h48) begin
    c_hresp = 1'b1;
  end
  hready = ~c_hresp;
  hresp = c_hresp | b_hresp;
end

//state machine 
wire enable;
ahb_slave_cntrlr CNTRLR(.clk(clk),
                        .n_rst(n_rst),
                        .hsel(hsel),
                        .hresp(c_hresp);
                        .htran(htrans),
                        .enable(enable));

//clear transfer size buffer fsm
wire clr_tx_ds;
clr_trans_size_fsm CTSM(.clk(clk),
                        .n_rst(n_rst),
                        .tx_trans_act(tx_transfer_active),
                        .buff_resv(buffer_reserved),
                        .tx_pack_ds_clr(clr_tx_ds));


endmodule
