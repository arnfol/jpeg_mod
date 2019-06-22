module dct_ft_math #(W = 8) (
	input                       clk        ,
	input                       rst_n      ,
	//
	input               [W-1:0] x_in  [7:0],
	output logic signed [ 15:0] x_out [7:0]
);

function automatic logic signed [18:0] round(logic signed [18:0] v);
	logic [15:0] result;
	logic sum_detect;
	sum_detect = v[0]|v[1];
	result = (~v[18]&v[2])|(v[18]&v[2]&sum_detect) ? v[18:3] + v[2] : v[18:3];
	return {result,3'd0};
endfunction : round

// unsigned to signed
logic signed [15:0] sx_in [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_u2s
	if(~rst_n)
		sx_in <= '{default:'0};
	else
		for(int i=0; i<8; i++)
			sx_in[i] <= $signed(x_in[i]);
end

// stage 1
logic signed [18:0] temp_s1x [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_1
	if(~rst_n)
		temp_s1x <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s1x[i] <= sx_in[i]<<3;
		for (int i = 0; i < 4; i++) begin
			temp_s1x[i] <= (sx_in[i] + sx_in[7-i])<<3;
			temp_s1x[4+i] <= (sx_in[3-i] - sx_in[4+i])<<3;
		end
	end
end

// stage 2 pipe (Arria V GZ syn)
logic signed [18:0] temp_s2x_pipe [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_2_pipe
	if(~rst_n)
		temp_s2x_pipe <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s2x_pipe[i] <= temp_s1x[i];
		temp_s2x_pipe[6] <= round((temp_s1x[5]>>>3) + (temp_s1x[5]>>>2)) + temp_s1x[6];
	end
end

// stage 2
logic signed [18:0] temp_s2x [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_2
	if(~rst_n)
		temp_s2x <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s2x[i] <= temp_s2x_pipe[i];
		temp_s2x[5] <= round((temp_s2x_pipe[6]>>>3) + (temp_s2x_pipe[6]>>>1)) - temp_s2x_pipe[5];
	end
end

// stage 3
logic signed [18:0] temp_s3x [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_3
	if(~rst_n)
		temp_s3x <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s3x[i] <= temp_s2x[i];
		temp_s3x[0] <= temp_s2x[0] + temp_s2x[3];
		temp_s3x[1] <= temp_s2x[1] + temp_s2x[2];
		temp_s3x[2] <= temp_s2x[1] - temp_s2x[2];
		temp_s3x[3] <= temp_s2x[0] - temp_s2x[3];
		temp_s3x[4] <= temp_s2x[4] + temp_s2x[5];
		temp_s3x[5] <= temp_s2x[4] - temp_s2x[5];
		temp_s3x[6] <= temp_s2x[7] - temp_s2x[6];
		temp_s3x[7] <= temp_s2x[7] + temp_s2x[6];
	end
end

// stage 4 pipe (Arria V GZ syn)
logic signed [18:0] temp_s4x_pipe [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_4_pipe
	if(~rst_n)
		temp_s4x_pipe <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s4x_pipe[i] <= temp_s3x[i];
		temp_s4x_pipe[0] <= temp_s3x[0] + temp_s3x[1];
		temp_s4x_pipe[2] <= temp_s3x[2] - round((temp_s3x[3]>>>3) + (temp_s3x[3]>>>2));
		temp_s4x_pipe[5] <= round((temp_s3x[6]>>>3) + (temp_s3x[6]>>>2) + (temp_s3x[6]>>>1)) + temp_s3x[5];
	end
end

// stage 4
logic signed [18:0] temp_s4x [7:0];

always_ff @(posedge clk, negedge rst_n) begin : proc_stage_4
	if(~rst_n)
		temp_s4x <= '{default:'0};
	else begin
		for (int i = 0; i < 8; i++)
			temp_s4x[i] <= temp_s4x_pipe[i];
		temp_s4x[1] <= round(temp_s4x_pipe[0]>>>1) - temp_s4x_pipe[1];
		temp_s4x[3] <= round((temp_s4x_pipe[2]>>>3) + (temp_s4x_pipe[2]>>>2)) + temp_s4x_pipe[3];
		temp_s4x[4] <= temp_s4x_pipe[4] - round(temp_s4x_pipe[7]>>>3);
		temp_s4x[6] <= temp_s4x_pipe[6] - round(temp_s4x_pipe[5]>>>1);
	end
end

// output res
always_ff @(posedge clk, negedge rst_n) begin : proc_res
	if(~rst_n)
		x_out <= '{default:0};
	else
		for(int i=0; i<8; i++)
			x_out[i] <= temp_s4x[i][18:3];
end

endmodule