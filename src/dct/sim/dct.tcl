transcript on
vlib work

vlog -sv +incdir+./ ../dct_ft_math.sv
vlog -sv +incdir+./ ../dct_it_math.sv
vlog -sv +incdir+./ ../dct_ft.sv
vlog -sv +incdir+./ ../dct_it.sv
vlog -sv +incdir+./ ./dct_tb.sv

vsim -t 1ns -voptargs="+acc" dct_tb

do ./dct_wave.do

configure wave -timelineunits ns
run -all
wave zoom full