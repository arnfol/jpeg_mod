onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /blocks_to_hdmi_tb/i_blocks_to_hdmi/clk
add wave -noupdate /blocks_to_hdmi_tb/i_blocks_to_hdmi/rst_n
add wave -noupdate -expand -group Blocks /blocks_to_hdmi_tb/i_blocks_to_hdmi/blk_data_cb
add wave -noupdate -expand -group Blocks /blocks_to_hdmi_tb/i_blocks_to_hdmi/blk_data_cr
add wave -noupdate -expand -group Blocks /blocks_to_hdmi_tb/i_blocks_to_hdmi/blk_data_y
add wave -noupdate -expand -group Blocks /blocks_to_hdmi_tb/i_blocks_to_hdmi/blk_eob
add wave -noupdate -expand -group Blocks /blocks_to_hdmi_tb/i_blocks_to_hdmi/blk_sob
add wave -noupdate -expand -group Blocks /blocks_to_hdmi_tb/i_blocks_to_hdmi/blk_sof
add wave -noupdate -expand -group Blocks /blocks_to_hdmi_tb/i_blocks_to_hdmi/blk_valid
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf1
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf1_o
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf1_wr_en
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf2
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf2_o
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf2_wr_en
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf_empty
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf_full
add wave -noupdate -expand -group BUFs /blocks_to_hdmi_tb/i_blocks_to_hdmi/buf_select
add wave -noupdate -expand -group HDMI /blocks_to_hdmi_tb/i_blocks_to_hdmi/hdmi_data_cb
add wave -noupdate -expand -group HDMI /blocks_to_hdmi_tb/i_blocks_to_hdmi/hdmi_data_cr
add wave -noupdate -expand -group HDMI /blocks_to_hdmi_tb/i_blocks_to_hdmi/hdmi_data_valid
add wave -noupdate -expand -group HDMI /blocks_to_hdmi_tb/i_blocks_to_hdmi/hdmi_data_y
add wave -noupdate -expand -group HDMI /blocks_to_hdmi_tb/i_blocks_to_hdmi/hdmi_h_sync
add wave -noupdate -expand -group HDMI /blocks_to_hdmi_tb/i_blocks_to_hdmi/hdmi_v_sync
add wave -noupdate -expand -group Controls /blocks_to_hdmi_tb/i_blocks_to_hdmi/state
add wave -noupdate -expand -group Controls /blocks_to_hdmi_tb/i_blocks_to_hdmi/got_sof
add wave -noupdate -expand -group Controls /blocks_to_hdmi_tb/i_blocks_to_hdmi/h_sync_cntr
add wave -noupdate -expand -group Controls /blocks_to_hdmi_tb/i_blocks_to_hdmi/v_sync_cntr
add wave -noupdate -expand -group Controls /blocks_to_hdmi_tb/i_blocks_to_hdmi/line_num
add wave -noupdate -expand -group Controls /blocks_to_hdmi_tb/i_blocks_to_hdmi/pix_cntr
add wave -noupdate -expand -group {W&R CNTRs} /blocks_to_hdmi_tb/i_blocks_to_hdmi/block
add wave -noupdate -expand -group {W&R CNTRs} /blocks_to_hdmi_tb/i_blocks_to_hdmi/block_elem
add wave -noupdate -expand -group {W&R CNTRs} /blocks_to_hdmi_tb/i_blocks_to_hdmi/block_line
add wave -noupdate -expand -group {W&R CNTRs} /blocks_to_hdmi_tb/i_blocks_to_hdmi/rd_cntr
add wave -noupdate -expand -group {W&R CNTRs} /blocks_to_hdmi_tb/i_blocks_to_hdmi/rd_cntr_en
add wave -noupdate -expand -group {W&R CNTRs} /blocks_to_hdmi_tb/i_blocks_to_hdmi/wr_cntr
add wave -noupdate -expand -group {W&R CNTRs} /blocks_to_hdmi_tb/i_blocks_to_hdmi/wr_cntr_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
