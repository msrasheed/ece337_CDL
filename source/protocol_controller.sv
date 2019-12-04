// $Id: $
// File name:   protocol_controller.sv
// Created:     11/10/2019
// Author:      Melissa Nguyen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 
//    Info: This block handles the enforcment of proper transfer sequences and any related high-level error handling. Moore-style FSM
//    Inputs:
//       -RX_Packet [3-bits]: Indicates the PID
//       -TX_Done   [1-bit] : Indicates when TX is done sending a packet
//       -Buffer_Reserved [1-bit]: Indicates when AHB-Lite wants to send data into the Data Buffer module
//       -TX_Packet_Data_Size [7-bits]: Indicates number of bytes of data the AHB-Lite Slave wants to send into the Data Buffer Module
//       -Buffer_Occupancy [7-bits]: Indicates the number of bytes of data the Data Buffer contains
//    
//    Outputs:
//       -RX_Data_Ready: When data from Host is ready to be sent into the AHB-Lite Slave
//       -RX_Transfer_Active: When the RX is currently receiving info
//       -RX_Error: Set high when a packet from the Host is bad
//       -TX_Transfer_Active: When the TX is sending data to the Host
//       -TX_Error: Set when the Host sends a NAK
//       -Clear: Set when a packet from the Host is bad
//       -TX_Packet [2-bits]: Sends a PID (IDLE, DATA, ACK, NAK) to the TX
//       -D_Mode: Indicates whether the RX is listening or the TX is sending

module protocol_controller
(
	input wire clk, n_rst,
	input wire [2:0] rx_packet,		// From RX
	input wire tx_done,			// From TX
	input wire buffer_reserved,		// From AHB
	input wire [6:0] tx_packet_data_size,	// From AHB
	input wire [6:0] buffer_occupancy,	// From Data Buffer

	output reg rx_data_ready,		// To AHB
	output reg rx_transfer_active,		// to AHB
	output reg rx_error,			// To AHB
	output reg tx_transfer_active,		// To AHB
	output reg tx_error,			// To AHB
	output reg clear,			// To Data Buffer
	output reg [1:0] tx_packet,		// To TX
	output reg d_mode			// To Host

);
	// Initializations for the States
	typedef enum bit [4:0] {IDLE, 
				// RX Cycle
				RX_ACTIVE, HE_DATA, HE_GOOD, SEND_ACK, HE_PACKET_DONE_WAIT, DATA_BUFFER_WAIT,
				// HE: Data Still in Data Buffer Error 
				HE_ERROR_WAIT, HE_ERROR_WAIT_DATA, HE_ERROR_START, HE_TX_ERROR, HE_PACKET_ERROR_WAIT,
				// TX Cycle
				AHB_STORE, TX_ACTIVE, EH_DATA, EH_PACKET_DONE_WAIT, EH_DONE,
				// EH: Host sends back a NAK
				TX_ERROR_SET,
				// RX Data Bad
				HE_BAD,
				// TX Needs to Send a NAK
				WAIT_RX_BAD, WAIT_RX_DATA, WAIT_RX_IDLE, EH_ERROR_START, EH_TX_ERROR, EH_PACKET_ERROR_WAIT
				} stateType;

	stateType PS;
	stateType NS;
	
	// Initializations for the PID from the RX
	localparam RX_IDLE 	= 3'b000;
	localparam RX_DATA   	= 3'b001;
	localparam RX_OUT  	= 3'b010;
	localparam RX_IN 	= 3'b011;
	localparam RX_ACK 	= 3'b100;
	localparam RX_NAK 	= 3'b101;
	localparam RX_BAD  	= 3'b110;

	// Initializations for the PID to the TX
	localparam TX_IDLE 	= 2'b00;
	localparam TX_DATA 	= 2'b01;
	localparam TX_ACK 	= 2'b10;
	localparam TX_NAK 	= 2'b11;

	// Sequential Block for the Current State Logic
	always_ff @ (posedge clk, negedge n_rst) 
	begin : PS_LOGIC
		if (n_rst == 1'b0)
			PS <= IDLE;
		else
			PS <= NS;
	end

	// Combinational Block for Next State Logic
	always_comb
	begin : NS_LOGIC
		NS = PS;
		case (PS)
			IDLE:	begin	// Beginning State
					if (rx_packet == RX_OUT)		// Host to Endpoint Transfer
						NS = RX_ACTIVE;			
					else if (rx_packet == RX_IN)		// Data Buffer is Empty so Error
						NS = EH_ERROR_START;	
					else if (rx_packet == RX_BAD)
						NS = EH_ERROR_START;	
					else if (buffer_reserved == 1'b1)	// Endpoint to Host Transfer
						NS = AHB_STORE;
				end
			
			// Host to Endpoint
			RX_ACTIVE:	begin	
						if (rx_packet == RX_DATA)
							NS = HE_DATA;		// Set RX_Transfer_Active
					end
			HE_DATA:	begin
						if (rx_packet == IDLE)
							NS = HE_GOOD;		// Host packet is good
						else if (rx_packet == RX_BAD)
							NS = WAIT_RX_BAD;		// Host packet is bad
					end
                        WAIT_RX_BAD:    begin
						if (rx_packet == RX_IDLE)
							NS = HE_BAD;
					end
			HE_GOOD:	begin
						NS = SEND_ACK;			// Tell TX to send the ACK
					end
			SEND_ACK:	begin
						NS = HE_PACKET_DONE_WAIT;	// Wait till the TX is done sending ACK
					end
			HE_PACKET_DONE_WAIT: 	begin
							if (tx_done == 1'b1)
								NS = DATA_BUFFER_WAIT;	// Wait until the data is sent to the AHB
						end
			DATA_BUFFER_WAIT:	begin
							if (buffer_occupancy == 1'b0)
								NS = IDLE;
							else if (rx_packet == RX_IN)
								NS = HE_ERROR_WAIT;
							else if (rx_packet == RX_OUT)
								NS = HE_ERROR_WAIT;
						end

			// Host to Endpoint Data Still in Data Buffer
			HE_ERROR_WAIT: begin
						if (rx_packet == RX_DATA)
							NS = HE_ERROR_WAIT_DATA;				
					end
			HE_ERROR_WAIT_DATA: begin
						if (rx_packet == RX_IDLE)
							NS = HE_ERROR_START;
					    end
			HE_ERROR_START:	begin
						NS = HE_TX_ERROR;		// Start of sending back a NAK
					end
			HE_TX_ERROR:	begin
						NS = HE_PACKET_ERROR_WAIT;	// Wait till the TX is done sending packet
					end
			HE_PACKET_ERROR_WAIT:	begin
							if (tx_done == 1'b1)
								NS = DATA_BUFFER_WAIT;	// Go back to wait for the data buffer to be empty since data from the Host may still exists
						end
			
			// Endpoint to Host
			AHB_STORE:	begin
						if ( (tx_packet_data_size == buffer_occupancy) && (rx_packet == RX_IN) )
							NS = TX_ACTIVE;			// Can send data to the Host
						else if (rx_packet == RX_OUT)
							NS = WAIT_RX_DATA;		// Host tried to do something while AHB not done
						else if ( (tx_packet_data_size != buffer_occupancy) && (rx_packet == RX_IN) )
							NS = EH_ERROR_START;		// Host tried to do something while AHB not done
					end
			WAIT_RX_DATA:   begin
						if (rx_packet == RX_DATA)
							NS = WAIT_RX_IDLE;
				 	end
			WAIT_RX_IDLE:   begin
						if (rx_packet == RX_IDLE)
							NS = EH_ERROR_START;
					end
			TX_ACTIVE:	begin
						NS = EH_DATA;	// Wait till the data from the AHB has been sent
					end
			EH_DATA:	begin
						if (buffer_occupancy == 1'b0)
							NS = EH_PACKET_DONE_WAIT;	// Wait till TX sends CRC
					end
			EH_PACKET_DONE_WAIT:	begin
							if (tx_done == 1'b1)
								NS = EH_DONE;
						end
			EH_DONE:	begin
						if (rx_packet == RX_ACK)
							NS = IDLE;
						else if (rx_packet == RX_NAK)
							NS = TX_ERROR_SET;
					end

			// Endpoint to Host: Host sends back a NACK
			TX_ERROR_SET:	begin
						NS = IDLE;
					end

			// Host to Endpoint: Host sends a bad packet
			HE_BAD:	begin
					NS = EH_ERROR_START;	// Setup TX to send a NACK
				end

			// TX Sends Back a NAK
			EH_ERROR_START:	begin
						NS = EH_TX_ERROR;	// Send NACK to TX
					end
			EH_TX_ERROR:	begin
						NS = EH_PACKET_ERROR_WAIT;	// Wait till the TX is done	
					end
			EH_PACKET_ERROR_WAIT:	begin
							if (tx_done == 1'b1)
								NS = IDLE;	// TX done sending NAK Packet
						end
		endcase
	end

	// Initializations for Output
	reg rx_data_ready_next;		// To AHB
	reg rx_transfer_active_next;	// to AHB
	reg rx_error_next;		// To AHB
	reg tx_transfer_active_next;	// To AHB
	reg tx_error_next;		// To AHB
	reg clear_next;			// To Data Buffer
	reg [1:0] tx_packet_next;	// To TX
	reg d_mode_next;

	// Output Sequential Logic
	always_ff @ (posedge clk, negedge n_rst)
	begin : OUTPUT_LOGIC
		if (n_rst == 1'b0) begin
			rx_data_ready <= 1'b0;
			rx_transfer_active <= 1'b0;
			rx_error <= 1'b0;
			tx_transfer_active <= 1'b0;
			tx_error <= 1'b0;
			clear <= 1'b0;
			tx_packet <= IDLE;
			d_mode <= 1'b0;
		end
		else begin
			rx_data_ready <= rx_data_ready_next;
			rx_transfer_active <= rx_transfer_active_next;
			rx_error <= rx_error_next;
			tx_transfer_active <= tx_transfer_active_next;
			tx_error <= tx_error_next;
			clear <= clear_next;
			tx_packet <= tx_packet_next;
			d_mode <= d_mode_next;
		end
	end

	// Combinational Next State Logic
	always_comb
	begin : NEXT_OUTPUT_LOGIC
		// IDLE State Values
		rx_data_ready_next = rx_data_ready;	// Stays the same
		rx_transfer_active_next = 1'b0;
		rx_error_next = rx_error;		// Stays the same
		tx_transfer_active_next = 1'b0;
		tx_error_next = tx_error;		// Stays the same
		clear_next = 1'b0;
		tx_packet_next = IDLE;
		d_mode_next = 1'b0;
		case (NS)
                        IDLE:           begin
						
                                        end
			// Host to Endpoint
			RX_ACTIVE:	begin
						tx_error_next = 1'b0;
						rx_error_next = 1'b0;
						rx_transfer_active_next = 1'b1;
					end
			HE_DATA:	begin
						rx_transfer_active_next = 1'b1;
					end
			HE_GOOD:	begin
						rx_data_ready_next = 1'b1;
						d_mode_next = 1'b1;
						tx_transfer_active_next = 1'b1;
					end
			SEND_ACK:	begin
						tx_transfer_active_next = 1'b1;
						tx_packet_next = TX_ACK;
						d_mode_next = 1'b1;
					end
			HE_PACKET_DONE_WAIT: 	begin
							tx_transfer_active_next = 1'b1;
							d_mode_next = 1'b1;
						end
			DATA_BUFFER_WAIT:	begin	// Waiting until the data is transferred from buffer to ahb
							d_mode_next = 1'b0;
							tx_transfer_active_next = 1'b0;
						end

			// Host to Endpoint Data Still in Data Buffer
			HE_ERROR_START:	begin
						d_mode_next = 1'b1;
						tx_transfer_active_next = 1'b1;
					end
			HE_TX_ERROR:	begin
						tx_transfer_active_next = 1'b1;
						d_mode_next = 1'b1;
						tx_packet_next = TX_NAK;
						rx_error_next = 1'b1;
					end
			HE_PACKET_ERROR_WAIT:	begin
							tx_transfer_active_next = 1'b1;
							d_mode_next = 1'b1;
							rx_error_next = 1'b1;
						end
			
			// Endpoint to Host
			AHB_STORE:	begin
						tx_error_next = 1'b0;
						rx_error_next = 1'b0;
					end
			TX_ACTIVE:	begin
						tx_transfer_active_next = 1'b1;
						d_mode_next = 1'b1;
						tx_packet_next = TX_DATA;
					end
			EH_DATA:	begin
						tx_transfer_active_next = 1'b1;
						d_mode_next = 1'b1;
					end
			EH_PACKET_DONE_WAIT:	begin
							tx_transfer_active_next = 1'b1;
							d_mode_next = 1'b1;
						end
			EH_DONE:	begin
						// Everything low in this state
						clear_next = 1'b1;
					end

			// Endpoint to Host: Host sends back a NACK
			TX_ERROR_SET:	begin
						tx_error_next = 1'b1;
					end
			
			// Host to Endpoint: Host sends a bad packet
			WAIT_RX_BAD:	begin
						rx_transfer_active_next = 1'b1;
					end
			HE_BAD:	begin
					clear_next = 1'b1;
				end

			// TX Sends Back a NAK
			EH_ERROR_START:	begin
						d_mode_next = 1'b1;
						tx_transfer_active_next = 1'b1;
					end
			EH_TX_ERROR:	begin
						tx_transfer_active_next = 1'b1;
						d_mode_next = 1'b1;
						tx_packet_next = TX_NAK;
						rx_error_next = 1'b1;		
					end
			EH_PACKET_ERROR_WAIT:	begin
							tx_transfer_active_next = 1'b1;
							d_mode_next = 1'b1;
						end
		endcase
	end

endmodule 
