(
	input                              clk      ,
	input                              rst_n    ,
	input                              en       ,
	// input interface
	input                              in_valid ,
	`ifdef DCT_FT
		input               [7:0][W_I-1:0] in_data,
	`elsif DCT_IT
		input        signed [7:0][   15:0] in_data,
	`endif
	input                              in_eob   ,
	input                              in_sob   ,
	input                              in_sof   ,
	// output interface
	output logic                       out_valid,
	`ifdef DCT_FT
		output logic signed [7:0][   15:0] out_data,
	`elsif DCT_IT
		output logic        [7:0][W_O-1:0] out_data,
	`endif
	output logic                       out_eob  ,
	output logic                       out_sob  ,
	output logic                       out_sof
);

localparam PIPE = 17;

`ifdef DCT_FT
	logic        [W_I-1:0] data_in [7:0];
	logic signed [   15:0] data_out[7:0];
`elsif DCT_IT
	logic signed [   15:0] data_in [7:0];
	logic        [W_O-1:0] data_out[7:0];
`endif

logic [PIPE-1:0] eob, sob, sof, valid;

// ctrl logic pipeline
always_ff @(posedge clk, negedge rst_n) 
	if(~rst_n)
		{eob, sob, sof, valid} <= '0;
	else if(en) begin
		eob   <= {eob, in_eob};
		sob   <= {sob, in_sob};
		sof   <= {sof, in_sof};
		valid <= {valid, in_valid};
	end

assign out_eob   = eob[PIPE-1];
assign out_sob   = sob[PIPE-1];
assign out_sof   = sof[PIPE-1];
assign out_valid = valid[PIPE-1];

`ifdef DCT_FT
	dct_ft_math #(.W_I(W_I)) i_dct_ft_math (.clk(clk), .rst_n(rst_n), .en(en), .in_data(in_data), .out_data(out_data));
`elsif DCT_IT
	dct_it_math #(.W_O(W_O)) i_dct_it_math (.clk(clk), .rst_n(rst_n), .en(en), .in_data(in_data), .out_data(out_data));
`endif