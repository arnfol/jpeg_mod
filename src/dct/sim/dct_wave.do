onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dct_tb/clk
add wave -noupdate /dct_tb/rst_n
add wave -noupdate -radix unsigned /dct_tb/in_valid
add wave -noupdate -radix unsigned /dct_tb/in_data
add wave -noupdate -radix unsigned /dct_tb/in_eob
add wave -noupdate -radix unsigned /dct_tb/in_sob
add wave -noupdate -radix unsigned /dct_tb/in_sof
add wave -noupdate -radix unsigned /dct_tb/out_valid
add wave -noupdate -radix unsigned /dct_tb/out_data
add wave -noupdate -radix unsigned /dct_tb/out_eob
add wave -noupdate -radix unsigned /dct_tb/out_sob
add wave -noupdate -radix unsigned /dct_tb/out_sof
add wave -noupdate /dct_tb/error_data
add wave -noupdate /dct_tb/error_ctrl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {9050 ns} {18257 ns}
