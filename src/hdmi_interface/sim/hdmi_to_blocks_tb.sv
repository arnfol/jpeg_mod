`timescale 1ns/1ns
module hdmi_to_blocks_tb ();

	parameter N = 2;
	parameter X_RES = 2160;
	parameter Y_RES = 1200;
	// parameter PIPE = 4;

	bit clk;
	bit en;
	bit rst_n;

	bit hdmi_v_sync;
	bit hdmi_h_sync;
	bit hdmi_data_valid;
	bit signed [N-1:0][7:0] hdmi_data_y;
	bit signed [N-1:0][7:0] hdmi_data_cr;
	bit signed [N-1:0][7:0] hdmi_data_cb;

	logic blk_valid;
	logic signed [N-1:0][7:0] blk_data_y;
	logic signed [N-1:0][7:0] blk_data_cr;
	logic signed [N-1:0][7:0] blk_data_cb;
	logic blk_eob;
	logic blk_sob;
	logic blk_sof;

	// bit in_valid;
	// logic signed [N-1:0][15:0] in_data;
	// logic unsigned [N-1:0][9:0] in_mult;
	// bit in_eob;
	// bit in_sob;
	// bit in_sof;

	// logic out_valid;
	// logic signed [N-1:0][15:0] out_data;
	// logic out_eob;
	// logic out_sob;
	// logic out_sof;


	/*------------------------------------------------------------------------------
	--  Controls
	------------------------------------------------------------------------------*/
	always #5 clk = !clk;

	initial begin
		#1000 $display("%t : Test complete", $time);
		$stop(); // simulation timeout
	end

	int wait_cycles;
	initial begin 	
		en = 1;
		rst_n = 0;
		repeat(2) @(posedge clk);
		rst_n = 1;

		forever @(posedge clk) begin 
			hdmi_data_valid <= 1;
			hdmi_data_y  <= hdmi_data_y  + {N{8'd1}};
			hdmi_data_cb <= hdmi_data_cb + {N{8'd1}};
			hdmi_data_cr <= hdmi_data_cr + {N{8'd1}};
		end
	end

	// /*------------------------------------------------------------------------------
	// --  Tasks
	// ------------------------------------------------------------------------------*/
	// task send_block();

	// 	for (int i = 0; i < 32; i++) begin
	// 		in_sob <= (i == 0);
	// 		in_sof <= (i == 0) && $urandom_range(1);
	// 		in_eob <= (i == 31);
	// 		in_valid <= 1;

	// 		for (int i = 0; i < N; i++) begin
	// 			in_mult[i] <= $random();
	// 			in_data[i] <= $random();
	// 		end

	// 		@(posedge clk);

	// 		in_sob <= 0;
	// 		in_sof <= 0;
	// 		in_eob <= 0;
	// 		in_valid <= 0;
	// 	end

	// endtask : send_block

	// task wait_for(int cycles);;

	// 	repeat(cycles) @(posedge clk);

	// endtask : wait_for


	// /*------------------------------------------------------------------------------
	// --  CHECKER
	// ------------------------------------------------------------------------------*/
	// bit [PIPE-1:0] chk_valid, chk_eob, chk_sob, chk_sof;
	// bit [N-1:0][PIPE-1:0][15:0] chk_data;

	// always @(posedge clk) begin	
	// 	if(en) begin
	// 		for (int i = 0; i < N; i++) begin
	// 			chk_data[i] <= {chk_data[i], 16'(in_mult[i]*in_data[i])};
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
	// 		assert(chk_eob[PIPE-1] == out_eob);
	// 		assert(chk_sob[PIPE-1] == out_sob);
	// 		assert(chk_sof[PIPE-1] == out_sof);
	// 		for (int i = 0; i < N; i++) begin
	// 			assert(chk_data[i][PIPE-1] == out_data[i]);
	// 		end
	// 	end
	// end


	/*------------------------------------------------------------------------------
	--  DUT
	------------------------------------------------------------------------------*/
	
	hdmi_to_blocks #(.N(N), .X_RES(X_RES), .Y_RES(Y_RES)) i_hdmi_to_blocks (
		.clk            (clk            ),
		.en             (en             ),
		.rst_n          (rst_n          ),
		.hdmi_v_sync    (hdmi_v_sync    ),
		.hdmi_h_sync    (hdmi_h_sync    ),
		.hdmi_data_valid(hdmi_data_valid),
		.hdmi_data_y    (hdmi_data_y    ),
		.hdmi_data_cr   (hdmi_data_cr   ),
		.hdmi_data_cb   (hdmi_data_cb   ),
		.blk_valid      (blk_valid      ),
		.blk_data_y     (blk_data_y     ),
		.blk_data_cr    (blk_data_cr    ),
		.blk_data_cb    (blk_data_cb    ),
		.blk_eob        (blk_eob        ),
		.blk_sob        (blk_sob        ),
		.blk_sof        (blk_sof        )
	);


endmodule