onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group GLOBAL /codec_tb/clk
add wave -noupdate -expand -group GLOBAL /codec_tb/rst_n
add wave -noupdate -expand -group GLOBAL /codec_tb/en
add wave -noupdate -expand -group {HDMI INPUT} /codec_tb/i_hdmi_v_sync
add wave -noupdate -expand -group {HDMI INPUT} /codec_tb/i_hdmi_h_sync
add wave -noupdate -expand -group {HDMI INPUT} /codec_tb/i_hdmi_data_valid
add wave -noupdate -expand -group {HDMI INPUT} -radix decimal /codec_tb/i_hdmi_data_y
add wave -noupdate -expand -group {HDMI INPUT} -radix decimal /codec_tb/i_hdmi_data_cr
add wave -noupdate -expand -group {HDMI INPUT} -radix decimal /codec_tb/i_hdmi_data_cb
add wave -noupdate -expand -group {HDMI OUTPUT} /codec_tb/o_hdmi_v_sync
add wave -noupdate -expand -group {HDMI OUTPUT} /codec_tb/o_hdmi_h_sync
add wave -noupdate -expand -group {HDMI OUTPUT} /codec_tb/o_hdmi_data_valid
add wave -noupdate -expand -group {HDMI OUTPUT} -radix decimal /codec_tb/o_hdmi_data_y
add wave -noupdate -expand -group {HDMI OUTPUT} -radix decimal /codec_tb/o_hdmi_data_cr
add wave -noupdate -expand -group {HDMI OUTPUT} -radix decimal /codec_tb/o_hdmi_data_cb
add wave -noupdate -expand -group {DATA ERRORS} /codec_tb/error_y
add wave -noupdate -expand -group {DATA ERRORS} /codec_tb/error_cr
add wave -noupdate -expand -group {DATA ERRORS} /codec_tb/error_cb
add wave -noupdate -radix decimal -childformat {{{/codec_tb/result_y[1]} -radix decimal} {{/codec_tb/result_y[0]} -radix decimal}} -subitemconfig {{/codec_tb/result_y[1]} {-height 15 -radix decimal} {/codec_tb/result_y[0]} {-height 15 -radix decimal}} /codec_tb/result_y
add wave -noupdate -radix decimal /codec_tb/result_cr
add wave -noupdate -radix decimal /codec_tb/result_cb
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/clk
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/rst_n
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/hdmi_v_sync
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/hdmi_h_sync
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/hdmi_data_valid
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/hdmi_data_y
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/hdmi_data_cr
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/hdmi_data_cb
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/blk_valid
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/blk_data_y
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/blk_data_cr
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/blk_data_cb
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/blk_eob
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/blk_sob
add wave -noupdate -group HDMI2BLOCKS -radix decimal /codec_tb/i_codec/i_hdmi_to_blocks/blk_sof
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/clk
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/rst_n
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/hdmi_v_sync
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/hdmi_h_sync
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/hdmi_data_valid
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/hdmi_data_y
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/hdmi_data_cr
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/hdmi_data_cb
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/blk_valid
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/blk_data_y
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/blk_data_cr
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/blk_data_cb
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/blk_eob
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/blk_sob
add wave -noupdate -group BLOCKS2HDMI -radix decimal /codec_tb/i_codec/i_blocks_to_hdmi/blk_sof
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/clk
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/rst_n
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/en
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/in_valid
add wave -noupdate -group {DCT Y} -radix decimal -childformat {{{/codec_tb/i_codec/i_dct_ft_matrix_y/in_data[1]} -radix decimal} {{/codec_tb/i_codec/i_dct_ft_matrix_y/in_data[0]} -radix decimal}} -subitemconfig {{/codec_tb/i_codec/i_dct_ft_matrix_y/in_data[1]} {-height 15 -radix decimal} {/codec_tb/i_codec/i_dct_ft_matrix_y/in_data[0]} {-height 15 -radix decimal}} /codec_tb/i_codec/i_dct_ft_matrix_y/in_data
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/in_eob
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/in_sob
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/in_sof
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/out_valid
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/out_data
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/out_eob
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/out_sob
add wave -noupdate -group {DCT Y} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_y/out_sof
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/clk
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/rst_n
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/en
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/in_valid
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/in_data
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/in_eob
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/in_sob
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/in_sof
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/out_valid
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/out_data
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/out_eob
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/out_sob
add wave -noupdate -group {DCT CR} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cr/out_sof
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/clk
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/rst_n
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/en
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/in_valid
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/in_data
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/in_eob
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/in_sob
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/in_sof
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/out_valid
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/out_data
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/out_eob
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/out_sob
add wave -noupdate -group {DCT CB} -radix decimal /codec_tb/i_codec/i_dct_ft_matrix_cb/out_sof
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/clk
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/en
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/rst_n
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/in_valid
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/in_data
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/in_denom
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/in_eob
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/in_sob
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/in_sof
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/out_valid
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/out_data
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/out_eob
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/out_sob
add wave -noupdate -group {FLOW DIVIDER Y} -radix decimal /codec_tb/i_codec/i_flow_divider_y/out_sof
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/clk
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/en
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/rst_n
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/in_valid
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/in_data
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/in_denom
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/in_eob
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/in_sob
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/in_sof
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/out_valid
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/out_data
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/out_eob
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/out_sob
add wave -noupdate -group {FLOW DIVIDER CR} -radix decimal /codec_tb/i_codec/i_flow_divider_cr/out_sof
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/clk
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/en
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/rst_n
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/in_valid
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/in_data
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/in_denom
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/in_eob
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/in_sob
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/in_sof
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/out_valid
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/out_data
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/out_eob
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/out_sob
add wave -noupdate -group {FLOW DIVIDER CB} -radix decimal /codec_tb/i_codec/i_flow_divider_cb/out_sof
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/clk
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/en
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/rst_n
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/in_valid
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/in_data
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/in_mult
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/in_eob
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/in_sob
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/in_sof
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/out_valid
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/out_data
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/out_eob
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/out_sob
add wave -noupdate -group {FLOW MULT Y} -radix decimal /codec_tb/i_codec/i_flow_mult_y/out_sof
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/clk
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/en
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/rst_n
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/in_valid
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/in_data
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/in_mult
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/in_eob
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/in_sob
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/in_sof
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/out_valid
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/out_data
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/out_eob
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/out_sob
add wave -noupdate -group {FLOW MULT CR} -radix decimal /codec_tb/i_codec/i_flow_mult_cr/out_sof
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/clk
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/en
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/rst_n
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/in_valid
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/in_data
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/in_mult
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/in_eob
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/in_sob
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/in_sof
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/out_valid
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/out_data
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/out_eob
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/out_sob
add wave -noupdate -group {FLOW MULT CB} -radix decimal /codec_tb/i_codec/i_flow_mult_cb/out_sof
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/clk
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/rst_n
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/en
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/in_valid
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/in_data
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/in_eob
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/in_sob
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/in_sof
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/out_valid
add wave -noupdate -group {IDCT Y} -radix decimal -childformat {{{/codec_tb/i_codec/i_dct_it_matrix_y/out_data[1]} -radix decimal} {{/codec_tb/i_codec/i_dct_it_matrix_y/out_data[0]} -radix decimal}} -subitemconfig {{/codec_tb/i_codec/i_dct_it_matrix_y/out_data[1]} {-height 15 -radix decimal} {/codec_tb/i_codec/i_dct_it_matrix_y/out_data[0]} {-height 15 -radix decimal}} /codec_tb/i_codec/i_dct_it_matrix_y/out_data
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/out_eob
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/out_sob
add wave -noupdate -group {IDCT Y} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_y/out_sof
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/clk
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/rst_n
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/en
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/in_valid
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/in_data
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/in_eob
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/in_sob
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/in_sof
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/out_valid
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/out_data
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/out_eob
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/out_sob
add wave -noupdate -group {IDCT CR} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cr/out_sof
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/clk
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/rst_n
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/en
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/in_valid
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/in_data
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/in_eob
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/in_sob
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/in_sof
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/out_valid
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/out_data
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/out_eob
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/out_sob
add wave -noupdate -group {IDCT CB} -radix decimal /codec_tb/i_codec/i_dct_it_matrix_cb/out_sof
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {490333260 ps} 0} {{Cursor 2} {402885000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 322
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
WaveRestoreZoom {490312250 ps} {490431397 ps}
