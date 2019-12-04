onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Top signals}
add wave -noupdate -color Gold /tb_protocol_controller/tb_test_case
add wave -noupdate -color Gold /tb_protocol_controller/tb_clk
add wave -noupdate -color Gold /tb_protocol_controller/tb_n_rst
add wave -noupdate -divider states
add wave -noupdate -color Blue /tb_protocol_controller/tb_test_state
add wave -noupdate -color Blue -radix symbolic -subitemconfig {{/tb_protocol_controller/DUT/PS[4]} {-color Blue} {/tb_protocol_controller/DUT/PS[3]} {-color Blue} {/tb_protocol_controller/DUT/PS[2]} {-color Blue} {/tb_protocol_controller/DUT/PS[1]} {-color Blue} {/tb_protocol_controller/DUT/PS[0]} {-color Blue}} /tb_protocol_controller/DUT/PS
add wave -noupdate -divider Outputs
add wave -noupdate -expand -group {RX Data Ready} -color {Medium Orchid} /tb_protocol_controller/tb_rx_data_ready
add wave -noupdate -expand -group {RX Data Ready} -color Cyan /tb_protocol_controller/expected_rx_data_ready
add wave -noupdate -expand -group {RX Transfer Active} -color {Medium Orchid} /tb_protocol_controller/tb_rx_transfer_active
add wave -noupdate -expand -group {RX Transfer Active} -color Cyan /tb_protocol_controller/expected_rx_transfer_active
add wave -noupdate -expand -group {RX Error} -color {Medium Orchid} /tb_protocol_controller/tb_rx_error
add wave -noupdate -expand -group {RX Error} -color Cyan /tb_protocol_controller/expected_rx_error
add wave -noupdate -expand -group {TX Transfer Active} -color {Medium Orchid} /tb_protocol_controller/tb_tx_transfer_active
add wave -noupdate -expand -group {TX Transfer Active} -color Cyan /tb_protocol_controller/expected_tx_transfer_active
add wave -noupdate -expand -group {TX Error} -color {Medium Orchid} /tb_protocol_controller/tb_tx_error
add wave -noupdate -expand -group {TX Error} -color Cyan /tb_protocol_controller/expected_tx_error
add wave -noupdate -expand -group Clear -color {Medium Orchid} /tb_protocol_controller/tb_clear
add wave -noupdate -expand -group Clear -color Cyan /tb_protocol_controller/expected_clear
add wave -noupdate -expand -group {TX Packet} -color {Medium Orchid} /tb_protocol_controller/tb_tx_packet
add wave -noupdate -expand -group {TX Packet} -color Cyan /tb_protocol_controller/expected_tx_packet
add wave -noupdate -expand -group D_Mode -color {Medium Orchid} /tb_protocol_controller/tb_d_mode
add wave -noupdate -expand -group D_Mode -color Cyan /tb_protocol_controller/expected_d_mode
add wave -noupdate -divider Inputs
add wave -noupdate -color {Lime Green} /tb_protocol_controller/tb_rx_packet
add wave -noupdate -color {Lime Green} /tb_protocol_controller/tb_tx_done
add wave -noupdate -color {Lime Green} /tb_protocol_controller/tb_buffer_reserved
add wave -noupdate -color {Lime Green} /tb_protocol_controller/tb_tx_packet_data_size
add wave -noupdate -color {Lime Green} /tb_protocol_controller/tb_buffer_occupancy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {65824 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {102256 ps}
