//tb_protocol_controller.sv

`timescale 1ns / 10ps

module tb_protocol_controller();

  localparam CLK_PERIOD = 10;

  // Initializations for the PID from the RX
	localparam RX_IDLE = 3'b000;
	localparam RX_IN   = 3'b001;
	localparam RX_OUT  = 3'b010;
	localparam RX_DATA = 3'b011;
	localparam RX_GOOD = 3'b100;
	localparam RX_BAD  = 3'b101;
	localparam RX_ACK  = 3'b110;
	localparam RX_NCK  = 3'b111;

	// Initializations for the PID to the TX
	localparam TX_IDLE = 2'b00;
	localparam TX_DATA = 2'b01;
	localparam TX_ACK = 2'b10;
	localparam TX_NCK = 2'b11;

  //DUT signals
  reg tb_clk;
  reg tb_n_rst;
  reg [2:0] tb_rx_packet;
  reg tb_tx_done;
  reg tb_buffer_reserved;
  reg [6:0] tb_tx_packet_data_size;
  reg [6:0] tb_buffer_occupancy;

  reg tb_rx_data_ready;
  reg tb_rx_transfer_active;
  reg tb_rx_error;
  reg tb_tx_transfer_active;
  reg tb_tx_error;
  reg tb_clear;
  reg [1:0] tb_tx_packet;
  reg tb_d_mode;



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

  protocol_controller DUT (.clk(tb_clk),
                           .n_rst(tb_n_rst),
                           .rx_packet(tb_rx_packet),
                           .tx_done(tb_tx_done).
                           .buffer_reserved(tb_buffer_reserved),
                           .tx_packet_data_size(tb_tx_packet_data_size),
                           .buffer_occupancy(tb_buffer_occupancy),
                           .rx_data_ready(tb_rx_data_ready),
                           .rx_transfer_active(tb_rx_transfer_active),
                           .rx_error(tb_rx_error),
                           .tx_transfer_active(tb_tx_transfer_active),
                           .tx_error(tb_tx_error),
                           .clear(tb_clear),
                           .tx_packet(tb_tx_packet),
                           .d_mode(tb_d_mode));

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

  task check_outputs;
    input logic expected_rx_data_ready;
    input logic expected_rx_transfer_active;
    input logic expected_rx_error;
    input logic expected_tx_transfer_active;
    input logic expected_tx_error;
    input logic expected_clear;
    input logic expected_tx_packet;
    input logic expected_d_mode;
    input string test_case;
    begin

      assert(expected_rx_data_ready == tb_rx_data_ready)
        $info("Correct rx_data_ready for %s test case", test_case);
      else
        $error("Incorrect rx_data_ready for %s test case", test_case);
      end

      assert(expected_rx_transfer_active == tb_rx_transfer_active)
        $info("Correct rx_transfer_active for %s test case", test_case);
      else
        $error("Incorrect rx_transfer_active for %s test case", test_case);
      end

      assert(expected_rx_error == tb_rx_error)
        $info("Correct rx_error for %s test case", test_case);
      else
        $error("Incorrect rx_error for %s test case", test_case);
      end

      assert(expected_tx_transfer_active == tb_tx_transfer_active)
        $info("Correct tx_transfer_active for %s test case", test_case);
      else
        $error("Incorrect tx_transfer_active for %s test case", test_case);
      end

      assert(expected_tx_error == tb_tx_error)
        $info("Correct tx_error for %s test case", test_case);
      else
        $error("Incorrect tx_error for %s test case", test_case);
      end

      assert(expected_clear == tb_clear)
        $info("Correct clear for %s test case", test_case);
      else
        $error("Incorrect clear for %s test case", test_case);
      end

      assert(expected_tx_packet == tb_tx_packet)
        $info("Correct tx_packet for %s test case", test_case);
      else
        $error("Incorrect tx_packet for %s test case", test_case);
      end

      assert(expected_d_mode == d_mode)
        $info("Correct d_mode for %s test case", test_case);
      else
        $error("Incorrect d_mode for %s test case", test_case);
      end
    end
  endtask

  //initialize expected signal Values
  reg expected_rx_data_ready;
  reg expected_rx_transfer_active;
  reg expected_rx_error;
  reg expected_tx_transfer_active;
  reg expected_tx_error;
  reg expected_clear;
  reg [1:0] expected_tx_packet;
  reg expected_d_mode;

  initial begin
    //set inputs to idle values
    tb_n_rst = 1'b1;
    tb_rx_packet = RX_IDLE;
    tb_tx_done = 1'b0;
    tb_buffer_reserved = 1'b0;
    tb_tx_packet_data_size = 7'd0;
    tb_buffer_occupancy = 7'd0;

    //Test cases

    //
    //Reset DUT then follow RX States for out token
    //
    //initialize expected values for check output function
    expected_rx_data_ready = 1'b0;
    expected_rx_transfer_active = 1'b0;
    expected_rx_error = 1'b0;
    expected_tx_transfer_active = 1'b0;
    expected_tx_error = 1'b0;
    expected_clear = 1'b0;
    expected_tx_packet = TX_IDLE;
    expected_d_mode = 1'b0;

    reset_dut();
    #0.1;
    tb_rx_packet = RX_OUT;
    //TODO check updated state diagram and follow state each possible path







endmodule
