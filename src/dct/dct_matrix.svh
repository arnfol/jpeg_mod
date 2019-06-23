(
	input                           clk      ,
	input                           rst_n    ,
	// input interface
	input                           in_valid ,
	`ifdef DCT_FT
		input               [7:0][ 7:0] in_data,
	`elsif DCT_IT
		input               [7:0][15:0] in_data,
	`endif
	input                           in_eob   ,
	input                           in_sob   ,
	input                           in_sof   ,
	// output interface
	output logic                    out_valid,
	`ifdef DCT_FT
		output logic signed [7:0][15:0] out_data,
	`elsif DCT_IT
		output logic        [7:0][ 7:0] out_data,
	`endif
	output logic                    out_eob  ,
	output logic                    out_sob  ,
	output logic                    out_sof
);

// DCT horizontal pass signals
logic             dct_hp_out_valid;
logic [7:0][15:0] dct_hp_out_data ;
logic             dct_hp_out_eob  ;
logic             dct_hp_out_sob  ;
logic             dct_hp_out_sof  ;

// DCT vertical pass signals
logic             dct_vp_in_valid;
logic [7:0][15:0] dct_vp_in_data ;
logic             dct_vp_in_eob  ;
logic             dct_vp_in_sob  ;
logic             dct_vp_in_sof  ;

// DCT inst
`ifdef DCT_FT
	dct_ft_wrapper #(.W_I(8)) i_dct_ft_horizontal_pass (
`elsif DCT_IT
	dct_it_wrapper #(.W_O(16)) i_dct_it_horizontal_pass (
`endif
	.clk      (clk             ),
	.rst_n    (rst_n           ),
	.in_valid (in_valid        ),
	.in_data  (in_data         ),
	.in_eob   (in_eob          ),
	.in_sob   (in_sob          ),
	.in_sof   (in_sof          ),
	.out_valid(dct_hp_out_valid),
	.out_data (dct_hp_out_data ),
	.out_eob  (dct_hp_out_eob  ),
	.out_sob  (dct_hp_out_sob  ),
	.out_sof  (dct_hp_out_sof  )
);

// to buffer and transpose
matrix_buffer #(.W_IO(16), .TRPS(1)) i_matrix_buffer (
	.clk      (clk             ),
	.rst_n    (rst_n           ),
	.in_valid (dct_hp_out_valid),
	.in_data  (dct_hp_out_data ),
	.in_eob   (dct_hp_out_eob  ),
	.in_sob   (dct_hp_out_sob  ),
	.in_sof   (dct_hp_out_sof  ),
	.out_valid(dct_vp_in_valid ),
	.out_data (dct_vp_in_data  ),
	.out_eob  (dct_vp_in_eob   ),
	.out_sob  (dct_vp_in_sob   ),
	.out_sof  (dct_vp_in_sof   )
);

// DCT inst
`ifdef DCT_FT
	dct_ft_wrapper #(.W_I(16)) i_dct_ft_vertical_pass (
`elsif DCT_IT
	dct_it_wrapper #(.W_O(8)) i_dct_it_vertical_pass (
`endif
	.clk      (clk            ),
	.rst_n    (rst_n          ),
	.in_valid (dct_vp_in_valid),
	.in_data  (dct_vp_in_data ),
	.in_eob   (dct_vp_in_eob  ),
	.in_sob   (dct_vp_in_sob  ),
	.in_sof   (dct_vp_in_sof  ),
	.out_valid(out_valid      ),
	.out_data (out_data       ),
	.out_eob  (out_eob        ),
	.out_sob  (out_sob        ),
	.out_sof  (out_sof        )
);