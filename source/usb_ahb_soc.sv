// $Id: $
// File name:   usb_ahb_soc.sv
// Created:     11/26/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .

module usb_ahb_soc (
		input wire clk,
		input wire n_rst,
		input wire hsel,
		input wire [7:0] haddr,
		input wire [1:0] htrans,
		input wire [1:0] hsize,
		input wire hwrite,
		input wire [31:0] hwdata,
		input wire [2:0] hburst,
		output wire [31:0] hrdata,
		output wire hresp,
		output wire hready,

		input wire dplus_in,
		input wire dminus_in,
		output wire d_mode,
		output wire dplus_out,
		output wire dminus_out
                   );

wire rx_data_ready, rx_transfer_active, rx_error, tx_transfer_active, tx_error;
wire buffer_reserved, get_rx_data, store_tx_data;
wire [1:0] data_size;
wire [6:0] buffer_occupancy, tx_packet_data_size;
wire [31:0] rx_data, tx_data;

ahb_slave AHBSLAVE(
              .clk(clk),
              .n_rst(n_rst),
              .hsel(hsel),
              .haddr(haddr),
              .htrans(htrans),
              .hsize(hsize),
              .hwrite(hwrite),
              .hwdata(hwdata),
              .hburst(hburst),
              .hrdata(hrdata),
              .hresp(hresp),
              .hready(hready),
              .rx_data_ready(rx_data_ready),
              .rx_transfer_active(rx_transfer_active),
              .rx_error(rx_error),
              .tx_transfer_active(tx_transfer_active),
              .tx_error(tx_error),
              .buffer_occupancy(buffer_occupancy),
              .rx_data(rx_data),
              .buffer_reserved(buffer_reserved),
              .tx_packet_data_size(tx_packet_data_size),
              .get_rx_data(get_rx_data),
              .store_tx_data(store_tx_data),
              .tx_data(tx_data),
              .data_size(data_size));

wire tx_done, clear;
wire [1:0] tx_packet;
wire [2:0] rx_packet;
protocol_controller PROTCONTR(
              .clk(clk),
              .n_rst(n_rst),
              .rx_packet(rx_packet),
              .tx_done(tx_done),
              .buffer_reserved(buffer_reserved),
              .tx_packet_data_size(tx_packet_data_size),
              .buffer_occupancy(buffer_occupancy),
              .rx_data_ready(rx_data_ready),
              .rx_transfer_active(rx_transfer_active),
              .rx_error(rx_error),
              .tx_transfer_active(tx_transfer_active),
              .tx_error(tx_error),
              .clear(clear),
              .tx_packet(tx_packet),
              .d_mode(d_mode));


wire store_rx_packet_data, get_tx_packet_data;
wire [7:0] rx_packet_data, tx_packet_data;
data_buffer DBUFF(
              .clk(clk),
              .n_rst(n_rst),
              .clear(clear),
              .store_rx_packet_data(store_rx_packet_data),
              .rx_packet_data(rx_packet_data),
              .get_rx_data(get_rx_data),
              .data_size(data_size),
              .tx_data(tx_data),
              .store_tx_data(store_tx_data),
              .get_tx_packet_data(get_tx_packet_data),
              .buffer_reserved(buffer_reserved),
              .buffer_occupancy(buffer_occupancy),
              .rx_data(rx_data),
              .tx_packet_data(tx_packet_data));

USB_RX RXBLOCK(
              .clk(clk),
              .n_rst(n_rst),
              .d_plus(dplus_in),
              .d_minus(dminus_in),
              .RX_packet(rx_packet),
              .store_RX_packet_data(store_rx_packet_data),
              .RX_packet_data(rx_packet_data));

usb_tx TXBLOCK(
              .clk(clk),
              .n_rst(n_rst),
              .tx_packet(tx_packet),
              .tx_packet_data_size(tx_packet_data_size),
              .tx_packet_data(tx_packet_data),
              .dPlus_out(dplus_out),
              .dMinus_out(dminus_out),
              .tx_done(tx_done),
              .get_tx_packet(get_tx_packet));


endmodule
