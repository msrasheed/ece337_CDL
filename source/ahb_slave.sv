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

//state machine 
wire enable;
ahb_slave_cntrlr CNTRLR(.clk(clk),
                        .n_rst(n_rst),
                        .hsel(hsel),
                        .hresp(c_hresp),
                        .htran(htrans),
                        .enable(enable));

//clear transfer size buffer fsm
wire clr_tx_ds;
clr_trans_size_fsm CTSM(.clk(clk),
                        .n_rst(n_rst),
                        .tx_trans_act(tx_transfer_active),
                        .buff_resv(buffer_reserved),
                        .tx_pack_ds_clr(clr_tx_ds));

//ahb address decoder
wire bo_read, ts_read, ts_write;
wire [1:0] sr_read, er_read;
ahb_addr_dec AAD(.clk(clk),
                 .n_rst(n_rst),
                 .hsel(hsel),
                 .haddr(haddr),
                 .hsize(hsize),
                 .hwrite(hwrite),
                 .hready(hready),
                 .hresp(hresp),
                 .get_rx_data(get_rx_data),
                 .store_tx_data(store_tx_data),
                 .sr_read(sr_read),
                 .er_read(er_read),
                 .bo_read(bo_read),
                 .ts_read(ts_read),
                 .ts_write(ts_write));

//Registers
localparam SR0 = 3'h0;
localparam SR1 = 3'h1;
localparam ER0 = 3'h2;
localparam ER1 = 3'h3;
localparam BO0 = 3'h4;
localparam TS0 = 3'h5;

reg [7:0] regfile [5:0];
reg [7:0] next_regfile [5:0];
always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    regfile <= {'0,'0,'0,'0,'0,'0};
  end else begin
    regfile <= next_regfile;
  end
end

//write handling
always_comb begin
  next_regfile = regfile;
  next_regfile[SR0] = {7'd0, rx_data_ready};
  next_regfile[SR1] = {6'd0, tx_transfer_active, rx_transfer_active};
  next_regfile[ER0] = {7'd0, rx_error};
  next_regfile[ER1] = {7'd0, tx_error};
  next_regfile[BO0] = {1'b0, buffer_occupancy};

  tx_data = '0;
  if (store_tx_data == 1'b1) begin
    if (hsize == 2'b00) begin
      case (haddr[1:0])
        2'b00: tx_data = {24'd0, hwdata[7:0]};
        2'b01: tx_data = {24'd0, hwdata[15:8]};
        2'b10: tx_data = {24'd0, hwdata[23:16]};
        2'b11: tx_data = {24'd0, hwdata[31:24]};
      endcase
    end else if (hsize == 2'b01) begin
      case (haddr[1])
        1'b0: tx_data = {16'd0, hwdata[15:0]};
        1'b1: tx_data = {16'd0, hwdata[31:16]};
      endcase
    end else begin
      tx_data = hwdata;
    end
  end

  if (ts_write == 1'b1) begin
    next_regfile[TS0] = hwdata[7:0];
  end

  if (clr_tx_ds == 1'b1) begin
    next_regfile[TS0] = '0;
  end 
  buffer_reserved = |regfile[TS0];
  tx_packet_data_size = regfile[TS0][6:0];
  data_size = hsize;
end

//read handling
reg [31:0] next_hrdata;
always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    hrdata <= '0;
  end else begin
    hrdata <= next_hrdata;
  end
end

always_comb begin
  next_hrdata = '0;
  if (get_rx_data == 1'b1) begin
    case (hsize)
      2'b00: next_hrdata[7:0] = rx_data[7:0];
      2'b01: next_hrdata[15:0] = rx_data[15:0];
      2'b10: next_hrdata = rx_data;
    endcase
  end
  if (sr_read[0] == 1'b1)
    next_hrdata[7:0] = next_regfile[SR0];
  if (sr_read[1] == 1'b1)
    next_hrdata[15:8] = next_regfile[SR1];
  if (er_read[0] == 1'b1)
    next_hrdata[23:16] = next_regfile[ER0];
  if (er_read[1] == 1'b1)
    next_hrdata[31:24] = next_regfile[ER1];
  if (bo_read == 1'b1)
    next_hrdata[7:0] = next_regfile[BO0];
  if (ts_read == 1'b1)
    next_hrdata[7:0] = next_regfile[TS0];
end

endmodule
