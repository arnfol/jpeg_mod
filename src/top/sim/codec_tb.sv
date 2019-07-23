`timescale 1ns/1ns

module codec_tb;

parameter N     = 2   ;
parameter X_RES = 2160;
parameter Y_RES = 1200;

localparam H_FRONT_PORCH_CYC = 40;
localparam H_BACK_PORCH_CYC  = 46;
localparam H_SYNC_CYC        = 20;
localparam V_FRONT_PORCH_CYC = 28;
localparam V_BACK_PORCH_CYC  = 234; // Original 234
localparam V_SYNC_CYC        = 2 ;

parameter FNUM = 3;

// global
bit clk  ;
bit rst_n;
bit en   ;

int error_y  = 0;
int error_cr = 0;
int error_cb = 0;

// hdmi
bit                   i_hdmi_v_sync    ;
bit                   i_hdmi_h_sync    ;
bit                   i_hdmi_data_valid;
bit signed [1:0][7:0] i_hdmi_data_y    ;
bit signed [1:0][7:0] i_hdmi_data_cr   ;
bit signed [1:0][7:0] i_hdmi_data_cb   ;

bit                   o_hdmi_v_sync    ;
bit                   o_hdmi_h_sync    ;
bit                   o_hdmi_data_valid;
bit signed [1:0][7:0] o_hdmi_data_y    ;
bit signed [1:0][7:0] o_hdmi_data_cr   ;
bit signed [1:0][7:0] o_hdmi_data_cb   ;

// test
logic [7:0] input_data_y [1:0][$];
logic [7:0] input_data_cr[1:0][$];
logic [7:0] input_data_cb[1:0][$];

logic [7:0] output_data_y [1:0][$];
logic [7:0] output_data_cr[1:0][$];
logic [7:0] output_data_cb[1:0][$];

always #5 clk = !clk;

//initial begin
//	#5000000 $display("%t : TIMEOUT : Test complete", $time);
//	$display("Y  DATA ERRORS: %d", error_y);
//	$display("CR DATA ERRORS: %d", error_cr);
//	$display("CB DATA ERRORS: %d", error_cb);
//	$stop(); // simulation timeout
//end

logic [7:0] result_y [1:0];
logic [7:0] result_cr[1:0];
logic [7:0] result_cb[1:0];


initial begin
	#40ms $display("%t : TIMEOUT : Test timeout", $time);
	$stop(); // simulation timeout
end

initial forever @(posedge clk iff rst_n) begin
	for (int i = 0; i < 2; i++) begin
		if(i_hdmi_data_valid) begin
			input_data_y[i].push_back(i_hdmi_data_y[i]);
			input_data_cr[i].push_back(i_hdmi_data_cr[i]);
			input_data_cb[i].push_back(i_hdmi_data_cb[i]);
		end

		if(o_hdmi_data_valid) begin
			output_data_y[i].push_back(o_hdmi_data_y[i]);
			output_data_cr[i].push_back(o_hdmi_data_cr[i]);
			output_data_cb[i].push_back(o_hdmi_data_cb[i]);
		end

		if(input_data_y[i].size()&&output_data_y[i].size()) begin
			result_y[i] = input_data_y[i].pop_front() - output_data_y[i].pop_front();
			assert(result_y[i]==8'd0||
			       result_y[i]==-8'd1||
			       result_y[i]==-8'd2||
			       result_y[i]==8'd1||
			       result_y[i]==8'd2)
			else error_y++;
		end

		if(input_data_cr[i].size()&&output_data_cr[i].size()) begin
			result_cr[i] = input_data_cr[i].pop_front() - output_data_cr[i].pop_front();
			assert(result_cr[i]==8'd0||
			       result_cr[i]==-8'd1||
			       result_cr[i]==-8'd2||
			       result_cr[i]==8'd1||
			       result_cr[i]==8'd2)
			else error_cr++;
		end

		if(input_data_cb[i].size()&&output_data_cb[i].size()) begin
			result_cb[i] = input_data_cb[i].pop_front() - output_data_cb[i].pop_front();
			assert(result_cb[i]==8'd0||
			       result_cb[i]==-8'd1||
			       result_cb[i]==-8'd2||
			       result_cb[i]==8'd1||
			       result_cb[i]==8'd2)
			else error_cb++;
		end

	end
end

int wait_cycles;
initial begin 	
	en = 1;
	rst_n = 0;
	repeat(2) @(posedge clk);
	rst_n = 1;

	repeat(FNUM) begin
		send_frame();
		// wait_for($urandom_range(0,50));
	end
	// repeat(18) send_line();

	$display("%t : Sending done", $time);

	$display("Y  DATA ERRORS: %d", error_y);
	$display("CR DATA ERRORS: %d", error_cr);
	$display("CB DATA ERRORS: %d", error_cb);
	$stop(); 
end

// tasks
task send_line();

	i_hdmi_h_sync <= 1;
	wait_for(H_SYNC_CYC/N);
	i_hdmi_h_sync <= 0;

	wait_for(H_BACK_PORCH_CYC/N);
	i_hdmi_data_valid <= 1;

	repeat(X_RES/N) begin
		i_hdmi_data_y  <= i_hdmi_data_y  + 1;
		i_hdmi_data_cb <= i_hdmi_data_cb + 1;
		i_hdmi_data_cr <= i_hdmi_data_cr + 1;
		@(posedge clk);
	end

	i_hdmi_data_valid <= 0;

	wait_for(H_FRONT_PORCH_CYC/N);

endtask : send_line

task wait_for(int cycles);
	repeat(cycles) @(posedge clk);
endtask : wait_for

task wait_lines(int lines);
	repeat(lines) begin
		i_hdmi_h_sync <= 1;
		wait_for(H_SYNC_CYC/N);
		i_hdmi_h_sync <= 0;
		wait_for(H_BACK_PORCH_CYC/N);
		wait_for(X_RES/N);
		wait_for(H_FRONT_PORCH_CYC/N);
	end
endtask : wait_lines

task send_frame();
	i_hdmi_v_sync <= 1;
	wait_lines(V_SYNC_CYC);
	i_hdmi_v_sync <= 0;
	wait_lines(V_BACK_PORCH_CYC);
	repeat(Y_RES) send_line();
	wait_lines(V_FRONT_PORCH_CYC);
endtask : send_frame

// instances
codec #(.N(N), .X_RES(X_RES), .Y_RES(Y_RES)) i_codec (
	.clk              (clk              ),
	.rst_n            (rst_n            ),
	.en               (en               ),
	.i_hdmi_v_sync    (i_hdmi_v_sync    ),
	.i_hdmi_h_sync    (i_hdmi_h_sync    ),
	.i_hdmi_data_valid(i_hdmi_data_valid),
	.i_hdmi_data_y    (i_hdmi_data_y    ),
	.i_hdmi_data_cr   (i_hdmi_data_cr   ),
	.i_hdmi_data_cb   (i_hdmi_data_cb   ),
	.o_hdmi_v_sync    (o_hdmi_v_sync    ),
	.o_hdmi_h_sync    (o_hdmi_h_sync    ),
	.o_hdmi_data_valid(o_hdmi_data_valid),
	.o_hdmi_data_y    (o_hdmi_data_y    ),
	.o_hdmi_data_cr   (o_hdmi_data_cr   ),
	.o_hdmi_data_cb   (o_hdmi_data_cb   )
);

endmodule