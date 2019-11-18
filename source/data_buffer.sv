// $Id: $
// File name:   data_buffer.sv
// Created:     11/10/2019
// Author:      Melissa Nguyen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 
//    Info: This block handles the buffering of the data packet payloads in FIFO queue fashion.
//    Inputs:
//       -Clear [1-bit]: Used to clear the data the Data Buffer currently holds
//       -Store_RX_Packet_Data [1-bit]: Tells the Data_Buffer that the RX wants to store data.
//       -RX_Packet_Data [8-bits]: Byte of data to store inside the buffer
//       -Get_TX_Packet_Data [1-bit]: Tells the Data Buffer that the TX wants data to be sent to it
//       -Data_Size [2-bits]: Size of the data to be sent from the AHB-Lite Slave
//       -TX_Data [32-bits]: Data sent from the AHB-Lite Slave
//       -Store_TX_Data [1-bit]: Tells the Data Buffer that the AHB-Lite Slave has data to send to it
//       -Get_RX_Data [1-bit]: Tells the Data Buffer to send data within it to the AHB-Lite Slave
//       -Buffer_Occupancy [7-bits]: How many bytes of data are currently stored inside the Data Buffer
//    
//    Outputs:
//       -TX_Packet_Data [8-bits] : Byte of data to send to the TX
//       -RX_Data        [32-bits]: Data sent to the AHB-Lite Slave

module data_buffer
(
	input wire clk, n_rst,
	input wire clear,			// From Protocol Controller
	input wire store_rx_packet_data,	// From RX
	input wire [7:0] rx_packet_data,	// From RX
	input wire get_rx_data,			// From AHB
	input wire [1:0] data_size,		// From AHB
	input wire [31:0] tx_data,		// From AHB
	input wire store_tx_data,		// From AHB
	input wire get_tx_packet_data,		// From TX
	input wire buffer_reserved,		// From AHB To Indicate that the AHB is trying to do stuff
	
	output reg [6:0] buffer_occupancy,	// To AHB and Protocol Controller
	output reg [31:0] rx_data,		// To AHB
	output reg [7:0] tx_packet_data	// To TX
);

// Initializations
	reg [63:0][7:0] mem;
	reg [63:0][7:0] next_mem;
	reg [5:0] write_pointer;
	reg [5:0] write_pointer_next;
	reg [5:0] read_pointer;
	reg [5:0] read_pointer_next;
	reg [31:0] rx_data_next;
	reg [7:0] tx_packet_data_next;
	reg [6:0] buffer_occupancy_next;

// Sequential Logic for the Write Pointer Counter
	always_ff @ (posedge clk, negedge n_rst)
	begin : WRITE_LOGIC
		if (n_rst == 1'b0)
			write_pointer <= 6'b0;
		else
			write_pointer <= write_pointer_next;
	end

	always_comb
	begin : WRITE_LOGIC_NEXT
		write_pointer_next = write_pointer;
		if (clear == 1'b1)
			write_pointer_next = 6'b0;
		else if (write_pointer == 6'd63)
			write_pointer_next = write_pointer;
		else if (store_tx_data == 1'b1 && buffer_reserved == 1'b1) begin
			case (data_size)
				2'd0: write_pointer_next = write_pointer + 1;
				2'd1: write_pointer_next = write_pointer + 2;
				2'd2: write_pointer_next = write_pointer + 3;
				2'd3: write_pointer_next = write_pointer + 4;
				default: write_pointer_next = write_pointer;
			endcase
		end
		else if (store_rx_packet_data == 1'b1 && buffer_reserved == 1'b0)
			write_pointer_next = write_pointer + 1;	//From RX
	
	end

// Sequential Logic for the Read Pointer Counter
	always_ff @ (posedge clk, negedge n_rst)
	begin : READ_LOGIC
		if (n_rst == 1'b0)
			read_pointer <= 6'b0;
		else
			read_pointer <= read_pointer_next;
	end

	always_comb
	begin : READ_LOGIC_NEXT
		read_pointer_next = read_pointer;
		if (clear == 1'b1)
			read_pointer_next = 6'b0;
		else if (read_pointer == 6'd63)
			read_pointer_next <= read_pointer_next;
		else if (get_rx_data == 1'b1)
			read_pointer_next = read_pointer + 4;	// From AHB
		else if (get_tx_packet_data == 1'b1)
			read_pointer_next = read_pointer + 1;	//From RX
			
	end

// Sequential Logic for the Buffer_Occupancy Output
	always_ff @ (posedge clk, negedge n_rst)
	begin : BUFFER_OCCUPANCY_LOGIC
		if (n_rst == 1'b0)
			buffer_occupancy <= 7'b0;
		else
			buffer_occupancy <= buffer_occupancy_next;		// Does this work out? Should I consider mem[0] as having no data? might work better for the pointer
	end

	always_comb
	begin : BUFFER_OCCUPANCY_NS_LOGIC
		buffer_occupancy_next = (write_pointer_next - read_pointer_next);
	end

// Combinational Logic for RX_Data Logic
	always_ff @ (posedge clk, negedge n_rst)
	begin : RX_DATA_AND_TX_DATA_OUTPUT_LOGIC
		if (n_rst == 1'b0) begin
			tx_packet_data <= 8'b0;
			rx_data <= 32'b0;
		end
		else begin
			tx_packet_data <= tx_packet_data_next;
			rx_data <= rx_data_next;
		end
	end

	always_comb						// Does this need to be sequential??
	begin : RX_DATA_AND_TX_DATA_NS_LOGIC
		tx_packet_data_next = 8'b0;
		rx_data_next = 32'b0;
		if (get_rx_data == 1'b1) begin
			rx_data_next[7:0] = mem[read_pointer];
			rx_data_next[15:8] = mem[(read_pointer + 1)];
			rx_data_next[23:16] = mem[(read_pointer + 2)];
			rx_data_next[31:24] = mem[(read_pointer + 3)];
		end
		if (get_tx_packet_data == 1'b1)
			tx_packet_data_next = mem[read_pointer];
	end

// Sequential Logic for MEM Block
	always_ff @ (posedge clk, negedge n_rst)
	begin : MEM_BLOCK_LOGIC
		if (n_rst == 1'b0)
			mem <= '0;
		else
			mem[63:0] <= next_mem[63:0];
	end

// Combinational Logic for Next MEM
	always_comb
	begin : NEXT_MEM_LOGIC
		next_mem = mem;
		if (store_rx_packet_data == 1'b1 && buffer_reserved == 1'b0) begin
			next_mem[write_pointer] = rx_packet_data;
		end
		else if (store_tx_data == 1'b1 && buffer_reserved == 1'b1) begin
			case(data_size)
				2'd0: next_mem[write_pointer] = tx_data[7:0];
				2'd1: begin 
					next_mem[write_pointer] = tx_data[7:0];
					next_mem[(write_pointer + 1)] = tx_data[15:8];
				      end
				2'd2: begin
					next_mem[write_pointer] = tx_data[7:0];
					next_mem[(write_pointer + 1)] = tx_data[15:8];
					next_mem[(write_pointer + 2)] = tx_data[23:16];
				      end
				2'd3: begin
					next_mem[write_pointer] = tx_data[7:0];
					next_mem[(write_pointer + 1)] = tx_data[15:8];
					next_mem[(write_pointer + 2)] = tx_data[23:16];
					next_mem[(write_pointer + 3)] = tx_data[31:24];
				      end
			endcase
		end
	end
	
endmodule
