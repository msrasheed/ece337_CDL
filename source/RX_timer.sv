//Timer module for USB RX CDL

module RX_timer (clk,
                n_rst,
                d_plus,
                d_minus,
                en_sample);

  input wire clk;
  input wire n_rst;
  input wire d_plus;
  input wire d_minus;
  output wire en_sample;

  reg sync;
  reg count_enable;
  reg enable_8;
  reg clear;
  wire skip_bit;
   wire count8;
   reg 	count_reset;
   reg 	ignore_count;
   
  reg last_d_plus;
  reg last_d_minus;


  typedef enum reg [3:0] {IDLE, WAIT1, WAIT2, WAIT3, WAIT4} state_type;

  state_type state;
  state_type next_state;

  always_comb begin //edge detector
    sync = 1'b0;
    if ((last_d_plus != d_plus) || (last_d_minus != d_minus)) begin
      sync = 1'b1;
    end
  end

  always_ff @(posedge clk,  negedge n_rst) begin
    if (n_rst == 1'b0) begin
      last_d_plus <= 1'b0;
      last_d_minus <= 1'b0;
    end else begin
      last_d_plus <= d_plus;
      last_d_minus <= d_minus;
    end
  end

  always_comb begin //state machine comb block
    next_state = state;
    count_enable = 1'b1;
    clear = 1'b0;
     count_reset = 1'b0;
     ignore_count = 1'b0;
     
    case(state)
      IDLE: begin
        if (sync == 1'b1) begin
          next_state = WAIT1;
        end
      end

      WAIT1: begin
        count_enable = 1'b0;
        clear = 1'b1;
	 ignore_count = 1'b1;
	 next_state = WAIT2;
      end

      WAIT2: begin
        count_enable = 1'b0;
        next_state = WAIT3;
      end

      WAIT3: begin
        count_enable = 1'b0;
        next_state = WAIT4;
      end

      WAIT4: begin
        count_enable = 1'b0;
	 count_reset = 1'b1;
	 next_state = IDLE;
      end
    endcase
  end //comb block

   always_ff @(posedge clk, negedge n_rst) begin
      if (n_rst == 1'b0) begin
	 state <= IDLE;
      end else begin
	 state <= next_state;
      end
   end
   

  flex_counter #(.NUM_CNT_BITS(6)) counter_25
                (.clk(clk),
                .n_rst(n_rst),
                .clear(clear),
                .count_enable(count_enable),
                .rollover_val(6'd25),
                .rollover_flag(skip_bit));

  always_comb begin
    enable_8 = (!skip_bit) && count_enable;
  end

  flex_counter #(.NUM_CNT_BITS(4)) counter_8
                (.clk(clk),
                .n_rst(n_rst),
                .clear(clear),
                .count_enable(enable_8),
                .rollover_val(4'd8),
                .rollover_flag(count8));

   assign en_sample = count_reset || (count8 && !ignore_count);
      
endmodule
