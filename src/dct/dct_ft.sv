module dct_ft #(PIX_WIDTH = 8) (
   input        [PIX_WIDTH-1:0] x_in  [7:0],
   output logic [PIX_WIDTH-1:0] x_out [7:0]
);

// stage 1
logic [PIX_WIDTH-1:0] temp_s1x [7:0];

always_comb begin : proc_stage_1
   for (int i = 0; i < 4; i++) begin
      temp_s1x[i]   = x_in[i] + x_in[7-i];
      temp_s1x[4+i] = x_in[3-i] - x_in[4+i];
   end
end

// stage 2
logic [PIX_WIDTH-1:0] temp_s2x [6:5];

always_comb begin : proc_stage_2
   temp_s2x[5] = (temp_s2x[6]>>3 + temp_s2x[6]>>2 + temp_s2x[6]>>2) - temp_s1x[5];
   temp_s2x[6] = (temp_s1x[5]>>3 + temp_s1x[5]>>2) + temp_s1x[6];
end

// stage 3
logic [PIX_WIDTH-1:0] temp_s3x [7:0];

always_comb begin : proc_stage_3
   temp_s3x[0] = temp_s1x[0] + temp_s1x[3];
   temp_s3x[1] = temp_s1x[1] + temp_s1x[2];
   temp_s3x[2] = temp_s1x[1] - temp_s1x[2];
   temp_s3x[3] = temp_s1x[0] - temp_s1x[3];
   temp_s3x[4] = temp_s1x[4] + temp_s2x[5];
   temp_s3x[5] = temp_s1x[4] - temp_s2x[5];
   temp_s3x[6] = temp_s1x[7] - temp_s2x[6];
   temp_s3x[7] = temp_s1x[7] + temp_s2x[6];
end

// stage 4

endmodule