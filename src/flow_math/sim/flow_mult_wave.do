onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /flow_mult_tb/dut/clk
add wave -noupdate /flow_mult_tb/dut/en
add wave -noupdate /flow_mult_tb/dut/rst_n
add wave -noupdate -expand -group IN /flow_mult_tb/dut/in_valid
add wave -noupdate -expand -group IN -childformat {{{/flow_mult_tb/dut/in_data[0]} -radix decimal}} -expand -subitemconfig {{/flow_mult_tb/dut/in_data[0]} {-radix decimal}} /flow_mult_tb/dut/in_data
add wave -noupdate -expand -group IN -childformat {{{/flow_mult_tb/dut/in_mult[0]} -radix decimal}} -expand -subitemconfig {{/flow_mult_tb/dut/in_mult[0]} {-radix decimal}} /flow_mult_tb/dut/in_mult
add wave -noupdate -expand -group IN /flow_mult_tb/dut/in_eob
add wave -noupdate -expand -group IN /flow_mult_tb/dut/in_sob
add wave -noupdate -expand -group IN /flow_mult_tb/dut/in_sof
add wave -noupdate -expand -group OUT /flow_mult_tb/dut/out_valid
add wave -noupdate -expand -group OUT -expand /flow_mult_tb/dut/out_data
add wave -noupdate -expand -group OUT /flow_mult_tb/dut/out_eob
add wave -noupdate -expand -group OUT /flow_mult_tb/dut/out_sob
add wave -noupdate -expand -group OUT /flow_mult_tb/dut/out_sof
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {289971 ps} 0} {{Cursor 2} {9421265 ps} 0}
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
WaveRestoreZoom {251151 ps} {332025 ps}
