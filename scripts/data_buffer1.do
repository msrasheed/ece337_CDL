onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Top level}
add wave -noupdate -color Gold /tb_data_buffer/tb_test_case
add wave -noupdate -color Gold /tb_data_buffer/tb_clk
add wave -noupdate -color Gold /tb_data_buffer/tb_n_rst
add wave -noupdate -divider Inputs
add wave -noupdate /tb_data_buffer/tb_clear
add wave -noupdate -group {Host to Endpoint} /tb_data_buffer/tb_store_rx_packet_data
add wave -noupdate -group {Host to Endpoint} /tb_data_buffer/tb_rx_packet_data
add wave -noupdate -group {Host to Endpoint} /tb_data_buffer/tb_get_rx_data
add wave -noupdate -group {Endpoint to Host} /tb_data_buffer/tb_buffer_reserved
add wave -noupdate -group {Endpoint to Host} /tb_data_buffer/tb_data_size
add wave -noupdate -group {Endpoint to Host} /tb_data_buffer/tb_tx_data
add wave -noupdate -group {Endpoint to Host} /tb_data_buffer/tb_store_tx_data
add wave -noupdate -group {Endpoint to Host} /tb_data_buffer/tb_get_tx_packet_data
add wave -noupdate -radix decimal /tb_data_buffer/tb_buffer_occupancy
add wave -noupdate -divider Outputs
add wave -noupdate -color {Medium Orchid} -radix decimal /tb_data_buffer/tb_buffer_occupancy
add wave -noupdate -color Cyan -radix decimal /tb_data_buffer/expected_buffer_occupancy
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb_data_buffer/tb_rx_data
add wave -noupdate -color Cyan -radix hexadecimal /tb_data_buffer/expected_rx_array
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb_data_buffer/tb_tx_packet_data
add wave -noupdate -color Cyan -radix hexadecimal /tb_data_buffer/expected_tx_packet_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94811 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 299
configure wave -valuecolwidth 330
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
WaveRestoreZoom {0 ps} {262280 ps}
