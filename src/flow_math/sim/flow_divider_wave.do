onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /flow_divider_tb/dut/clk
add wave -noupdate /flow_divider_tb/dut/en
add wave -noupdate /flow_divider_tb/dut/rst_n
add wave -noupdate -expand -group IN /flow_divider_tb/dut/in_data
add wave -noupdate -expand -group IN /flow_divider_tb/dut/in_denom
add wave -noupdate -expand -group IN /flow_divider_tb/dut/in_eob
add wave -noupdate -expand -group IN /flow_divider_tb/dut/in_sob
add wave -noupdate -expand -group IN /flow_divider_tb/dut/in_sof
add wave -noupdate -expand -group IN /flow_divider_tb/dut/in_valid
add wave -noupdate -expand -group OUT /flow_divider_tb/dut/out_data
add wave -noupdate -expand -group OUT /flow_divider_tb/dut/out_eob
add wave -noupdate -expand -group OUT /flow_divider_tb/dut/out_sob
add wave -noupdate -expand -group OUT /flow_divider_tb/dut/out_sof
add wave -noupdate -expand -group OUT /flow_divider_tb/dut/out_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {275000 ps} 0}
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
