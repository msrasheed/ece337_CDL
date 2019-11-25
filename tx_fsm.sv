
module tx_fsm(input wire clk, input wire n_rst,input wire [1:0] tx_packet,  output reg tx_done, output reg crc_enable, output reg [7:0] data_pts, input wire [7:0] tx_packet_data, input wire [6:0] tx_packet_data_size,
              output reg [2:0] state_val,input wire flag, output reg load_enable, output reg enable_timer, input wire [15:0] crc, output reg clear_timer, output reg get_tx_packet, input wire shift_strobe, output reg clear_crc);

typedef enum bit [4:0]{IDLE = 5'b00000, SYNC = 5'b00001, PID = 5'b00010, DATA_T = 5'b00011, CRC_UP = 5'b00100, CRC_LOW = 5'b00101, EOP1 = 5'b00110, EOP2 = 5'b00111, ACK = 5'b01000, NACK = 5'b01001, SYNC_L = 5'b01010, PID_L = 5'b01011, EOP3 = 5'b01100, TXDONE = 5'b01101, DATA_L = 5'b01110, CRC_UP_L = 5'b01111, CRC_LOW_L = 5'b10000} STATE;

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
reg [1:0] go;
reg [1:0] next_go;

// Comparison register : Byte Count : Keep Requesting data from the data buffer until byte count >= tx_packet_data_size + 2

reg[7:0] byte_count;
reg [7:0] next_byte_count;
reg next_crc_enable;
reg next_clear_crc;

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
next_byte_count = byte_count;
next_get_tx_packet = '0;
next_crc_enable = '0;
next_clear_crc = '0;

case(PS)

IDLE: if (tx_packet == 2'd0) begin
      NS = IDLE;
      next_clear_timer = 1'b1;
      next_enable_timer = 1'b0;
      end
 
      else begin
      NS = SYNC_L;
      next_clear_crc = 1'b1;
      next_enable_timer = 1'b1;
      next_clear_timer = 1'b0;
      end
SYNC_L: NS = SYNC;
SYNC:  if (flag == 1'b1) begin
       NS = PID_L;
       next_byte_count = byte_count + 1;
       end
       else 
       NS = SYNC;
PID_L: NS = PID;
PID:  if ((flag == 1'b1)&& (go == 2'd1)) begin
      NS = DATA_L;
      next_byte_count = byte_count + 1;
      end

      else if ((flag == 1'b1) && (go == 2'd2)) begin
      NS = EOP1;
      next_byte_count = byte_count + 1;
      end

      else if ((flag == 1'b1) && (go == 2'd3)) begin
      NS = EOP1;
      next_byte_count = byte_count + 1;
      end

      else 
      NS = PID;
DATA_L: begin
	NS = DATA_T;
	next_crc_enable = 1'b1;
	end

DATA_T: begin
        if ((byte_count == (tx_packet_data_size + 7'd1)) && (flag == 1'b1)) begin 
        NS = CRC_UP_L;
        next_byte_count = byte_count + 1;
        end
        
        else if (flag == 1'b1) begin
        NS = DATA_L;
        next_byte_count = byte_count + 1;
        next_get_tx_packet = 1'b1;
        end
        next_crc_enable = 1'b1;
	end

CRC_UP_L: begin
	NS = CRC_UP;
        end
CRC_UP: begin
	if(flag == 1'b1) begin

	NS = CRC_LOW_L;
        next_byte_count = byte_count + 1;
        end

        else begin
        NS = CRC_UP;
	end
	end

CRC_LOW_L: begin 
	   NS = CRC_LOW;
	   end
CRC_LOW: begin
	 if (flag == 1'b1) begin
         NS =  EOP1;
         next_byte_count = byte_count + 1;
         end

         else begin
         NS = CRC_LOW;
         end
	 end

EOP1:    if(shift_strobe == 1'b1) 
         NS = EOP2;

EOP2:   if (shift_strobe == 1'b1)
	NS = EOP3;

EOP3: if (shift_strobe == 1'b1)
	NS = TXDONE;

TXDONE: NS = IDLE;

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
next_go = go;

case(PS)

IDLE: 	begin
		next_data_pts = 8'b0;
		next_state_val = 3'd0;
		next_go = tx_packet;
	end
PID_L: begin
	
	if (go == 2'd0) 
        	next_data_pts = {4'd15, 4'd0};

        else if(go == 2'd1)
        	next_data_pts = {4'd12, 4'd3};

        else if(go == 2'd2)
        	next_data_pts = {4'd2, 4'd13};

        else if(go == 2'd3)
        	next_data_pts = {4'd10, 4'd5};
	next_load_enable = 1'd1;
      next_state_val = 3'd1;
      end
PID:  begin
	
	if (go == 2'd0) 
        	next_data_pts = {4'd15, 4'd0};

        else if(go == 2'd1)
        	next_data_pts = {4'd3, 4'd12};

        else if(go == 2'd2)
        	next_data_pts = {4'd2, 4'd13};

        else if(go == 2'd3)
        	next_data_pts = {4'd10, 4'd5};
	next_load_enable = 1'd0;      
      next_state_val = 3'd1;
      end
SYNC_L: begin
	next_load_enable = 1'd1;
	next_data_pts = 8'b10000000;
	next_state_val = 3'd2;
	end
SYNC: begin
      next_load_enable = 1'd0;
      next_data_pts = 8'b10000000;
      next_state_val = 3'd2;
      end
DATA_L: begin
        next_load_enable = 1'd1;
	next_data_pts = tx_packet_data;
        next_state_val = 3'd3;
      
	end
DATA_T: begin
        next_load_enable = 1'd0;
	next_data_pts = tx_packet_data;
        next_state_val = 3'd3;

	end
CRC_UP_L: begin
         next_load_enable = 1'd1;
	next_data_pts = crc[7:0];
        next_state_val = 3'd4;

        end
CRC_UP: begin
        next_load_enable = 1'd0;
	next_data_pts = crc[7:0];
        next_state_val = 3'd4;

        end
CRC_LOW_L:begin

	 next_load_enable = 1'd1;
         next_data_pts = crc[15:8];
         next_state_val = 3'd5;
         end
CRC_LOW: begin
	
	 next_load_enable = 1'd0;
             next_data_pts = crc[15:8];
         next_state_val = 3'd5;
         end

EOP1:    begin
        next_load_enable = 1'd0;
        next_state_val = 3'd6;
        end

EOP2: begin
    next_load_enable = 1'd0;
    next_state_val = 3'd7;
    end
EOP3: begin
	next_load_enable = 1'b0;
	next_state_val = 3'd0;
	end
TXDONE:	begin
		next_data_pts = 8'b0;
		next_state_val = 3'd0;
		next_tx_done = 1'b1;
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
	crc_enable <= '0;
	go <= '0;
	clear_crc <= '0;

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
	crc_enable <= next_crc_enable;
	go <= next_go;
        clear_crc <= next_clear_crc;

end
end
endmodule
