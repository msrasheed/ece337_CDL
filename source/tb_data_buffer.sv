//tb_data_buffer.sv

`timescale 1ns / 10ps

module tb_data_buffer();

  localparam CLK_PERIOD = 10;

  //DUT signals
  reg tb_clk;
  reg tb_n_rst;
  reg tb_clear;
  reg tb_store_rx_packet_data;
  reg [7:0] tb_rx_packet_data;
  reg tb_get_rx_data;
  reg [1:0] tb_data_size;
  reg [31:0] tb_tx_data;
  reg tb_store_tx_data;
  reg tb_get_tx_packet_data;
  reg tb_buffer_reserved;

  reg [6:0] tb_buffer_occupancy;
  reg [31:0] tb_rx_data;
  reg [7:0] tb_tx_packet_data;

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

  data_buffer DUT (.clk(tb_clk),
                   .n_rst(tb_n_rst),
                   .clear(tb_clear),
                   .store_rx_packet_data(tb_store_rx_packet_data),
                   .rx_packet_data(tb_rx_packet_data),
                   .get_rx_data(tb_get_rx_data),
                   .data_size(tb_data_size),
                   .tx_data(tb_tx_data),
                   .store_tx_data(tb_store_tx_data),
                   .get_tx_packet_data(tb_get_tx_packet_data),
                   .buffer_reserved(tb_buffer_reserved),
                   .buffer_occupancy(tb_buffer_occupancy),
                   .rx_data(tb_rx_data),
                   .tx_packet_data(tb_tx_packet_data));

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
   endtask // reset_dut

   //TODO add task for sending a byte from RX
   //TODO add task for getting RX data
   //TODO add task for storing TX data
   //TODO add task for sending TX data packet
