
module codec #(
	N     = 2   , // bus width
	X_RES = 2160, // X resolution, should be dividable by 8 (block width)
	Y_RES = 1200  // Y resolution should be dividable by 8 (block height)
) (
	input                      clk              ,
	input                      rst_n            ,
	input                      en               ,
	// ihdmi interface
	input                      i_hdmi_v_sync    ,
	input                      i_hdmi_h_sync    ,
	input                      i_hdmi_data_valid,
	input  signed [N-1:0][7:0] i_hdmi_data_y    ,
	input  signed [N-1:0][7:0] i_hdmi_data_cr   ,
	input  signed [N-1:0][7:0] i_hdmi_data_cb   ,
	// ohdmi interface
	output                     o_hdmi_v_sync    ,
	output                     o_hdmi_h_sync    ,
	output                     o_hdmi_data_valid,
	output signed [N-1:0][7:0] o_hdmi_data_y    ,
	output signed [N-1:0][7:0] o_hdmi_data_cr   ,
	output signed [N-1:0][7:0] o_hdmi_data_cb
);

// HDMI TO BLOCKS
logic                     blk_valid  ;
logic signed [N-1:0][7:0] blk_data_y ;
logic signed [N-1:0][7:0] blk_data_cr;
logic signed [N-1:0][7:0] blk_data_cb;
logic                     blk_eob    ;
logic                     blk_sob    ;
logic                     blk_sof    ;

// DCT Y
logic                    out_dct_valid_y;
logic signed [1:0][15:0] out_dct_data_y ;
logic                    out_dct_eob_y  ;
logic                    out_dct_sob_y  ;
logic                    out_dct_sof_y  ;

// DCT CR
logic                    out_dct_valid_cr;
logic signed [1:0][15:0] out_dct_data_cr ;
logic                    out_dct_eob_cr  ;
logic                    out_dct_sob_cr  ;
logic                    out_dct_sof_cr  ;

// DCT CB
logic                    out_dct_valid_cb;
logic signed [1:0][15:0] out_dct_data_cb ;
logic                    out_dct_eob_cb  ;
logic                    out_dct_sob_cb  ;
logic                    out_dct_sof_cb  ;

// DIVIDER Y
logic unsigned [1:0][ 9:0] in_denom_y     ;
logic                      out_valid_div_y;
logic signed   [1:0][15:0] out_data_div_y ;
logic                      out_eob_div_y  ;
logic                      out_sob_div_y  ;
logic                      out_sof_div_y  ;

// DIVIDER CR
logic unsigned [1:0][ 9:0] in_denom_cr     ;
logic                      out_valid_div_cr;
logic signed   [1:0][15:0] out_data_div_cr ;
logic                      out_eob_div_cr  ;
logic                      out_sob_div_cr  ;
logic                      out_sof_div_cr  ;

// DIVIDER CB
logic unsigned [1:0][ 9:0] in_denom_cb     ;
logic                      out_valid_div_cb;
logic signed   [1:0][15:0] out_data_div_cb ;
logic                      out_eob_div_cb  ;
logic                      out_sob_div_cb  ;
logic                      out_sof_div_cb  ;

// MULTIPLIER Y
logic unsigned [  1:0][ 9:0] in_mult_y      ;
logic                        out_valid_mul_y;
logic signed   [N-1:0][15:0] out_data_mul_y ;
logic                        out_eob_mul_y  ;
logic                        out_sob_mul_y  ;
logic                        out_sof_mul_y  ;

// MULTIPLIER CR
logic unsigned [  1:0][ 9:0] in_mult_cr      ;
logic                        out_valid_mul_cr;
logic signed   [N-1:0][15:0] out_data_mul_cr ;
logic                        out_eob_mul_cr  ;
logic                        out_sob_mul_cr  ;
logic                        out_sof_mul_cr  ;

// MULTIPLIER CB
logic unsigned [  1:0][ 9:0] in_mult_cb      ;
logic                        out_valid_mul_cb;
logic signed   [N-1:0][15:0] out_data_mul_cb ;
logic                        out_eob_mul_cb  ;
logic                        out_sob_mul_cb  ;
logic                        out_sof_mul_cb  ;

// IDCT Y
logic                   out_idct_valid_y;
logic signed [1:0][7:0] out_idct_data_y ;
logic                   out_idct_eob_y  ;
logic                   out_idct_sob_y  ;
logic                   out_idct_sof_y  ;

// IDCT CR
logic                   out_idct_valid_cr;
logic signed [1:0][7:0] out_idct_data_cr ;
logic                   out_idct_eob_cr  ;
logic                   out_idct_sob_cr  ;
logic                   out_idct_sof_cr  ;

// IDCT CB
logic                   out_idct_valid_cb;
logic signed [1:0][7:0] out_idct_data_cb ;
logic                   out_idct_eob_cb  ;
logic                   out_idct_sob_cb  ;
logic                   out_idct_sof_cb  ;

always_comb
	for (int i = 0; i < 2; i++) begin
		in_denom_y[i]  = 1;
		in_denom_cr[i] = 1;
		in_denom_cb[i] = 1;
	
		in_mult_y[i]  = 1;
		in_mult_cr[i] = 1;
		in_mult_cb[i] = 1;
	end

// CODER
hdmi_to_blocks #(.N(N), .X_RES(X_RES), .Y_RES(Y_RES)) i_hdmi_to_blocks (
	.clk            (clk              ),
	.rst_n          (rst_n            ),
	.en             (en               ),
	.hdmi_v_sync    (i_hdmi_v_sync    ),
	.hdmi_h_sync    (i_hdmi_h_sync    ),
	.hdmi_data_valid(i_hdmi_data_valid),
	.hdmi_data_y    (i_hdmi_data_y    ),
	.hdmi_data_cr   (i_hdmi_data_cr   ),
	.hdmi_data_cb   (i_hdmi_data_cb   ),
	.blk_valid      (blk_valid        ),
	.blk_data_y     (blk_data_y       ),
	.blk_data_cr    (blk_data_cr      ),
	.blk_data_cb    (blk_data_cb      ),
	.blk_eob        (blk_eob          ),
	.blk_sob        (blk_sob          ),
	.blk_sof        (blk_sof          )
);

dct_ft_matrix i_dct_ft_matrix_y (
	.clk      (clk            ),
	.rst_n    (rst_n          ),
	.en       (en             ),
	.in_valid (blk_valid      ),
	.in_data  (blk_data_y     ),
	.in_eob   (blk_eob        ),
	.in_sob   (blk_sob        ),
	.in_sof   (blk_sof        ),
	.out_valid(out_dct_valid_y),
	.out_data (out_dct_data_y ),
	.out_eob  (out_dct_eob_y  ),
	.out_sob  (out_dct_sob_y  ),
	.out_sof  (out_dct_sof_y  )
);

dct_ft_matrix i_dct_ft_matrix_cr (
	.clk      (clk             ),
	.rst_n    (rst_n           ),
	.en       (en              ),
	.in_valid (blk_valid       ),
	.in_data  (blk_data_cr     ),
	.in_eob   (blk_eob         ),
	.in_sob   (blk_sob         ),
	.in_sof   (blk_sof         ),
	.out_valid(out_dct_valid_cr),
	.out_data (out_dct_data_cr ),
	.out_eob  (out_dct_eob_cr  ),
	.out_sob  (out_dct_sob_cr  ),
	.out_sof  (out_dct_sof_cr  )
);

dct_ft_matrix i_dct_ft_matrix_cb (
	.clk      (clk             ),
	.rst_n    (rst_n           ),
	.en       (en              ),
	.in_valid (blk_valid       ),
	.in_data  (blk_data_cb     ),
	.in_eob   (blk_eob         ),
	.in_sob   (blk_sob         ),
	.in_sof   (blk_sof         ),
	.out_valid(out_dct_valid_cb),
	.out_data (out_dct_data_cb ),
	.out_eob  (out_dct_eob_cb  ),
	.out_sob  (out_dct_sob_cb  ),
	.out_sof  (out_dct_sof_cb  )
);

flow_divider #(.N(N)) i_flow_divider_y (
	.clk      (clk            ),
	.en       (en             ),
	.rst_n    (rst_n          ),
	.in_valid (out_dct_valid_y),
	.in_data  (out_dct_data_y ),
	.in_denom (in_denom_y     ),
	.in_eob   (out_dct_eob_y  ),
	.in_sob   (out_dct_sob_y  ),
	.in_sof   (out_dct_sof_y  ),
	.out_valid(out_valid_div_y),
	.out_data (out_data_div_y ),
	.out_eob  (out_eob_div_y  ),
	.out_sob  (out_sob_div_y  ),
	.out_sof  (out_sof_div_y  )
);

flow_divider #(.N(N)) i_flow_divider_cr (
	.clk      (clk             ),
	.en       (en              ),
	.rst_n    (rst_n           ),
	.in_valid (out_dct_valid_cr),
	.in_data  (out_dct_data_cr ),
	.in_denom (in_denom_cr     ),
	.in_eob   (out_dct_eob_cr  ),
	.in_sob   (out_dct_sob_cr  ),
	.in_sof   (out_dct_sof_cr  ),
	.out_valid(out_valid_div_cr),
	.out_data (out_data_div_cr ),
	.out_eob  (out_eob_div_cr  ),
	.out_sob  (out_sob_div_cr  ),
	.out_sof  (out_sof_div_cr  )
);

flow_divider #(.N(N)) i_flow_divider_cb (
	.clk      (clk             ),
	.en       (en              ),
	.rst_n    (rst_n           ),
	.in_valid (out_dct_valid_cb),
	.in_data  (out_dct_data_cb ),
	.in_denom (in_denom_cb     ),
	.in_eob   (out_dct_eob_cb  ),
	.in_sob   (out_dct_sob_cb  ),
	.in_sof   (out_dct_sof_cb  ),
	.out_valid(out_valid_div_cb),
	.out_data (out_data_div_cb ),
	.out_eob  (out_eob_div_cb  ),
	.out_sob  (out_sob_div_cb  ),
	.out_sof  (out_sof_div_cb  )
);

// DECODER
flow_mult #(.N(N)) i_flow_mult_y (
	.clk      (clk            ),
	.en       (en             ),
	.rst_n    (rst_n          ),
	.in_valid (out_valid_div_y),
	.in_data  (out_data_div_y ),
	.in_mult  (in_mult_y      ),
	.in_eob   (out_eob_div_y  ),
	.in_sob   (out_sob_div_y  ),
	.in_sof   (out_sof_div_y  ),
	.out_valid(out_valid_mul_y),
	.out_data (out_data_mul_y ),
	.out_eob  (out_eob_mul_y  ),
	.out_sob  (out_sob_mul_y  ),
	.out_sof  (out_sof_mul_y  )
);

flow_mult #(.N(N)) i_flow_mult_cr (
	.clk      (clk             ),
	.en       (en              ),
	.rst_n    (rst_n           ),
	.in_valid (out_valid_div_cr),
	.in_data  (out_data_div_cr ),
	.in_mult  (in_mult_cr      ),
	.in_eob   (out_eob_div_cr  ),
	.in_sob   (out_sob_div_cr  ),
	.in_sof   (out_sof_div_cr  ),
	.out_valid(out_valid_mul_cr),
	.out_data (out_data_mul_cr ),
	.out_eob  (out_eob_mul_cr  ),
	.out_sob  (out_sob_mul_cr  ),
	.out_sof  (out_sof_mul_cr  )
);

flow_mult #(.N(N)) i_flow_mult_cb (
	.clk      (clk             ),
	.en       (en              ),
	.rst_n    (rst_n           ),
	.in_valid (out_valid_div_cb),
	.in_data  (out_data_div_cb ),
	.in_mult  (in_mult_cb      ),
	.in_eob   (out_eob_div_cb  ),
	.in_sob   (out_sob_div_cb  ),
	.in_sof   (out_sof_div_cb  ),
	.out_valid(out_valid_mul_cb),
	.out_data (out_data_mul_cb ),
	.out_eob  (out_eob_mul_cb  ),
	.out_sob  (out_sob_mul_cb  ),
	.out_sof  (out_sof_mul_cb  )
);

dct_it_matrix i_dct_it_matrix_y (
	.clk      (clk             ),
	.rst_n    (rst_n           ),
	.en       (en              ),
	.in_valid (out_valid_mul_y ),
	.in_data  (out_data_mul_y  ),
	.in_eob   (out_eob_mul_y   ),
	.in_sob   (out_sob_mul_y   ),
	.in_sof   (out_sof_mul_y   ),
	.out_valid(out_idct_valid_y),
	.out_data (out_idct_data_y ),
	.out_eob  (out_idct_eob_y  ),
	.out_sob  (out_idct_sob_y  ),
	.out_sof  (out_idct_sof_y  )
);

dct_it_matrix i_dct_it_matrix_cr (
	.clk      (clk              ),
	.rst_n    (rst_n            ),
	.en       (en               ),
	.in_valid (out_valid_mul_cr ),
	.in_data  (out_data_mul_cr  ),
	.in_eob   (out_eob_mul_cr   ),
	.in_sob   (out_sob_mul_cr   ),
	.in_sof   (out_sof_mul_cr   ),
	.out_valid(out_idct_valid_cr),
	.out_data (out_idct_data_cr ),
	.out_eob  (out_idct_eob_cr  ),
	.out_sob  (out_idct_sob_cr  ),
	.out_sof  (out_idct_sof_cr  )
);

dct_it_matrix i_dct_it_matrix_cb (
	.clk      (clk              ),
	.rst_n    (rst_n            ),
	.en       (en               ),
	.in_valid (out_valid_mul_cb ),
	.in_data  (out_data_mul_cb  ),
	.in_eob   (out_eob_mul_cb   ),
	.in_sob   (out_sob_mul_cb   ),
	.in_sof   (out_sof_mul_cb   ),
	.out_valid(out_idct_valid_cb),
	.out_data (out_idct_data_cb ),
	.out_eob  (out_idct_eob_cb  ),
	.out_sob  (out_idct_sob_cb  ),
	.out_sof  (out_idct_sof_cb  )
);

blocks_to_hdmi #(.N(N), .X_RES(X_RES), .Y_RES(Y_RES)) i_blocks_to_hdmi (
	.clk            (clk                                                 ),
	.rst_n          (rst_n                                               ),
	.en             (en                                                  ),
	.hdmi_v_sync    (o_hdmi_v_sync                                       ),
	.hdmi_h_sync    (o_hdmi_h_sync                                       ),
	.hdmi_data_valid(o_hdmi_data_valid                                   ),
	.hdmi_data_y    (o_hdmi_data_y                                       ),
	.hdmi_data_cr   (o_hdmi_data_cr                                      ),
	.hdmi_data_cb   (o_hdmi_data_cb                                      ),
	.blk_valid      (out_idct_valid_y&out_idct_valid_cr&out_idct_valid_cb),
	.blk_data_y     (out_idct_data_y                                     ),
	.blk_data_cr    (out_idct_data_cr                                    ),
	.blk_data_cb    (out_idct_data_cb                                    ),
	.blk_eob        (out_idct_eob_y&out_idct_eob_cr&out_idct_eob_cb      ),
	.blk_sob        (out_idct_sob_y&out_idct_sob_cr&out_idct_sob_cb      ),
	.blk_sof        (out_idct_sof_y&out_idct_sof_cr&out_idct_sof_cb      )
);

endmodule