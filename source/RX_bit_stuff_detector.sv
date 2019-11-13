//Bit Stuff detector for CDL USB RX

module RX_bit_stuff_detector (clk,
                              n_rst,
                              decoded_bit,
                              ignore_bit);
  input wire clk;
  input wire n_rst;
  input wire decoded_bit;
  output reg ignore_bit;

  typedef enum reg [3:0] {IDLE, COUNT1, COUNT2, COUNT3, COUNT4, COUNT5, COUNT6, SKIP} state_type;

  state_type state;
  state_type next_state;

  always_comb begin //case statement for state assignment
    state = IDLE; //prevent latches
    ignore_bit = 1'b0;

    case(state)
      IDLE: begin
        if (decoded_bit == 1'b1) begin
          next_state = COUNT1;
        end
      end

      COUNT1: begin
        if (decoded_bit == 1'b1) begin
          next_state = COUNT2;
        end
      end

      COUNT2: begin
        if (decoded_bit == 1'b1) begin
          next_state = COUNT3;
        end
      end

      COUNT3: begin
        if (decoded_bit == 1'b1) begin
          next_state = COUNT4;
        end
      end

      COUNT4: begin
        if (decoded_bit == 1'b1) begin
          next_state = COUNT5;
        end
      end

      COUNT5: begin
        if (decoded_bit == 1'b1) begin
          next_state = COUNT6;
        end
      end

      COUNT6: begin
        next_state = SKIP;
      end

      SKIP: begin
        next_state = IDLE;
        ignore_bit = 1'b1;
      end
    endcase
  end

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 1'b0) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end
endmodule
