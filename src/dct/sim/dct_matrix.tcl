transcript on
vlib work

vlog -sv +incdir+./ ../dct_ft_math.sv
vlog -sv +incdir+./ ../dct_it_math.sv
vlog -sv +incdir+./ ../dct_ft_wrapper.sv
vlog -sv +incdir+./ ../dct_it_wrapper.sv
vlog -sv +incdir+./ ../../matrix_buffer/matrix_buffer.sv
vlog -sv +incdir+./ ../dct_ft_matrix.sv
vlog -sv +incdir+./ ../dct_it_matrix.sv
vlog -sv +incdir+./ ./dct_matrix_tb.sv

vsim -t 1ns -voptargs="+acc" dct_matrix_tb

do ./dct_matrix_wave.do

configure wave -timelineunits ns
run -all
wave zoom full