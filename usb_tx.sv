module usb_tx(input wire clk, input wire n_rst, input wire [1:0] tx_packet, input wire [6:0] tx_packet_size, input wire [7:0] packet_data, output reg dPlus, output reg dMinus);


reg load_enable_tx;        //Load Enable from the TX
reg [7:0] parallel_in_tx;  // Parallel Input to the PTS shift register, controlled by the TX FSM
reg serial_out_pts;        // Serial out from the Parallel To Serial Shift Register
reg shift_enable_timer;    // Shift Enable from the Timer Module

// Timer Input Signals

reg enable_timer_tx;       // enable signal from the TX FSM
reg disable_bit_stuffer;   // disable signal from the bit stuffer

// Encoder Input Signals

reg encoder_in_timer;      // Input to the encoder, from the Timer

pts_8_bit SR(.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable_timer), .load_enable(load_enable_tx), .parallel_in(parallel_in_tx), .serial_out(.serial_out_pts));

// Timer Block

tx_timer TIM1(.clk(clk) ,.n_rst(n_rst), .shift_strobe(shift_enable_timer), .enable_timer(enable_timer_tx & !(disable_bit_stuffer)));

bit_stuffer BST(.clk(clk), .n_rst(n_rst), .serial_in(serial_out_pts), .disable_timer(disable_bit_stuffer), .encoder_in(encoder_in_timer)); 

endmodule

