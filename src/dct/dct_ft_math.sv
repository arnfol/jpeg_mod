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
    Description : binDCT Forward Transform algorithm
                  
*/

module dct_ft_math #(W_I = 8) (
	input                              clk     ,
	input                              rst_n   ,
	//
	input               [7:0][W_I-1:0] in_data ,
	output logic signed [7:0][   15:0] out_data
);

function automatic logic signed [18:0] round(logic signed [18:0] v);
	logic [15:0] result;
	logic sum_detect;

	sum_detect = v[0]|v[1];
	result = (~v[18]&v[2])|(v[18]&v[2]&sum_detect) ? v[18:3] + v[2] : v[18:3];

	return {result,3'd0};
endfunction : round

// unsigned to signed
logic signed [15:0] sign_data_in [7:0];

always_ff @(posedge clk, negedge rst_n) begin : u2s
	if(~rst_n)
		sign_data_in <= '{default:'0};
	else
		for(int i=0; i<8; i++)
			sign_data_in[i] <= $signed({'0,in_data[i]});
end

// stage 1
logic signed [18:0] stage1_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_1
	if(~rst_n)
		stage1_data <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			stage1_data[i] <= sign_data_in[i]<<3;

		for (int i = 0; i < 4; i++) begin
			stage1_data[i] <= (sign_data_in[i] + sign_data_in[7-i])<<3;
			stage1_data[4+i] <= (sign_data_in[3-i] - sign_data_in[4+i])<<3;
		end
	end
end

// stage 2
logic signed [18:0] stage2_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_2
	if(~rst_n)
		stage2_data <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			stage2_data[i] <= stage1_data[i];

		stage2_data[6] <= round((stage1_data[5]>>>3) + (stage1_data[5]>>>2)) + stage1_data[6];
	end
end

// stage 3
logic signed [18:0] stage3_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_3
	if(~rst_n)
		stage3_data <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			stage3_data[i] <= stage2_data[i];

		stage3_data[5] <= round((stage2_data[6]>>>3) + (stage2_data[6]>>>1)) - stage2_data[5];
	end
end

// stage 4
logic signed [18:0] stage4_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_4
	if(~rst_n)
		stage4_data <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			stage4_data[i] <= stage3_data[i];

		stage4_data[0] <= stage3_data[0] + stage3_data[3];
		stage4_data[1] <= stage3_data[1] + stage3_data[2];
		stage4_data[2] <= stage3_data[1] - stage3_data[2];
		stage4_data[3] <= stage3_data[0] - stage3_data[3];
		stage4_data[4] <= stage3_data[4] + stage3_data[5];
		stage4_data[5] <= stage3_data[4] - stage3_data[5];
		stage4_data[6] <= stage3_data[7] - stage3_data[6];
		stage4_data[7] <= stage3_data[7] + stage3_data[6];
	end
end

// stage 5
logic signed [18:0] stage5_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_5
	if(~rst_n)
		stage5_data <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			stage5_data[i] <= stage4_data[i];

		stage5_data[0] <= stage4_data[0] + stage4_data[1];
		stage5_data[2] <= stage4_data[2] - round((stage4_data[3]>>>3) + (stage4_data[3]>>>2));
		stage5_data[5] <= round((stage4_data[6]>>>3) + (stage4_data[6]>>>2) + (stage4_data[6]>>>1)) + stage4_data[5];
	end
end

// stage 6
logic signed [18:0] stage6_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_6
	if(~rst_n)
		stage6_data <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			stage6_data[i] <= stage5_data[i];

		stage6_data[1] <= round(stage5_data[0]>>>1) - stage5_data[1];
		stage6_data[3] <= round((stage5_data[2]>>>3) + (stage5_data[2]>>>2)) + stage5_data[3];
		stage6_data[4] <= stage5_data[4] - round(stage5_data[7]>>>3);
		stage6_data[6] <= stage5_data[6] - round(stage5_data[5]>>>1);
	end
end

// output res
always_ff @(posedge clk, negedge rst_n) begin : proc_res
	if(~rst_n)
		out_data <= '{default:0};
	else
		for(int i=0; i<8; i++)
			out_data[i] <= stage6_data[i][18:3];
end

endmodule