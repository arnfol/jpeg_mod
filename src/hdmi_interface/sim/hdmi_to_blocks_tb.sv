`timescale 1ns/1ns
module hdmi_to_blocks_tb ();

	parameter N = 2;
	parameter X_RES = 2160;
	parameter Y_RES = 1200;
	// parameter PIPE = 4;

	localparam H_FRONT_PORCH_CYC = 40;
	localparam H_BACK_PORCH_CYC = 46;
	localparam H_SYNC_CYC = 20;
	localparam V_FRONT_PORCH_CYC = 28;
	localparam V_BACK_PORCH_CYC = 234;
	localparam V_SYNC_CYC = 2;

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

	// initial begin
	// 	#0000 $display("%t : Test complete", $time);
	// 	$stop(); // simulation timeout
	// end

	int wait_cycles;
	initial begin 	
		en = 1;
		rst_n = 0;
		repeat(2) @(posedge clk);
		rst_n = 1;

		repeat(12) send_line();

		$display("%t : Test complete", $time);
		$stop(); 
	end

	// /*------------------------------------------------------------------------------
	// --  Tasks
	// ------------------------------------------------------------------------------*/
	task send_line();

		hdmi_h_sync <= 1;
		wait_for(H_SYNC_CYC);
		hdmi_h_sync <= 0;

		wait_for(H_BACK_PORCH_CYC);
		hdmi_data_valid <= 1;

		repeat(X_RES/N) begin
			hdmi_data_y  <= hdmi_data_y  + {N{8'd1}};
			hdmi_data_cb <= hdmi_data_cb + {N{8'd1}};
			hdmi_data_cr <= hdmi_data_cr + {N{8'd1}};
			@(posedge clk);
		end

		hdmi_data_y  <= '0;
		hdmi_data_cb <= '0;
		hdmi_data_cr <= '0;
		hdmi_data_valid <= 0;

		wait_for(H_FRONT_PORCH_CYC);

	endtask : send_line

	task wait_for(int cycles);
		repeat(cycles) @(posedge clk);
	endtask : wait_for

	task wait_lines(int lines);
		repeat(lines) begin
			hdmi_h_sync <= 1;
			wait_for(H_SYNC_CYC);
			hdmi_h_sync <= 0;
			wait_for(H_BACK_PORCH_CYC);
			wait_for(X_RES/N);
			wait_for(H_FRONT_PORCH_CYC);
		end
	endtask : wait_lines

	task send_frame();
		hdmi_v_sync <= 1;
		wait_lines(V_SYNC_CYC);
		hdmi_v_sync <= 0;
		wait_lines(V_BACK_PORCH_CYC);
		repeat(Y_RES) send_line();
		wait_lines(V_FRONT_PORCH_CYC);
	endtask : send_frame

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