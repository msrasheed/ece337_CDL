onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold /tb_USB_RX/tb_test_case
add wave -noupdate -color Gold /tb_USB_RX/tb_test_case_num
add wave -noupdate /tb_USB_RX/tb_check
add wave -noupdate -color Salmon /tb_USB_RX/tb_clk
add wave -noupdate -color Salmon /tb_USB_RX/tb_n_rst
add wave -noupdate -divider input
add wave -noupdate /tb_USB_RX/tb_d_plus
add wave -noupdate /tb_USB_RX/tb_d_minus
add wave -noupdate /tb_USB_RX/tb_byte_out
add wave -noupdate /tb_USB_RX/tb_numbyte
add wave -noupdate /tb_USB_RX/tb_prev_vals
add wave -noupdate -divider output
add wave -noupdate -expand -group RX_packet -color Turquoise /tb_USB_RX/tb_RX_packet
add wave -noupdate -expand -group RX_packet /tb_USB_RX/tb_expected_RX_packet
add wave -noupdate -expand -group RX_packet_data -color Turquoise /tb_USB_RX/tb_RX_packet_data
add wave -noupdate -expand -group RX_packet_data /tb_USB_RX/tb_expected_RX_packet_data
add wave -noupdate -expand -group store_RX_packet_data -color Turquoise /tb_USB_RX/tb_store_RX_packet_data
add wave -noupdate -expand -group store_RX_packet_data /tb_USB_RX/tb_expected_store_RX_packet_data
add wave -noupdate -divider misc
add wave -noupdate /tb_USB_RX/tb_crc_5bit
add wave -noupdate /tb_USB_RX/tb_crc_16bit
add wave -noupdate /tb_USB_RX/tb_usb_addr
add wave -noupdate /tb_USB_RX/tb_usb_endpoint
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12499380 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 244
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
WaveRestoreZoom {9009740 ps} {9901520 ps}

