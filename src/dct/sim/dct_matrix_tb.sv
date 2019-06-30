`timescale 1ns/1ns
module dct_matrix_tb;

bit clk;
bit rst_n;

// test
logic [7:0] input_data_q   [1:0][$]    ;
logic [7:0] output_data_q  [1:0][$]    ;
logic [2:0] input_ctrl_q   [  $]       ;
logic [2:0] output_ctrl_q  [  $]       ;
logic [7:0] val            [1:0][1:0]  ;
int         error_data              = 0;
int         error_ctrl              = 0;

bit [1:0][9:0] in_denom;
bit [1:0][9:0] in_mult;

always_comb
	for (int i = 0; i < 2; i++) begin
		in_denom[i]  = 1;
	
		in_mult[i]  = 1;
	end

logic            in_valid;
logic [1:0][7:0] in_data ;
logic            in_eob  ;
logic            in_sob  ;
logic            in_sof  ;

logic            out_valid;
logic [1:0][7:0] out_data ;
logic            out_eob  ;
logic            out_sob  ;
logic            out_sof  ;

logic                    out_valid_dct;
logic signed [1:0][15:0] out_data_dct ;
logic                    out_eob_dct  ;
logic                    out_sob_dct  ;
logic                    out_sof_dct  ;

logic                    out_valid_div;
logic signed [1:0][15:0] out_data_div ;
logic                    out_eob_div  ;
logic                    out_sob_div  ;
logic                    out_sof_div  ;

logic                    out_valid_mul;
logic signed [1:0][15:0] out_data_mul ;
logic                    out_eob_mul  ;
logic                    out_sob_mul  ;
logic                    out_sof_mul  ;
/*------------------------------------------------------------------------------
--  Controls
------------------------------------------------------------------------------*/
always #5 clk = !clk;

initial begin
	#10000000 $display("%t : TIME OUT", $time);
	$display("Data errors: %d",error_data);
	$display("Ctrl errors: %d",error_ctrl);
	$stop(); // simulation timeout
end

logic [7:0] result [1:0];
initial
	forever @(posedge clk iff rst_n) begin
		
		if(in_valid) begin
			for (int i = 0; i < 2; i++)
				input_data_q[i].push_back(in_data[i]);
			input_ctrl_q.push_back({in_eob,in_sob,in_sof});
		end

		if(out_valid) begin
			for (int i = 0; i < 2; i++)
				output_data_q[i].push_back(out_data[i]);
			output_ctrl_q.push_back({out_eob,out_sob,out_sof});
		end

		for (int i = 0; i < 2; i++) begin
			if(input_data_q[i].size()&&output_data_q[i].size()) begin
				result[i] = input_data_q[i].pop_front() - output_data_q[i].pop_front();
				assert((result[i]==8'd0)||
						 (result[i]==8'd1)||
						 (result[i]==-8'd1)||
						 (result[i]==-8'd2)||
						 (result[i]==8'd2)) 
				else error_data++;
			end
		end

		if(input_ctrl_q.size()&&output_ctrl_q.size())
			assert(input_ctrl_q.pop_front()==output_ctrl_q.pop_front())
			else error_ctrl++;

	end

int wait_cycles;
// main
initial begin  
	rst_n = 0;
	repeat(2) @(posedge clk);
	rst_n = 1;

	repeat(1000) begin 
		if($urandom_range(1)) begin
			$display("%t : sending block", $time);
			send_block(0);
		end else begin 
			wait_cycles = $urandom_range(1,36);
			$display("%t : waiting for %0d cycles", $time, wait_cycles);
			wait_for(wait_cycles);
		end 
	end

	repeat(1000) begin 
		if($urandom_range(1)) begin
			$display("%t : sending block", $time);
			send_block(1);
		end else begin 
			wait_cycles = $urandom_range(1,36);
			$display("%t : waiting for %0d cycles", $time, wait_cycles);
			wait_for(wait_cycles);
		end 
	end

	@(posedge clk);
	$display("%t : Test complete", $time);
	$display("Data errors: %d",error_data);
	$display("Ctrl errors: %d",error_ctrl);
	$stop(); // simulation timeout
end

/*------------------------------------------------------------------------------
--  Tasks
------------------------------------------------------------------------------*/
task send_block(bit que = 0);

	for (int i = 0; i < 32; i++) begin
		in_sob <= (i == 0);
		in_sof <= (i == 0) && $urandom_range(1);
		in_eob <= (i == 31);
		in_valid <= 1;

		for (int i = 0; i < 2; i++) begin
			in_data[i] <= $urandom_range(0,255);
		end

		@(posedge clk);

		in_sob <= 0;
		in_sof <= 0;
		in_eob <= 0;
		in_valid <= 0;
		in_data[i] <= $urandom_range(0,255);
		if(que)
			wait_for($urandom_range(0,20));
	end

endtask : send_block

task wait_for(int cycles);

	repeat(cycles) @(posedge clk);

endtask : wait_for

// instance

dct_ft_matrix i_dct_ft_m (
	.clk      (clk          ),
	.rst_n    (rst_n        ),
	.en       (1            ),
	.in_valid (in_valid     ),
	.in_data  (in_data      ),
	.in_eob   (in_eob       ),
	.in_sob   (in_sob       ),
	.in_sof   (in_sof       ),
	.out_valid(out_valid_dct),
	.out_data (out_data_dct ),
	.out_eob  (out_eob_dct  ),
	.out_sob  (out_sob_dct  ),
	.out_sof  (out_sof_dct  )
);

flow_divider #(.N(2)) i_flow_divider (
	.clk      (clk          ),
	.en       (1            ),
	.rst_n    (rst_n        ),
	.in_valid (out_valid_dct),
	.in_data  (out_data_dct ),
	.in_denom (in_denom     ),
	.in_eob   (out_eob_dct  ),
	.in_sob   (out_sob_dct  ),
	.in_sof   (out_sof_dct  ),
	.out_valid(out_valid_div),
	.out_data (out_data_div ),
	.out_eob  (out_eob_div  ),
	.out_sob  (out_sob_div  ),
	.out_sof  (out_sof_div  )
);

flow_mult #(.N(2)) i_flow_mult (
	.clk      (clk          ),
	.en       (1            ),
	.rst_n    (rst_n        ),
	.in_valid (out_valid_div),
	.in_data  (out_data_div ),
	.in_mult  (in_mult      ),
	.in_eob   (out_eob_div  ),
	.in_sob   (out_sob_div  ),
	.in_sof   (out_sof_div  ),
	.out_valid(out_valid_mul),
	.out_data (out_data_mul ),
	.out_eob  (out_eob_mul  ),
	.out_sob  (out_sob_mul  ),
	.out_sof  (out_sof_mul  )
);

dct_it_matrix i_dct_it_m (
	.clk      (clk          ),
	.rst_n    (rst_n        ),
	.en       (1            ),
	.in_valid (out_valid_mul),
	.in_data  (out_data_mul ),
	.in_eob   (out_eob_mul  ),
	.in_sob   (out_sob_mul  ),
	.in_sof   (out_sof_mul  ),
	.out_valid(out_valid    ),
	.out_data (out_data     ),
	.out_eob  (out_eob      ),
	.out_sob  (out_sob      ),
	.out_sof  (out_sof      )
);

endmodule