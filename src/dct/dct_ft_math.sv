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
	Description : binDCT Forward Transform algorithm. 17 step pipelined.
						
*/

module dct_ft_math #(W_I = 8) (
	input                              clk     ,
	input                              rst_n   ,
	input                              en      ,
	//
	input        signed [7:0][W_I-1:0] in_data ,
	output logic signed [7:0][   15:0] out_data
);

function automatic logic signed [18:0] round(logic signed [18:0] v);
	logic signed [15:0] result;
	logic sum_detect;

	sum_detect = v[0]|v[1];
	result = (~v[18]&v[2])|(v[18]&v[2]&sum_detect) ? v[18:3] + v[2] : v[18:3];

	return $signed({result,3'd0});
endfunction : round

// fixed point number
logic signed [18:0] fixed_point_num_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : fixed_point_num
	if(~rst_n)
		fixed_point_num_data <= '{default:'0};
	else if(en)
		for(int i=0; i<8; i++)
			fixed_point_num_data[i] <= $signed({in_data[i],3'd0});
end

// stage 1
logic signed [18:0] stage1_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_1
	if(~rst_n)
		stage1_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage1_data[i] <= fixed_point_num_data[i];

		for (int i = 0; i < 4; i++) begin
			stage1_data[i]   <= fixed_point_num_data[i] + fixed_point_num_data[7-i];
			stage1_data[4+i] <= fixed_point_num_data[3-i] - fixed_point_num_data[4+i];
		end
	end
end

// stage 2
logic signed [18:0] stage2_data [9:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_2
	if(~rst_n)
		stage2_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage2_data[i] <= stage1_data[i];

		stage2_data[8] <= stage1_data[5]>>>3;
		stage2_data[9] <= stage1_data[5]>>>2;
	end
end

// stage 3
logic signed [18:0] stage3_data [8:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_3
	if(~rst_n)
		stage3_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage3_data[i] <= stage2_data[i];

		stage3_data[8] <= round(stage2_data[8] + stage2_data[9]);
	end
end

// stage 4
logic signed [18:0] stage4_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_4
	if(~rst_n)
		stage4_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage4_data[i] <= stage3_data[i];

		stage4_data[6] <= stage3_data[8] + stage3_data[6];
	end
end

// stage 5
logic signed [18:0] stage5_data [9:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_5
	if(~rst_n)
		stage5_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage5_data[i] <= stage4_data[i];

		stage5_data[8] <= stage4_data[6]>>>3;
		stage5_data[9] <= stage4_data[6]>>>1;
	end
end

// stage 6
logic signed [18:0] stage6_data [8:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_6
	if(~rst_n)
		stage6_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage6_data[i] <= stage5_data[i];

		stage6_data[8] <= round(stage5_data[8] + stage5_data[9]);
	end
end

// stage 7
logic signed [18:0] stage7_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_7
	if(~rst_n)
		stage7_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage7_data[i] <= stage6_data[i];

		stage7_data[5] <= stage6_data[8] - stage6_data[5];
	end
end

// stage 8
logic signed [18:0] stage8_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_8
	if(~rst_n)
		stage8_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage8_data[i] <= stage7_data[i];

		stage8_data[0] <= stage7_data[0] + stage7_data[3];
		stage8_data[1] <= stage7_data[1] + stage7_data[2];
		stage8_data[2] <= stage7_data[1] - stage7_data[2];
		stage8_data[3] <= stage7_data[0] - stage7_data[3];
		stage8_data[4] <= stage7_data[4] + stage7_data[5];
		stage8_data[5] <= stage7_data[4] - stage7_data[5];
		stage8_data[6] <= stage7_data[7] - stage7_data[6];
		stage8_data[7] <= stage7_data[7] + stage7_data[6];
	end
end

// stage 9
logic signed [18:0] stage9_data [12:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_9
	if(~rst_n)
		stage9_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage9_data[i] <= stage8_data[i];

		stage9_data[0] <= stage8_data[0] + stage8_data[1];

		stage9_data[ 8] <= stage8_data[3]>>>3;
		stage9_data[ 9] <= stage8_data[3]>>>2;
		stage9_data[10] <= stage8_data[6]>>>3;
		stage9_data[11] <= stage8_data[6]>>>2;
		stage9_data[12] <= stage8_data[6]>>>1;
	end
end

// stage 10
logic signed [18:0] stage10_data [10:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_10
	if(~rst_n)
		stage10_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage10_data[i] <= stage9_data[i];

		stage10_data[ 8] <= round(stage9_data[8] + stage9_data[9]);
		stage10_data[ 9] <= stage9_data[10] + stage9_data[11];
		stage10_data[10] <= stage9_data[12];
	end
end

// stage 11
logic signed [18:0] stage11_data [8:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_11
	if(~rst_n)
		stage11_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage11_data[i] <= stage10_data[i];

		stage11_data[2] <= stage10_data[2] - stage10_data[8];

		stage11_data[8] <= round(stage10_data[9] + stage10_data[10]);
	end
end

// stage 12
logic signed [18:0] stage12_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_12
	if(~rst_n)
		stage12_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage12_data[i] <= stage11_data[i];

		stage12_data[5] <= stage11_data[8] + stage11_data[5];
	end
end

// stage 13
logic signed [18:0] stage13_data [12:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_13
	if(~rst_n)
		stage13_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage13_data[i] <= stage12_data[i];

		stage13_data[ 8] <= stage12_data[0]>>>1;
		stage13_data[ 9] <= stage12_data[2]>>>3;
		stage13_data[10] <= stage12_data[2]>>>2;
		stage13_data[11] <= stage12_data[7]>>>3;
		stage13_data[12] <= stage12_data[5]>>>1;
	end
end

// stage 14
logic signed [18:0] stage14_data [8:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_14
	if(~rst_n)
		stage14_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage14_data[i] <= stage13_data[i];

		stage14_data[1] <= round(stage13_data[8]) - stage13_data[1];
		stage14_data[4] <= stage13_data[4] - round(stage13_data[11]);
		stage14_data[6] <= stage13_data[6] - round(stage13_data[12]);

		stage14_data[8] <= round(stage13_data[9] + stage13_data[10]);
	end
end

// stage 15
logic signed [18:0] stage15_data [7:0];

always_ff @(posedge clk, negedge rst_n) begin : stage_15
	if(~rst_n)
		stage15_data <= '{default:'0};
	else if(en) begin
		for (int i = 0; i < 8; i++)
			stage15_data[i] <= stage14_data[i];

		stage15_data[3] <= stage14_data[8] + stage14_data[3];
	end
end

// output res
always_ff @(posedge clk, negedge rst_n) begin : proc_res
	if(~rst_n)
		out_data <= '{default:0};
	else if(en)
		for(int i=0; i<8; i++) begin
			out_data[0] <= $signed(stage15_data[0][18:3]);
			out_data[1] <= $signed(stage15_data[7][18:3]);
			out_data[2] <= $signed(stage15_data[3][18:3]);
			out_data[3] <= $signed(stage15_data[6][18:3]);
			out_data[4] <= $signed(stage15_data[1][18:3]);
			out_data[5] <= $signed(stage15_data[5][18:3]);
			out_data[6] <= $signed(stage15_data[2][18:3]);
			out_data[7] <= $signed(stage15_data[4][18:3]);
		end
end

endmodule