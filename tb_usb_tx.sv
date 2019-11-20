// $Id: $
// File name:   tb_usb_tx.sv
// Created:     11/13/2019
// Author:      Melissa Nguyen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test Bench for USB TX

`timescale 1ns / 10ps

module tb_usb_tx ();

// Timing related constants
localparam CLK_PERIOD = 2.5;

// Other related constants to the inputs
// Tx_packet
localparam tx_IDLE = 2'b00;
localparam tx_DATA = 2'b01;
localparam tx_ACK = 2'b10;
localparam tx_NAK = 2'b11;
//Dplus and Dminus for common PIDs / Packet Types
localparam IDLE 	= 8'b11111111;
localparam SYNC		= 8'b00101010;		// For d_plus. d_minus is complement of it
localparam ACK		= 8'b00101101;
localparam NAK		= 8'b10100101;
localparam DATA		= 8'b00111100;

// DUT Inputs
reg tb_clk;				// Generated Clock
reg tb_n_rst;				// Negated Reset
reg [1:0] tb_tx_packet;			// Packet from the Protocol Controller
reg [7:0] tb_tx_packet_data;		// Data from the Data Buffer
reg [6:0] tb_tx_packet_data_size;	// Number of data in bytes from the AHB-Lite Slave

// DUT Outputs
wire tb_dplus_out;			// Dplus Output Line to Host
wire tb_dminus_out;			// Dminus Output Line to Host
wire tb_tx_done;			// Tells the Protocol Controller that the TX is done sending its packet
wire tb_get_tx_packet_data;		// Tells the Data Buffer to get the data

// Test Bench Debug Signals
// Overall test case number for reference
integer tb_test_num;
string tb_test_case;
// Test case 'inputs' used for test stimulus
reg [63:0][7:0] tb_test_packet_data;
// Test case expected output values for the test case
reg tb_expected_dplus_out;	
reg tb_expected_dminus_out;
reg tb_expected_tx_done;
reg tb_expected_get_tx_packet_data;

reg [7:0] tb_expected_dplus_packet;	// Byte seeing what expected value it needs to be
reg [7:0] tb_expected_dminus_packet;
reg [15:0] tb_expected_crc;		// 16 bits for the Expected CRC (Will need to calculate later)

// DUT Portmap
usb_tx DUT
(
	// Inputs
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.tx_packet(tb_tx_packet),
	.tx_packet_data_size(tb_tx_packet_data_size),
	.tx_packet_data(tx_packet_data),

	// Outputs
	.dPlus_out(tb_dplus_out),
	.dMinus_out(tb_dminus_out),
	.tx_done(tb_tx_done),
	.get_tx_packet_data(tb_get_tx_packet_data)
);

// Tasks for regulating the timing of input stimulus to the design

	// Reset_DUT Task
	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronized with clock)
		tb_n_rst = 1'b0;
		
		// Wait for the couple clock cycles
		@(posedge tb_clk);
		@(posedge tb_clk);
		
		// Release the reset
		@(negedge tb_clk);
		tb_n_rst = 1;

		// Wait for a while before activating the design
		@(posedge tb_clk);
		@(posedge tb_clk);
	end
	endtask

	// Task for Check Outputs
	task check_outputs;
	begin
		// Wait a little bit before checking
		#1;

		// Checking D_plus
		assert(tb_expected_dplus_out == tb_dplus_out)
			$info("Test case %0d: Test d_plus correctly received", tb_test_num);
		else
			$error("Test case %0d: Test d_plus was not correctly received", tb_test_num);

		// Checking D_plus
		assert(tb_expected_dminus_out == tb_dminus_out)
			$info("Test case %0d: Test d_minus correctly received", tb_test_num);
		else
			$error("Test case %0d: Test d_minus was not correctly received", tb_test_num);

		// Checking D_plus
		assert(tb_expected_tx_done == tb_tx_done)
			$info("Test case %0d: Test tx_done correctly received", tb_test_num);
		else
			$error("Test case %0d: Test tx_done was not correctly received", tb_test_num);

		// Checking D_plus
		assert(tb_expected_get_tx_packet_data == tb_get_tx_packet_data)
			$info("Test case %0d: Test get_tx_packet_data correctly received", tb_test_num);
		else
			$error("Test case %0d: Test get_tx_pcket_data was not correctly received", tb_test_num);
	end
	endtask	
	
	// Task for Checking Common SYNC/NAK/ACK
	task check_packet_common;
		input [7:0] expected_dplus;
		input [7:0] expected_dminus;

		integer i;
	begin

		for (i = 0; i < 8; i = i + 1)
		begin
			// Wait a clock cycle before checking the output again
			@(posedge tb_clk)

			// Setting the expected outputs
			tb_expected_dplus_out = expected_dplus[i];
			tb_expected_dminus_out = expected_dminus[i];
			tb_expected_tx_done = 1'b0;
			tb_expected_get_tx_packet_data = 1'b0;
			
			check_outputs;
		end

	end
	endtask

	task check_EOP;		// Checks the EOP
	begin
		// Should be EOP Cycle
		// Should be low for 2 clock cycles
		tb_expected_dplus_out = 1'b0;
		tb_expected_dminus_out = 1'b0;
		tb_expected_tx_done = 1'b0;
		tb_expected_get_tx_packet_data = 1'b0;
		@ (posedge tb_clk);
		check_outputs;
		@ (posedge tb_clk);
		check_outputs;
	
		// Tx_done = HIGH for 1 clock cycle and dplus and dminus go to IDLE states
		tb_expected_dplus_out = 1'b1;
		tb_expected_dminus_out = 1'b0;
		tb_expected_tx_done = 1'b1;
		tb_expected_get_tx_packet_data = 1'b0;
		@ (posedge tb_clk);
		check_outputs;
	
		tb_expected_tx_done = 1'b0;
		@ (posedge tb_clk);
		check_outputs;
	
	end
	endtask

// Generating the Clock
always
begin : CLK_GEN
	tb_clk = 1'b0;
	#(CLK_PERIOD / 2);
	tb_clk = 1'b1;
	#(CLK_PERIOD / 2);
end

// Test Bench Process
initial
begin : TEST_PROC
	// Initialize all of the test bench signals
	tb_test_num = -1;
	tb_test_case = "TB Init";
	tb_test_packet_data[63:0] = '0;	// Contains the Data Buffer Data, which is initially all 0
	
	// Output expected initial values
	tb_expected_dplus_out = 1'b1;
	tb_expected_dminus_out = 1'b0;
	tb_expected_tx_done = 1'b0;
	tb_expected_get_tx_packet_data = 1'b0;
	
	// Used for calling tasks
	tb_expected_crc = 16'b0;
	tb_expected_dplus_packet = IDLE;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	
	// Initialize all of the inputs of the DUT to their inactive signals
	tb_n_rst = 1'b1;		// Initially inactive
	tb_tx_packet = tx_IDLE;		// Initially IDLE
	tb_tx_packet_data = 8'b0;	// Initially all 0
	tb_tx_packet_data_size = 7'b0;	// Initially 0 Bytes

	// Get away from Time = 0
	#0.1;

	/******************************************************
	********** TEST CASE 0: Basic Power On Reset **********
	*******************************************************/
	tb_test_num = 0;
	tb_test_case = "Power-on-Reset";

	// All expected outputs should be set to the 'inital/idle' values
	tb_test_packet_data[63:0] = 8'b0;
	tb_tx_packet_data_size = 7'b0;
	tb_tx_packet_data = 8'b0;
	tb_tx_packet = tx_IDLE;

	// Define expected outputs for this test case
	tb_expected_crc = 16'b0;
	tb_expected_dplus_packet = IDLE;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	// Dplus idle is HIGH
	tb_expected_dplus_out = 1'b1;
	// Dminus idle is LOW
	tb_expected_dminus_out = 1'b0;
	// No packet is being sent so tx_done should be LOW
	tb_expected_tx_done = 1'b0;
	// No packet should be gotten from the Data Buffer so idle value should be LOW
	tb_expected_get_tx_packet_data = 1'b0;

	// DUT Reset
	reset_dut;

	// Check Outputs
	check_outputs;

	/******************************************************
	********** TEST CASE 1: Checking the ACK **************
	*******************************************************/
	
	@(negedge tb_clk);
	tb_test_num += 1;
	tb_test_case = "HE is good, Send ACK";

	// Define expected outputs for this test case
	tb_expected_crc = 16'b0;
	tb_expected_dplus_packet = SYNC;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	tb_expected_dplus_out = 1'b1;
	tb_expected_dminus_out = 1'b0;
	tb_expected_tx_done = 1'b0;
	tb_expected_get_tx_packet_data = 1'b0;

	reset_dut;

	@(posedge tb_clk);
	// Setup packet info for debugging/verification signals
	tb_test_packet_data[63:0] = 8'b0;
	tb_tx_packet_data_size = 7'b0;
	tb_tx_packet_data = 8'b0;
	tb_tx_packet = tx_ACK;

	// Wait 2 clock cycles before the dplus and dminus changes
	@(posedge tb_clk);
	check_outputs; 		// Making sure that the outputs stay in IDLE
	@(posedge tb_clk);
	check_outputs;		// Making sure that the outputs stay in IDLE
	
	// Should be a SYNC
	check_packet_common (tb_expected_dplus_packet, tb_expected_dminus_packet);
	
	// Should be an ACK PID
	tb_expected_dplus_packet = ACK;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	check_packet_common (tb_expected_dplus_packet, tb_expected_dminus_packet);

	// Should be EOP Cycle
	check_EOP;

	/******************************************************
	********** TEST CASE 2: Checking the NAK **************
	*******************************************************/
	
	@(negedge tb_clk);
	tb_test_num += 1;
	tb_test_case = "HE is bad, Send NAK";

	// Define expected outputs for this test case
	tb_expected_crc = 16'b0;
	tb_expected_dplus_packet = SYNC;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	tb_expected_dplus_out = 1'b1;
	tb_expected_dminus_out = 1'b0;
	tb_expected_tx_done = 1'b0;
	tb_expected_get_tx_packet_data = 1'b0;

	reset_dut;

	@(posedge tb_clk);
	// Setup packet info for debugging/verification signals
	tb_test_packet_data[63:0] = 8'b0;
	tb_tx_packet_data_size = 7'b0;
	tb_tx_packet_data = 8'b0;
	tb_tx_packet = tx_NAK;

	// Wait 2 clock cycles before the dplus and dminus changes
	@(posedge tb_clk);
	check_outputs; 		// Making sure that the outputs stay in IDLE
	@(posedge tb_clk);
	check_outputs;		// Making sure that the outputs stay in IDLE
	
	// Should be a SYNC
	check_packet_common (tb_expected_dplus_packet, tb_expected_dminus_packet);
	
	// Should be an ACK PID
	tb_expected_dplus_packet = NAK;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	check_packet_common (tb_expected_dplus_packet, tb_expected_dminus_packet);

	// Should be EOP Cycle
	check_EOP;

	/******************************************************
	********** TEST CASE 3: Checking the DATA **************
	*******************************************************/

	@(negedge tb_clk);
	tb_test_num += 1;
	tb_test_case = "1 Byte of Data";

	// Define expected outputs for this test case
	tb_expected_crc = 16'hC0C0;								/********** WHAT IS THIS VALUE **********/
	tb_expected_dplus_packet = SYNC;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	tb_expected_dplus_out = 1'b1;
	tb_expected_dminus_out = 1'b0;
	tb_expected_tx_done = 1'b0;
	tb_expected_get_tx_packet_data = 1'b0;

	reset_dut;

	@(posedge tb_clk);
	// Setup packet info for debugging/verification signals
	tb_test_packet_data[0] = 8'b10101010;
	tb_tx_packet_data_size = 7'd1;
	tb_tx_packet_data = tb_test_packet_data[0];
	tb_tx_packet = tx_DATA;

	// Wait 2 clock cycles before the dplus and dminus changes
	@(posedge tb_clk);
	check_outputs; 		// Making sure that the outputs stay in IDLE
	@(posedge tb_clk);
	check_outputs;		// Making sure that the outputs stay in IDLE
	
	// Should be a SYNC
	check_packet_common (tb_expected_dplus_packet, tb_expected_dminus_packet);
	
	// Should be an ACK PID
	tb_expected_dplus_packet = DATA;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	check_packet_common (tb_expected_dplus_packet, tb_expected_dminus_packet);

	// Getting the data from the Data Buffer
	tb_expected_get_tx_packet_data = 1'b1;
	@(posedge tb_clk);
	tb_expected_get_tx_packet_data = 1'b0;
	@(posedge tb_clk);

	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_expected_dplus_packet = 8'b01010101;			// Last bit was a 1 from data buffer
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;

	check_packet_common(tb_expected_dplus_packet, tb_expected_dminus_packet);

	// Sending the CRC
	tb_expected_dplus_packet = tb_expected_crc[7:0];
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	@(posedge tb_clk);
	check_packet_common(tb_expected_dplus_packet, tb_expected_dminus_packet);

	tb_expected_dplus_packet = tb_expected_crc[15:8];
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	@(posedge tb_clk);
	check_packet_common(tb_expected_dplus_packet, tb_expected_dminus_packet);

	// Should be EOP Cycle
	check_EOP;

	/******************************************************
	****** TEST CASE 3: Checking the Bit Stuffing *********
	*******************************************************/

	@(negedge tb_clk);
	tb_test_num += 1;
	tb_test_case = "1 Byte of Data";

	// Define expected outputs for this test case
	tb_expected_crc = 16'h3FC1 ;								/********** WHAT IS THIS VALUE **********/
	tb_expected_dplus_packet = SYNC;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	tb_expected_dplus_out = 1'b1;
	tb_expected_dminus_out = 1'b0;
	tb_expected_tx_done = 1'b0;
	tb_expected_get_tx_packet_data = 1'b0;

	reset_dut;

	@(posedge tb_clk);
	// Setup packet info for debugging/verification signals
	tb_test_packet_data[0] = 8'b11111110;
	tb_tx_packet_data_size = 7'd1;
	tb_tx_packet_data = tb_test_packet_data[0];
	tb_tx_packet = tx_DATA;

	// Wait 2 clock cycles before the dplus and dminus changes
	@(posedge tb_clk);
	check_outputs; 		// Making sure that the outputs stay in IDLE
	@(posedge tb_clk);
	check_outputs;		// Making sure that the outputs stay in IDLE
	
	// Should be a SYNC
	check_packet_common (tb_expected_dplus_packet, tb_expected_dminus_packet);
	
	// Should be an ACK PID
	tb_expected_dplus_packet = DATA;
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	check_packet_common (tb_expected_dplus_packet, tb_expected_dminus_packet);

	// Getting the data from the Data Buffer
	tb_expected_get_tx_packet_data = 1'b1;
	@(posedge tb_clk);
	tb_expected_get_tx_packet_data = 1'b0;
	@(posedge tb_clk);

	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_expected_dplus_packet = 8'b01111111;			// Last bit was a 1 from data buffer
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;

	check_packet_common(tb_expected_dplus_packet, tb_expected_dminus_packet);

	// Due to bit stuffing the last bit of the byte from the Data Buffer is delayed
	tb_expected_dplus_out = 1'b1;
	tb_expected_dminus_out = 1'b0;
	tb_expected_tx_done = 1'b0;
	@(posedge tb_clk);
	check_outputs;

	// Sending the CRC
	tb_expected_dplus_packet = tb_expected_crc[7:0];
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	@(posedge tb_clk);
	check_packet_common(tb_expected_dplus_packet, tb_expected_dminus_packet);

	tb_expected_dplus_packet = tb_expected_crc[15:8];
	tb_expected_dminus_packet = ~tb_expected_dplus_packet;
	@(posedge tb_clk);
	check_packet_common(tb_expected_dplus_packet, tb_expected_dminus_packet);

	// Should be EOP Cycle
	check_EOP;
	
end

endmodule 