onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group GLOBAL /dct_matrix_tb/clk
add wave -noupdate -expand -group GLOBAL /dct_matrix_tb/rst_n
add wave -noupdate -expand -group {DCT INPUT} -radix unsigned /dct_matrix_tb/in_valid
add wave -noupdate -expand -group {DCT INPUT} -radix unsigned /dct_matrix_tb/in_data
add wave -noupdate -expand -group {DCT INPUT} -radix unsigned /dct_matrix_tb/in_eob
add wave -noupdate -expand -group {DCT INPUT} -radix unsigned /dct_matrix_tb/in_sob
add wave -noupdate -expand -group {DCT INPUT} -radix unsigned /dct_matrix_tb/in_sof
add wave -noupdate -expand -group {DCT OUTPUT} -radix unsigned /dct_matrix_tb/out_valid
add wave -noupdate -expand -group {DCT OUTPUT} -radix unsigned /dct_matrix_tb/out_data
add wave -noupdate -expand -group {DCT OUTPUT} -radix unsigned /dct_matrix_tb/out_eob
add wave -noupdate -expand -group {DCT OUTPUT} -radix unsigned /dct_matrix_tb/out_sob
add wave -noupdate -expand -group {DCT OUTPUT} -radix unsigned /dct_matrix_tb/out_sof
add wave -noupdate -expand -group ERRORS /dct_matrix_tb/error_data
add wave -noupdate -expand -group ERRORS /dct_matrix_tb/error_ctrl
add wave -noupdate -expand -group ERRORS -childformat {{{/dct_matrix_tb/result[1]} -radix decimal} {{/dct_matrix_tb/result[0]} -radix decimal}} -subitemconfig {{/dct_matrix_tb/result[1]} {-radix decimal} {/dct_matrix_tb/result[0]} {-radix decimal}} /dct_matrix_tb/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20915000 ps} 0} {{Cursor 2} {203000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 184
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
WaveRestoreZoom {0 ps} {105 us}
