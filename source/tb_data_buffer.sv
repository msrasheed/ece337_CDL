// $Id: $
// File name:   tb_data_buffer.sv
// Created:     11/17/2019
// Author:      Melissa Nguyen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Data Buffer
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

  reg [31:0] tb_test_data;
  reg [1:0] tb_bit_size;

  string tb_test_case;
   integer i;
   logic [63:0][7:0] tb_test_array;

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

   //task for receiving a byte from RX
   task rx_send_byte;
      input logic [7:0] rx_byte;
      begin
	@(posedge tb_clk);
	 tb_rx_packet_data = rx_byte;
	 tb_store_rx_packet_data = 1'b1;

	 @(posedge tb_clk); //hold rx_packet_data high for one clock cycle

	 tb_store_rx_packet_data  = 1'b0;
      end
   endtask // rx_send_byte

   //add task for sending multiple bytes to buffer
   task rx_send_array;
      input integer num_bytes;
      input logic [63:0][7:0] data; //not sure if this will work with the 63 there if you call it without the full 64 bytes
      integer 				  i;

      begin
    	 for (i = 0; i < num_bytes; i++)
    	   begin
    	      rx_send_byte(data[i]);
              #0.1; //not sure if this is needed, might need to adjust
    	   end
      end
   endtask // rx_send_bytes

   //task for sending data to AHB-Lite Slave
   task slave_request_data;
      input logic [1:0] data_size;
      input logic [31:0] expected_data;
      begin
    	@(posedge tb_clk);
	tb_data_size = data_size;
    	tb_get_rx_data = 1'b1;
	@(posedge tb_clk);
	tb_get_rx_data = 1'b0;
    	 #1
    	 case(data_size)
    	   2'd0: begin //1 byte
    	      assert({24'd0, expected_data[7:0]} == tb_rx_data)
    		$info("Test case %s: correct RX data for read 1 byte from data buffer", tb_test_case);
    	      else
    		$error("Test case %s: Incorrect RX data for read 1 byte from data buffer", tb_test_case);
    	   end
    	   2'd1: begin //2 byte
    	      assert({16'd0, expected_data[15:0]} == tb_rx_data)
    		$info("Test case %s: correct RX data for read 2 bytes from data buffer", tb_test_case);
    	      else
    		$error("Test case %s: Incorrect RX data for read 2 bytes from data buffer", tb_test_case);
    	   end
    	   2'd2: begin //3 byte
    	      assert({8'd0, expected_data[23:0]} == tb_rx_data)
    		$info("Test case %s: correct RX data for read 3 bytes from data buffer", tb_test_case);
    	      else
    		$error("Test case %s: Incorrect RX data for read 3 bytes from data buffer", tb_test_case);
    	   end
    	   2'd3: begin //4 byte
    	      assert(expected_data == tb_rx_data)
    		$info("Test case %s: correct RX data for read 4 bytes from data buffer", tb_test_case);
    	      else
    		$error("Test case %s: Incorrect RX data for read 4 bytes from data buffer", tb_test_case);
    	   end
    	 endcase // case (data_size)
      end
   endtask // slave_request_data

   //task for storing TX data sent from AHB slave
   task send_tx_data;
      input logic [1:0] num_bytes;
      input logic [31:0] tx_data;
      begin
    	 @(posedge tb_clk);
    	 tb_buffer_reserved = 1'b1;
    	 tb_store_tx_data = 1'b1;
    	 tb_data_size = num_bytes;
    	 case(num_bytes)
    	   2'd0: begin //1 byte
    	      tb_tx_data = {24'd0, tx_data[7:0]};
    	   end
    	   2'd1: begin //2 byte
    	      tb_tx_data = {16'd0, tx_data[15:0]};

    	   end
    	   2'd2: begin //3 byte
    	      tb_tx_data = {8'd0, tx_data[23:0]};

    	   end
    	   2'd3: begin //4 byte
    	      tb_tx_data = tx_data;
    	   end
    	 endcase // case (data_size)

    	@(posedge tb_clk)
    	tb_store_tx_data = 1'b0;
      end
   endtask // send_tx_data

   //task for requesting TX data packet
   task request_tx_packet;
      input logic [7:0] expected_byte;
      begin
    	 @(posedge tb_clk);//wait a clock cycle after asserting
    	 tb_get_tx_packet_data = 1'b1;
    	 @(posedge tb_clk);//wait a clock cycle after asserting
    	 #1
    	 assert(expected_byte == tb_tx_packet_data)
    	   $info("Test case %s: correct tx_packet_data sent to usb tx", tb_test_case);
    	 else
    	   $error("Test case %s: incorrect tx_packet_data sent to usb tx", tb_test_case);
    	 tb_get_tx_packet_data = 1'b0;
      end
   endtask


   //task for checking buffer occupancy
   task check_buffer_occupancy;
      input logic [6:0] expected_occupancy;
      begin
    	 #1
    	 assert(tb_buffer_occupancy == expected_occupancy)
    	   $info("Test case %s: correct output for buffer occupancy", tb_test_case);
    	 else
    	   $error("Test case %s: incorrect output for buffer occupancy", tb_test_case);
      end
   endtask // check_buffer_occupancy

   task gen_rand_tb_test_array;
    integer i;
    integer j;
    begin
      for (i = 0; i < 64; i++) begin
        for (j = 0; j < 8; j++) begin
          tb_test_array[i][j] = $urandom_range(1,0); //generate a lot of data
        end
      end
    end
  endtask

  task slave_request_data_array; //main for 4 bytes
    input logic [6:0] num_bytes;
    input logic [63:0][7:0] test_array;
    integer j;
     logic [31:0] temp;
     begin
      for(j = 0; j < num_bytes; j+=4) begin
	 temp = {test_array[j+3],test_array[j+2],test_array[j+1],test_array[j]};
	 slave_request_data(2'd3, temp);
      end
    end
  endtask

  task slave_request_data_array_2; //for 2 bytes
    input logic [6:0] num_bytes;
    input logic [63:0][7:0] test_array;
    integer j;
     logic [15:0] temp;
     begin

      for(j = 0; j < num_bytes; j+=2) begin
	 temp = test_array[j+:2];
	 slave_request_data(2'd1, temp);
      end

    end
  endtask // slave_request_data_array

   task slave_request_data_array_1; //for 1 byte
    input logic [6:0] num_bytes;
    input logic [63:0][7:0] test_array;
    integer j;
     logic [7:0] temp;
     begin

      for(j = 0; j < num_bytes; j++) begin
	 temp = test_array[j];
	 slave_request_data(2'd0, temp);
      end
    end
  endtask
   
  task send_tx_data_array; //only use this with bit size multiples of 4
    input logic [6:0] num_bytes;
    input logic [63:0][7:0] test_array;
    logic [31:0] test_data;
    integer j;
    begin
       for(j = 0; j < num_bytes; j+=4) begin
          test_data = {test_array[j+3], test_array[j+2], test_array[j+1], test_array[j]};
	  send_tx_data(2'd3, test_data);
      end
    end
  endtask

  task request_tx_array;
    input logic [6:0] num_bytes;
    input logic [63:0][7:0] test_array;
    integer j;
    begin
      for(j = 0; j < num_bytes; j++) begin
        request_tx_packet(test_array[j]);
      end
    end
  endtask

   initial begin
     //set inputs to idle values
     tb_n_rst = 1'b1;
     tb_clear = 1'b0;
     tb_store_rx_packet_data = 1'b0;
     tb_get_rx_data = 1'b0;
     tb_store_tx_data = 1'b0;
     tb_get_tx_packet_data= 1'b0;
     tb_buffer_reserved = 1'b0;

     //Small data test cases
     //
     //Reset dut then write 4 bytes of data to buffer from UBS RX
     //
     tb_test_case = "small data rx";
     gen_rand_tb_test_array();
     reset_dut();
     #0.1;
     rx_send_array(4, tb_test_array); //send 4 bytes to check basic functionality

     //
     //Request the 4 bytes sent in the previous test case to the AHB slave
     //
     tb_test_case = "small data AHB read";
     tb_test_data = tb_test_array[3:0];
     slave_request_data_array_2(2, tb_test_array[1:0]); // request the data to the AHB slave
     slave_request_data_array_1(1, tb_test_array[2]); // request the data to the AHB slave
     slave_request_data_array_1(1, tb_test_array[3]); // request the data to the AHB slave
     @(posedge tb_clk);
     //
     //Reset DUT then write 2 bytes of data from AHB slave
     //
     tb_test_case = "small data AHB write";
     gen_rand_tb_test_array();
     reset_dut();
     #0.1;
     send_tx_data_array(2, tb_test_array); // CHANGE: Always does 4 because that is how the task is written

     //
     //check the buffer occupancy
     //
     check_buffer_occupancy(7'd4);	

     //
     //Send the data to the USB TX
     //
     tb_test_case = "small data tx";
     request_tx_packet(tb_test_array[0]);
     request_tx_packet(tb_test_array[1]);
     
     @(posedge tb_clk);			// CHANGE: Needed to make the tb_buffer_reserved back to LOW
     tb_buffer_reserved = 1'b0;


     //large data test cases
     //
     //Reset dut then write 32 bytes of data to buffer from UBS RX
     //
     tb_test_case = "large data rx";
     gen_rand_tb_test_array();
     reset_dut();
     #0.1;
     rx_send_array(32, tb_test_array); //send 32 bytes to check basic functionality

     //
     //Request the 32 bytes sent in the previous test case to the AHB slave
     //
     tb_test_case = "large data AHB read";
     slave_request_data_array(32, tb_test_array); //read 32 bytes to ahb

     //
     //Reset DUT then write 32 bytes of data from AHB slave
     //
     tb_test_case = "large data AHB write";
     gen_rand_tb_test_array();
     reset_dut();
     #0.1;
     send_tx_data_array(32, tb_test_array); //write 32 bytes from ahb

     //
     //Send the data to the USB TX
     //
      tb_test_case = "large data tx";
      request_tx_array(32, tb_test_array); //read 32 bytes to ahb

     @(posedge tb_clk);			// CHANGE: Needed to make the tb_buffer_reserved back to LOW
     tb_buffer_reserved = 1'b0;

     //64 byte test cases
     //
     //Reset dut then write 64 bytes of data to buffer from UBS RX
     //
     gen_rand_tb_test_array();
     tb_test_case = "64 byte data rx";
     reset_dut();
     #0.1;
     rx_send_array(64, tb_test_array); //send 64 bytes to check basic functionality

     //
     //Request the 64 bytes sent in the previous test case to the AHB slave
     //
     tb_test_case = "64 byte data AHB read";
     slave_request_data_array(64, tb_test_array);

     //
     //Reset DUT then write 64 bytes of data from AHB slave
     //
     tb_test_case = "64 byte data AHB write";
     gen_rand_tb_test_array();
     reset_dut();
     #0.1;
     send_tx_data_array(64, tb_test_array);

     //
     //Send the data to the USB TX
     //
      tb_test_case = "64 byte data tx";
      request_tx_array(64, tb_test_array);

   end

endmodule
