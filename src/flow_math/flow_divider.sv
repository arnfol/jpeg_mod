module flow_divider #(
	N    = 2, // bus width
	PIPE = 8  // number of math pipelines
) (
	input                               clk      ,
	input                               en       ,
	input                               rst_n    ,
	// input interface
	input                               in_valid ,
	input        signed   [N-1:0][15:0] in_data  ,
	input        unsigned [N-1:0][ 9:0] in_denom ,
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

	logic [PIPE-1:0] eob, sob, sof, valid;


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
	genvar i;
	generate for (i = 0; i < N; i++) begin : math_gen

		lpm_divide u_lpm_divide (
			.aclr    (!rst_n       ),
			.clken   (en & in_valid),
			.clock   (clk          ),
			.denom   (in_denom[i]  ),
			.numer   (in_data[i]   ),
			.quotient(out_data[i]  ),
			.remain  (             )
		);
		defparam
			u_lpm_divide.lpm_drepresentation = "UNSIGNED",
			u_lpm_divide.lpm_hint = "MAXIMIZE_SPEED=6,LPM_REMAINDERPOSITIVE=TRUE",
			u_lpm_divide.lpm_nrepresentation = "SIGNED",
			u_lpm_divide.lpm_pipeline = PIPE,
			u_lpm_divide.lpm_type = "LPM_DIVIDE",
			u_lpm_divide.lpm_widthd = 10,
			u_lpm_divide.lpm_widthn = 16;

	end endgenerate
	


endmodule