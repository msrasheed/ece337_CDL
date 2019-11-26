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
		input wire [6:0] haddr,
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

localparam SR0 = 7'h40;
localparam SR1 = 7'h41;
localparam ER0 = 7'h42;
localparam ER1 = 7'h43;
localparam BO0 = 7'h44;
localparam TS0 = 7'h48;


reg [6:0] waddr;
reg b_hresp, c_hresp;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    c_hresp <= 1'b0;
  end else begin
    c_hresp <= b_hresp;
  end
end

always_comb begin
get_rx_data = 1'b0;
store_tx_data = 1'b0;
sr_read = 2'b00;
er_read = 2'b00;
bo_read = 1'b0;
ts_read = 1'b0;
ts_write = 1'b0;

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
  if (hsel == 1'b1) begin
    if (hwrite == 1'b0) begin
      if (haddr[6] != 1'b1) begin
        get_rx_data = 1'b1;
      end else begin
        if (hsize == 2'b00) begin
          case (waddr)
            SR0: sr_read[0] = 1'b1;
            SR1: sr_read[1] = 1'b1;
            ER0: er_read[0] = 1'b1;
            ER1: er_read[1] = 1'b1;
            BO0: bo_read = 1'b1;
            TS0: ts_read = 1'b1;
            default: b_hresp = 1'b1;
          endcase
        end else if (hsize == 2'b01) begin
          case (waddr)
            SR0: sr_read = 2'b11;
            ER0: er_read = 2'b11;
            default: b_hresp = 1'b1;
          endcase
        end else begin
          case (waddr)
            SR0: begin
                 sr_read = 2'b11;
                 er_read = 2'b11;
                 end
            default: b_hresp = 1'b1;
          endcase
        end
      end
    end else begin
    //WRITE activate lines
      if (haddr[6] != 1'b0) begin
        store_tx_data = 1'b1;
      end else begin
        if (waddr == 7'h48 && hsize == 2'b00) begin
          ts_write = 1'b1;
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
