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
add wave -noupdate -divider crc
add wave -noupdate -color Turquoise /tb_USB_RX/rxmod/crc5/clear
add wave -noupdate /tb_USB_RX/rxmod/crc5/serial_in
add wave -noupdate /tb_USB_RX/rxmod/crc5/shift_en
add wave -noupdate -color Turquoise /tb_USB_RX/rxmod/crc5/pass
add wave -noupdate -radix binary /tb_USB_RX/rxmod/crc5/Q
add wave -noupdate /tb_USB_RX/rxmod/decoder/decoded
add wave -noupdate /tb_USB_RX/rxmod/shift_register/RX_packet_data
add wave -noupdate /tb_USB_RX/rxmod/controller/state
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
WaveRestoreCursors {{Cursor 1} {511945 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 244
configure wave -valuecolwidth 150
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
WaveRestoreZoom {0 ps} {1181723 ps}
