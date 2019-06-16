module dct_ft #(INPUT_W = 8) (
   input               [INPUT_W-1:0] x_in  [7:0],
   output logic signed [       15:0] x_out [7:0]
);

// unsigned to signed
logic signed [15:0] sx_in [7:0];

always_comb begin : proc_u2s
   foreach(sx_in[i]) sx_in[i] = $signed(x_in[i]);
end

// stage 1
logic signed [15:0] temp_s1x [7:0];

always_comb begin : proc_stage_1
   foreach (temp_s1x[i]) temp_s1x[i] = '0;
   for (int i = 0; i < 4; i++) begin
      temp_s1x[i]   = sx_in[i] + sx_in[7-i];
      temp_s1x[4+i] = sx_in[3-i] - sx_in[4+i];
   end
end

// stage 2
logic signed [15:0] temp_s2x [7:0];

always_comb begin : proc_stage_2
   foreach (temp_s2x[i]) temp_s2x[i] = temp_s1x[i];
   temp_s2x[5] = (temp_s2x[6]>>>3 + temp_s2x[6]>>>1) - temp_s1x[5];
   temp_s2x[6] = (temp_s1x[5]>>>3 + temp_s1x[5]>>>2) + temp_s1x[6];
end

// stage 3
logic signed [15:0] temp_s3x [7:0];

always_comb begin : proc_stage_3
   foreach (temp_s3x[i]) temp_s3x[i] = temp_s2x[i];
   temp_s3x[0] = temp_s2x[0] + temp_s2x[3];
   temp_s3x[1] = temp_s2x[1] + temp_s2x[2];
   temp_s3x[2] = temp_s2x[1] - temp_s2x[2];
   temp_s3x[3] = temp_s2x[0] - temp_s2x[3];
   temp_s3x[4] = temp_s2x[4] + temp_s2x[5];
   temp_s3x[5] = temp_s2x[4] - temp_s2x[5];
   temp_s3x[6] = temp_s2x[7] - temp_s2x[6];
   temp_s3x[7] = temp_s2x[7] + temp_s2x[6];
end

// stage 4
logic signed [15:0] temp_s4x [7:0];

always_comb begin : proc_stage_4
   foreach (temp_s4x[i]) temp_s4x[i] = temp_s3x[i];
   temp_s4x[0] = temp_s3x[0] + temp_s3x[1];
   temp_s4x[1] = temp_s4x[0]>>>1 - temp_s3x[1];
   temp_s4x[2] = (temp_s3x[3]>>>3 + temp_s3x[3]>>>2) - temp_s3x[2];
   temp_s4x[3] = (temp_s4x[2]>>>3 + temp_s4x[2]>>>2) + temp_s3x[3];
   temp_s4x[4] = temp_s3x[4] - temp_s3x[7]>>>3;
   temp_s4x[5] = (temp_s3x[6]>>>3 + temp_s3x[6]>>>2 + temp_s3x[6]>>>1) + temp_s3x[5];
   temp_s4x[6] = temp_s3x[6] - temp_s4x[5]>>>1;
end

// output res
always_comb begin : proc_res
   foreach(x_out[i]) x_out[i] = temp_s4x[i];
end

endmodule