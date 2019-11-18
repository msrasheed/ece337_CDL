onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_clk
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_n_rst
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_clear
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_store_rx_packet_data
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_rx_packet_data
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_get_rx_data
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_data_size
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_tx_data
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_store_tx_data
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_get_tx_packet_data
add wave -noupdate -group {DUT Inputs} /tb_data_buffer/tb_buffer_reserved
add wave -noupdate -group {DUT Outputs} -color Gold /tb_data_buffer/tb_buffer_occupancy
add wave -noupdate -group {DUT Outputs} -color Gold /tb_data_buffer/tb_rx_data
add wave -noupdate -group {DUT Outputs} -color Gold /tb_data_buffer/tb_tx_packet_data
add wave -noupdate -group {Test Data} -color Blue /tb_data_buffer/tb_test_data
add wave -noupdate -group {Test Data} -color Blue /tb_data_buffer/tb_bit_size
add wave -noupdate -expand -group Inputs /tb_data_buffer/DUT/n_rst
add wave -noupdate -expand -group Inputs /tb_data_buffer/DUT/clear
add wave -noupdate -expand -group Inputs /tb_data_buffer/DUT/get_rx_data
add wave -noupdate -expand -group Inputs /tb_data_buffer/DUT/data_size
add wave -noupdate -expand -group Inputs /tb_data_buffer/DUT/tx_data
add wave -noupdate -expand -group Inputs /tb_data_buffer/DUT/store_tx_data
add wave -noupdate -expand -group Inputs /tb_data_buffer/DUT/get_tx_packet_data
add wave -noupdate -expand -group Inputs /tb_data_buffer/DUT/buffer_reserved
add wave -noupdate -expand -group Outputs /tb_data_buffer/DUT/buffer_occupancy
add wave -noupdate -expand -group Outputs /tb_data_buffer/DUT/buffer_occupancy_next
add wave -noupdate -expand -group Outputs /tb_data_buffer/DUT/rx_data
add wave -noupdate -expand -group Outputs /tb_data_buffer/DUT/rx_data_next
add wave -noupdate -expand -group Outputs /tb_data_buffer/DUT/tx_packet_data
add wave -noupdate -expand -group Outputs /tb_data_buffer/DUT/tx_packet_data_next
add wave -noupdate /tb_data_buffer/DUT/clk
add wave -noupdate /tb_data_buffer/DUT/store_rx_packet_data
add wave -noupdate /tb_data_buffer/DUT/rx_packet_data
add wave -noupdate -expand -group {Write Pointer} -radix decimal /tb_data_buffer/DUT/write_pointer
add wave -noupdate -expand -group {Write Pointer} -radix decimal /tb_data_buffer/DUT/write_pointer_next
add wave -noupdate -group {Read Pointer} /tb_data_buffer/DUT/read_pointer
add wave -noupdate -group {Read Pointer} /tb_data_buffer/DUT/read_pointer_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61755 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {129792 ps}
