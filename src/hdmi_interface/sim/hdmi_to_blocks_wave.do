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
add wave -noupdate -group BUFs /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf1_o
add wave -noupdate -group BUFs /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf1_wr_en
add wave -noupdate -group BUFs /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf2_o
add wave -noupdate -group BUFs /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf2_wr_en
add wave -noupdate -group BUFs /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf_empty
add wave -noupdate -group BUFs /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf_full
add wave -noupdate -group BUFs /hdmi_to_blocks_tb/i_hdmi_to_blocks/buf_select
add wave -noupdate -group rd_cntr -radix unsigned /hdmi_to_blocks_tb/i_hdmi_to_blocks/block
add wave -noupdate -group rd_cntr /hdmi_to_blocks_tb/i_hdmi_to_blocks/block_line
add wave -noupdate -group rd_cntr /hdmi_to_blocks_tb/i_hdmi_to_blocks/block_elem
add wave -noupdate -group rd_cntr -radix unsigned /hdmi_to_blocks_tb/i_hdmi_to_blocks/rd_cntr
add wave -noupdate -group rd_cntr /hdmi_to_blocks_tb/i_hdmi_to_blocks/rd_cntr_en
add wave -noupdate -group wr_cntr -radix unsigned /hdmi_to_blocks_tb/i_hdmi_to_blocks/wr_cntr
add wave -noupdate -group wr_cntr /hdmi_to_blocks_tb/i_hdmi_to_blocks/wr_cntr_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44043 ns} 0}
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
WaveRestoreZoom {0 ns} {224170 ns}
