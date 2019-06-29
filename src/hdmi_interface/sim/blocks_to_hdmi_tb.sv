`timescale 1ns/1ns
module blocks_to_hdmi_tb ();

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
	bit rst_n;

	logic hdmi_v_sync;
	logic hdmi_h_sync;
	logic hdmi_data_valid;
	logic signed [N-1:0][7:0] hdmi_data_y;
	logic signed [N-1:0][7:0] hdmi_data_cr;
	logic signed [N-1:0][7:0] hdmi_data_cb;

	bit blk_valid;
	bit signed [N-1:0][7:0] blk_data_y;
	bit signed [N-1:0][7:0] blk_data_cr;
	bit signed [N-1:0][7:0] blk_data_cb;
	bit blk_eob;
	bit blk_sob;
	bit blk_sof;

	/*------------------------------------------------------------------------------
	--  Controls
	------------------------------------------------------------------------------*/
	always #5 clk = !clk;

	initial begin
		#1000 $display("%t : TIMEOUT : Test complete", $time);
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
	task send_block(bit sof=0);

		for (int i = 0; i < 32; i++) begin
			in_sob <= (i == 0);
			in_sof <= (i == 0) && sof;
			in_eob <= (i == 31);
			in_valid <= 1;

			blk_data_y <= blk_data_y + 1;
			blk_data_cr <= blk_data_cr + 1;
			blk_data_cb <= blk_data_cb + 1;

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

	task send_8_lines(bit sof=0);
		send_block(sof);
		repeat(X_RES/8-1) send_block();
		wait_for(H_FRONT_PORCH_CYC+H_BACK_PORCH_CYC+H_SYNC_CYC);
	endtask : send_8_lines

	task send_frame();
		send_8_lines(sof=1);
		repeat((X_RES/8)*(Y_RES/8-1)) send_block();
		wait_for((V_FRONT_PORCH_CYC+V_BACK_PORCH_CYC+V_SYNC_CYC)*(X_RES/N+H_FRONT_PORCH_CYC+H_BACK_PORCH_CYC+H_SYNC_CYC));
	endtask : send_frame
	

	/*------------------------------------------------------------------------------
	--  DUT
	------------------------------------------------------------------------------*/
	blocks_to_hdmi #(.N(N), .X_RES(X_RES), .Y_RES(Y_RES)) i_blocks_to_hdmi (
	.clk            (clk            ),
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