/*
	 ------------------------------------------------------------------------------
	 -- The MIT License (MIT)
	 --
	 -- Copyright (c) <2019> Allavi Ali
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
	 Author      : Allavi Ali
	 Description : 
						
*/

module matrix_buffer #(W_IO = 16, TRPS = 0) (
	input                        clk      ,
	input                        rst_n    ,
	input                        en       ,
	// input interface
	input                        in_valid ,
	input        [7:0][W_IO-1:0] in_data  ,
	input                        in_eob   ,
	input                        in_sob   ,
	input                        in_sof   ,
	// output interface
	output logic                 out_valid,
	output logic [7:0][W_IO-1:0] out_data ,
	output logic                 out_eob  ,
	output logic                 out_sob  ,
	output logic                 out_sof
);

typedef logic [7:0][W_IO-1:0] matrix_t [7:0];

function automatic matrix_t transpose (logic [7:0][W_IO-1:0] matrix [7:0]);
	logic [7:0][W_IO-1:0] matrix_transpose [7:0];

	for (int i = 0; i < 8; i++)
		for (int j = 0; j < 8; j++)
			matrix_transpose[i][j] = matrix[j][i];

	return matrix_transpose;
endfunction : transpose

logic [7:0][W_IO-1:0] matrix_buffer          [1:0][7:0];
logic [7:0][W_IO-1:0] matrix_buffer_transpose[1:0][7:0];

logic sel_ibuffer;
logic sel_obuffer;

logic [2:0] mux_ibuffer;
logic [2:0] mux_obuffer;

logic [7:0] sof_buffer [1:0];

logic [1:0] out_counter;

// ctrl logic
always_ff @(posedge clk, negedge rst_n)
	if(~rst_n)
		out_valid <= '0;
	else if(&out_counter & en)
		out_valid <= 1;
	else if(out_valid & en)
		out_valid <= 0;
	else if(in_eob & in_valid & en)
		out_valid <= 1;
	else if(out_eob & out_valid & en)
		out_valid <= 0;

always_ff @(posedge clk, negedge rst_n)
	if(~rst_n)
		out_counter <= '0;
	else if(out_eob & out_valid & en)
		out_counter <= '0;
	else if((out_valid | |out_counter) & en)
		out_counter <= out_counter + 1;

always_comb begin
	out_sob = &(~mux_obuffer) & out_valid;
	out_eob = &mux_obuffer & out_valid;
end

// input buffer logic
always_ff @(posedge clk, negedge rst_n)
	if(!rst_n) begin
		sel_ibuffer <= '0;
		mux_ibuffer <= '0;
	end
	else if(in_eob & in_valid & en) begin
		sel_ibuffer <= ~sel_ibuffer;
		mux_ibuffer <= '0;
	end
	else if(in_valid & en)
		mux_ibuffer <= mux_ibuffer + 1;

// output buffer logic
always_ff @(posedge clk, negedge rst_n)
	if(!rst_n) begin
		sel_obuffer <= '0;
		mux_obuffer <= '0;
	end
	else if(out_eob & out_valid & en) begin
		sel_obuffer <= ~sel_obuffer;
		mux_obuffer <= '0;
	end
	else if(out_valid & en)
		mux_obuffer <= mux_obuffer + 1;

// matrix transpose
always_comb
	for (int i = 0; i < 2; i++)
		matrix_buffer_transpose[i] = transpose(matrix_buffer[i]);

// buffer upload
always_ff @(posedge clk, negedge rst_n)
	if(~rst_n) begin
		matrix_buffer <= '{default:'0};
		sof_buffer    <= '{default:'0};
	end
	else if(in_valid & en) begin
		matrix_buffer[sel_ibuffer][mux_ibuffer] <= in_data;
		sof_buffer[sel_ibuffer][mux_ibuffer]    <= in_sof ;
	end

// buffer unload
always_comb begin
	if(TRPS==1)
		out_data = matrix_buffer_transpose[sel_obuffer][mux_obuffer];
	else if(TRPS==0)
		out_data = matrix_buffer[sel_obuffer][mux_obuffer];

	out_sof = sof_buffer[sel_obuffer][mux_obuffer] & out_valid;
end

endmodule