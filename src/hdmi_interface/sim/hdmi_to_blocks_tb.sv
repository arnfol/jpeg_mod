`timescale 1ns/1ns
module hdmi_to_blocks_tb ();

	parameter N = 2;
	parameter X_RES = 2160;
	parameter Y_RES = 1200;

	localparam H_FRONT_PORCH_CYC = 40;
	localparam H_BACK_PORCH_CYC = 46;
	localparam H_SYNC_CYC = 20;
	localparam V_FRONT_PORCH_CYC = 28;
	localparam V_BACK_PORCH_CYC = 24; // Original 234, but I don't want to wait so long
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

	/*------------------------------------------------------------------------------
	--  Controls
	------------------------------------------------------------------------------*/
	always #5 clk = !clk;

	initial begin
		#1000000 $display("%t : TIMEOUT : Test complete", $time);
		$stop(); // simulation timeout
	end

	int wait_cycles;
	initial begin 	
		en = 1;
		rst_n = 0;
		repeat(2) @(posedge clk);
		rst_n = 1;

		send_frame();
		// repeat(18) send_line();

		$display("%t : Sending done", $time);
		$stop(); 
	end

	/*------------------------------------------------------------------------------
	--  Tasks
	------------------------------------------------------------------------------*/
	task send_line();

		hdmi_h_sync <= 1;
		wait_for(H_SYNC_CYC);
		hdmi_h_sync <= 0;

		wait_for(H_BACK_PORCH_CYC);
		hdmi_data_valid <= 1;

		repeat(X_RES/N) begin
			hdmi_data_y  <= hdmi_data_y  + 1;
			hdmi_data_cb <= hdmi_data_cb + 1;
			hdmi_data_cr <= hdmi_data_cr + 1;
			@(posedge clk);
		end

		// hdmi_data_y  <= '0;
		// hdmi_data_cb <= '0;
		// hdmi_data_cr <= '0;
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