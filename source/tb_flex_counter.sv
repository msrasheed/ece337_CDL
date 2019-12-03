
// 337 TA Provided Lab 4 Testbench
// This code serves as a starer test bench for the synchronizer design
// STUDENT: Replace this message and the above header section with an
// appropriate header based on your other code files

// 0.5um D-FlipFlop Timing Data Estimates:
// Data Propagation delay (clk->Q): 670ps
// Setup time for data relative to clock: 190ps
// Hold time for data relative to clock: 10ps

`timescale 1 ns / 10ps

module tb_flex_counter();

  // Define local parameters used by the test bench
  localparam  NUM_CNT_BITS = 4;
  localparam  CLK_PERIOD    = 1;
  localparam  FF_SETUP_TIME = 0.190;
  localparam  FF_HOLD_TIME  = 0.100;
  localparam  CHECK_DELAY   = (CLK_PERIOD - FF_SETUP_TIME); // Check right before the setup time starts
 
  localparam  INACTIVE_VALUE     = 1'b0;
  localparam  RESET_OUTPUT_VALUE = INACTIVE_VALUE;
  
  // Declare DUT portmap signals
  reg tb_clk;
  reg tb_n_rst;
  reg tb_clear;
  reg [3: 0] tb_rollover;
  reg tb_count_enable;

  // DUT outputs
  wire tb_rollover_flag;
  wire [NUM_CNT_BITS - 1 :0] tb_count_out;
  
  // Declare test bench signals
  integer tb_test_num;
  string tb_test_case;
  integer tb_stream_test_num;
  string tb_stream_check_tag;
  
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

  // Task to cleanly and consistently check DUT output values
  task check_output;
    input logic [NUM_CNT_BITS - 1:0] expected_value;
    input logic expected_rollover_flag;
    input string check_tag;
  begin
    if(expected_value == tb_count_out) begin // Check passed
      $info("Correct counter output %s during %s test case", check_tag, tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect counter output %s during %s test case", check_tag, tb_test_case);
    end
   if(expected_rollover_flag == tb_rollover_flag) begin // Check passed
      $info("Correct rollover flag %s during %s test case", check_tag, tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect rollover flag %s during %s test case", check_tag, tb_test_case);
    end
  end
  endtask


  // Clock generation block
  always
  begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end
  
  // DUT Port map
  flex_counter DUT(.clk(tb_clk), .n_rst(tb_n_rst), .rollover_val(tb_rollover), .count_enable(tb_count_enable), .count_out(tb_count_out), .clear(tb_clear), .rollover_flag(tb_rollover_flag));
  
  // Test bench main process
  initial
  begin
    // Initialize all of the test inputs
    tb_n_rst  = 1'b1;              // Initialize to be inactive
    tb_clear = 1'b0;
    tb_count_enable = 1'b1;
    tb_rollover = 'b1;
    
    tb_test_num = 0;               // Initialize test case counter
    tb_test_case = "Test bench initializaton";
    tb_stream_test_num = 0;
    tb_stream_check_tag = "N/A";
    // Wait some time before starting first test case
    #(0.1);
    
    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus

    tb_n_rst  = 1'b0;    // Activate reset
    
    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    check_output( 0,0, 
                  "after reset applied");
    
    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD * 0.5);
    check_output( 0,0,
                  "after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(posedge tb_clk);
    #(2 * FF_HOLD_TIME);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    #0.1;
    // Check that internal state was correctly keep after reset release
    check_output( 0,0, 
                  "after reset was released");
  
    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);

    // ************************************************************************
    // Test Case 2: Rollover for a rollover value that is not a power of 2
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover, value not a power of 2";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_n_rst = 1'b0;
    tb_count_enable = 1'b0;
    tb_clear = 1'b0;
    tb_rollover = 4'b0011;

    reset_dut();

    // Wait some time before applying test case stimulus
    #(0.1);

    tb_count_enable = 1'b1;
    tb_clear = 1'b0;
    tb_rollover = 4'b0110;
    
    for(int i = 0; i < 5; i++) begin
    
	 @(posedge tb_clk);
         #(0.1);
          check_output( i + 1, 0,
                  "after processing delay");         
    end

     // Wait for DUT to process stimulus before checking results
    @(posedge tb_clk); 
    #(0.1);
    check_output(4'b0110, 1'b1, "after additional clock");
  
    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
 
   // ************************************************************************
    // Test Case 3: Continous Counting
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continuous Counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_n_rst = 1'b0;
    tb_count_enable = 1'b0;
    tb_clear = 1'b0;
    tb_rollover = 'b1;

    reset_dut();

    
    tb_count_enable = 1'b1;
    tb_clear = 1'b0;
    tb_rollover = 4'b0111;
    
    for(int i = 0; i < 6; i++)
    begin
   
	 @(posedge tb_clk);
	 #(0.1);
          check_output( i + 1, 0,
                  "after processing delay");     
    end
    
	@(posedge tb_clk); 
	#(0.1);
     check_output( 4'b0111, 1,
                  "after processing delay");         
    
    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);


    // ************************************************************************
    // Test Case 4: Discontinuous Counting
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover, value not a power of 2";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_n_rst = 1'b0;
    tb_count_enable = 1'b0;
    tb_clear = 1'b1;
    tb_rollover = 'b1;
 
    reset_dut();
    tb_count_enable = 1'b1;
    tb_clear = 1'b0;
    tb_rollover = 4'b0111;


    for(int i = 0; i < 6; i++) begin
    
	 @(posedge tb_clk); 
	#(0.1);
          check_output( i + 1, 0,
                  "after processing delay");     
    end
    
     @(posedge tb_clk);
	#(0.1);
	 
     check_output( 7, 1,
                  "after processing delay");  
     tb_count_enable = 1'b0;
     
     @(posedge tb_clk); 

     @(posedge tb_clk); 
	#(0.1);

     check_output( 7, 1,
                  "after processing delay");  
     tb_count_enable = 1'b1;
    
     @(posedge tb_clk);
	#(0.1);

     check_output( 1, 0,
                  "after processing delay");  
      
    
    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);


    // ************************************************************************
    // Test Case 5: Clearing while counting,
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Clear while Counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_n_rst = 1'b0;
    tb_count_enable = 1'b0;
    tb_clear = 1'b1;
    tb_rollover = 'b1;
 
    reset_dut();

    tb_count_enable = 1'b1;
    tb_clear = 1'b0;
    tb_rollover = 4'b0100;
    for(int i = 0; i < 3; i++) begin
    
	 @(posedge tb_clk); 
	#(0.1);
          check_output( i + 1, 0,
                  "after processing delay");     
    end
    
	@(posedge tb_clk); 
	#(0.1);
	 
     check_output( 4'b0100, 1'b1,
                  "after processing delay");  
    // Activate the reset
    tb_clear= 1'b1;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

	#(0.1);

     check_output( 0, 0,
                  "after processing delay");  

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_clear= 1'b0;
    tb_count_enable = 1'b0;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_count_enable = 1'b1;
    
     @(posedge tb_clk);
	#(0.1);

     check_output( 1, 0,
                  "after processing delay");  
      
  end
endmodule 