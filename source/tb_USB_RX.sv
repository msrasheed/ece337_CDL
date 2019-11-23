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
  string                        tb_test_case;
  integer                       tb_test_case_num;
  logic [(RX_PACKET_WIDTH-1):0] tb_expected_RX_packet;
  logic                         tb_expected_store_RX_packet_data;
  logic [(DATA_WIDTH-1):0]      tb_expected_RX_packet_data;
  logic                         tb_check;
  integer                       tb_numbyte = 0;
  logic [(DATA_WIDTH-1):0]      tb_byte_out; 

  //EOP signals
  localparam  NORMAL_EOP    = 2'd0;
  localparam  BAD_EOP_ONE   = 2'd1;
  localparam  BAD_EOP_TWO   = 2'd2;
  localparam  BAD_EOP_THREE = 2'd3;
  logic [1:0] tb_eop_type;
  
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
  logic [5:0]  tb_prev_vals;
  logic [4:0]  tb_crc_5bit;
  logic [15:0] tb_crc_16bit;
  logic [6:0]  tb_usb_addr = 7'd0;
  logic [3:0]  tb_usb_endpoint = 4'd0;
  logic [7:0]  tb_send_data [];

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
    for (i = 10; i > -1; i = i - 1)
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

  //calc 16 bit crc
  task calc_crc16;
    input [7:0] senddata[];
    integer i;
    integer j;
    logic test;
  begin
    tb_crc_16bit = '1;
    for (i = 0; i < senddata.size(); i = i + 1)
    begin
      for (j = 7; j > -1; j = j - 1)
      begin
        test = senddata[i][j] ^ tb_crc_16bit[15];
        tb_crc_16bit = tb_crc_16bit << 1;
        if (test == 1'b1) begin
          tb_crc_16bit = tb_crc_16bit ^ 16'h8005;
        end
      end
    end
    tb_crc_16bit = ~tb_crc_16bit;
  end
  endtask

  //set data to send for IN or OUT token
  task set_senddata_in_out;
  begin
    tb_send_data = new [2];
    calc_crc5(tb_usb_addr, tb_usb_endpoint);
    tb_send_data = {{tb_usb_addr, tb_usb_endpoint[3]}, {tb_usb_endpoint[2:0], tb_crc_5bit}};
  end
  endtask

  //generate random senddata of any size
  task random_senddata;
    input integer numbytes;
    integer i;
    integer j;
    logic [7:0] temp;
  begin
    tb_send_data = new [numbytes];
    for (j = 0; j < numbytes; j = j + 1) begin
      for (i = 0; i < 8; i = i + 1) begin
        temp[i] = $urandom_range(1,0);
      end
      tb_send_data[j] = temp;
    end
  end
  endtask

  //send a byte
  task send_byte;
    input [7:0] data;
    integer i;
  begin
    tb_numbyte = tb_numbyte + 1;
    tb_byte_out = data;
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
  task send_eop;
  begin
    if (tb_eop_type == NORMAL_EOP) begin
      tb_d_plus = 1'b0;
      tb_d_minus = 1'b0;
      #(BIT_RATE);
      #(BIT_RATE);
      tb_d_plus = 1'b1;
      #(BIT_RATE);
    end else if (tb_eop_type == BAD_EOP_ONE) begin
      #(BIT_RATE);
      tb_d_plus = 1'b0;
      tb_d_minus = 1'b0;
      #(BIT_RATE);
      tb_d_plus = 1'b1;
      #(BIT_RATE);
    end else if (tb_eop_type == BAD_EOP_TWO) begin
      tb_d_plus = 1'b0;
      tb_d_minus = 1'b0;
      #(BIT_RATE);
      tb_d_plus = 1'b1;
      #(BIT_RATE);
      #(BIT_RATE);
    end else if (tb_eop_type == BAD_EOP_THREE) begin
      tb_d_plus = 1'b0;
      tb_d_minus = 1'b0;
      #(BIT_RATE);
      #(BIT_RATE);
      #(BIT_RATE);
      tb_d_plus = 1'b1;
    end
  end
  endtask

  //send packet task
  task send_packet;
    input [3:0] pid;
    input [7:0] senddata [];
    integer i;
  begin
    tb_numbyte = 0;
    tb_prev_vals = '0;
    send_byte(8'h01);
    send_byte({pid, ~pid});
    if (pid == PID_IN || pid == PID_OUT) begin
      for (i = 0; i < senddata.size(); i = i + 1) begin
        send_byte(senddata[i]);
      end
    end else if (pid == PID_DATA0 || pid == PID_DATA1) begin
      for (i = 0; i < senddata.size(); i = i + 1) begin
        send_byte(senddata[i]);
      end 
      send_byte(tb_crc_16bit[15:8]);
      send_byte(tb_crc_16bit[7:0]);
    end
    tb_numbyte = 0;
    tb_prev_vals = '0;
    send_eop();
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
  //set eop to normal
  tb_eop_type = NORMAL_EOP;
  //initialize crc
  tb_crc_5bit = '0;
  tb_crc_16bit = '0;
  //inialize bit stuffing setup
  tb_prev_vals = '0;
  //inialize expected vals
  tb_expected_RX_packet = '0;
  tb_expected_store_RX_packet_data = '0;
  tb_expected_RX_packet_data = '0;

  //wait some time before starting first test case
  #(0.1);

  //*****************************************************************************
  // Power-on-Reset Test Case
  //*****************************************************************************
  tb_test_case = "Power-on-Reset";
  tb_test_case_num = tb_test_case_num + 1;
  reset_dut();

  //spacing of test cases
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send IN Token
  //*****************************************************************************
  tb_test_case = "IN Token";
  tb_test_case_num = tb_test_case_num + 1;

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_IN, tb_send_data);

  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send OUT Token
  //*****************************************************************************
  tb_test_case = "OUT Token";
  tb_test_case_num = tb_test_case_num + 1;

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_OUT, tb_send_data);

  //spacing of test cases
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send ACK
  //*****************************************************************************
  tb_test_case = "ACK PID";
  tb_test_case_num = tb_test_case_num + 1;

  tb_send_data.delete();
  send_packet(PID_ACK, tb_send_data);

  //spacing of test cases
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send DATA0
  //*****************************************************************************
  tb_test_case = "DATA0 PID";
  tb_test_case_num = tb_test_case_num + 1;

  tb_send_data = new [5];
  random_senddata(2);                  //puts two random bytes in tb_send_data
  tb_send_data[0] = '1;
  tb_send_data[1] = '0;
  calc_crc16(tb_send_data);            //sets tb_crc_16bit variable
  send_packet(PID_DATA0, tb_send_data);

  //spacing of test cases
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send DATA1
  //*****************************************************************************
  tb_test_case = "DATA1 PID";
  tb_test_case_num = tb_test_case_num + 1;

  tb_send_data = new [5];
  random_senddata(2);                  //puts two random bytes in tb_send_data
  tb_send_data[0] = '1;
  tb_send_data[1] = '0;
  calc_crc16(tb_send_data);            //sets tb_crc_16bit variable
  send_packet(PID_DATA1, tb_send_data);

  //spacing of test cases
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send IN Token bad address
  //*****************************************************************************
  tb_test_case = "IN Token";
  tb_test_case_num = tb_test_case_num + 1;

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_IN, tb_send_data);

  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send IN Token bad address
  //*****************************************************************************
  tb_test_case = "IN Token bad address";
  tb_test_case_num = tb_test_case_num + 1;

  tb_usb_addr = 7'b1;                      //correct address is 0
  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_IN, tb_send_data);

  #(CLK_PERIOD * 10);
  tb_usb_addr = 7'b0;                      //reset address

  //*****************************************************************************
  // Send IN Token bad endpoint
  //*****************************************************************************
  tb_test_case = "IN Token bad endpoint";
  tb_test_case_num = tb_test_case_num + 1;

  tb_usb_endpoint = 4'b1;                  //correct endpoint is 0
  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_IN, tb_send_data);

  #(CLK_PERIOD * 10);
  tb_usb_endpoint = 4'b0;                  //reset endpoint

  //*****************************************************************************
  // Send IN Token bad crc5
  //*****************************************************************************
  tb_test_case = "IN Token bad crc5";
  tb_test_case_num = tb_test_case_num + 1;

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  tb_crc_5bit = 5'b0;                      //for correct addr and endpoint - crc is 5'd8
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_IN, tb_send_data);

  //spacing of test cases
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send OUT Token bad address
  //*****************************************************************************
  tb_test_case = "OUT Token bad address";
  tb_test_case_num = tb_test_case_num + 1;

  tb_usb_addr = 7'b1;                      //correct address is 0
  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_OUT, tb_send_data);

  #(CLK_PERIOD * 10);
  tb_usb_addr = 7'b0;                      //reset address

  //*****************************************************************************
  // Send OUT Token bad endpoint
  //*****************************************************************************
  tb_test_case = "OUT Token bad endpoint";
  tb_test_case_num = tb_test_case_num + 1;

  tb_usb_endpoint = 4'b1;                  //correct endpoint is 0
  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_OUT, tb_send_data);

  #(CLK_PERIOD * 10);
  tb_usb_endpoint = 4'b0;                  //reset endpoint

  //*****************************************************************************
  // Send OUT Token bad crc5
  //*****************************************************************************
  tb_test_case = "OUT Token bad crc5";
  tb_test_case_num = tb_test_case_num + 1;

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  tb_crc_5bit = 5'b0;                      //for correct addr and endpoint - crc is 5'd8
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_OUT, tb_send_data);

  //spacing of test cases
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send DATA0 bad crc16
  //*****************************************************************************
  tb_test_case = "DATA0 PID bad crc16";
  tb_test_case_num = tb_test_case_num + 1;

  tb_send_data = new [5];
  random_senddata(2);                  //puts two random bytes in tb_send_data
  tb_send_data[0] = '1;
  tb_send_data[1] = '0;
  calc_crc16(tb_send_data);            //sets tb_crc_16bit variable
  tb_crc_16bit = '0;                   //correct crc16 is for sure not 0
  send_packet(PID_DATA0, tb_send_data);

  //spacing of test cases
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Send DATA1 bad data
  //*****************************************************************************
  tb_test_case = "DATA1 PID bad data";
  tb_test_case_num = tb_test_case_num + 1;

  tb_send_data = new [5];
  random_senddata(2);                  //puts two random bytes in tb_send_data
  tb_send_data[0] = '1;
  tb_send_data[1] = '0;
  calc_crc16(tb_send_data);            //sets tb_crc_16bit variable
  tb_send_data[0] = 8'b01010101;
  send_packet(PID_DATA1, tb_send_data);

  //spacing of test cases
  #(CLK_PERIOD * 10);

  

  //*****************************************************************************
  // END
  //*****************************************************************************
  tb_test_case = "END";
  tb_test_case_num = tb_test_case_num + 1;
  end

endmodule
