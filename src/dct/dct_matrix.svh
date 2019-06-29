(
	input                           clk      ,
	input                           rst_n    ,
	input                           en       ,
	// input interface
	input                           in_valid ,
	`ifdef DCT_FT
		input               [1:0][ 7:0] in_data,
	`elsif DCT_IT
		input               [1:0][15:0] in_data,
	`endif
	input                           in_eob   ,
	input                           in_sob   ,
	input                           in_sof   ,
	// output interface
	output logic                    out_valid,
	`ifdef DCT_FT
		output logic signed [1:0][15:0] out_data,
	`elsif DCT_IT
		output logic        [1:0][ 7:0] out_data,
	`endif
	output logic                    out_eob  ,
	output logic                    out_sob  ,
	output logic                    out_sof
);

// 2 -> 8 upscaler
logic [1:0]      up_counter ;
logic            up_in_valid;
`ifdef DCT_FT
	logic [7:0][ 7:0] up_in_data;
`elsif DCT_IT
	logic [7:0][15:0] up_in_data;
`endif
logic            up_in_eob  ;
logic [3:0]      up_in_sob  ;
logic [3:0]      up_in_sof  ;

// 8 -> 2 downscaler
logic [3:0]      down_out_valid;
`ifdef DCT_FT
	logic [7:0][15:0] down_out_data;
`elsif DCT_IT
	logic [7:0][ 7:0] down_out_data;
`endif
logic [3:0]      down_out_eob  ;
logic            down_out_sob  ;
logic            down_out_sof  ;

// DCT horizontal pass signals
logic             dct_hp_in_valid;
`ifdef DCT_FT
	logic [7:0][ 7:0] dct_hp_in_data ;
`elsif DCT_IT
	logic [7:0][15:0] dct_hp_in_data ;
`endif
logic             dct_hp_in_eob  ;
logic             dct_hp_in_sob  ;
logic             dct_hp_in_sof  ;

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

logic             dct_vp_out_valid;
`ifdef DCT_FT
	logic [7:0][15:0] dct_vp_out_data ;
`elsif DCT_IT
	logic [7:0][ 7:0] dct_vp_out_data ;
`endif
logic             dct_vp_out_eob  ;
logic             dct_vp_out_sob  ;
logic             dct_vp_out_sof  ;

// 2 -> 8 upscaler
always_ff @(posedge clk, negedge rst_n)
	if(~rst_n)
		up_counter <= '0;
	else if(in_valid & en)
		up_counter <= up_counter + 1;

always_ff @(posedge clk, negedge rst_n)
	if(~rst_n)
		up_in_data <= '0;
	else if(in_valid & en)
		up_in_data <= {in_data,up_in_data[7:2]};

always_ff @(posedge clk, negedge rst_n)
	if(~rst_n)
		up_in_valid <= 0;
	else if(&up_counter & en)
		up_in_valid <= 1;
	else if(en)
		up_in_valid <= 0;

always_ff @(posedge clk, negedge rst_n) 
	if(~rst_n)
		{up_in_sob, up_in_sof, up_in_eob} <= '0;
	else if(in_valid & en) begin
		up_in_eob <= in_eob;
		up_in_sob <= {up_in_sob, in_sob};
		up_in_sof <= {up_in_sof, in_sof};
	end

// 8 -> 2 downscaler
always_ff @(posedge clk, negedge rst_n)
	if(~rst_n)
		down_out_data <= '0;
	else if(dct_vp_out_valid & en)
		down_out_data <= dct_vp_out_data;
	else if(en)
		down_out_data <= down_out_data[7:2];

always_ff @(posedge clk, negedge rst_n)
	if(~rst_n)
		down_out_valid <= '0;
	else if(dct_vp_out_valid & en)
		down_out_valid <= 1;
	else if(en)
		down_out_valid <= down_out_valid<<1;

always_ff @(posedge clk, negedge rst_n) 
	if(~rst_n)
		{down_out_sob, down_out_sof, down_out_eob} <= '0;
	else if(en) begin
		down_out_eob <= {down_out_eob, dct_vp_out_eob};
		down_out_sob <= dct_vp_out_sob;
		down_out_sof <= dct_vp_out_sof;
	end

// horizontal pass input
assign dct_hp_in_valid = up_in_valid ;
assign dct_hp_in_data  = up_in_data  ;
assign dct_hp_in_eob   = up_in_eob   ;
assign dct_hp_in_sob   = up_in_sob[3];
assign dct_hp_in_sof   = up_in_sof[3];

// vertical pass output
assign out_valid = |down_out_valid   ;
assign out_data  = down_out_data[1:0];
assign out_eob   = down_out_eob[3]   ;
assign out_sob   = down_out_sob      ;
assign out_sof   = down_out_sof      ;

// DCT inst
`ifdef DCT_FT
	dct_ft_wrapper #(.W_I(8)) i_dct_ft_horizontal_pass (
`elsif DCT_IT
	dct_it_wrapper #(.W_O(16)) i_dct_it_horizontal_pass (
		`endif
		.clk      (clk             ),
		.rst_n    (rst_n           ),
		.en       (en              ),
		.in_valid (dct_hp_in_valid ),
		.in_data  (dct_hp_in_data  ),
		.in_eob   (dct_hp_in_eob   ),
		.in_sob   (dct_hp_in_sob   ),
		.in_sof   (dct_hp_in_sof   ),
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
	.en       (en              ),
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
		.clk      (clk             ),
		.rst_n    (rst_n           ),
		.en       (en              ),
		.in_valid (dct_vp_in_valid ),
		.in_data  (dct_vp_in_data  ),
		.in_eob   (dct_vp_in_eob   ),
		.in_sob   (dct_vp_in_sob   ),
		.in_sof   (dct_vp_in_sof   ),
		.out_valid(dct_vp_out_valid),
		.out_data (dct_vp_out_data ),
		.out_eob  (dct_vp_out_eob  ),
		.out_sob  (dct_vp_out_sob  ),
		.out_sof  (dct_vp_out_sof  )
	);