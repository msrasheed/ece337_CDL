module usb_tx(input wire clk, input wire n_rst, input wire [1:0] tx_packet, input wire [6:0] tx_packet_data_size, input wire [7:0] tx_packet_data, 
              output reg dPlus_out, output reg dMinus_out, output reg tx_done, output reg get_tx_packet);


reg [7:0] parallel_in_tx;  // Parallel Input to the PTS shift register, controlled by the TX FSM
reg serial_out_pts;        // Serial out from the Parallel To Serial Shift Register
reg shift_enable_timer;    // Shift Enable from the Timer Module

// Timer Input Signals
reg enable_timer_tx;       // enable signal from the TX FSM
reg disable_bit_stuffer;   // disable signal from the bit stuffer

// Encoder Input Signals
reg encoder_in_timer;      // Input to the encoder, from the Timer
reg next_encoder_in_timer;      // Input to the encoder, from the Timer

// CRC output registers
reg [15:0] crc_to_fsm;

// FSM signals
reg [2:0] state_val_fsm;     // State value from the TX FSM
reg load_enable_fsm;         // Load Enable from the TX FSM
reg byte_complete_timer;     // Byte Complete signal from the Timer [counter 2]
reg load_enable_tx;          // Load enable value from the TX

reg enable_timer_fsm;
reg clear_timer_fsm;
reg flag_timer;
reg clear_crc_fsm;

pts_8_bit SR(.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable_timer && !(disable_bit_stuffer)), .load_enable(load_enable_tx), .parallel_in(parallel_in_tx), .serial_out(serial_out_pts));

tx_timer TIM1(.clk(clk) ,.n_rst(n_rst), .shift_strobe(shift_enable_timer),.byte_complete(byte_complete_timer), .enable_timer(enable_timer_fsm), .disable_timer(disable_bit_stuffer), .clear_timer(clear_timer_fsm), .flag(flag_timer));

bit_stuffer BST(.clk(shift_enable_timer), .n_rst(n_rst), .serial_in(serial_out_pts), .disable_timer(disable_bit_stuffer), .encoder_in(encoder_in_timer), .next_encoder_in(next_encoder_in_timer)); 

crc_16_bit_gen CRC(.clk(clk), .n_rst(n_rst), .serial_in(serial_out_pts), .shift_en(shift_enable_timer && (crc_enable_fsm)), .crc(crc_to_fsm), .clear(clear_crc_fsm));

tx_fsm FSM(.clk(clk), .n_rst(n_rst), .tx_packet(tx_packet), .state_val(state_val_fsm), .tx_done(tx_done), .crc_enable(crc_enable_fsm), .data_pts(parallel_in_tx), .tx_packet_data(tx_packet_data), 
           .tx_packet_data_size(tx_packet_data_size), .flag(flag_timer), .enable_timer(enable_timer_fsm), .crc(crc_to_fsm), .load_enable(load_enable_tx), .get_tx_packet(get_tx_packet),
           .clear_timer(clear_timer_fsm), .shift_strobe(shift_enable_timer), .clear_crc(clear_crc_fsm));

encoder ENC(.clk(shift_enable_timer), .n_rst(n_rst), .encoder_in(next_encoder_in_timer), .state_val(state_val_fsm), .d_plus(dPlus_out), .d_minus(dMinus_out), .serial_in(serial_out_pts));

endmodule
