// $Id: $
// File name:   tb_usb_ahb_soc.sv
// Created:     11/26/2019
// Author:      Moiz Rasheed
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .

`timescale 1ns / 10ps

module tb_usb_ahb_soc();

// Timing related constants
localparam CLK_PERIOD = 10;
localparam BUS_DELAY  = 800ps; // Based on FF propagation delay

// Sizing related constants
localparam DATA_WIDTH      = 4;
localparam ADDR_WIDTH      = 8;
localparam DATA_WIDTH_BITS = DATA_WIDTH * 8;
localparam DATA_MAX_BIT    = DATA_WIDTH_BITS - 1;
localparam ADDR_MAX_BIT    = ADDR_WIDTH - 1;

// HTRANS Codes
localparam TRANS_IDLE = 2'd0;
localparam TRANS_BUSY = 2'd1;
localparam TRANS_NSEQ = 2'd2;
localparam TRANS_SEQ  = 2'd3;

// HBURST Codes
localparam BURST_SINGLE = 3'd0;
localparam BURST_INCR   = 3'd1;
localparam BURST_WRAP4  = 3'd2;
localparam BURST_INCR4  = 3'd3;
localparam BURST_WRAP8  = 3'd4;
localparam BURST_INCR8  = 3'd5;
localparam BURST_WRAP16 = 3'd6;
localparam BURST_INCR16 = 3'd7;

// Define our address mapping scheme via constants
localparam ADDR_READ_MIN  = 8'd0;
localparam ADDR_READ_MAX  = 8'd127;
localparam ADDR_WRITE_MIN = 8'd64;
localparam ADDR_WRITE_MAX = 8'd255;

//*****************************************************************************
// Declare TB Signals (Bus Model Controls)
//*****************************************************************************
// Testing setup signals
bit                          tb_enqueue_transaction;
bit                          tb_transaction_write;
bit                          tb_transaction_fake;
bit [(ADDR_WIDTH - 1):0]     tb_transaction_addr;
bit [((DATA_WIDTH*8) - 1):0] tb_transaction_data [];
bit [2:0]                    tb_transaction_burst;
bit                          tb_transaction_error;
bit [2:0]                    tb_transaction_size;
// Testing control signal(s)
logic    tb_model_reset;
logic    tb_enable_transactions;
integer  tb_current_addr_transaction_num;
integer  tb_current_addr_beat_num;
logic    tb_current_addr_transaction_error;
integer  tb_current_data_transaction_num;
integer  tb_current_data_beat_num;
logic    tb_current_data_transaction_error;

string                 tb_test_case;
integer                tb_test_case_num;
bit   [DATA_MAX_BIT:0] tb_test_data [];
string                 tb_check_tag;
logic                  tb_mismatch;
logic                  tb_check;
integer                tb_i;

//*****************************************************************************
// General System signals
//*****************************************************************************
logic tb_clk;
logic tb_n_rst;

//*****************************************************************************
// AHB-Lite-Slave side signals
//*****************************************************************************
logic                          tb_hsel;
logic [1:0]                    tb_htrans;
logic [2:0]                    tb_hburst;
logic [(ADDR_WIDTH - 1):0]     tb_haddr;
logic [2:0]                    tb_hsize;
logic                          tb_hwrite;
logic [((DATA_WIDTH*8) - 1):0] tb_hwdata;
logic [((DATA_WIDTH*8) - 1):0] tb_hrdata;
logic                          tb_hresp;
logic                          tb_hready;

//*****************************************************************************
// USB-endpoint side signals
//*****************************************************************************
logic tb_dplus_in;
logic tb_dminus_in;
logic tb_d_mode;
logic tb_dplus_out;
logic tb_dminus_out;

//*****************************************************************************
// Clock Generation Block
//*****************************************************************************
// Clock generation block
always begin
  // Start with clock low to avoid false rising edge events at t=0
  tb_clk = 1'b0;
  // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
  #(CLK_PERIOD/2.0);
  tb_clk = 1'b1;
  // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
  #(CLK_PERIOD/2.0);
end

//*****************************************************************************
// Bus Model Instance
//*****************************************************************************
ahb_lite_bus_cdl 
              #(  .DATA_WIDTH(4),
                  .ADDR_WIDTH(8))
              BFM(.clk(tb_clk),
                  // Testing setup signals
                  .enqueue_transaction(tb_enqueue_transaction),
                  .transaction_write(tb_transaction_write),
                  .transaction_fake(tb_transaction_fake),
                  .transaction_addr(tb_transaction_addr),
                  .transaction_size(tb_transaction_size),
                  .transaction_data(tb_transaction_data),
                  .transaction_burst(tb_transaction_burst),
                  .transaction_error(tb_transaction_error),
                  // Testing controls
                  .model_reset(tb_model_reset),
                  .enable_transactions(tb_enable_transactions),
                  .current_addr_transaction_num(tb_current_addr_transaction_num),
                  .current_addr_beat_num(tb_current_addr_beat_num),
                  .current_addr_transaction_error(tb_current_addr_transaction_error),
                  .current_data_transaction_num(tb_current_data_transaction_num),
                  .current_data_beat_num(tb_current_data_beat_num),
                  .current_data_transaction_error(tb_current_data_transaction_error),
                  // AHB-Lite-Slave Side
                  .hsel(tb_hsel),
                  .haddr(tb_haddr),
                  .hsize(tb_hsize),
                  .htrans(tb_htrans),
                  .hburst(tb_hburst),
                  .hwrite(tb_hwrite),
                  .hwdata(tb_hwdata),
                  .hrdata(tb_hrdata),
                  .hresp(tb_hresp),
                  .hready(tb_hready));

//*****************************************************************************
// Test Module Instance
//*****************************************************************************
usb_ahb_soc DUT ( .clk(tb_clk), 
                  .n_rst(tb_n_rst),
                        // AHB-Lite-Slave Side Bus
                        .hsel(tb_hsel),
                        .haddr(tb_haddr),
                        .hsize(tb_hsize[1:0]),
                        .htrans(tb_htrans),
                        .hburst(tb_hburst),
                        .hwrite(tb_hwrite),
                        .hwdata(tb_hwdata),
                        .hrdata(tb_hrdata),
                        .hresp(tb_hresp),
                        .hready(tb_hready),
                        // USB-side bus signals
                        .dplus_in(tb_dplus_in),
                        .dminus_in(tb_dminus_in),
                        .d_mode(tb_d_mode),
                        .dplus_out(tb_dplus_out),
                        .dminus_out(tb_dminus_out));

//*****************************************************************************
// DUT Related TB Tasks
//*****************************************************************************
// Task for standard DUT reset procedure
task reset_dut;
begin
  // Activate the reset
  tb_n_rst = 1'b0;

  // Maintain the reset for more than one cycle
  @(posedge tb_clk);
  @(posedge tb_clk);

  // Wait until safely away from rising edge of the clock before releasing
  @(negedge tb_clk);
  tb_n_rst = 1'b1;

  // Leave out of reset for a couple cycles before allowing other stimulus
  // Wait for negative clock edges, 
  // since inputs to DUT should normally be applied away from rising clock edges
  @(negedge tb_clk);
  @(negedge tb_clk);
end
endtask

//*****************************************************************************
// Bus Model Usage Related TB Tasks
//*****************************************************************************
// Task to pulse the reset for the bus model
task reset_model;
begin
  tb_model_reset = 1'b1;
  #(0.1);
  tb_model_reset = 1'b0;
end
endtask

// Task to enqueue a new transaction
task enqueue_transaction;
  input bit for_dut;
  input bit write_mode;
  input bit [ADDR_MAX_BIT:0] address;
  input bit [DATA_MAX_BIT:0] data [];
  input bit [2:0] burst_type;
  input bit expected_error;
  input bit [1:0] size;
begin
  // Make sure enqueue flag is low (will need a 0->1 pulse later)
  tb_enqueue_transaction = 1'b0;
  #0.1ns;

  // Setup info about transaction
  tb_transaction_fake  = ~for_dut;
  tb_transaction_write = write_mode;
  tb_transaction_addr  = address;
  tb_transaction_data  = data;
  tb_transaction_error = expected_error;
  tb_transaction_size  = {1'b0,size};
  tb_transaction_burst = burst_type;

  // Pulse the enqueue flag
  tb_enqueue_transaction = 1'b1;
  #0.1ns;
  tb_enqueue_transaction = 1'b0;
end
endtask

// Task to wait for multiple transactions to happen
task execute_transactions;
  input integer num_transactions;
  integer wait_var;
begin
  // Activate the bus model
  tb_enable_transactions = 1'b1;
  @(posedge tb_clk);

  // Process the transactions (all but last one overlap 1 out of 2 cycles
  for(wait_var = 0; wait_var < num_transactions; wait_var++) begin
    @(posedge tb_clk);
  end

  // Run out the last one (currently in data phase)
  @(posedge tb_clk);

  // Turn off the bus model
  @(negedge tb_clk);
  tb_enable_transactions = 1'b0;
end
endtask

//*****************************************************************************
//*****************************************************************************
// Host to Endpoint tasks
//*****************************************************************************
//*****************************************************************************
//PID values
localparam PID_OUT   = 4'b0001;
localparam PID_IN    = 4'b1001;
localparam PID_DATA0 = 4'b0011;
localparam PID_DATA1 = 4'b1011;
localparam PID_ACK   = 4'b0010;
localparam PID_NAK   = 4'b1010;
localparam PID_STALL = 4'b1110;

localparam BIT_PERIOD = CLK_PERIOD * 100.0 / 12;

logic [6:0]  tb_usb_addr     = '0;
logic [3:0]  tb_usb_endpoint = '0;

logic [4:0]  tb_crc_5bit;
logic [15:0] tb_crc_16bit;

logic [7:0]  tb_send_data [];

logic [7:0] tb_byte_out;
logic [7:0] tb_byte_out_rev;
logic [5:0] tb_prev_vals_in;
integer     tb_numbyte;

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
    for (j = 0; j < 8; j = j + 1)
    begin
      test = senddata[i][j] ^ tb_crc_16bit[15];
      tb_crc_16bit = tb_crc_16bit << 1;
      if (test == 1'b1) begin
        tb_crc_16bit = tb_crc_16bit ^ 16'h8005;
      end
    end
  end
  tb_crc_16bit = ~tb_crc_16bit;
  tb_send_data = new [tb_send_data.size() + 2] (tb_send_data);
  tb_send_data[tb_send_data.size() - 2] = tb_crc_16bit[15:8];
  tb_send_data[tb_send_data.size() - 1] = tb_crc_16bit[7:0];
end
endtask

//set data to send for IN or OUT token
task set_senddata_in_out;
begin
  tb_send_data = new [2];
  tb_send_data[0] = {tb_usb_endpoint[0], tb_usb_addr};
  tb_send_data[1] = {tb_crc_5bit[0], tb_crc_5bit[1], tb_crc_5bit[2], tb_crc_5bit[3], tb_crc_5bit[4], tb_usb_endpoint[3:1]};
  //tb_send_data = {{tb_usb_addr, tb_usb_endpoint[3]}, {tb_usb_endpoint[2:0], tb_crc_5bit}};
end
endtask

  // send the EOP
task send_eop;
begin
  tb_dplus_in = 1'b0;
  tb_dminus_in = 1'b0;
  #(BIT_PERIOD);
  #(BIT_PERIOD);
  tb_dplus_in = 1'b1;
  #(BIT_PERIOD);
end
endtask

//send a byte
task send_byte;
  input [7:0] data;
  integer i;
begin
  tb_numbyte = tb_numbyte + 1;
  tb_byte_out_rev = data;
  tb_byte_out = {data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]};
  for (i = 0; i < 8; i = i + 1)
  begin
    if (tb_prev_vals_in == 6'h3f) begin
      tb_dplus_in = tb_dminus_in;
      tb_dminus_in = ~tb_dplus_in;
      tb_prev_vals_in = '0;
      #(BIT_PERIOD);
    end
    if (data[i] == 1'b0) begin
      tb_dplus_in = tb_dminus_in;
      tb_dminus_in = ~tb_dplus_in;
    end
    tb_prev_vals_in = (tb_prev_vals_in << 1) | data[i];
    #(BIT_PERIOD);
  end
end
endtask

//send a byte
task send_bytemsb;
  input [7:0] data;
  integer i;
begin
  tb_numbyte = tb_numbyte + 1;
  //tb_byte_out = data;
  tb_byte_out = data;
  for (i = 7; i > -1; i = i - 1)
  begin
    if (tb_prev_vals_in == 6'h3f) begin
      tb_dplus_in = tb_dminus_in;
      tb_dminus_in = ~tb_dplus_in;
      tb_prev_vals_in = '0;
      #(BIT_PERIOD);
    end
    if (data[i] == 1'b0) begin
      tb_dplus_in = tb_dminus_in;
      tb_dminus_in = ~tb_dplus_in;
    end
    tb_prev_vals_in = (tb_prev_vals_in << 1) | data[i];
    #(BIT_PERIOD);
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
  tb_prev_vals_in = '0;
//   @(posedge tb_clk);
  //send_byte(8'h01);
  send_byte(8'h80);
  //send_byte({pid, ~pid});
  send_byte({~pid[0],~pid[1],~pid[2],~pid[3],pid[0], pid[1], pid[2],pid[3]});
  if (pid == PID_IN || pid == PID_OUT) begin
    for (i = 0; i < senddata.size(); i = i + 1) begin
      send_byte(senddata[i]);
    end
  end else if (pid == PID_DATA0 || pid == PID_DATA1) begin
    for (i = 0; i < senddata.size() - 2; i = i + 1) begin
      send_byte(senddata[i]);
    end 
    send_bytemsb(senddata[senddata.size - 2]);
    send_bytemsb(senddata[senddata.size - 1]);
    //send_byte(tb_crc_16bit[7:0]);
  end
  tb_numbyte = 0;
  tb_prev_vals_in = '0;
  send_eop();
end
endtask

//*****************************************************************************
//*****************************************************************************
// Endpoint to Host tasks
//*****************************************************************************
//*****************************************************************************

logic tb_eop_out_detected = 1'b0;
logic [1:0] tb_dm_out_hist, tb_dp_out_hist;
logic [5:0] tb_prev_vals_out;
logic [7:0] tb_outcoming_byte;
logic [7:0] tb_outcoming_byte_stable;
logic [7:0] tb_data_received [];
integer tb_num_byte_out;

logic [7:0] tb_store_data [];

task receive_byte;
  input logic save;
  integer i;
begin
  tb_outcoming_byte = 8'd0;
  tb_num_byte_out = tb_num_byte_out + 1;
  for (i = 0; i < 8; i = i + 1) begin
    tb_dp_out_hist = (tb_dp_out_hist << 1) | tb_dplus_out;
    tb_dm_out_hist = (tb_dm_out_hist << 1) | tb_dminus_out;

    if ((tb_dp_out_hist[0] == 1'b0) && (tb_dm_out_hist[0] == 1'b0)) begin
      tb_eop_out_detected = 1'b1;
      break;
    end

    if (tb_prev_vals_out == 6'h3f) begin
      i = i - 1;
      tb_prev_vals_out = '0;
    end else if (tb_dp_out_hist[0] != tb_dp_out_hist[1]) begin
      tb_outcoming_byte[i] = 1'b0;
      tb_prev_vals_out = (tb_prev_vals_out << 1) | 1'b0;
    end else begin
      tb_outcoming_byte[i] = 1'b1;
      tb_prev_vals_out = (tb_prev_vals_out << 1) | 1'b1;
    end
    #(BIT_PERIOD);
  end
  if (save == 1'b1 && tb_eop_out_detected != 1'b1) begin
    tb_data_received = new [tb_data_received.size() + 1] (tb_data_received);
    //$info("tb_data_received size is %d", tb_data_received.size());
    //$info("tb_outcoming_byte is %d", tb_outcoming_byte);
    tb_data_received[tb_data_received.size() - 1] = tb_outcoming_byte;
  end
  tb_outcoming_byte_stable = tb_outcoming_byte;
end
endtask

task receive_packet;
  input logic [3:0] pid;
begin
  tb_eop_out_detected = 1'b0;
  tb_data_received = new [0];
  tb_dp_out_hist = 2'b00 | tb_dplus_out;
  tb_dm_out_hist = 2'b00 | tb_dminus_out;
  tb_prev_vals_out = '0;
  tb_num_byte_out = 0;

  if (tb_d_mode != 1'b1) begin
    @(posedge tb_d_mode);
  end 
  @(tb_dplus_out);
  #(BIT_PERIOD / 2);

  receive_byte(1'b0);
  if (tb_outcoming_byte != 8'h80) begin
    $error("sync byte not detected");
  end

  receive_byte(1'b0);
  if (tb_outcoming_byte != {~pid[0], ~pid[1],~pid[2], ~pid[3],pid[0],pid[1],pid[2],pid[3]}) begin
    $error("expected pid not detected");
  end

  while (tb_eop_out_detected != 1'b1) begin
    receive_byte(1'b1);
  end

  if (pid != PID_DATA0 && tb_data_received.size() != 0) begin
    $error("eop was not asserted correctly");
  end 
  
  #(BIT_PERIOD * 2); //for rest of eop
end
endtask

task check_received;
  input logic [7:0] data [];
  integer i;
  logic pass;
begin
  pass = 1'b1;
  if (tb_data_received.size() != data.size()) begin
    $error("expected and recieved aren't of the same size dr: %d; d: %d", tb_data_received.size(), data.size());
    pass = 1'b0;
  end

  if (pass == 1'b1) begin 
    for (i = 0; i < tb_data_received.size(); i = i + 1) begin
      if (tb_data_received[i] != data[i]) begin
        $error("byte incorrect in received %d", i);
        pass = 1'b0; 
        break;
      end
    end
  end
  
  if (pass == 1'b1) begin
    $info("data received check passed for %s", tb_test_case);
  end
end
endtask

//*****************************************************************************
//*****************************************************************************
// Conversions
//*****************************************************************************
//*****************************************************************************

task convert64byte_16trans; //converts 8bit 64 byte array to 32bit 16 byte array
  input logic [7:0] data [];
  integer i;
begin
  //assumes that data is 64 bytes long
  tb_test_data = new [16];
  for (i = 0; i < 16; i = i + 1) begin
    tb_test_data[i] = {data[i*4 + 3], data[i*4 + 2], data[i*4 + 1], data[i*4]};
    //$info("%h", {data[i*4 + 3], data[i*4 + 2], data[i*4 + 1], data[i*4]});
  end 
end
endtask

task convert16trans_64byte;
  input bit [31:0] data [];
  integer i;
begin
  tb_send_data = new [64];
  for (i = 0; i < 16; i = i + 1) begin
    tb_send_data[i*4] = data[i][7:0];
    tb_send_data[i*4 + 1] = data[i][15:8];
    tb_send_data[i*4 + 2] = data[i][23:16];
    tb_send_data[i*4 + 3] = data[i][31:24];
  end
end
endtask

//*****************************************************************************
//*****************************************************************************
// Main TB Process
//*****************************************************************************
//*****************************************************************************
logic [31:0] tb_see_test_data;
integer i;
initial begin
  // Initialize Test Case Navigation Signals
  tb_test_case       = "Initialization";
  tb_test_case_num   = -1;
  tb_test_data       = new[1];
  tb_check_tag       = "N/A";
  tb_check           = 1'b0;
  tb_mismatch        = 1'b0;
  // Initialize all of the directly controled DUT inputs
  tb_n_rst          = 1'b1;
  // Initialize all of the bus model control inputs
  tb_model_reset          = 1'b0;
  tb_enable_transactions  = 1'b0;
  tb_enqueue_transaction  = 1'b0;
  tb_transaction_write    = 1'b0;
  tb_transaction_fake     = 1'b0;
  tb_transaction_addr     = '0;
  tb_transaction_data     = new[1];
  tb_transaction_error    = 1'b0;
  tb_transaction_size     = 3'd0;
  tb_transaction_burst    = 3'd0;

  //initialize my stuff
  tb_dplus_in = 1'b1;
  tb_dminus_in = 1'b0;

  // Wait some time before starting first test case
  #(0.1);

  // Clear the bus model
  reset_model();

  //*****************************************************************************
  // Power-on-Reset Test Case
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Power-on-Reset";
  tb_test_case_num = tb_test_case_num + 1;
  
  // Reset the DUT
  reset_dut();
  
  //*****************************************************************************
  // Test Case 1: endpoint to host transfer
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Endpoint to Host Transfer";
  tb_test_case_num = tb_test_case_num + 1;

  // Enqueue the needed transactions
  tb_test_data = new [1];
  tb_test_data[0] = {24'd0, 8'd64};
  enqueue_transaction(1'b1, 1'b1, 8'h48, tb_test_data, BURST_SINGLE, 1'b0, 2'd0); 

  random_senddata(64);
  tb_send_data[0] = 8'hff;
  tb_send_data[1] = 8'h00;
  convert64byte_16trans(tb_send_data); 
  enqueue_transaction(1'b1, 1'b1, 8'd0, tb_test_data, BURST_INCR16, 1'b0, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(17);

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_IN, tb_send_data);
  
  receive_packet(PID_DATA0);

  convert16trans_64byte(tb_test_data);
  calc_crc16(tb_send_data);
  check_received(tb_send_data);

  send_packet(PID_ACK, tb_send_data);
  
  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Test Case 2: Host to Endpoint transfer
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Host to Endpoint Transfer";
  tb_test_case_num = tb_test_case_num + 1;

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_OUT, tb_send_data);

  send_packet(PID_DATA0, tb_data_received);

  tb_store_data = tb_data_received;
  receive_packet(PID_ACK);

  convert64byte_16trans(tb_store_data);
  enqueue_transaction(1'b1, 1'b0, 8'h40, '{32'd01}, BURST_SINGLE, 1'b0, 2'd2);
  enqueue_transaction(1'b1, 1'b0, 8'd0, tb_test_data, BURST_INCR16, 1'b0, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(17);

  #(CLK_PERIOD * 10);

  //*****************************************************************************
  // Test Case 3: Host to Endpoint transfer error
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Host to Endpoint Transfer error";
  tb_test_case_num = tb_test_case_num + 1;

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_OUT, tb_send_data);

  tb_store_data[1] = 8'h05;
  send_packet(PID_DATA0, tb_store_data);

  receive_packet(PID_NAK);

  convert64byte_16trans(tb_store_data);
  enqueue_transaction(1'b1, 1'b0, 8'h40, '{32'h10000}, BURST_SINGLE, 1'b0, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(1);

  #(CLK_PERIOD * 20);
  
  //*****************************************************************************
  // Test Case 4: endpoint to host transfer no data
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Endpoint to Host Transfer: No Data";
  tb_test_case_num = tb_test_case_num + 1;


  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_IN, tb_send_data);
  
  receive_packet(PID_NAK);
  
  #(CLK_PERIOD * 20);


  //*****************************************************************************
  // Test Case 5: endpoint to host transfer reserved
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Endpoint to Host Transfer: reserved";
  tb_test_case_num = tb_test_case_num + 1;

  enqueue_transaction(1'b1, 1'b1, 8'h48, tb_test_data, BURST_SINGLE, 1'b0, 2'd0); 
  execute_transactions(1);

  calc_crc5(tb_usb_addr, tb_usb_endpoint); //sets tb_crc_5bit variable
  set_senddata_in_out();                   //sets tb_send_data to right values
  send_packet(PID_OUT, tb_send_data);

  tb_store_data[1] = 8'h00;
  send_packet(PID_DATA0, tb_store_data);
  
  receive_packet(PID_NAK);
  
  #(CLK_PERIOD * 10);


end

endmodule

