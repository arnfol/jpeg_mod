`timescale 1ns/1ns
module matrix_buffer_tb;

bit clk;
bit rst_n;

// test
logic [7:0] input_data_q   [7:0][$]    ;
logic [7:0] output_data_q  [7:0][$]    ;
logic [2:0] input_ctrl_q   [  $]       ;
logic [2:0] output_ctrl_q  [  $]       ;
logic [7:0] val            [1:0][7:0]  ;
int         error_data              = 0;
int         error_ctrl              = 0;

logic            in_valid;
logic [7:0][7:0] in_data ;
logic            in_eob  ;
logic            in_sob  ;
logic            in_sof  ;

logic            out_valid;
logic [7:0][7:0] out_data ;
logic            out_eob  ;
logic            out_sob  ;
logic            out_sof  ;

logic            out_valid_t[2:0];
logic [7:0][7:0] out_data_t [2:0];
logic            out_eob_t  [2:0];
logic            out_sob_t  [2:0];
logic            out_sof_t  [2:0];

/*------------------------------------------------------------------------------
--  Controls
------------------------------------------------------------------------------*/
always #5 clk = !clk;

initial begin
   #10000 $display("%t : Test complete", $time);
   $display("Data errors: %d",error_data);
   $display("Ctrl errors: %d",error_ctrl);
   $stop(); // simulation timeout
end

int wait_cycles;
initial begin  
   rst_n = 0;
   repeat(2) @(posedge clk);
   rst_n = 1;

   forever begin 
      if($urandom_range(1)) begin
         $display("%t : sending block", $time);
         send_block();
      end else begin 
         wait_cycles = $urandom_range(1,36);
         $display("%t : waiting for %0d cycles", $time, wait_cycles);
         wait_for(wait_cycles);
      end 
   end
end

initial
   forever @(posedge clk iff rst_n) begin
      if(in_valid) begin
         for (int i = 0; i < 8; i++)
            input_data_q[i].push_back(in_data[i]);
         input_ctrl_q.push_back({in_eob,in_sob,in_sof});
      end
      if(out_valid) begin
         for (int i = 0; i < 8; i++)
            output_data_q[i].push_back(out_data[i]);
         output_ctrl_q.push_back({out_eob,out_sob,out_sof});
      end
   end

initial
   forever @(posedge clk iff rst_n) begin
      for (int i = 0; i < 8; i++) begin
         if(input_data_q[i].size()&&output_data_q[i].size()) begin
            val[0][i] <= input_data_q[i].pop_front();
            val[1][i] <= output_data_q[i].pop_front();
            if(val[0][i]!=='x||val[1][i]!=='x)
               assert(val[0][i]==val[1][i]) 
               else error_data++;
         end
      end
      if(input_ctrl_q.size()&&output_ctrl_q.size())
         assert(input_ctrl_q.pop_front()==output_ctrl_q.pop_front())
         else error_ctrl++;
   end


/*------------------------------------------------------------------------------
--  Tasks
------------------------------------------------------------------------------*/
task send_block();

   for (int i = 0; i < 8; i++) begin
      in_sob <= (i == 0);
      in_sof <= (i == 0) && $urandom_range(1);
      in_eob <= (i == 7);
      in_valid <= 1;

      for (int i = 0; i < 8; i++) begin
         in_data[i] <= $urandom_range(1,255);
      end

      @(posedge clk);

      in_sob <= 0;
      in_sof <= 0;
      in_eob <= 0;
      in_valid <= 0;
   end

endtask : send_block

task wait_for(int cycles);;

   repeat(cycles) @(posedge clk);

endtask : wait_for

// instance

matrix_buffer #(.W_IO(8), .TRPS(0)) i_matrix_buffer0 (
   .clk      (clk           ),
   .rst_n    (rst_n         ),
   .in_valid (in_valid      ),
   .in_data  (in_data       ),
   .in_eob   (in_eob        ),
   .in_sob   (in_sob        ),
   .in_sof   (in_sof        ),
   .out_valid(out_valid_t[0]),
   .out_data (out_data_t[0] ),
   .out_eob  (out_eob_t[0]  ),
   .out_sob  (out_sob_t[0]  ),
   .out_sof  (out_sof_t[0]  )
);

matrix_buffer #(.W_IO(8), .TRPS(1)) i_matrix_buffer1 (
   .clk      (clk           ),
   .rst_n    (rst_n         ),
   .in_valid (out_valid_t[0]),
   .in_data  (out_data_t[0] ),
   .in_eob   (out_eob_t[0]  ),
   .in_sob   (out_sob_t[0]  ),
   .in_sof   (out_sof_t[0]  ),
   .out_valid(out_valid_t[1]),
   .out_data (out_data_t[1] ),
   .out_eob  (out_eob_t[1]  ),
   .out_sob  (out_sob_t[1]  ),
   .out_sof  (out_sof_t[1]  )
);

matrix_buffer #(.W_IO(8), .TRPS(1)) i_matrix_buffer2 (
   .clk      (clk           ),
   .rst_n    (rst_n         ),
   .in_valid (out_valid_t[1]),
   .in_data  (out_data_t[1] ),
   .in_eob   (out_eob_t[1]  ),
   .in_sob   (out_sob_t[1]  ),
   .in_sof   (out_sof_t[1]  ),
   .out_valid(out_valid_t[2]),
   .out_data (out_data_t[2] ),
   .out_eob  (out_eob_t[2]  ),
   .out_sob  (out_sob_t[2]  ),
   .out_sof  (out_sof_t[2]  )
);

matrix_buffer #(.W_IO(8), .TRPS(0)) i_matrix_buffer3 (
   .clk      (clk           ),
   .rst_n    (rst_n         ),
   .in_valid (out_valid_t[2]),
   .in_data  (out_data_t[2] ),
   .in_eob   (out_eob_t[2]  ),
   .in_sob   (out_sob_t[2]  ),
   .in_sof   (out_sof_t[2]  ),
   .out_valid(out_valid     ),
   .out_data (out_data      ),
   .out_eob  (out_eob       ),
   .out_sob  (out_sob       ),
   .out_sof  (out_sof       )
);

endmodule