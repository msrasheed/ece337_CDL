// $Id: $
// File name:   ahb_addr_dec.sv
// Created:     11/11/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .

module ahb_addr_dec (
		input wire clk,
		input wire n_rst,
		input wire hsel,
		input wire [7:0] haddr,
		input wire [1:0] htrans,
		input wire [1:0] hsize,
		input wire hwrite,
 		output reg hready,
		output reg hresp,
		output reg get_rx_data,
		output reg store_tx_data,
		output reg [1:0] sr_read,
		output reg [1:0] er_read,
		output reg bo_read,
		output reg ts_read,
		output reg ts_write
                    );

localparam HTRANS_IDLE   = 2'd0;
localparam HTRANS_BUSY   = 2'd1;
localparam HTRANS_NONSEQ = 2'd2;
localparam HTRANS_SEQ    =2'd3;

localparam SR0 = 7'h40;
localparam SR1 = 7'h41;
localparam ER0 = 7'h42;
localparam ER1 = 7'h43;
localparam BO0 = 7'h44;
localparam TS0 = 7'h48;


reg [6:0] waddr;
reg b_hresp, c_hresp, nxt_store_tx_data, nxt_ts_write, nxt_bo_read, nxt_ts_read, nxt_get_rx_data;
reg [1:0] nxt_sr_read, nxt_er_read;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    c_hresp <= 1'b0;
    store_tx_data <= 1'b0;
    ts_write <= 1'b0;
    bo_read <= 1'b0;
    ts_read <= 1'b0;
    sr_read <= 2'b00;
    er_read <= 2'b00;
    get_rx_data <= 1'b0;
  end else begin
    c_hresp <= b_hresp;
    store_tx_data <= nxt_store_tx_data;
    ts_write <= nxt_ts_write;
    bo_read <= nxt_bo_read;
    ts_read <= nxt_ts_read;
    sr_read <= nxt_sr_read;
    er_read <= nxt_er_read;
    get_rx_data <= nxt_get_rx_data;
  end
end

always_comb begin
nxt_get_rx_data = 1'b0;
nxt_store_tx_data = 1'b0;
nxt_sr_read = 2'b00;
nxt_er_read = 2'b00;
nxt_bo_read = 1'b0;
nxt_ts_read = 1'b0;
nxt_ts_write = 1'b0;

  if (hsize == 2'b00) begin
    waddr = haddr; 
  end else if (hsize == 2'b01) begin
    waddr = {haddr[6:1], 1'b0};
  end else begin
    waddr = {haddr[6:2], 2'b00}; 
  end

  //HRESP handling
  b_hresp = 1'b0;

  //READ activate lines
  if (hsel == 1'b1 && htrans != HTRANS_IDLE) begin
    if (hwrite == 1'b0) begin
      if (haddr[6] != 1'b1) begin
        nxt_get_rx_data = 1'b1;
      end else begin
        if (hsize == 2'b00) begin
          case (waddr)
            SR0: nxt_sr_read[0] = 1'b1;
            SR1: nxt_sr_read[1] = 1'b1;
            ER0: nxt_er_read[0] = 1'b1;
            ER1: nxt_er_read[1] = 1'b1;
            BO0: nxt_bo_read = 1'b1;
            TS0: nxt_ts_read = 1'b1;
            default: b_hresp = 1'b1;
          endcase
        end else if (hsize == 2'b01) begin
          case (waddr)
            SR0: nxt_sr_read = 2'b11;
            ER0: nxt_er_read = 2'b11;
            default: b_hresp = 1'b1;
          endcase
        end else begin
          case (waddr)
            SR0: begin
                 nxt_sr_read = 2'b11;
                 nxt_er_read = 2'b11;
                 end
            default: b_hresp = 1'b1;
          endcase
        end
      end
    end else begin
    //WRITE activate lines
      if (haddr[6] == 1'b0) begin
        nxt_store_tx_data = 1'b1;
      end else begin
        if (waddr == 7'h48 && hsize == 2'b00) begin
          nxt_ts_write = 1'b1;
        end else begin
          b_hresp = 1'b1;
        end
      end
    end
  end

  //HRESP handling cont.
  hready = ~b_hresp;
  hresp = b_hresp | c_hresp;
end

endmodule
