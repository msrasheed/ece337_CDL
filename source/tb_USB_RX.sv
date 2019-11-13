// $Id: $
// File name:   tb_USB_RX.sv
// Created:     11/13/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .

`timescale 1ns / 10ps

module tb_USB_RX;

  //Timing related constants
  localparam CLK_PERIOD = 10;
  localparam BUS_DELAY = 800ps;

  //sizing related constants
  localparam RX_PACKET_WIDTH = 3;
  localparam DATA_WIDTH = 8;

  //Teseting control signals
  string tb_test_case;
  integer tb_test_case_num;
  logic [(RX_PACKET_WIDTH-1):0] tb_expected_RX_packet;
  logic tb_expected_store_RX_packet_data;
  logic [(DATA_WIDTH-1):0] tb_expected_RX_packet_data;
  logic tb_check;
  
  //PID values
  localparam PID_OUT   = 4'b0001;
  localparam PID_IN    = 4'b1001;
  localparam PID_DATA0 = 4'b0011;
  localparam PID_DATA1 = 4'b1011;
  localparam PID_ACK   = 4'b0010;
  localparam PID_NAK   = 4'b1010;
  localparam PID_STALL = 5'b1110;

  //RX Packet values
  localparam PACKET_IDLE = 3'd0;//need to encode packet types
  localparam PACKET_DATA = 3'd1;
  localparam PACKET_OUT = 3'd2;
  localparam PACKET_IN = 3'd3;
  localparam PACKET_ACK = 3'd4;
  localparam PACKET_NAK = 3'd5;
  localparam PACKET_BAD = 3'd6;

  //Reset values
  localparam RESET_RX_PACKET = '0;
  localparam RESET_RX_PACKET_DATA = '0;
  localparam RESET_STORE_RX_PACKET_DATA = 1'b0;

  //General System Signals
  logic tb_clk;
  logic tb_n_rst;

  //USB_RX signals
  logic                         tb_d_plus;
  logic                         tb_d_minus;
  logic [(RX_PACKET_WIDTH-1):0] tb_RX_packet;
  logic                         tb_store_RX_packet_data;
  logic [(DATA_WIDTH-1):0]      tb_RX_packet_data;

  //send packet task signals
  localparam BIT_RATE = CLK_PERIOD * 100.0 / 12;
  logic [5:0] tb_prev_vals;
  logic [4:0] tb_crc_5bit;
  logic [15:0] tb_crc_16bit;

  //Clock generation Block
  always begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    //Wait half of the clock period before toggling clock value (maintain %50 duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    //Wait half of the clock period before toggling clock value via rernning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end
 
  //DUT instance
  USB_RX rxmod(.clk(tb_clk),
               .n_rst(tb_n_rst),
               .d_plus(tb_d_plus),
               .d_minus(tb_d_minus),
               .RX_packet(tb_RX_packet),
               .store_RX_packet_data(tb_store_RX_packet_data),
               .RX_packet_data(tb_RX_packet_data));

  task reset_dut;
  begin
    //activate the reset
    tb_n_rst = 1'b0;

    //maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    //Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_n_rst = 1'b1;

    //leave out of reset for a couple cycles before allowing other stimulus
    //wait for negative clock edges
    //since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  //send a byte
  task send_byte;
    input [7:0] data;
    integer i;
  begin
    @(negedge tb_clk);

    for (i = 7; i >= 0; i = i - 1)
    begin
      if (tb_prev_vals == 6'h3f) begin
        tb_d_plus = tb_d_minus;
        tb_d_minus = ~tb_d_plus;
        tb_prev_vals = '0;
        #(BIT_RATE);
      end
      if (data[i] == 1'b0) begin
        tb_d_plus = tb_d_minus;
        tb_d_minus = ~tb_d_plus;
      end
      tb_prev_vals = (tb_prev_vals << 1) | data[i];
      #(BIT_RATE);
    end
  end
  endtask

  // send the EOP
  task send_stop;
  begin
    tb_d_plus = 1'b0;
    tb_d_minus = 1'b0;
    #(BIT_RATE);
    #(BIT_RATE);
    tb_d_plus = 1'b1;
  end
  endtask

  //calc 5 bit crc
  task calc_crc5;
    input [6:0] addr;
    input [3:0] endref;
    logic test;
    logic [10:0] senddata;
    integer i;
  begin
    tb_crc_5bit = '1;
    senddata = {addr, endref};
    for (i = 10; i > -1; i = i + 1)
    begin
      test = senddata[i] ^ tb_crc_5bit[4];
      tb_crc_5bit = tb_crc_5bit << 1;
      if (test == 1'b1) begin
        tb_crc_5bit = tb_crc_5bit ^ 5'b00101;
      end
    end
    tb_crc_5bit = ~tb_crc_5bit;
  end
  endtask

  task calc_crc16;
    input [7:0] senddata[];
  begin
    
  end
  endtask

  //send packet task
  task send_packet;
    input [3:0] pid;
    input int datalen;
    input [7:0] data [63:0];
  begin
    send_byte(8'h01);
    send_byte({pid, ~pid});
    
  end
  endtask

  initial begin
  //initialize test case navigation signals
  tb_test_case = "Initilization";
  tb_test_case_num = -1;
  tb_check = '0;
  //initualize rx input
  tb_n_rst = 1'b1;
  tb_d_plus = 1'b1;
  tb_d_minus = ~tb_d_plus;
  end

endmodule
