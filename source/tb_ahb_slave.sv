// $Id: $
// File name:   tb_ahb_lite_slave_cdl.sv
// Created:     10/1/2018
// Author:      Tim Pritchett
// Lab Section: 9999
// Version:     1.0  Initial Design Entry
// Description: Full ABH-Lite slave/bus model test bench

`timescale 1ns / 10ps

module tb_ahb_slave();

// Timing related constants
localparam CLK_PERIOD = 10;
localparam BUS_DELAY  = 800ps; // Based on FF propagation delay

// Sizing related constants
localparam DATA_WIDTH      = 4;
localparam ADDR_WIDTH      = 7;
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

// Expected Values
logic [((DATA_WIDTH*8) - 1):0] tb_expected_hrdata;
logic                          tb_expected_hresp;
logic                          tb_expected_hready;

//*****************************************************************************
// AHB-Lite-Slave side signals
//*****************************************************************************
logic tb_rx_data_ready;
logic tb_rx_transfer_active;
logic tb_rx_error;
logic tb_tx_transfer_active;
logic tb_tx_error;
logic [6:0] tb_buffer_occupancy;
logic [31:0] tb_rx_data;
	
logic tb_buffer_reserved;
logic [6:0] tb_tx_packet_data_size;
logic tb_get_rx_data;
logic tb_store_tx_data;
logic [31:0] tb_tx_data;
logic [1:0] tb_data_size;

//Expected Values for the DUT Outputs
logic tb_expected_buffer_reserved;
logic [6:0] tb_expected_tx_packet_data_size;
logic tb_expected_get_rx_data;
logic tb_expected_store_tx_data;
logic [31:0] tb_expected_tx_data;
logic [1:0] tb_expected_data_size;

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
                  .ADDR_WIDTH(7))
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
ahb_slave DUT ( .clk(tb_clk), .n_rst(tb_n_rst),
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

                        // Operation Signals

                        .rx_data_ready(tb_rx_data_ready),
		        .rx_transfer_active(tb_rx_transfer_active),
		        .rx_error(tb_rx_error),
		        .tx_transfer_active(tb_tx_transfer_active),
		        .tx_error(tb_tx_error),
		        .buffer_occupancy(tb_buffer_occupancy),
		        .rx_data(tb_rx_data),
		        .buffer_reserved(tb_buffer_reserved),
		        .tx_packet_data_size(tb_tx_packet_data_size),
		        .get_rx_data(tb_get_rx_data),
		        .store_tx_data(tb_store_tx_data),
		        .tx_data(tb_tx_data),
		        .data_size(tb_data_size)
                 );


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
// Bus Model Usage Related TB Tasks920
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
  input bit for_dut;                                   // Is the transaction for the DUT ?
  input bit write_mode;                                // WRITE MODE = 1, READ MODE = 0
  input bit [ADDR_MAX_BIT:0] address;                  // Define address
  input bit [DATA_MAX_BIT:0] data [];                  // Define array of data
  input bit [2:0] burst_type;                          // Define burst type
  input bit expected_error;                            // Define expected error
  input bit [1:0] size;                                // Define Size
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
  input integer num_transactions;                         // The input integer lists how many transactions you are going to queue
  integer wait_var;
begin
  // Activate the bus model
  tb_enable_transactions = 1'b1;
  @(posedge tb_clk);

  // Process the transactions (all but last one overlap 1 out of 2 cycles
  for(wait_var = 0; wait_var < num_transactions; wait_var++) begin
    @(posedge tb_clk);                                         // @posedge tb_clk -> Runs the design for #(transactions)
  end

  // Run out the last one (currently in data phase)
  @(posedge tb_clk);

  // Turn off the bus model
  @(negedge tb_clk);
  tb_enable_transactions = 1'b0;
end
endtask

//*****************************************************************************
// Task: Check Outputs 
//**************************************************************************8
// Task to cleanly and consistently check DUT output values
task check_outputs;
  input string check_tag;
begin
  tb_mismatch = 1'b0;
  tb_check    = 1'b1;
  if(tb_expected_buffer_reserved == tb_buffer_reserved) begin // Check passed
    $info("Correct buffer reserved output %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect buffer reserved output %s during %s test case", check_tag, tb_test_case);
  end

  if(tb_expected_tx_packet_data_size == tb_tx_packet_data_size) begin // Check passed
    $info("Correct tx_packet_data_size %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect tx_packet_data_size %s during %s test case", check_tag, tb_test_case);
  end

  if(tb_store_tx_data == tb_expected_store_tx_data) begin // Check passed
    $info("Correct store_tx_data output %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect store_tx_data output %s during %s test case", check_tag, tb_test_case);
  end

  if(tb_expected_get_rx_data == tb_get_rx_data) begin // Check passed
    $info("Correct rx_data output %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect rx_data output %s during %s test case", check_tag, tb_test_case);
  end

 if(tb_tx_data == tb_expected_tx_data) begin // Check passed
    $info("Correct tx_data output %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect tx_data output %s during %s test case", check_tag, tb_test_case);
  end

  if(tb_expected_data_size == tb_data_size) begin // Check passed
    $info("Correct data size %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect data size %s during %s test case", check_tag, tb_test_case);
  end

  // Wait some small amount of time so check pulse timing is visible on waves
  #(0.1);
  tb_check =1'b0;
end
endtask

task configure_reset_outputs;
begin

// AHB SLave Side Signals
tb_expected_hready = '0;
tb_expected_hresp = '0;
tb_expected_hrdata = '0;

// Other interfacing signals
tb_expected_buffer_reserved = '0;
tb_expected_tx_packet_data_size ='0;
tb_expected_get_rx_data ='0;
tb_expected_store_tx_data ='0;
tb_expected_tx_data ='0;
tb_expected_data_size ='0;

end
endtask

task configure_reset_inputs;
begin

tb_rx_data_ready = '0;
tb_rx_transfer_active = '0;
tb_rx_error = '0;
tb_tx_transfer_active = '0;
tb_tx_error = '0;
tb_buffer_occupancy = '0;
tb_rx_data = '0;

end
endtask

//*****************************************************************************
// Main TB Process
//*****************************************************************************

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
  tb_i = '0;
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
   configure_reset_inputs();
   // Compare values to reset values, set by the task reset_outputs()
   configure_reset_outputs();

   check_outputs("after DUT reset");
   #(CLK_PERIOD * 3);
  
/*
  input bit for_dut;                                   // Is the transaction for the DUT ?
  input bit write_mode;                                // WRITE MODE = 1, READ MODE = 0
  input bit [ADDR_MAX_BIT:0] address;                  // Define address
  input bit [DATA_MAX_BIT:0] data [];                  // Define array of data
  input bit [2:0] burst_type;                          // Define burst type
  input bit expected_error;                            // Define expected error
  input bit [1:0] size;                                // Define Size
*/
  //*****************************************************************************
  // Test Case: Single Value Write
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Single Value, 1 byte write";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  tb_test_data = '{4'd10};

  //Enqueue a Write: Write to this Slave (transaction is not fake), write mode (1'd1)
  // to DEC address 64, with the value as 32'd1000, SINGLE BURST (3'd0) as HBURST Code
  // with no expected error, and the value of HSIZE as 2.

  enqueue_transaction(1'b1, 1'b1, 7'h0, tb_test_data, BURST_SINGLE, 1'b0, 2'd0);   
  
  // Run the transactions via the model
  execute_transactions(1);
  check_outputs("after 1 byte write to address 0");
  #(CLK_PERIOD * 3);
  
  //*****************************************************************************
  // Test Case: Single Value Write
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Single Value, 2 byte write";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  tb_test_data = '{16'd100};

  //Enqueue a Write: Write to this Slave (transaction is not fake), write mode (1'd1)
  // to DEC address 64, with the value as 32'd1000, SINGLE BURST (3'd0) as HBURST Code
  // with no expected error, and the value of HSIZE as 2.

  enqueue_transaction(1'b1, 1'b1, 7'h0, tb_test_data, BURST_SINGLE, 1'b0, 2'd1);   
  
  // Run the transactions via the model
  execute_transactions(1);
  check_outputs("after 2 byte write to address 0");
  #(CLK_PERIOD * 3);

//*****************************************************************************
  // Test Case: Single Value Write
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Single Value, 3 byte write";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  tb_test_data = '{24'd250};

  //Enqueue a Write: Write to this Slave (transaction is not fake), write mode (1'd1)
  // to DEC address 64, with the value as 32'd1000, SINGLE BURST (3'd0) as HBURST Code
  // with no expected error, and the value of HSIZE as 2.

  enqueue_transaction(1'b1, 1'b1, 7'h0, tb_test_data, BURST_SINGLE, 1'b0, 2'd2);   
  
  // Run the transactions via the model
  execute_transactions(1);
  check_outputs("after 3 byte write to address 0");
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Single Value Write
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Single Value Write";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  tb_test_data = '{32'd1000};

  //Enqueue a Write: Write to this Slave (transaction is not fake), write mode (1'd1)
  // to DEC address 64, with the value as 32'd1000, SINGLE BURST (3'd0) as HBURST Code
  // with no expected error, and the value of HSIZE as 2.

  enqueue_transaction(1'b1, 1'b1, 7'h3f, tb_test_data, BURST_SINGLE, 1'b0, 2'd3);   
  
  // Run the transactions via the model
  execute_transactions(1);

  check_outputs("after 4 byte write to address 0");
  #(CLK_PERIOD * 3);


  //*****************************************************************************
  // Test Case: INCR4 Burst
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "INCR4 Bursts";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_test_data = new[4];
  for(tb_i = 0; tb_i < 4; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b1, 7'h3f, tb_test_data, BURST_INCR4, 1'b0, 2'd2);  // 4 WRITES
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 7'h3f, tb_test_data, BURST_INCR4, 1'b0, 2'd2);  // 4 READS
  
  // Run the transactions via the model
  execute_transactions(8);
  tb_expected_data_size = 2'd3;

  check_outputs("after back to back read/write INCR4 bursts");
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: INCR8 Burst
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "INCR8 Bursts";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_test_data = new[8];
  for(tb_i = 0; tb_i < 8; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b1, 7'h3f, tb_test_data, BURST_INCR8, 1'b0, 2'd2);
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 7'h3f, tb_test_data, BURST_INCR8, 1'b0, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(16);
   check_outputs("after attempting to do a INCR8 burst for the data buffer");

  //*****************************************************************************
  // Test Case: INCR16 Burst
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "INCR16 Bursts";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_test_data = new[16];
  for(tb_i = 0; tb_i < 16; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b1, 7'h3f, tb_test_data, BURST_INCR16, 1'b0, 2'd3);
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 7'h3f, tb_test_data, BURST_INCR16, 1'b0, 2'd3);
  configure_reset_outputs();
  
  tb_expected_data_size = 2'd3;

  // Run the transactions via the model
  execute_transactions(32);
  check_outputs("after attempting to do a INCR16 burst for the data buffer");

  //*****************************************************************************
  // Test Case: WRAP4 Burst
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "WRAP4 Bursts";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_test_data = new[4];
  for(tb_i = 0; tb_i < 4; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b1, 7'h3f, tb_test_data, BURST_WRAP4, 1'b0, 2'd2);
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 7'h3f, tb_test_data, BURST_WRAP4, 1'b0, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(8);
  check_outputs("after attempting to execute a WRAP4 write burst for the data buffer");

  //*****************************************************************************
  // Test Case: WRAP8 Burst
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "WRAP8 Bursts";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_test_data = new[8];
  for(tb_i = 0; tb_i < 8; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b1, 7'h3f, tb_test_data, BURST_WRAP8, 1'b0, 2'd2);
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 7'h3f, tb_test_data, BURST_WRAP8, 1'b0, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(16);
  check_outputs("after attempting to execute a WRAP8 write/read burst for the data buffer");
  
  //*****************************************************************************
  // Test Case: WRAP16 Burst
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "WRAP16 Bursts";
  tb_test_case_num = tb_test_case_num + 1;
  
  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_test_data = new[16];
  for(tb_i = 0; tb_i < 16; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b1, 7'h3f, tb_test_data, BURST_WRAP16, 1'b0, 2'd2);
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 7'h3f, tb_test_data, BURST_WRAP16, 1'b0, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(32);
  check_outputs("after attempting to execute a WRAP16 write/read burst for the data buffer");
  
  //*****************************************************************************
  // Test Case: Write to unallocated address 0x46
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Write to unallocated address 0x46";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  tb_test_data = '{32'd1000}; 
  enqueue_transaction(1'b1, 1'b1, 7'h46, tb_test_data, BURST_SINGLE, 1'b1, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(1);
  check_outputs("after attempting to write to unallocated address 0x46");

  //*****************************************************************************
  // Test Case: Write to Read-Only address 0x42
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Write to READ-ONLY address 0x42";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  tb_test_data = '{32'd1000}; 
  enqueue_transaction(1'b1, 1'b1, 7'h42, tb_test_data, BURST_SINGLE, 1'b1, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(1);
  check_outputs("after attempting to write to a READ-ONLY address, 0x42");
  //*****************************************************************************
  // Test Case: Invalid Singleton Read of Invalid Address
  //*****************************************************************************
  // Update Navigation Info

  tb_test_case     = "Attempting to Read from an Invalid Address";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  tb_test_data = '{32'd1000}; 
  enqueue_transaction(1'b1, 1'b0, 7'h78, tb_test_data, BURST_SINGLE, 1'b1, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(1);
  check_outputs("after attempting to read from an unallocated address, 0x78");

  //*****************************************************************************
  // Test Case: Erroneous INCR4 Write Burst
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Erroneous INCR4 Write Burst";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_test_data = new[4];
  for(tb_i = 0; tb_i < 4; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b1, 7'h78, tb_test_data, BURST_INCR4, 1'b1, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(8);
  check_outputs("after attempting to do a write burst to an unallocated address");

  //*****************************************************************************
  // Test Case: Erroneous INCR4 Read Burst
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Erroneous INCR4 Read Burst";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_test_data = new[4];
  for(tb_i = 0; tb_i < 4; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b0, 7'h7f, tb_test_data, BURST_INCR4, 1'b1, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(8);
  check_outputs("after attempting to do a read burst of an unallocated address");

/*
  input bit for_dut;                                   // Is the transaction for the DUT ?
  input bit write_mode;                                // WRITE MODE = 1, READ MODE = 0
  input bit [ADDR_MAX_BIT:0] address;                  // Define address
  input bit [DATA_MAX_BIT:0] data [];                  // Define array of data
  input bit [2:0] burst_type;                          // Define burst type
  input bit expected_error;                            // Define expected error
  input bit [1:0] size;                                // Define Size
*/

  //*****************************************************************************
  // Test Case: Endpoint To Host Transfer Size Register Check
  //*****************************************************************************
  tb_test_case     = "Endpoint to Host Transfer Size Register";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();
  configure_reset_inputs();
  
  //Setting the transfer size to 7 bytes
  tb_test_data = '{4'd4};

  // Enqueue a write to register 0x48 so that the Endpoint to Host Transfer Size
  // is updated to 7 [bytes]

  enqueue_transaction(1'b1, 1'b1, 7'h48, tb_test_data, BURST_SINGLE, 1'b0, 2'd0);
  
  // Run the transactions via the model
  execute_transactions(1);
 
  //Populate the Data Buffer
  tb_test_data = new[4];
  for(tb_i = 0; tb_i < 4; tb_i++)begin
    tb_test_data[tb_i] = {16'hABCD,tb_i[15:0]};
  end
  // Enqueue the write
  enqueue_transaction(1'b1, 1'b1, 7'h3f, tb_test_data, BURST_INCR4, 1'b0, 2'd2);  // 4 WRITES
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 7'h3f, tb_test_data, BURST_INCR4, 1'b0, 2'd2);  // 4 READS
  
  // Run the transactions via the model
  execute_transactions(8);
  // Initialize all expected values to 0
  configure_reset_outputs();
 
  // At this point, buffer reserved must be asserted..
  tb_expected_buffer_reserved = 1'b0;
  tb_expected_tx_packet_data_size = 7'd7;
  check_outputs("after initiating the Endpoint to Host Transfer Sequence");

  // To simulate the termination of the the transfer sequence, deassert tx_transfer_active
  
  tb_tx_transfer_active = 1'b1;
  @(posedge tb_clk);
  @(posedge tb_clk);

  tb_tx_transfer_active = 1'b0;
  @(posedge tb_clk);
  
  // At this point, the Endpoint to Host Transfer Size register must be cleared, and
  // buffer reserved must be deasserted 1410
  
  tb_test_data = '{4'd0};
  
  // Enqueue a read to register 0x48 [Endpoint to Host Transfer Size Register]
  // and ensure it is cleared

  enqueue_transaction(1'b1, 1'b0, 7'h48, tb_test_data, BURST_SINGLE, 1'b0, 2'd0);

  // The buffer reserved should be deasserted at this point..
 
  tb_expected_buffer_reserved = 1'b0;

  // Check for buffer reserved and get_rx_data
  check_outputs("after termination of Endpoint to Host Transfer Sequence");
end

endmodule
