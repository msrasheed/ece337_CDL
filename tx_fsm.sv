module tx_fsm(input wire clk, input wire n_rst,input wire [1:0] tx_packet,  output reg tx_done, output reg crc_enable, output reg [7:0] data_pts, input wire [7:0] tx_packet_data, input wire [6:0] tx_packet_data_size,
              output reg [2:0] state_val,input wire flag, output reg load_enable, output reg enable_timer, input wire [15:0] crc, output reg clear_timer, output reg get_tx_packet);

typedef enum bit [3:0]{IDLE = 4'b0000, SYNC = 4'b0001, PID = 4'b0010, DATA_T = 4'b0011, CRC_UP = 4'b0100, CRC_LOW = 4'b0101, EOP1 = 4'b0110, EOP2 = 4'b0111, ACK = 4'b1000, NACK = 4'b1001, WACK = 4'b1010, WNACK = 4'b1011, WSYNC = 4'b1100,
                       WPID = 4'b1101, WDATA = 4'b1111} STATE;

STATE PS;
STATE NS;

// Next state Registers

reg [2:0] next_state_val;
reg next_tx_done;
reg [7:0] next_data_pts;
reg next_enable_timer;
reg next_clear_timer;
reg next_load_enable;            // Should be asserted so that data is loadede into the parallel shift register at the appropriate times
reg next_get_tx_packet;

// Comparison register : Byte Count : Keep Requesting data from the data buffer until byte count >= tx_packet_data_size + 2

reg[7:0] byte_count;
reg [7:0] next_byte_count;

// Combinational Logic

/* Process flow - Use tx_packet as a trigger signal, wait for 8 ticks from the 25/3 timer, then transition to the next state.
   The state determines what is pushed to pTs shift register, and what the encoder toggles dPlus and dMinus as.
   
   tx_packet | 00 | IDLE | 01 | DATA | 10 | ACK  | 11 | NACK |
*/

always_comb NS_LOGIC:
begin
next_get_tx_packet = 1'b0;
next_clear_timer = clear_timer;
next_enable_timer = enable_timer;
next_byte_count = '0;
next_get_tx_packet = '0;


case(PS)

IDLE: if (tx_packet == 2'd0) begin
      NS = IDLE;
      next_clear_timer = 1'b1;
      next_enable_timer = 1'b0;
      end
 
      else begin
      NS = WSYNC;
      next_enable_timer = 1'b1;
      next_clear_timer = 1'b0;
      end
WSYNC: NS = SYNC;

SYNC:  if (flag == 1'b1) begin
       NS = WPID;
       next_byte_count = byte_count + 1;
       end
       else 
       NS = SYNC;
WPID: NS = PID;
PID:  if ((flag == 1'b1)&& (tx_packet == 2'd1)) begin
      NS = WDATA;
      next_byte_count = byte_count + 1;
      end

      else if ((flag == 1'b1) && (tx_packet == 2'd2)) begin
      NS = WACK;
      next_byte_count = byte_count + 1;
      end

      else if ((flag == 1'b1) && (tx_packet == 2'd3)) begin
      NS = WNACK;
      next_byte_count = byte_count + 1;
      end

      else 
      NS = PID;
WDATA: NS = DATA_T;
WACK: NS = ACK;
WNACK: NS = NACK;

DATA_T: if (byte_count == tx_packet_data_size + 7'd2) begin 
        NS = CRC_UP;
        next_byte_count = byte_count + 1;
        end

        else begin
        NS = DATA_T;
        next_byte_count = byte_count + 1;
        next_get_tx_packet = 1'b1;
        end

CRC_UP: if(flag == 1'b1) begin

	NS = CRC_LOW;
        next_byte_count = byte_count + 1;
        end

        else 
        NS = CRC_UP;

CRC_LOW: if (flag == 1'b1) begin
         NS =  EOP1;
         next_byte_count = byte_count + 1;
         end

         else begin
         NS = CRC_LOW;
         end

EOP1:    if(flag == 1'b1) 
         NS = EOP2;

EOP2:   NS = IDLE;

ACK:    if (flag == 1'd1) begin
        next_byte_count = byte_count + 1;
        NS = EOP1;
        end 
        else
        NS = ACK;

NACK: 	if (flag == 1'd1) begin
        next_byte_count = byte_count + 1;
        NS = EOP1;
        end
        
	else 
        NS = NACK;
        
endcase
end

always_comb OUTPUT_LOGIC:
begin

next_data_pts = data_pts;
next_state_val = state_val;
next_load_enable = '0;
next_tx_done = '0;

case(PS)

IDLE: 	begin
		next_data_pts = 8'b0;
		next_state_val = 3'd0;
                next_load_enable = '0;
	end
PID:  begin
	
	if (tx_packet == 2'd0) 
        	next_data_pts = {4'd15, 4'd0};

        else if(tx_packet == 2'd1)
        	next_data_pts = {4'd12, 4'd3};

        else if(tx_packet == 2'd2)
        	next_data_pts = {4'd11, 4'd4};

        else if(tx_packet == 2'd3)
        	next_data_pts = {4'd10, 4'd5};
      
      next_state_val = 3'd1;
      next_load_enable = '0;
      end
WSYNC: next_load_enable = 1'b1;
WPID : next_load_enable = 1'b1;
WACK: next_load_enable = 1'b1;
WNACK: next_load_enable = 1'b1;
WDATA: next_load_enable = 1'b1;

SYNC: begin
      next_load_enable = 1'd1;
      next_data_pts = 8'b10000000;
      next_state_val = 3'd2;
      next_load_enable = '0;
      end

DATA_T: begin
        next_load_enable = 1'd1;
	next_data_pts = tx_packet_data;
        next_state_val = 3'd3;
	next_load_enable = '0;
	end

CRC_UP: begin
         next_load_enable = 1'd1;
	next_data_pts = crc[15:8];
        next_state_val = 3'd4;
       next_load_enable = '0;
        end

CRC_LOW: begin
	 next_load_enable = 1'd1;
         next_data_pts = crc[7:0];
         next_state_val = 3'd5;
         next_load_enable = '0;
         end

EOP1:    begin
        next_load_enable = 1'd0;
	next_data_pts = 8'd0;
        next_state_val = 3'd6;
        end

EOP2: begin
    next_load_enable = 1'd0;
    next_state_val = 3'd7;
    next_data_pts = 8'd0;
    next_tx_done = 1'b1;
    end

ACK: 
begin
next_load_enable = 1'b0;
next_state_val = 3'd2;
next_data_pts = {4'd13, 4'd2};
end

NACK:
begin
next_load_enable = 1'b0;
next_state_val = 3'd2;
next_data_pts = {4'd10, 4'd5};
end
endcase
end

always_ff @(posedge clk, negedge n_rst) begin

if (n_rst == 1'b0)
begin
	PS <= IDLE;
	byte_count <= '0;
	data_pts <= '0;
	state_val <= '0;
        get_tx_packet <= '0;
        load_enable <= '0;
        tx_done <= '0;
        enable_timer <= '0;
	clear_timer <= '0;
end

else begin
	PS <= NS;
	byte_count <= next_byte_count;
	data_pts <= next_data_pts;
	state_val <= next_state_val;     
        get_tx_packet <= next_get_tx_packet;
        load_enable <= next_load_enable;
        tx_done <= next_tx_done;
	enable_timer <= next_enable_timer;
	clear_timer <= next_clear_timer;

end
end
endmodule
  
       
                  