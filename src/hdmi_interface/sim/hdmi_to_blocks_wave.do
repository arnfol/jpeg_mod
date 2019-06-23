onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hdmi_to_blocks_tb/i_hdmi_to_blocks/clk
add wave -noupdate /hdmi_to_blocks_tb/i_hdmi_to_blocks/en
add wave -noupdate /hdmi_to_blocks_tb/i_hdmi_to_blocks/rst_n
add wave -noupdate -expand -group HDMI /hdmi_to_blocks_tb/i_hdmi_to_blocks/hdmi_data_cb
add wave -noupdate -expand -group HDMI /hdmi_to_blocks_tb/i_hdmi_to_blocks/hdmi_data_cr
add wave -noupdate -expand -group HDMI /hdmi_to_blocks_tb/i_hdmi_to_blocks/hdmi_data_y
add wave -noupdate -expand -group HDMI /hdmi_to_blocks_tb/i_hdmi_to_blocks/hdmi_data_valid
add wave -noupdate -expand -group HDMI /hdmi_to_blocks_tb/i_hdmi_to_blocks/hdmi_h_sync
add wave -noupdate -expand -group HDMI /hdmi_to_blocks_tb/i_hdmi_to_blocks/hdmi_v_sync
add wave -noupdate -expand -group BLOCKs /hdmi_to_blocks_tb/i_hdmi_to_blocks/blk_data_cb
add wave -noupdate -expand -group BLOCKs /hdmi_to_blocks_tb/i_hdmi_to_blocks/blk_data_cr
add wave -noupdate -expand -group BLOCKs /hdmi_to_blocks_tb/i_hdmi_to_blocks/blk_data_y
add wave -noupdate -expand -group BLOCKs /hdmi_to_blocks_tb/i_hdmi_to_blocks/blk_eob
add wave -noupdate -expand -group BLOCKs /hdmi_to_blocks_tb/i_hdmi_to_blocks/blk_sob
add wave -noupdate -expand -group BLOCKs /hdmi_to_blocks_tb/i_hdmi_to_blocks/blk_sof
add wave -noupdate -expand -group BLOCKs /hdmi_to_blocks_tb/i_hdmi_to_blocks/blk_valid
add wave -noupdate -expand -group BUF1 /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf1
add wave -noupdate -expand -group BUF1 /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf1_en
add wave -noupdate -expand -group BUF1 /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf1_o
add wave -noupdate -expand -group BUF1 /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf1_rd_addr
add wave -noupdate -expand -group BUF1 /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf1_wr_en
add wave -noupdate -radix decimal /hdmi_to_blocks_tb/i_hdmi_to_blocks/block
add wave -noupdate -radix decimal /hdmi_to_blocks_tb/i_hdmi_to_blocks/block_elem
add wave -noupdate -radix decimal /hdmi_to_blocks_tb/i_hdmi_to_blocks/block_line
add wave -noupdate -radix decimal /hdmi_to_blocks_tb/i_hdmi_to_blocks/rd_cntr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {257 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1050 ns}
