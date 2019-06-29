`timescale 1ns/1ns
module blocks_buf_tb ();

	parameter N = 2;
	parameter X_RES = 2160;
	parameter V_FRONT_PORCH_CYC = 28;
	parameter V_BACK_PORCH_CYC = 234;
	parameter V_SYNC_CYC = 2;
	// parameter SIZE = (X_RES/N)*(V_BACK_PORCH_CYC+V_SYNC_CYC);
	parameter SIZE = 16;

	bit clk;
	bit rst_n;

	bit                       in_valid  ;
	logic signed [N-1:0][7:0] in_data_y ;
	logic signed [N-1:0][7:0] in_data_cr;
	logic signed [N-1:0][7:0] in_data_cb;
	bit                       in_eob    ;
	bit                       in_sob    ;
	bit                       in_sof    ;

	logic                     out_valid  ;
	logic signed [N-1:0][7:0] out_data_y ;
	logic signed [N-1:0][7:0] out_data_cr;
	logic signed [N-1:0][7:0] out_data_cb;
	logic                     out_eob    ;
	logic                     out_sob    ;
	logic                     out_sof    ;
	bit                       out_ready  ;

	logic overflow;

	/*------------------------------------------------------------------------------
	--  Controls
	------------------------------------------------------------------------------*/
	always #5 clk = !clk;

	initial begin
		#10000 $display("%t : Test complete", $time);
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
				wait_cycles = $urandom_range(36);
				$display("%t : waiting for %0d cycles", $time, wait_cycles);
				wait_for(wait_cycles);
			end 
		end
	end


	bit not_first_sof;
	initial begin 
		out_ready = 1;
		forever	@(posedge clk) begin 
			if(out_valid && out_sof && !not_first_sof) begin 
				not_first_sof <= 1;
				out_ready <= 0;
				repeat(SIZE-5) @(posedge clk);
			end else begin 
				out_ready <= 1;
			end
		end
	end

	/*------------------------------------------------------------------------------
	--  Tasks
	------------------------------------------------------------------------------*/
	task send_block();
		in_data_y  = '0;
		in_data_cb = '0;
		in_data_cr = '0;

		for (int i = 0; i < 32; i++) begin
			in_sob <= (i == 0);
			in_sof <= (i == 0) && $urandom_range(1);
			in_eob <= (i == 31);
			in_valid <= 1;

			for (int i = 0; i < N; i++) begin
				in_data_y  <= (32'hA << N*8-4) | in_data_y  + 1 ;
				in_data_cb <= (32'hB << N*8-4) | in_data_cb + 1;
				in_data_cr <= (32'hC << N*8-4) | in_data_cr + 1;
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


	/*------------------------------------------------------------------------------
	--  CHECKER
	------------------------------------------------------------------------------*/
	// bit [PIPE-1:0] chk_valid, chk_eob, chk_sob, chk_sof;
	// bit signed [N-1:0][PIPE-1:0][15:0] chk_data;

	// always @(posedge clk) begin	
	// 	if(en) begin
	// 		for (int i = 0; i < N; i++) begin
	// 			chk_data[i] <= {chk_data[i], 16'(in_data[i]/in_denom[i])}; // here should be a mistake
	// 		end
	// 		chk_valid <= {chk_valid, in_valid};
	// 		chk_eob <= {chk_eob, in_eob};
	// 		chk_sob <= {chk_sob, in_sob};
	// 		chk_sof <= {chk_sof, in_sof};
	// 	end
	// end

	// always @(posedge clk) begin 
	// 	assert(chk_valid[PIPE-1] == out_valid);
	// 	if(out_valid) begin 
	// 		assert(chk_eob[PIPE-1] == out_eob) 
	// 			else $display("%t : EOB comparing error, expecting %0h", $time, chk_eob[PIPE-1]);
	// 		assert(chk_sob[PIPE-1] == out_sob)
	// 			else $display("%t : SOB comparing error, expecting %0h", $time, chk_sob[PIPE-1]);
	// 		assert(chk_sof[PIPE-1] == out_sof)
	// 			else $display("%t : SOF comparing error, expecting %0h", $time, chk_sof[PIPE-1]);

	// 		// do not check data due to mistake in tb divider model
	// 		// for (int i = 0; i < N; i++) begin
	// 		// 	assert(chk_data[i][PIPE-1] == out_data[i])
	// 		// 	else $display("%t : Data[%0d] comparing error, expecting %0d, got %0d", $time, i, chk_data[i][PIPE-1], out_data[i]);
	// 		// end
	// 	end
	// end


	/*------------------------------------------------------------------------------
	--  DUT
	------------------------------------------------------------------------------*/	
	blocks_buf #(.N(N), .SIZE(SIZE)) i_blocks_buf (
		.clk        (clk        ), 
		.rst_n      (rst_n      ), 
		.overflow   (overflow   ),
		.in_valid   (in_valid   ),
		.in_data_y  (in_data_y  ),
		.in_data_cr (in_data_cr ),
		.in_data_cb (in_data_cb ),
		.in_eob     (in_eob     ),
		.in_sob     (in_sob     ),
		.in_sof     (in_sof     ),
		.out_valid  (out_valid  ), 
		.out_ready  (out_ready  ),
		.out_data_y (out_data_y ),
		.out_data_cr(out_data_cr),
		.out_data_cb(out_data_cb),
		.out_eob    (out_eob    ),
		.out_sob    (out_sob    ),
		.out_sof    (out_sof    )
	);


endmodule