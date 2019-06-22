transcript on
vlib work

vlog -sv +incdir+./ ../matrix_buffer.sv
vlog -sv +incdir+./ ./matrix_buffer_tb.sv

vsim -t 1ns -voptargs="+acc" matrix_buffer_tb

do ./matrix_buffer_wave.do

configure wave -timelineunits ns
run -all
wave zoom full