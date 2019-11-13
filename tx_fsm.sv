module tx_fsm(input wire n_rst, input wire [1:0] tx_packet, output reg [2:0] state, output reg tx_done, output reg crc_enable, output reg [7:0] data_pts, input wire[7:0] tx_packet_data, input wire [6:0] tx_packet_data_size
              output reg [2:0] state_val,input wire tick8, output reg enable_timer);

typedef enum [3:0] bit{ 4'b0000 = IDLE, 4'b0001 = SYNC, 4'b0010 = PID, 4'b0011 = DATA_R, 4'b0100 = DATA_T, 4'b0101 = CRC_UP, 4'b0110 = CRC_LOW, 4'b0111 = EOP1, 4'b1000 = EOP2, 4'b1001 = NON_DATA} STATE;

STATE PS;
STATE NS;

// Next state Registers
reg [2:0] next_state_val;
reg next_tx_done;
reg [7:0] next_data_pts;
reg next_enable_timer;

// Combinational Logic

/* Process flow - Use tx_packet as a trigger signal, wait for 8 ticks from the 25/3 timer, then transition to the next state.
   The state determines what is pushed to pTs shift register, and what the encoder toggles dPlus and dMinus as
*/

always_comb NS_LOGIC:
begin

case(PS)

IDLE: if (tx_packet == 2'd0) 
      NS = IDLE;
 
      else if (tx_packet == 2'd1) begin
      NS = SYNC;
      next_enable_timer = 1'b1;
      end

SYNC: if (tick8 == 1'b1)
       NS = PID;
       else 
       NS = SYNC;

PID: if ((tick8 == 1'b1)&& (tx_packet == 2'd1)) 
     NS = DATA_R;
     else if ((tick8 == 1'b1) && (tx_packet == 2'd2))
     NS = ACK;
     else if ((tick8 == 1'b1) && (tx_packet == 2'd3))
     NS = NACK;
     else 
     NS = PID;

DATA_R: NS = DATA_T;
DATA_T: if (tick8 == 1'b1);
        NS = CRC_UP;
        else
        NS = DATA_T;
CRC_UP: if(tick8 == 1'b1))
	NS = CRC_LOW;

CRC_LOW: if (tick8 == 1'b1))
         NS =  EOP1;
EOP1:    if(tick8 == 1'b1)
         NS = EOP2;
EOP2:   if (tick8 == 1'b1)
         NS = IDLE;

endcase
end

always_comb OUTPUT_LOGIC:
begin

next_data_pts = data_pts;
next_state_val = state_val;

case(PS)

IDLE: 	begin
		next_data_pts = 8'b0;
		next_state_val = 3'd0;
	end
PID:  begin
	
	if (tx_packet == 2'd0) 
        	next_data_pts = {4'd15, 4'd0};

        else if(tx_packet == 2'd1)
        	next_data_pts = {4'd12, 4'd3};

        else if(tx_packet == 2'd2)
        	next_data_pts = {4'd13, 4'd2};

        else if(tx_packet == 2'd3)
        	next_data_pts = {4'd5, 4'd10};
      
      next_state_val = 3'd1
      end
SYNC: begin
      next_data_pts = 8'd1;
      next_state_val = 3'd5;
      end

DATA_T: begin
	next_data_pts = data_buffer;
        next_state_val = 3'd2;
	end
EOP1:
    next_state_val = 3'd3;

EOP2:
    next_state_val = 3'd4;

endcase
end

endmodule
  
       
                  