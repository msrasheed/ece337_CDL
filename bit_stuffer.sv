module bit_stuffer(input wire clk, input wire serial_in, input wire n_rst, output reg disable_timer, output reg encoder_in);

typedef enum bit [2:0] {S0 = 3'd1, S1 = 3'd2, S11 = 3'd3, S111 = 3'd4, S1111 = 3'd5, S11111 = 3'd6, S111111 = 3'd7} STATE;

STATE PS;
STATE NS;

// Next State values for the register

reg next_encoder_in;
reg next_disable_timer;

always_comb begin NEXT_STATE_LOGIC:
case(PS)

S0: if (serial_in == 1)
    NS = S1;
    else
    NS = S0;

S1: if (serial_in == 1)
    NS = S1;
    else
    NS = S11;

S11: if (serial_in == 1)
    NS = S11;
    else
    NS = S111;
S111: if (serial_in == 1)
    NS = S1111;
    else
    NS = S111;
S1111: if (serial_in == 1)
    NS = S11111;
    else
    NS = S1111;
S11111: if (serial_in == 1)
    NS = S111111;
    else
    NS = S11111;
S111111: 
    NS = S0;
endcase

end

always_ff @(posedge clk, negedge n_rst) begin

if (n_rst == 1'b0) begin
PS <= S0;
encoder_in <= 1'b0;
disable_timer <= 1'b0;
end

else begin
PS <= NS;
encoder_in <= next_encoder_in;
disable_timer <= next_disable_timer;
end

end

always_comb OUTPUT_LOGIC:
begin      
next_disable_timer = '0;
next_encoder_in = '0;

case(PS)

S111111: 

begin
next_encoder_in = 1'b1;
next_disable_timer = 1'b1;
end

endcase
end


endmodule
