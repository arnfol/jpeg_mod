/*
    ------------------------------------------------------------------------------
    -- The MIT License (MIT)
    --
    -- Copyright (c) <2019> Konovalov Vitaliy
    --
    -- Permission is hereby granted, free of charge, to any person obtaining a copy
    -- of this software and associated documentation files (the "Software"), to deal
    -- in the Software without restriction, including without limitation the rights
    -- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    -- copies of the Software, and to permit persons to whom the Software is
    -- furnished to do so, subject to the following conditions:
    --
    -- The above copyright notice and this permission notice shall be included in
    -- all copies or substantial portions of the Software.
    --
    -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    -- THE SOFTWARE.
    -------------------------------------------------------------------------------
    Project     : JPEG_MOD
    Author      : Konovalov Vitaliy
    Description :
                  Note: output is only 16 bit, overflow is not handled in any way. 
*/

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

	logic [PIPE-1:0] eob, sob, sof, valid;


	/*------------------------------------------------------------------------------
	--  Control logic pipeline
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			{eob, sob, sof, valid} <= '0;
		end else if(en) begin
			eob <= {eob, in_eob};
			sob <= {sob, in_sob};
			sof <= {sof, in_sof};
			valid <= {valid, in_valid};
		end
	end

	assign out_eob = eob[PIPE-1];
	assign out_sob = sob[PIPE-1];
	assign out_sof = sof[PIPE-1];
	assign out_valid = valid[PIPE-1];


	/*------------------------------------------------------------------------------
	--  Math
	------------------------------------------------------------------------------*/
	genvar i;
	generate for (i = 0; i < N; i++) begin : math_gen

		lpm_mult u_lpm_mult (
			.aclr  (!rst_n                 ),
			.clken (en & |{in_valid, valid}),
			.clock (clk                    ),
			.dataa (in_data[i]             ),
			.datab ({1'b0, in_mult[i]}     ), // 1'b0 for convertion to unsigned
			.result(out_data[i]            ), // TODO: check overflow
			.sclr  (1'b0                   ),
			.sum   (1'b0                   )
		);
		defparam
			u_lpm_mult.lpm_hint = "MAXIMIZE_SPEED=5",
			u_lpm_mult.lpm_pipeline = PIPE,
			u_lpm_mult.lpm_representation = "SIGNED",
			u_lpm_mult.lpm_type = "LPM_MULT",
			u_lpm_mult.lpm_widtha = 16,
			u_lpm_mult.lpm_widthb = 11,
			u_lpm_mult.lpm_widthp = 27;

	end endgenerate
	


endmodule