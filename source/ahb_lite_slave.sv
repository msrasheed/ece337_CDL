
module ahb_lite_slave(input wire clk, input wire n_rst, input wire [1:0] coefficient_num, input wire err, input wire modwait, output reg [15:0] fir_coefficient, input wire [3:0] haddr, input wire [1:0] htrans, input wire hwrite, input wire [15:0] hwdata,
                      output reg [15:0] hrdata, output reg hresp, input wire [15:0] fir_out, input wire hsel, input wire hsize, output reg data_ready, output reg new_coefficient_set, output reg [15:0] sample_data);


typedef enum bit {IDLE = 1'b0, TR= 1'b1} STATE;
typedef enum bit [1:0] {ZERO = 2'b00, ASSERT = 2'b01, STALL = 2'b10} DATA_STATE;
DATA_STATE PSt;
DATA_STATE NSt; 
STATE PS;
STATE NS;

// We create the memory registers for the slave 

reg [15:0] sr;               // Status register
reg [15:0] res;              // Error Status Register
reg [15:0] nsr;              // New Sample Register
reg [15:0] f0;              // F0 coefficient
reg [15:0] f1;              // F1 coefficient
reg [15:0] f2;              // F2 coeffcient
reg [15:0] f3;              // F3 coefficient
reg [7:0] ncset;            // New coefficient Set signal

// Next States for the configuration registers for the 

reg [15:0] next_sr;               // Status register
reg [15:0] next_res;              // Error Status Register
reg [15:0] next_nsr;              // New Sample Register
reg [15:0] next_f0;              // F0 coefficient
reg [15:0] next_f1;              // F1 coefficient
reg [15:0] next_f2;              // F2 coeffcient
reg [15:0] next_f3;              // F3 coefficient
reg [7:0]  next_ncset;            // New Coefficient Set Register
//reg [15:0] next_hrdata;

// Next State for the Slave Error Response
//reg next_hresp;

// Next State for the Outputs of AHB Slave
reg next_new_coefficient_set;
reg next_data_ready;

//Next State for haddr
reg [3:0] haddr_reg;
reg hsize_reg;
reg hwrite_reg;
reg hsel_reg;
reg htrans_reg;

always_comb NEXT_STATE_LOGIC:
begin
NS = PS;
case(PS)

// Only valid states - IDLE and NON-SEQ
IDLE: if (hsel == 1'b1 && htrans == 2'b10) 
      NS = TR;
      else
      NS = IDLE;

TR: if (hsel == 1'b0 || htrans == 2'b00)
       NS = IDLE;
    else
    NS = TR;
   
endcase
end

// Sequential Logic

always_ff @(posedge clk, negedge n_rst) begin

if (n_rst == 1'b0) begin
	
	PS <= IDLE;
	sr <=  '0;
	res <= '0;
        nsr <= '0;
        f0 <= '0;
	f1 <= '0;
        f2 <= '0;
        f3 <= '0;
        ncset <= '0;
        //hresp <= '0;
        data_ready <= '0;
        //hrdata <= '0;
	PSt <= ZERO;
        haddr_reg <= '0;
        hsize_reg <= '0;
        hwrite_reg <= '0;
        htrans_reg <= '0;
        hsel_reg <= '0;
      
end
else begin

	PS <= NS;
	sr <= next_sr;
	res <= next_res;
        nsr <= next_nsr;
        f0 <= next_f0;
	f1 <= next_f1;
        f2 <= next_f2;
        f3 <= next_f3;
        ncset <= next_ncset;
        //hresp <= next_hresp;
        data_ready <= next_data_ready;
        //hrdata <= next_hrdata;
	haddr_reg <= haddr;
        hsize_reg <= hsize;
	PSt <= NSt;
        hwrite_reg <= hwrite;
        htrans_reg <= htrans;
        hsel_reg <= hsel;
end
end

// accesses addresses in the APB slave

always_comb OUTPUT_LOGIC:

begin

next_nsr = nsr;
next_f0 = f0;
next_f1 = f1;
next_f2 = f2;
next_f3 = f3;
next_ncset = ncset;
hresp = hresp;
next_new_coefficient_set = new_coefficient_set;
//next_hrdata = hrdata;
next_res = res;
hrdata = '0;
hresp = '0;

// Status Register Settings
next_sr = {8'd0,err,6'd0,(ncset[0]|modwait)};

case({haddr_reg, hsize_reg})

// 0x0
5'b00000: if (PS == TR & hwrite_reg == 1'b1)
      	  hresp = 1'b1;
      	  else if (PS == TR & hwrite_reg == 1'b0)
          hrdata = {8'b0,sr[7:0]};

5'b00001: if (PS == TR & hwrite_reg == 1'b1)
          hresp = 1'b1;
          else if (PS == TR & hwrite_reg == 1'b0)
          hrdata = sr;

// 0x1 
5'b00010: if (PS == TR & hwrite_reg == 1'b1)
      	  hresp = 1'b1;
          else if (PS == TR & hwrite_reg == 1'b0)
          hrdata = {sr[15:8], 8'b0};

5'b00011: if (PS == TR & hwrite_reg == 1'b1)
          hresp = 1'b1;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = sr;
// 0x2
5'b00100: if (PS == TR & hwrite_reg == 1'b1)
      hresp = 1'b1;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {8'b0,fir_out[7:0]};

5'b00101: if (PS == TR & hwrite_reg == 1'b1)
      hresp = 1'b1;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = fir_out;
// 0x3
5'b00110: if (PS == TR & hwrite_reg == 1'b1)
      hresp = 1'b1;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {fir_out[15:8], 8'b0};

5'b00111: if (PS == TR & hwrite_reg == 1'b1)
      hresp = 1'b1;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = fir_out;

// 0x4
5'b01000: if (PS == TR & hwrite_reg == 1'b1)
       next_nsr = {nsr[15:8], hwdata[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {8'b0,nsr[7:0]};

5'b01001: if (PS == TR & hwrite_reg == 1'b1)
       next_nsr = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
       hrdata = nsr;

// 0x5 
5'b01000: if (PS == TR & hwrite_reg == 1'b1)
       next_nsr = {hwdata[15:8], nsr[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
       hrdata = {nsr[15:8], 8'b0};

5'b01001: if (PS == TR & hwrite_reg == 1'b1)
       next_nsr = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
       hrdata = nsr;

// 0x6
5'b01100: if (PS == TR & hwrite_reg == 1'b1)
       next_f0 = {f0[15:8],hwdata[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
       hrdata = {8'b0,f0[7:0]};

5'b01101: if (PS == TR & hwrite_reg == 1'b1)
       next_f0 = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = f0;

// 0x7
5'b01110: if (PS == TR & hwrite_reg == 1'b1)
       next_f0 = {hwdata[15:8], f0[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {f0[15:8], 8'b0};

5'b01111: if (PS == TR & hwrite_reg == 1'b1)
       next_f0 = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = f0;

// 0x8
5'b10000: if (PS == TR & hwrite_reg == 1'b1)
       next_f1 = {f1[15:8], hwdata[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {8'b0,f1[7:0]};

5'b01101: if (PS == TR & hwrite_reg == 1'b1)
       next_f1 = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = next_f1;

// 0x9
5'b10010: if (PS == TR & hwrite_reg == 1'b1)
       next_f0 = {hwdata[15:8], f1[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {f1[15:8], 8'b0};

5'b10011: if (PS == TR & hwrite_reg == 1'b1)
       next_f1 = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = f1;
// 0xA
5'b10100: if (PS == TR & hwrite_reg == 1'b1)
       next_f2 = {f2[15:8], hwdata[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {8'b0,f2[7:0]};

5'b10101: if (PS == TR & hwrite_reg == 1'b1)
       next_f2 = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = f2;

// 0xB
5'b10110: if (PS == TR & hwrite_reg == 1'b1)
       next_f0 = {hwdata[15:8], f2[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {f2[15:8], 8'b0};

5'b10111: if (PS == TR & hwrite_reg == 1'b1)
       next_f2 = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = f2;

// 0xC
5'b11000: if (PS == TR & hwrite_reg == 1'b1)
       next_f3 = {f3[15:8], hwdata[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {8'b0,f3[7:0]};

5'b11001: if (PS == TR & hwrite_reg == 1'b1)
       next_f3 = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = f3;

// 0xD
5'b11010: if (PS == TR & hwrite_reg == 1'b1)
       next_f3 = {hwdata[15:8], f3[7:0]};
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = {f3[15:8], 8'b0};

5'b11011: if (PS == TR & hwrite_reg == 1'b1)
       next_f3 = hwdata;
      else if (PS == TR & hwrite_reg == 1'b0)
      hrdata = f3;

// 0xE
5'b11100:  if(coefficient_num == 2'd3)
           next_ncset = '0;      
	   else if (PS == TR & hwrite_reg == 1'b1)
           next_ncset = hwdata[7:0];
           else if (PS == TR & hwrite_reg == 1'b0)
           hrdata = {8'b0, ncset};


5'b11101: if(coefficient_num == 2'd3)
           next_ncset = '0;      
      	   else if (PS == TR & hwrite_reg == 1'b1)
      	   next_ncset = hwdata[7:0];
      	   else if (PS == TR & hwrite_reg == 1'b0)
      	   hrdata = {8'b0, ncset};

// invalid 0xF
5'b11110: hresp = 1'b1;
5'b11111: hresp = 1'b1;
endcase
end

always_comb FIR_COEFF:

begin
fir_coefficient = '0;
if (coefficient_num == 2'd0)
fir_coefficient = f0;

else if (coefficient_num == 2'd1)
fir_coefficient = f1;

else if (coefficient_num == 2'd2)
fir_coefficient = f2;

else if(coefficient_num == 2'd3)
fir_coefficient = f3;

end

always_comb DATA_READY_STATE:
begin
NSt = PSt;
case(PSt)
ZERO:   if ((haddr_reg == 4'd4) | (haddr_reg == 4'd5) && hwrite_reg == 1'b1)
	NSt = ASSERT;
	else
	NSt = ZERO;
ASSERT: NSt = STALL;
STALL: NSt = ZERO;
endcase
end


always_comb DATA_READY:
begin
next_data_ready = data_ready;

case(NSt)
	ZERO: next_data_ready = 1'b0;
	ASSERT: next_data_ready = 1'b1;
	STALL: next_data_ready = 1'b1;
endcase
end

assign new_coefficient_set = ncset[0];
assign sample_data = nsr;

endmodule

