# -------------------------------------------------------------------
# config
# -------------------------------------------------------------------

set worklib "work"
set top_lvl "codec_tb"
set macro_file "codec.do"
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
vlog -sv +incdir+./ -work $worklib "../../matrix_buffer/matrix_buffer.sv"
vlog -sv +incdir+./ -work $worklib "../../dct/dct_ft_math.sv"
vlog -sv +incdir+./ -work $worklib "../../dct/dct_it_math.sv"
vlog -sv +incdir+./ -work $worklib "../../dct/dct_ft_wrapper.sv"
vlog -sv +incdir+./ -work $worklib "../../dct/dct_it_wrapper.sv"
vlog -sv +incdir+./ -work $worklib "../../dct/dct_ft_matrix.sv"
vlog -sv +incdir+./ -work $worklib "../../dct/dct_it_matrix.sv"
vlog -sv +incdir+./ -work $worklib "../../flow_math/flow_divider.sv"
vlog -sv +incdir+./ -work $worklib "../../flow_math/flow_mult.sv"
vlog -sv +incdir+./ -work $worklib "../../hdmi_interface/hdmi_to_blocks.sv"
vlog -sv +incdir+./ -work $worklib "../../hdmi_interface/blocks_to_hdmi.sv"
vlog -sv +incdir+./ -work $worklib "../../top/codec.sv"
vlog -sv +incdir+./ -work $worklib "codec_tb.sv"

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
configure wave -timelineunits ms
run -all
wave zoom full