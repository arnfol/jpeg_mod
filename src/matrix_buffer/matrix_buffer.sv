module matrix_buffer #(W = 16, TRPS = 0) (
   input                     clk      ,
   input                     rst_n    ,
   // input interface
   input                     in_valid ,
   input        [7:0][W-1:0] in_data  ,
   input                     in_eob   ,
   input                     in_sob   ,
   input                     in_sof   ,
   // output interface
   output logic              out_valid,
   output logic [7:0][W-1:0] out_data ,
   output logic              out_eob  ,
   output logic              out_sob  ,
   output logic              out_sof
);

typedef logic [7:0][15:0] matrix_t [7:0];

function automatic matrix_t transpose (logic [7:0][15:0] matrix [7:0]);
   logic [7:0][15:0] array_tps [7:0];
   foreach(matrix[i,j]) array_tps[i][j] = matrix[j][i];
   return array_tps;
endfunction : transpose

logic [7:0][15:0] matrix_buffer[1:0][7:0];
logic [7:0][15:0] matrix_trps  [1:0][7:0];
logic             sel_ibuffer            ;
logic             sel_obuffer            ;
logic [2:0]       mux_ibuffer            ;
logic [2:0]       mux_obuffer            ;

logic [7:0] sof_m [1:0];

// ctrl logic
always_ff @(posedge clk or negedge rst_n)
   if(~rst_n)
      out_valid <= '0;
   else if(in_eob&in_valid)
      out_valid <= 1;
   else if(out_eob&out_valid)
      out_valid <= 0;

always_comb begin
   out_sob = &(~mux_obuffer)&out_valid;
   out_eob = &mux_obuffer&out_valid;
end

// input buffer logic
always_ff @(posedge clk, negedge rst_n)
   if(!rst_n) begin
      sel_ibuffer <= '0;
      mux_ibuffer <= '0;
   end
   else begin 
      if(in_eob&in_valid)
         sel_ibuffer <= ~sel_ibuffer;

      if(in_eob&in_valid)
         mux_ibuffer <= '0;
      else if(in_valid)
         mux_ibuffer <= mux_ibuffer + 1;
   end

// output buffer logic
always_ff @(posedge clk, negedge rst_n) begin
   if(!rst_n) begin
      sel_obuffer <= '0;
      mux_obuffer <= '0;
   end
   else begin
      if(out_eob&out_valid)
         sel_obuffer <= ~sel_obuffer;

      if(out_eob&out_valid)
         mux_obuffer <= '0;
      else if(out_valid)
         mux_obuffer <= mux_obuffer + 1;
   end
end

// buffer accumulation
always_ff @(posedge clk, negedge rst_n)
   if(~rst_n) begin
      matrix_buffer <= '{default:'0};
      sof_m         <= '{default:'0};
   end
   else if(in_valid) begin
      matrix_buffer[sel_ibuffer][mux_ibuffer] <= in_data;
      sof_m[sel_ibuffer][mux_ibuffer]         <= in_sof;
   end

always_comb begin : proc_mtrps
   for (int i = 0; i < 2; i++) begin
      matrix_trps[i] = transpose(matrix_buffer[i]);
   end
end

// buffer unload
always_comb begin
   if(TRPS==1)
      out_data = matrix_tr[sel_obuffer][mux_obuffer];
   else if(TRPS==0)
      out_data = matrix_buffer[sel_obuffer][mux_obuffer];
   out_sof  = sof_m[sel_obuffer][mux_obuffer];
end

endmodule