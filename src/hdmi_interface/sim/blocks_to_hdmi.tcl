# -------------------------------------------------------------------
# config
# -------------------------------------------------------------------

set worklib "work"
set top_lvl "blocks_to_hdmi_tb"
set macro_file "blocks_to_hdmi_wave.do"

# -------------------------------------------------------------------
# make libs
# -------------------------------------------------------------------
vlib $worklib


# -------------------------------------------------------------------
# compile
# -------------------------------------------------------------------
vlog -work $worklib "../blocks_to_hdmi.sv"
vlog -work $worklib "blocks_to_hdmi_tb.sv"

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
configure wave -timelineunits us
run -all
wave zoom full