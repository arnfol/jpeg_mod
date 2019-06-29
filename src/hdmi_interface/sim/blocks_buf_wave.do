onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /blocks_buf_tb/i_blocks_buf/clk
add wave -noupdate /blocks_buf_tb/i_blocks_buf/rst_n
add wave -noupdate /blocks_buf_tb/i_blocks_buf/overflow
add wave -noupdate /blocks_buf_tb/i_blocks_buf/fifo_empty
add wave -noupdate /blocks_buf_tb/i_blocks_buf/fifo_full
add wave -noupdate -expand -group OUT /blocks_buf_tb/i_blocks_buf/out_data_cb
add wave -noupdate -expand -group OUT /blocks_buf_tb/i_blocks_buf/out_data_cr
add wave -noupdate -expand -group OUT /blocks_buf_tb/i_blocks_buf/out_data_y
add wave -noupdate -expand -group OUT /blocks_buf_tb/i_blocks_buf/out_eob
add wave -noupdate -expand -group OUT /blocks_buf_tb/i_blocks_buf/out_sob
add wave -noupdate -expand -group OUT /blocks_buf_tb/i_blocks_buf/out_sof
add wave -noupdate -expand -group OUT /blocks_buf_tb/i_blocks_buf/out_valid
add wave -noupdate -expand -group OUT /blocks_buf_tb/i_blocks_buf/out_ready
add wave -noupdate -expand -group IN /blocks_buf_tb/i_blocks_buf/in_data_cb
add wave -noupdate -expand -group IN /blocks_buf_tb/i_blocks_buf/in_data_cr
add wave -noupdate -expand -group IN /blocks_buf_tb/i_blocks_buf/in_data_y
add wave -noupdate -expand -group IN /blocks_buf_tb/i_blocks_buf/in_eob
add wave -noupdate -expand -group IN /blocks_buf_tb/i_blocks_buf/in_sob
add wave -noupdate -expand -group IN /blocks_buf_tb/i_blocks_buf/in_sof
add wave -noupdate -expand -group IN /blocks_buf_tb/i_blocks_buf/in_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {771341 ps} 0}
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
WaveRestoreZoom {688270 ps} {1221172 ps}
