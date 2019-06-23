# -------------------------------------------------------------------
# config
# -------------------------------------------------------------------

set worklib "work"
set top_lvl "hdmi_to_blocks_tb"
set macro_file "hdmi_to_blocks_wave.do"

# -------------------------------------------------------------------
# make libs
# -------------------------------------------------------------------
vlib $worklib


# -------------------------------------------------------------------
# compile
# -------------------------------------------------------------------
vlog -work $worklib "../hdmi_to_blocks.sv"
vlog -work $worklib "hdmi_to_blocks_tb.sv"

# -------------------------------------------------------------------
# simulate
# -------------------------------------------------------------------

# some windows
view structure
view signals
view wave

vsim "$worklib.$top_lvl"

# signals
if {!($macro_file eq "")} { do $macro_file }

# run
configure wave -timelineunits ns
run -all
wave zoom full