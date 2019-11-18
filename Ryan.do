onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_USB_RX/tb_clk
add wave -noupdate /tb_USB_RX/tb_n_rst
add wave -noupdate /tb_USB_RX/tb_d_plus
add wave -noupdate /tb_USB_RX/tb_d_minus
add wave -noupdate /tb_USB_RX/rxmod/decoder/decoded
add wave -noupdate /tb_USB_RX/rxmod/decoder/eop
add wave -noupdate /tb_USB_RX/rxmod/controller/state
add wave -noupdate /tb_USB_RX/rxmod/timer/en_sample
add wave -noupdate /tb_USB_RX/rxmod/decoder/value
add wave -noupdate /tb_USB_RX/rxmod/decoder/next_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {132159 ps} 0}
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
WaveRestoreZoom {0 ps} {1050 ns}
