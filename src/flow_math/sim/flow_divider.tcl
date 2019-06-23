# -------------------------------------------------------------------
# config
# -------------------------------------------------------------------

set worklib "work"
set top_lvl "flow_divider_tb"
set macro_file "flow_divider_wave.do"
set path_to_quartus C:/intelFPGA/18.0/quartus

# -------------------------------------------------------------------
# make libs
# -------------------------------------------------------------------
vlib $worklib

# create quartus megafunctions lib
vlib lpm_ver
vmap lpm_ver lpm_ver
vlog -work lpm_ver $path_to_quartus/eda/sim_lib/220model.v


# -------------------------------------------------------------------
# compile
# -------------------------------------------------------------------
vlog -work $worklib "../flow_divider.sv"
vlog -work $worklib "flow_divider_tb.sv"

# -------------------------------------------------------------------
# simulate
# -------------------------------------------------------------------

# some windows
view structure
view signals
view wave

vsim -L lpm_ver "$worklib.$top_lvl"

# signals
if {!($macro_file eq "")} { do $macro_file }

# run
configure wave -timelineunits ns
run -all
wave zoom full