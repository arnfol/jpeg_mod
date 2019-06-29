# -------------------------------------------------------------------
# config
# -------------------------------------------------------------------

set worklib "work"
set top_lvl "blocks_buf_tb"
set macro_file "blocks_buf_wave.do"
set path_to_quartus C:/intelFPGA/18.0/quartus

# -------------------------------------------------------------------
# make libs
# -------------------------------------------------------------------
vlib $worklib

# create quartus megafunctions lib
vlib altera_mf
vmap altera_mf altera_mf
vlog -work altera_mf $path_to_quartus/eda/sim_lib/altera_mf.v

# -------------------------------------------------------------------
# compile
# -------------------------------------------------------------------
vlog -work $worklib "../blocks_buf.sv"
vlog -work $worklib "blocks_buf_tb.sv"

# -------------------------------------------------------------------
# simulate
# -------------------------------------------------------------------

# some windows
view structure
view signals
view wave

vsim -L altera_mf "$worklib.$top_lvl"

# signals
if {!($macro_file eq "")} { do $macro_file }

# run
configure wave -timelineunits ns
run -all
wave zoom full