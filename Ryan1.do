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
add wave -noupdate /tb_USB_RX/rxmod/timer/en_sample
add wave -noupdate /tb_USB_RX/rxmod/shift_register/RX_packet_data
add wave -noupdate /tb_USB_RX/rxmod/byte_counter/byte_done
add wave -noupdate /tb_USB_RX/rxmod/controller/pass_5_bit
add wave -noupdate /tb_USB_RX/rxmod/controller/state
add wave -noupdate /tb_USB_RX/tb_byte_out
add wave -noupdate /tb_USB_RX/tb_numbyte
add wave -noupdate /tb_USB_RX/tb_prev_vals
add wave -noupdate -divider {Decoder signals}
add wave -noupdate /tb_USB_RX/rxmod/decoder/decoded
add wave -noupdate /tb_USB_RX/rxmod/decoder/next_value
add wave -noupdate /tb_USB_RX/rxmod/decoder/value
add wave -noupdate -divider {BSD signals}
add wave -noupdate /tb_USB_RX/rxmod/bsd/state
add wave -noupdate /tb_USB_RX/rxmod/bsd/ignore_bit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2139337 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 205
configure wave -valuecolwidth 183
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
WaveRestoreZoom {2101461 ps} {2143299 ps}
