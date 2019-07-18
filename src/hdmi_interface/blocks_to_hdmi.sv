/*
    ------------------------------------------------------------------------------
    -- The MIT License (MIT)
    --
    -- Copyright (c) <2019> Konovalov Vitaliy
    --
    -- Permission is hereby granted, free of charge, to any person obtaining a copy
    -- of this software and associated documentation files (the "Software"), to deal
    -- in the Software without restriction, including without limitation the rights
    -- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    -- copies of the Software, and to permit persons to whom the Software is
    -- furnished to do so, subject to the following conditions:
    --
    -- The above copyright notice and this permission notice shall be included in
    -- all copies or substantial portions of the Software.
    --
    -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    -- THE SOFTWARE.
    -------------------------------------------------------------------------------
    Project     : JPEG_MOD
    Author      : Konovalov Vitaliy
    Description :   
                  
*/
module blocks_to_hdmi #(
	N     = 2   , // bus width
	X_RES = 2160, // X resolution, should be dividable by 8 (block width)
	Y_RES = 1200  // Y resolution should be dividable by 8 (block height)
) (
	input                            clk            ,
	input                            rst_n          ,
	input                            en             ,
	// hdmi interface
	output logic                     hdmi_v_sync    ,
	output logic                     hdmi_h_sync    ,
	output logic                     hdmi_data_valid,
	output logic signed [N-1:0][7:0] hdmi_data_y    ,
	output logic signed [N-1:0][7:0] hdmi_data_cr   ,
	output logic signed [N-1:0][7:0] hdmi_data_cb   ,
	// block interface
	input                            blk_valid      ,
	input        signed [N-1:0][7:0] blk_data_y     ,
	input        signed [N-1:0][7:0] blk_data_cr    ,
	input        signed [N-1:0][7:0] blk_data_cb    ,
	input                            blk_eob        , // end of block
	input                            blk_sob        , // start of block
	input                            blk_sof          // start of frame
);

	localparam BLOCK_SIZE = 8;
	localparam BUF_DEPTH = X_RES*BLOCK_SIZE/N;

	localparam H_FRONT_PORCH_CYC = 40;
	localparam H_BACK_PORCH_CYC = 46;
	localparam H_SYNC_CYC = 20;
	localparam V_FRONT_PORCH_CYC = 28;
	localparam V_BACK_PORCH_CYC = 234;
	localparam V_SYNC_CYC = 2;

	localparam LINE_WIDTH = (X_RES + H_FRONT_PORCH_CYC + H_BACK_PORCH_CYC + H_SYNC_CYC)/N;

	logic [8*3*N-1:0] buf1 [BUF_DEPTH];
	logic             buf1_wr_en;
	logic [8*3*N-1:0] buf1_o    ;
	logic [8*3*N-1:0] buf2 [BUF_DEPTH];
	logic             buf2_wr_en;
	logic [8*3*N-1:0] buf2_o    ;

	logic signed [N-1:0][7:0] pipe_data_y   ;
	logic signed [N-1:0][7:0] pipe_data_cr  ;
	logic signed [N-1:0][7:0] pipe_data_cb  ;
	logic                     pipe_blk_valid;
	logic                     pipe_blk_sof  ;

	logic [$clog2(BUF_DEPTH)-1:0] wr_cntr   ;
	logic                         wr_cntr_en;
	logic [$clog2(BUF_DEPTH)-1:0] rd_cntr   ;
	logic                         rd_cntr_en;

	logic [$clog2(X_RES/BLOCK_SIZE)-1:0] block     ;
	logic [      $clog2(BLOCK_SIZE)-1:0] block_line;
	logic [    $clog2(BLOCK_SIZE/N)-1:0] block_elem;

	logic buf_empty ;
	logic buf_full  ;
	logic buf_select;

	logic got_sof;

	logic h_sync;
	logic v_sync;

	enum logic [2:0] {IDLE,
	                  LINE_DATA,
	                  LINE_SYNC,
	                  FRAME_F_PORCH,
	                  FRAME_B_PORCH,
	                  FRAME_SYNC} state, next_state;


	logic [$clog2((H_FRONT_PORCH_CYC+H_BACK_PORCH_CYC+H_SYNC_CYC)/N)-1:0] next_h_sync_cntr, h_sync_cntr;
	logic [$clog2(Y_RES)-1:0] next_line_num, line_num;
	logic [$clog2(LINE_WIDTH)-1:0] next_pix_cntr, pix_cntr;

	/*------------------------------------------------------------------------------
	--  INPUT BUFFERS
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk) begin
		buf1_o <= buf1[rd_cntr];
		if(buf1_wr_en) begin
			buf1[wr_cntr] <= {pipe_data_cb, pipe_data_cr, pipe_data_y};
		end
	end

	always_ff @(posedge clk) begin
		buf2_o <= buf2[rd_cntr];
		if(buf2_wr_en) begin
			buf2[wr_cntr] <= {pipe_data_cb, pipe_data_cr, pipe_data_y};
		end
	end

	// additional pipeline for wr_cntr pipeline compensation
	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			pipe_data_cb   <= '0;
			pipe_data_cr   <= '0;
			pipe_data_y    <= '0;
			pipe_blk_valid <= '0;
			pipe_blk_sof   <= '0;
		end else begin
			pipe_data_cb   <= blk_data_cb;
			pipe_data_cr   <= blk_data_cr;
			pipe_data_y    <= blk_data_y;
			pipe_blk_valid <= blk_valid;
			pipe_blk_sof   <= blk_sof;
		end
	end


	/*------------------------------------------------------------------------------
	--  COUNTERS
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk or negedge rst_n) begin : proc_wr_cntr
		if(~rst_n) begin
			rd_cntr <= '0;
		end else if(rd_cntr_en) begin
			rd_cntr <= (rd_cntr < BUF_DEPTH-1) ? rd_cntr + 1'b1 : '0;
		end
	end	

 	assign buf_empty = (rd_cntr == BUF_DEPTH-1);

	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			block      <= '0;
			block_line <= '0;
			block_elem <= '0;
		end else if(wr_cntr_en)begin
			if(block_elem == BLOCK_SIZE/N-1) begin // end of block line
				block_elem <= '0;
				if(block_line == BLOCK_SIZE-1) begin // end of block
					block_line <= '0;
					block      <= (block == X_RES/BLOCK_SIZE-1) ? 0 : block + 1'b1;
					// if not end of block
				end else block_line <= block_line + 1'b1;
				// if not end of block line
			end else block_elem <= block_elem + 1'b1;
		end
	end

	// additional pipeline for synthesis
	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			wr_cntr  <= '0;
			buf_full <= 0;
		end else begin
			wr_cntr  <= block_elem + block_line*X_RES/N + block*BLOCK_SIZE/N;
			buf_full <= (wr_cntr >= BUF_DEPTH-1);
		end
	end


	/*------------------------------------------------------------------------------
	--  Control logic
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			buf_select <= 0;
		end else if(buf_full) begin
			buf_select <= !buf_select;
		end
	end

	assign wr_cntr_en = blk_valid;
	assign buf1_wr_en = !buf_select && pipe_blk_valid && got_sof;
	assign buf2_wr_en =  buf_select && pipe_blk_valid && got_sof;
	
	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			got_sof <= 0;
		end else begin
			if(blk_valid && blk_sof) got_sof <= en;
			else if(next_state == FRAME_F_PORCH) got_sof <= 0;
		end
	end


	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state       <= IDLE;
			h_sync_cntr <= '0;
			line_num    <= '0;
			pix_cntr    <= '0;
		end else begin
			state       <= next_state;
			h_sync_cntr <= next_h_sync_cntr;
			line_num    <= next_line_num;
			pix_cntr    <= next_pix_cntr;
		end
	end

	always_comb begin
		rd_cntr_en       = 0;
		h_sync           = 0;
		v_sync           = 0;
		next_h_sync_cntr = h_sync_cntr;
		next_line_num    = line_num;
		next_pix_cntr    = pix_cntr;
		next_state       = state;

		case (state)
			IDLE : begin
				if(buf_full && got_sof) next_state = LINE_DATA;
			end

			LINE_DATA : begin
				rd_cntr_en = 1;

				// what a shame, should have made 3-dimentional buffers
				if(rd_cntr == 1*X_RES/N-1
					|| rd_cntr == 2*X_RES/N-1
					|| rd_cntr == 3*X_RES/N-1
					|| rd_cntr == 4*X_RES/N-1
					|| rd_cntr == 5*X_RES/N-1
					|| rd_cntr == 6*X_RES/N-1
					|| rd_cntr == 7*X_RES/N-1
					|| rd_cntr == 8*X_RES/N-1
				) begin
					next_line_num = line_num + 1;
					next_state    = LINE_SYNC;
				end else begin
					next_state = LINE_DATA;
				end
			end

			LINE_SYNC : begin
				next_h_sync_cntr = h_sync_cntr + 1;
				h_sync           = (h_sync_cntr > H_FRONT_PORCH_CYC/N-1) && (h_sync_cntr < (H_FRONT_PORCH_CYC+H_SYNC_CYC)/N);

				if(h_sync_cntr >= (H_FRONT_PORCH_CYC+H_BACK_PORCH_CYC+H_SYNC_CYC)/N-1) begin
					next_h_sync_cntr = '0;
					if(line_num >= Y_RES) begin // last line in frame
						next_state    = FRAME_F_PORCH;
						next_line_num = '0;
					end else begin
						next_state = LINE_DATA;
					end
				end else begin
					next_state = LINE_SYNC;
				end
			end

			FRAME_F_PORCH : begin
				next_pix_cntr = pix_cntr + 1;
				v_sync        = (pix_cntr > (X_RES+H_FRONT_PORCH_CYC)/N-1) && (line_num >= V_FRONT_PORCH_CYC-1);
				h_sync        = (pix_cntr > (X_RES+H_FRONT_PORCH_CYC)/N-1)
					         && (pix_cntr < (X_RES+H_FRONT_PORCH_CYC+H_SYNC_CYC)/N);

				if(pix_cntr >= LINE_WIDTH-1) begin
					next_pix_cntr = '0;
					if(line_num >= V_FRONT_PORCH_CYC-1) begin
						next_state    = FRAME_SYNC;
						next_line_num = '0;
					end else begin
						next_state    = FRAME_F_PORCH;
						next_line_num = line_num + 1;
					end
				end
			end

			FRAME_SYNC : begin
				next_pix_cntr = pix_cntr + 1;
				v_sync        = 1;
				v_sync        = (pix_cntr < (X_RES+H_FRONT_PORCH_CYC)/N) 
				             && (line_num == V_SYNC_CYC-1) || (line_num < V_SYNC_CYC-1);
				h_sync        = (pix_cntr > (X_RES+H_FRONT_PORCH_CYC)/N-1)
					         && (pix_cntr < (X_RES+H_FRONT_PORCH_CYC+H_SYNC_CYC)/N);

				if(pix_cntr >= LINE_WIDTH-1) begin
					next_pix_cntr = '0;
					if(line_num >= V_SYNC_CYC-1) begin
						next_state    = FRAME_B_PORCH;
						next_line_num = '0;
					end else begin
						next_state    = FRAME_SYNC;
						next_line_num = line_num + 1;
					end
				end
			end

			FRAME_B_PORCH : begin
				next_pix_cntr = pix_cntr + 1;
				h_sync        = (pix_cntr > (X_RES+H_FRONT_PORCH_CYC)/N-1)
				             && (pix_cntr < (X_RES+H_FRONT_PORCH_CYC+H_SYNC_CYC)/N);

				if(pix_cntr >= LINE_WIDTH-1) begin
					next_pix_cntr = '0;
					if(line_num >= V_BACK_PORCH_CYC-1) begin
						if(got_sof) next_state = LINE_DATA;
						else begin
							// TODO: raise error?
							next_state = IDLE;
						end
						next_line_num = '0;
					end else begin
						next_state    = FRAME_B_PORCH;
						next_line_num = line_num + 1;
					end
				end
			end

			default : begin
				next_state = IDLE;
			end
		endcase

	end

	// pipelined for block memory compensation
	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			hdmi_data_valid <= 0;
			hdmi_v_sync <= 0;
			hdmi_h_sync <= 0;
		end else begin
			hdmi_data_valid <= rd_cntr_en;
			hdmi_v_sync <= v_sync;
			hdmi_h_sync <= h_sync;
		end
	end

	assign hdmi_data_y  = (!buf_select) ? buf2_o[8*N-1   : 0]     : buf1_o[8*N-1   : 0]    ;
	assign hdmi_data_cr = (!buf_select) ? buf2_o[8*N*2-1 : 8*N]   : buf1_o[8*N*2-1 : 8*N]  ;
	assign hdmi_data_cb = (!buf_select) ? buf2_o[8*N*3-1 : 8*N*2] : buf1_o[8*N*3-1 : 8*N*2];

endmodule