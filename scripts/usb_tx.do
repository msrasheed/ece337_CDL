onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_usb_tx/tb_clk
add wave -noupdate /tb_usb_tx/tb_n_rst
add wave -noupdate /tb_usb_tx/tb_tx_packet
add wave -noupdate /tb_usb_tx/tb_tx_packet_data
add wave -noupdate /tb_usb_tx/tb_tx_packet_data_size
add wave -noupdate /tb_usb_tx/tb_dplus_out
add wave -noupdate /tb_usb_tx/tb_dminus_out
add wave -noupdate /tb_usb_tx/tb_tx_done
add wave -noupdate /tb_usb_tx/tb_get_tx_packet
add wave -noupdate /tb_usb_tx/tb_test_num
add wave -noupdate /tb_usb_tx/tb_test_case
add wave -noupdate /tb_usb_tx/tb_expected_dplus_out
add wave -noupdate /tb_usb_tx/tb_expected_dminus_out
add wave -noupdate /tb_usb_tx/tb_expected_tx_done
add wave -noupdate /tb_usb_tx/tb_expected_get_tx_packet_data
add wave -noupdate /tb_usb_tx/tb_expected_dplus_packet
add wave -noupdate /tb_usb_tx/tb_expected_dminus_packet
add wave -noupdate /tb_usb_tx/tb_expected_crc
add wave -noupdate /tb_usb_tx/encoder_out
add wave -noupdate /tb_usb_tx/period
add wave -noupdate /tb_usb_tx/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61428 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 218
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
WaveRestoreZoom {0 ps} {464896 ps}
