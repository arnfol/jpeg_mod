module dct_it_math #(W = 16) (
	input                       clk        ,
	input                       rst_n      ,
	//
	input        signed [W-1:0] x_in  [7:0],
	output logic        [  7:0] x_out [7:0]
);

function automatic logic signed [18:0] round(logic signed [18:0] v);
	logic [15:0] result;
	logic sum_detect;
	sum_detect = v[0]|v[1];
	result = (~v[18]&v[2])|(v[18]&v[2]&sum_detect) ? v[18:3] + v[2] : v[18:3];
	return {result,3'd0};
endfunction : round

// vector extension
logic signed [18:0] x_in_e [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_v_ext
	if(~rst_n)
		x_in_e <= '{default:'0};
	else
		for (int i = 0; i < 8; i++)
			x_in_e[i] <= x_in[i]<<3;
end

// stage 1 pipe (Arria V GZ syn)
logic signed [18:0] temp_s1x_pipe [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_1_pipe
	if(~rst_n)
		temp_s1x_pipe <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s1x_pipe[i] <= x_in_e[i];
		temp_s1x_pipe[1] <= round(x_in_e[0]>>>1) - x_in_e[1];
		temp_s1x_pipe[3] <= x_in_e[3] - round((x_in_e[2]>>>3) + (x_in_e[2]>>>2));
		temp_s1x_pipe[6] <= round(x_in_e[5]>>>1) + x_in_e[6];
	end
end

// stage 1
logic signed [18:0] temp_s1x [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_1
	if(~rst_n)
		temp_s1x <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s1x[i] <= temp_s1x_pipe[i];
		temp_s1x[0] <= temp_s1x_pipe[0] - temp_s1x_pipe[1];
		temp_s1x[2] <= round((temp_s1x_pipe[3]>>>3) + (temp_s1x_pipe[3]>>>2)) + temp_s1x_pipe[2];
		temp_s1x[4] <= round(temp_s1x_pipe[7]>>>3) + temp_s1x_pipe[4];
		temp_s1x[5] <= temp_s1x_pipe[5] - round((temp_s1x_pipe[6]>>>3) + (temp_s1x_pipe[6]>>>2) + (temp_s1x_pipe[6]>>>1));
	end
end

// stage 2
logic signed [18:0] temp_s2x [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_2
	if(~rst_n)
		temp_s2x <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s2x[i] <= temp_s1x[i];
		temp_s2x[0] <= temp_s1x[0] + temp_s1x[3];
		temp_s2x[1] <= temp_s1x[1] + temp_s1x[2];
		temp_s2x[2] <= temp_s1x[1] - temp_s1x[2];
		temp_s2x[3] <= temp_s1x[0] - temp_s1x[3];
		temp_s2x[4] <= temp_s1x[4] + temp_s1x[5];
		temp_s2x[5] <= temp_s1x[4] - temp_s1x[5];
		temp_s2x[6] <= temp_s1x[7] - temp_s1x[6];
		temp_s2x[7] <= temp_s1x[6] + temp_s1x[7];
	end
end

// stage 3 pipe (Arria V GZ syn)
logic signed [18:0] temp_s3x_pipe [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_3_pipe
	if(~rst_n)
		temp_s3x_pipe <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s3x_pipe[i] <= temp_s2x[i];
		temp_s3x_pipe[5] <= round((temp_s2x[6]>>>3) + (temp_s2x[6]>>>1)) - temp_s2x[5];
	end
end

// stage 3
logic signed [18:0] temp_s3x [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_3
	if(~rst_n)
		temp_s3x <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s3x[i] <= temp_s3x_pipe[i];
		temp_s3x[6] <= temp_s3x_pipe[6] - round((temp_s3x_pipe[5]>>>3) + (temp_s3x_pipe[5]>>>2));
	end
end

// stage 4
logic signed [18:0] temp_s4x [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_4
	if(~rst_n)
		temp_s4x <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s4x[i] <= temp_s3x[i];
		for (int i = 0; i < 4; i++) begin
			temp_s4x[i]   <= temp_s3x[i] + temp_s3x[7-i];
			temp_s4x[4+i] <= temp_s3x[3-i] - temp_s3x[4+i];
		end
	end
end

// output res
always_ff @(posedge clk, negedge rst_n) begin : proc_res
	if(~rst_n)
		x_out <= '{default:'0};
	else
		for (int i = 0; i < 8; i++)
			x_out[i] <= (temp_s4x[i]>>>2)>>3;
end

endmodule