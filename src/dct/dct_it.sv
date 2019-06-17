module dct_it #(INPUT_W = 16) (
   input        signed [INPUT_W-1:0] x_in  [7:0],
   output logic        [        7:0] x_out [7:0]
);

// stage 1
logic signed [15:0] temp_s1x [7:0];

always_comb begin : proc_stage_1
   foreach (temp_s1x[i]) temp_s1x[i] = x_in[i];
   temp_s1x[1] = (x_in[0]>>>1) - x_in[1];
   temp_s1x[0] = x_in[0] - temp_s1x[1];
   temp_s1x[3] = x_in[3] - ((x_in[2]>>>3) + (x_in[2]>>>2));
   temp_s1x[2] = ((temp_s1x[3]>>>3) + (temp_s1x[3]>>>2)) + x_in[2];
   temp_s1x[4] = (x_in[7]>>>3) + x_in[4];
   temp_s1x[6] = (x_in[5]>>>1) + x_in[6];
   temp_s1x[5] = x_in[5] - ((temp_s1x[6]>>>3) + (temp_s1x[6]>>>2) + (temp_s1x[6]>>>1));
end

// stage 2
logic signed [15:0] temp_s2x [7:0];

always_comb begin : proc_stage_2
   foreach (temp_s2x[i]) temp_s2x[i] = temp_s1x[i];
   temp_s2x[0] = temp_s1x[0] + temp_s1x[3];
   temp_s2x[1] = temp_s1x[1] + temp_s1x[2];
   temp_s2x[2] = temp_s1x[1] - temp_s1x[2];
   temp_s2x[3] = temp_s1x[0] - temp_s1x[3];
   temp_s2x[4] = temp_s1x[4] + temp_s1x[5];
   temp_s2x[5] = temp_s1x[4] - temp_s1x[5];
   temp_s2x[6] = temp_s1x[7] - temp_s1x[6];
   temp_s2x[7] = temp_s1x[6] + temp_s1x[7];
end

// stage 3
logic signed [15:0] temp_s3x [7:0];

always_comb begin : proc_stage_3
   foreach (temp_s3x[i]) temp_s3x[i] = temp_s2x[i];
   temp_s3x[5] = ((temp_s2x[6]>>>3) + (temp_s2x[6]>>>1)) - temp_s2x[5];
   temp_s3x[6] = temp_s2x[6] - ((temp_s3x[5]>>>3) + (temp_s3x[5]>>>2));
end

// stage 4
logic signed [15:0] temp_s4x [7:0];

always_comb begin : proc_stage_4
   foreach (temp_s4x[i]) temp_s4x[i] = temp_s3x[i];
   for (int i = 0; i < 4; i++) begin
      temp_s4x[i]   = temp_s3x[i] + temp_s3x[7-i];
      temp_s4x[4+i] = temp_s3x[3-i] - temp_s3x[4+i];
   end
end

// output res
always_comb begin : proc_res
   foreach(x_out[i]) x_out[i] = temp_s4x[i];
end

endmodule