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

  string tb_test_state;



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
                           .tx_done(tb_tx_done),
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
      
      assert(expected_rx_transfer_active == tb_rx_transfer_active)
        $info("Correct rx_transfer_active for %s test case", test_case);
      else
        $error("Incorrect rx_transfer_active for %s test case", test_case);
      
      assert(expected_rx_error == tb_rx_error)
        $info("Correct rx_error for %s test case", test_case);
      else 
        $error("Incorrect rx_error for %s test case", test_case);

      assert(expected_tx_transfer_active == tb_tx_transfer_active)
        $info("Correct tx_transfer_active for %s test case", test_case);
      else
        $error("Incorrect tx_transfer_active for %s test case", test_case);

      assert(expected_tx_error == tb_tx_error)
        $info("Correct tx_error for %s test case", test_case);
      else
        $error("Incorrect tx_error for %s test case", test_case);

      assert(expected_clear == tb_clear)
        $info("Correct clear for %s test case", test_case);
      else
        $error("Incorrect clear for %s test case", test_case);

      assert(expected_tx_packet == tb_tx_packet)
        $info("Correct tx_packet for %s test case", test_case);
      else
        $error("Incorrect tx_packet for %s test case", test_case);

      assert(expected_d_mode == tb_d_mode)
        $info("Correct d_mode for %s test case", test_case);
      else
        $error("Incorrect d_mode for %s test case", test_case);
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
    //initialize expected values for  //I added these for readability
     expected_rx_data_ready = 1'b0;
     expected_rx_transfer_active = 1'b0;
    expected_rx_error = 1'b0;
    expected_tx_transfer_active = 1'b0;
    expected_tx_error = 1'b0;
    expected_clear = 1'b0;
    expected_tx_packet = TX_IDLE;
    expected_d_mode = 1'b0;

    //
    //Follow main RX packet States
    //
    tb_rx_packet = RX_IDLE;
     tb_test_state = "after reset";
     
    reset_dut();
    #0.1;
    check_outputs(expected_rx_data_ready, //check outputs after reset
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
		  tb_test_state);
   //  @(posedge tb_clk);
     
    //advance to RX_Active state
    tb_rx_packet = RX_OUT;
     expected_rx_transfer_active = 1'b1;
    tb_test_state = "RX_Active";
    @(posedge tb_clk); //let state machine shift
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to HE_Data state
    tb_rx_packet = RX_DATA;
    tb_test_state = "HE_Data";
     @(posedge tb_clk);
     #0.1;
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to HE_Good state
    expected_rx_transfer_active = 1'b0;
    expected_rx_data_ready = 1'b1;
    expected_d_mode = 1'b1;
    expected_tx_transfer_active = 1'b1;
    tb_rx_packet = RX_IDLE;
    tb_test_state = "HE_Good";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to Send_ACK state
    expected_rx_data_ready = 1'b0;
    expected_tx_packet = TX_ACK;
    tb_test_state = "Send_ACK";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to HE_PACKET_DONE_WAIT state
    expected_tx_packet = TX_IDLE;
    tb_test_state = "HE_Packet_Done_Wait";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //check that HE_Packet_Done_Wait state is held until TX_Done
    tb_test_state = "Hold in HE_Packet_Done_Wait";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advacne to DATA_BUFFER_WAIT
    expected_tx_transfer_active = 1'b0;
    tb_buffer_occupancy = 7'd1; //set this to make sure state is held until buffer occupancy reaches 0
    tb_tx_done = 1'b1;
    tb_test_state = "Data_Buffer_Wait";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //check that state doesnt advance until buffer occupancy is 0
    tb_test_state = "Hold in Data_Buffer_Wait";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //TODO add path for error states
    //advance to IDLE
    tb_buffer_occupancy = 7'd0;
    tb_test_state = "IDLE";
    @(posedge tb_clk);
    //need to check states on wave forms since same outputs expected for Data_buffer_wait and IDLE
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //END RX_OUT standard operation test cases

    //
    //Tests for standard operation EH States
    //
    expected_rx_transfer_active = 1'b0; //reset expected values
    expected_rx_error = 1'b0;
    expected_tx_transfer_active = 1'b0;
    expected_tx_error = 1'b0;
    expected_clear = 1'b0;
    expected_tx_packet = TX_IDLE;
    expected_d_mode = 1'b0;

    reset_dut();
    #0.1;
    //advance to AHB_STORE
    tb_buffer_reserved = 1'b1;
    tb_test_state = "AHB_STORE";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //check that AHB_Store is held properly
    tb_tx_packet_data_size = 7'd5;
    tb_buffer_occupancy = 7'd4;
    tb_test_state = "hold in AHB_STORE";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to TX_active
    tb_tx_packet_data_size = 7'd5;
    tb_buffer_occupancy = 7'd5;
    tb_rx_packet = RX_IN;
    expected_tx_transfer_active = 1'b1;
    expected_tx_packet = TX_DATA;
    expected_d_mode = 1'b1;
    tb_test_state = "TX_active";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to EH_Data
    tb_rx_packet = RX_IDLE;
    expected_tx_packet = TX_IDLE; //is this correct?
    tb_test_state = "EH_Data";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //check that EH_Data is held until buffer is Empty
    tb_test_state = "Hold in EH_Data";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to EH_Packet_Done_Wait
    tb_buffer_occupancy = 7'd0;
    tb_tx_done = 1'b0;
    tb_test_state = "EH_Packet_Done_Wait";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //check that EH_Packet_Done_Wait state is held
    tb_test_state = "Hold in EH_Packet_Done_Wait";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to EH_Done
    expected_tx_transfer_active = 1'b0;
    expected_d_mode = 1'b0;
    tb_test_state = "EH_Done";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
    //advance to IDLE
    tb_rx_packet = RX_IDLE;
    tb_test_state = "IDLE";
    @(posedge tb_clk);
    check_outputs(expected_rx_data_ready,
                  expected_rx_transfer_active,
                  expected_rx_error,
                  expected_tx_transfer_active,
                  expected_tx_error,
                  expected_clear,
                  expected_tx_packet,
                  expected_d_mode,
                  tb_test_state);
  end
endmodule
