module flow_mult #(
	N    = 2, // bus width
	PIPE = 4  // number of math pipelines
) (
	input                               clk      ,
	input                               en       ,
	input                               rst_n    ,
	// input interface
	input                               in_valid ,
	input        signed   [N-1:0][15:0] in_data  ,
	input        unsigned [N-1:0][ 9:0] in_mult  ,
	input                               in_eob   ,
	input                               in_sob   ,
	input                               in_sof   ,
	// output interface
	output logic                        out_valid,
	output logic signed   [N-1:0][15:0] out_data ,
	output logic                        out_eob  ,
	output logic                        out_sob  ,
	output logic                        out_sof
);

	logic [N-1:0] eob, sob, sof, valid;


	/*------------------------------------------------------------------------------
	--  Control logic pipeline
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			{eob, sob, sof, valid} <= '0;
		end else begin
			eob <= {eob, in_eob};
			sob <= {sob, in_sob};
			sof <= {sof, in_sof};
			valid <= {valid, in_valid & en};
		end
	end

	assign out_eob = eob[N-1];
	assign out_sob = sob[N-1];
	assign out_sof = sof[N-1];
	assign out_valid = valid[N-1];


	/*------------------------------------------------------------------------------
	--  Math
	------------------------------------------------------------------------------*/
	generate for (genvar i = 0; i < N; i++) begin : math_gen

		lpm_mult u_lpm_mult (
			.aclr  (!rst_n         ),
			.clken (en & in_valid  ),
			.clock (clk            ),
			.dataa (in_data        ),
			.datab ({1'b0, in_mult}),
			.result(out_data       ), // TODO: check overflow
			.sclr  (1'b0           ),
			.sum   (1'b0           )
		);
		defparam
			u_lpm_mult.lpm_hint = "MAXIMIZE_SPEED=5",
			u_lpm_mult.lpm_pipeline = PIPE,
			u_lpm_mult.lpm_representation = "SIGNED",
			u_lpm_mult.lpm_type = "LPM_MULT",
			u_lpm_mult.lpm_widtha = 16,
			u_lpm_mult.lpm_widthb = 11,
			u_lpm_mult.lpm_widthp = 27;

	end	endgenerate
	


endmodule