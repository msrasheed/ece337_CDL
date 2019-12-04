onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold /tb_usb_ahb_soc/tb_test_case
add wave -noupdate -color Gold -radix decimal /tb_usb_ahb_soc/tb_test_case_num
add wave -noupdate -color Salmon /tb_usb_ahb_soc/tb_clk
add wave -noupdate -color Salmon /tb_usb_ahb_soc/tb_n_rst
add wave -noupdate -divider {ahb bus}
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_hsel
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_htrans
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_hburst
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_haddr
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_hsize
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_hwrite
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_hwdata
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_hrdata
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_hresp
add wave -noupdate -color Cyan /tb_usb_ahb_soc/tb_hready
add wave -noupdate -group {ahb in sigs} /tb_usb_ahb_soc/DUT/AHBSLAVE/rx_data_ready
add wave -noupdate -group {ahb in sigs} /tb_usb_ahb_soc/DUT/AHBSLAVE/rx_transfer_active
add wave -noupdate -group {ahb in sigs} /tb_usb_ahb_soc/DUT/AHBSLAVE/rx_error
add wave -noupdate -group {ahb in sigs} /tb_usb_ahb_soc/DUT/AHBSLAVE/tx_transfer_active
add wave -noupdate -group {ahb in sigs} /tb_usb_ahb_soc/DUT/AHBSLAVE/tx_error
add wave -noupdate -group {ahb in sigs} /tb_usb_ahb_soc/DUT/AHBSLAVE/buffer_reserved
add wave -noupdate -group {ahb in sigs} /tb_usb_ahb_soc/DUT/AHBSLAVE/get_rx_data
add wave -noupdate -group {ahb in sigs} /tb_usb_ahb_soc/DUT/AHBSLAVE/store_tx_data
add wave -noupdate -group {buff sigs} /tb_usb_ahb_soc/DUT/DBUFF/clear
add wave -noupdate -group {buff sigs} /tb_usb_ahb_soc/DUT/DBUFF/write_pointer
add wave -noupdate -group {buff sigs} /tb_usb_ahb_soc/DUT/DBUFF/read_pointer
add wave -noupdate -group {buff sigs} /tb_usb_ahb_soc/DUT/DBUFF/buffer_occupancy
add wave -noupdate -group {rx sigs} /tb_usb_ahb_soc/DUT/RXBLOCK/RX_packet_data
add wave -noupdate -group {rx sigs} /tb_usb_ahb_soc/DUT/RXBLOCK/store_RX_packet_data
add wave -noupdate -group {rx sigs} /tb_usb_ahb_soc/DUT/RXBLOCK/RX_packet
add wave -noupdate -group {tx sigs} /tb_usb_ahb_soc/DUT/TXBLOCK/tx_done
add wave -noupdate -group {tx sigs} /tb_usb_ahb_soc/DUT/TXBLOCK/get_tx_packet
add wave -noupdate -group {tx sigs} /tb_usb_ahb_soc/DUT/TXBLOCK/tx_packet_data
add wave -noupdate -divider usb
add wave -noupdate /tb_usb_ahb_soc/tb_d_mode
add wave -noupdate -divider {usb rx}
add wave -noupdate -color {Indian Red} /tb_usb_ahb_soc/tb_dplus_in
add wave -noupdate -color {Indian Red} /tb_usb_ahb_soc/tb_dminus_in
add wave -noupdate -color {Indian Red} -radix decimal /tb_usb_ahb_soc/tb_numbyte
add wave -noupdate -color {Indian Red} -radix binary /tb_usb_ahb_soc/tb_byte_out
add wave -noupdate -divider {usb tx}
add wave -noupdate -color Violet /tb_usb_ahb_soc/tb_dplus_out
add wave -noupdate -color Violet /tb_usb_ahb_soc/tb_dminus_out
add wave -noupdate -color Violet /tb_usb_ahb_soc/tb_eop_out_detected
add wave -noupdate -color Violet -radix binary /tb_usb_ahb_soc/tb_outcoming_byte_stable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58849359 ps} 0}
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
WaveRestoreZoom {0 ps} {225750 ns}
