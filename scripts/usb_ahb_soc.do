onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_usb_ahb_soc/tb_test_case
add wave -noupdate -radix decimal /tb_usb_ahb_soc/tb_test_case_num
add wave -noupdate /tb_usb_ahb_soc/tb_check_tag
add wave -noupdate /tb_usb_ahb_soc/tb_mismatch
add wave -noupdate /tb_usb_ahb_soc/tb_check
add wave -noupdate /tb_usb_ahb_soc/tb_i
add wave -noupdate -color Salmon /tb_usb_ahb_soc/tb_clk
add wave -noupdate -color Salmon /tb_usb_ahb_soc/tb_n_rst
add wave -noupdate -divider {ahb bus}
add wave -noupdate /tb_usb_ahb_soc/tb_hsel
add wave -noupdate /tb_usb_ahb_soc/tb_htrans
add wave -noupdate /tb_usb_ahb_soc/tb_hburst
add wave -noupdate /tb_usb_ahb_soc/tb_haddr
add wave -noupdate /tb_usb_ahb_soc/tb_hsize
add wave -noupdate /tb_usb_ahb_soc/tb_hwrite
add wave -noupdate /tb_usb_ahb_soc/tb_hwdata
add wave -noupdate /tb_usb_ahb_soc/tb_hrdata
add wave -noupdate /tb_usb_ahb_soc/tb_hresp
add wave -noupdate /tb_usb_ahb_soc/tb_hready
add wave -noupdate -divider usb
add wave -noupdate /tb_usb_ahb_soc/tb_d_mode
add wave -noupdate -divider {usb rx}
add wave -noupdate /tb_usb_ahb_soc/tb_dplus_in
add wave -noupdate /tb_usb_ahb_soc/tb_dminus_in
add wave -noupdate -radix decimal /tb_usb_ahb_soc/tb_numbyte
add wave -noupdate -radix binary /tb_usb_ahb_soc/tb_byte_out
add wave -noupdate -radix binary /tb_usb_ahb_soc/DUT/RXBLOCK/RX_packet
add wave -noupdate /tb_usb_ahb_soc/DUT/RXBLOCK/controller/state
add wave -noupdate /tb_usb_ahb_soc/DUT/RXBLOCK/shift_register/RX_packet_data
add wave -noupdate /tb_usb_ahb_soc/DUT/RXBLOCK/shift_register/serial_in
add wave -noupdate -divider {usb tx}
add wave -noupdate /tb_usb_ahb_soc/tb_dplus_out
add wave -noupdate /tb_usb_ahb_soc/tb_dminus_out
add wave -noupdate /tb_usb_ahb_soc/tb_eop_out_detected
add wave -noupdate /tb_usb_ahb_soc/tb_dm_out_hist
add wave -noupdate /tb_usb_ahb_soc/tb_dp_out_hist
add wave -noupdate /tb_usb_ahb_soc/tb_outcoming_byte
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {886940 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 162
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
WaveRestoreZoom {0 ps} {2020096 ps}
