module dct_it #(W_O = 16) (
	input                              clk      ,
	input                              rst_n    ,
	// input interface
	input                              in_valid ,
	input        signed [7:0][   15:0] in_data  ,
	input                              in_eob   ,
	input                              in_sob   ,
	input                              in_sof   ,
	// output interface
	output logic                       out_valid,
	output logic        [7:0][W_O-1:0] out_data ,
	output logic                       out_eob  ,
	output logic                       out_sob  ,
	output logic                       out_sof
);

localparam PIPE = 8;

logic signed [   15:0] x_in [7:0];
logic        [W_O-1:0] x_out[7:0];

logic [PIPE-1:0] eob, sob, sof, valid;

// ctrl logic pipeline
always_ff @(posedge clk, negedge rst_n) 
   if(~rst_n)
      {eob, sob, sof, valid} <= '0;
   else begin
      eob   <= {eob, in_eob};
      sob   <= {sob, in_sob};
      sof   <= {sof, in_sof};
      valid <= {valid, in_valid};
   end

assign out_eob   = eob[PIPE-1];
assign out_sob   = sob[PIPE-1];
assign out_sof   = sof[PIPE-1];
assign out_valid = valid[PIPE-1];

// dct
always_comb
	for (int i = 0; i < 8; i++) begin
		x_in[i]     = in_data[i];
		out_data[i] = x_out[i]  ;
	end

dct_it_math #(.W_O(W_O)) i_dct_it_math (.clk(clk), .rst_n(rst_n), .x_in(x_in), .x_out(x_out));

endmodule