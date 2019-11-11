//Control FSM for USB RX CDL

module RX_ControlFSM (clk,
                      n_rst,
                      eop,
                      decoded_bit,
                      pass_5_bit,
                      pass_16_bit,
                      byte_done,
                      sr_val,
                      en_buffer,
                      RX_PID,
                      clear_crc);

  localparam PACKET_IDLE = 3'd0;//need to encode packet types
  localparam PACKET_DATA = 3'd1;
  localparam PACKET_OUT = 3'd2;
  localparam PACKET_IN = 3'd3;
  localparam PACKET_ACK = 3'd4;
  localparam PACKET_NAK = 3'd5;
  localparam PACKET_BAD = 3'd6;

  localparam PID_OUT = 8'b00011110;
  localparam PID_IN = 8'b10010110;
  localparam PID_DATA0 = 8'b00111100;
  localparam PID_DATA1 = 8'10110100;
  localparam PID_ACK = 8'b00101101;
  localparam PID_NAK = 8'b10100101;

  localparam address = 11'd0;

  input wire clk;
  input wire n_rst;
  input wire eop;
  input wire decoded_bit;
  input wire pass_5_bit;
  input wire pass_16_bit;
  input wire byte_done;
  input wire [15:0] sr_val;
  output reg en_buffer;
  output reg [2:0] RX_PID;
  output reg clear_crc;

  reg [2:0] next_RX_PID;
  reg [2:0] PID;
  reg [2:0] next_PID;

  typedef enum reg [4:0] {IDLE, SYNC, PIDWAIT, CHECKPID, TOKEN, READTOKEN, CRC5, EOPTOKEN, SENDTOKEN, DATA, READDATA, READWRITE, CRC16, BADDATA, ACK, EOPACK, SENDACK, NAK, EOPNAK, SENDNAK} state_type;

  state_type state;
  state_type next_state;

  always_comb begin
    next_RX_PID = RX_PID;
    en_buffer = 1'b0;
    clear_crc = 1'b0;
    next_state = state;
    PID = next_PID;

    case(state)
    IDLE: begin
      next_RX_PID = PACKET_IDLE;
      if (byte_done == 1'b1) begin
        next_state = SYNC;
      end
    end

    SYNC: begin
      if (sr_val[7:0] == 8'b00000001) begin
        next_state = PIDWAIT;
      end else begin
        next_state = IDLE;
      end
    end

    PIDWAIT: begin
      if (byte_done == 1'b1) begin
        next_state = CHECKPID
      end
    end

    CHECKPID: begin
      if (sr_val[7:0] == PID_IN) begin
        next_state = TOKEN;
        next_PID = PACKET_IN;
      end else if (sr_val[7:0] == PID_OUT) begin
        next_state = TOKEN;
        next_PID = PACKET_OUT;
      end else if ((sr_val[7:0] == PID_DATA0) || (sr_val[7:0] == PID_DATA1)) begin
        next_state = DATA;
        next_PID = PACKET_DATA;
      end else if (sr_val[7:0] == PID_ACK) begin
        next_state = ACK;
        next_PID = PACKET_ACK;
      end else if (sr_val[7:0] == PID_NAK) begin
        next_state = NAK;
        next_PID = PACKET_NAK;
      end else begin
        next_state = IDLE; //Ignore any unrecognized PIDs
        next_PID = PACKET_IDLE;
      end
    end

    TOKEN: begin
      clear_crc = 1'b1
      if (byte_done == 1'b1) begin
        next_state = READTOKEN;
      end
    end

    READTOKEN: begin
      if (byte_done == 1'b1) begin
        next_state =  CRC5;
      end
    end

    CRC5: begin
      next_state = IDLE;
      if (sr_val[15:4] == address) begin
        if (eop == 1'b1) begin
          if (pass_5_bit == 1'b1) begin
            next_state = EOPTOKEN;
          end
        end
      end
    end

    EOPTOKEN: begin
      if (eop == 1'b1) begin
        next_state = SENDTOKEN;
      end else begin
        next_state = BADDATA;
      end
    end

    SENDTOKEN: begin
      next_RX_PID = PID; //assign in or out token based on what was received
      next_state = IDLE;
    end

    DATA: begin
      next_RX_PID = PACKET_DATA;
      clear_crc = 1'b1
      if (byte_done == 1'b1) begin
        next_state = READDATA;
      end
    end

    READDATA: begin
      if (byte_done == 1'b1) begin
        next_state = READWRITE;
      end
    end

    READWRITE: begin
      en_buffer = 1'b1;
      if (eop == 1'b1) begin
        next_state = CRC16;
      end
    end

    CRC16: begin
      if ((pass_16_bit == 1'b1) && (eop == 1'b1)) begin
        next_state = IDLE;
      end else begin
        next_state = BADDATA;
      end
    end

    BADDATA: begin
      next_RX_PID = PACKET_BAD;
      next_state = IDLE;
    end

    ACK: begin
      if (eop == 1'b1) begin
        next_state = EOPACK;
      end else begin
        next_state = BADDATA;
      end
    end

    EOPACK: begin
      if (eop == 1'b1) begin
        next_state = SENDACK;
      end else begin
        next_state = BADDATA;
      end
    end

    SENDACK: begin
      next_RX_PID = PACKET_ACK;
      next_state = IDLE;
    end

    NAK: begin
      if (eop == 1'b1) begin
        next_state = EOPNAK;
      end else begin
        next_state = BADDATA;
      end
    end

    EOPNAK: begin
      if (eop == 1'b1) begin
        next_state = SENDNAK;
      end else begin
        next_state = BADDATA;
      end
    end

    SENDNAK: begin
      next_RX_PID = PACKET_NAK;
      next_state = IDLE;
    end
    endcase
  end //always_comb

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 1'b0) begin
      state <= IDLE;
      RX_PID <= PACKET_IDLE;
      PID <= PACKET_IDLE;
    end else begin
      state <= next_state;
      RX_PID <= next_RX_PID;
      PID <= next_PID;
    end
  end //always_ff

endmodule
