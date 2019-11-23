onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {From AHB} /tb_data_buffer/DUT/get_rx_data
add wave -noupdate -expand -group {From AHB} /tb_data_buffer/DUT/data_size
add wave -noupdate -expand -group {From AHB} /tb_data_buffer/DUT/buffer_reserved
add wave -noupdate -expand -group {From AHB} /tb_data_buffer/DUT/store_tx_data
add wave -noupdate -expand -group {From AHB} /tb_data_buffer/DUT/tx_data
add wave -noupdate -group {From RX} /tb_data_buffer/DUT/rx_packet_data
add wave -noupdate -group {From RX} /tb_data_buffer/DUT/store_rx_packet_data
add wave -noupdate -group {From RX} /tb_data_buffer/DUT/rx_data
add wave -noupdate -group {From RX} /tb_data_buffer/DUT/rx_data_next
add wave -noupdate /tb_data_buffer/DUT/n_rst
add wave -noupdate /tb_data_buffer/DUT/clear
add wave -noupdate /tb_data_buffer/DUT/clk
add wave -noupdate -expand -group {From TX} /tb_data_buffer/DUT/get_tx_packet_data
add wave -noupdate -expand -group {From TX} /tb_data_buffer/DUT/tx_packet_data
add wave -noupdate -expand -group {Buffer Occupancy} -radix decimal -childformat {{{/tb_data_buffer/DUT/buffer_occupancy[6]} -radix decimal} {{/tb_data_buffer/DUT/buffer_occupancy[5]} -radix decimal} {{/tb_data_buffer/DUT/buffer_occupancy[4]} -radix decimal} {{/tb_data_buffer/DUT/buffer_occupancy[3]} -radix decimal} {{/tb_data_buffer/DUT/buffer_occupancy[2]} -radix decimal} {{/tb_data_buffer/DUT/buffer_occupancy[1]} -radix decimal} {{/tb_data_buffer/DUT/buffer_occupancy[0]} -radix decimal}} -subitemconfig {{/tb_data_buffer/DUT/buffer_occupancy[6]} {-height 17 -radix decimal} {/tb_data_buffer/DUT/buffer_occupancy[5]} {-height 17 -radix decimal} {/tb_data_buffer/DUT/buffer_occupancy[4]} {-height 17 -radix decimal} {/tb_data_buffer/DUT/buffer_occupancy[3]} {-height 17 -radix decimal} {/tb_data_buffer/DUT/buffer_occupancy[2]} {-height 17 -radix decimal} {/tb_data_buffer/DUT/buffer_occupancy[1]} {-height 17 -radix decimal} {/tb_data_buffer/DUT/buffer_occupancy[0]} {-height 17 -radix decimal}} /tb_data_buffer/DUT/buffer_occupancy
add wave -noupdate -expand -group {Buffer Occupancy} -radix decimal /tb_data_buffer/DUT/buffer_occupancy_next
add wave -noupdate -expand -group {Write Pointer} -radix decimal /tb_data_buffer/DUT/write_pointer
add wave -noupdate -expand -group {Write Pointer} -radix decimal /tb_data_buffer/DUT/write_pointer_next
add wave -noupdate -expand -group Memory /tb_data_buffer/DUT/mem
add wave -noupdate -expand -group Memory /tb_data_buffer/DUT/next_mem
add wave -noupdate -expand -group {Read Pointer} -radix decimal /tb_data_buffer/DUT/read_pointer
add wave -noupdate -expand -group {Read Pointer} -radix decimal /tb_data_buffer/DUT/read_pointer_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {175000 ps} 0}
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
WaveRestoreZoom {101 ns} {229 ns}
