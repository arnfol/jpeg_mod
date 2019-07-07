create_clock -name clk -period 6.66 [get_ports "clk"]
#set_max_delay -from [get_registers] -to [all_outputs] 5.0
set_max_delay -from [all_inputs] -to [get_registers] 5.0