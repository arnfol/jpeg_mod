module hdmi_to_blocks #(
	N     = 2   , // bus width
	X_RES = 2160, // X resolution, should be dividable by 8 (block width)
	Y_RES = 1200  // Y resolution, should be dividable by 8 (block height)
) (
	input                            clk            ,
	input                            en             ,
	input                            rst_n          ,
	// hdmi interface
	input                            hdmi_v_sync    ,
	input                            hdmi_h_sync    ,
	input                            hdmi_data_valid,
	input        signed [N-1:0][7:0] hdmi_data_y    ,
	input        signed [N-1:0][7:0] hdmi_data_cr   ,
	input        signed [N-1:0][7:0] hdmi_data_cb   ,
	// block interface
	output logic                     blk_valid      ,
	output logic signed [N-1:0][7:0] blk_data_y     ,
	output logic signed [N-1:0][7:0] blk_data_cr    ,
	output logic signed [N-1:0][7:0] blk_data_cb    ,
	output logic                     blk_eob        ,
	output logic                     blk_sob        ,
	output logic                     blk_sof
);

	localparam BLOCK_SIZE = 8;
	localparam BUF_DEPTH = 2160*BLOCK_SIZE/N;

	logic [8*3*N-1:0] buf1 [BUF_DEPTH];
	logic             buf1_wr_en;
	logic [8*3*N-1:0] buf1_o    ;
	logic [8*3*N-1:0] buf2 [BUF_DEPTH];
	logic             buf2_wr_en;
	logic [8*3*N-1:0] buf2_o    ;

	logic [$clog2(BUF_DEPTH)-1:0] wr_cntr   ;
	logic                         wr_cntr_en;
	logic [$clog2(BUF_DEPTH)-1:0] rd_cntr   ;
	logic                         rd_cntr_en;
	logic                         rd_cntr_en_del;

	logic [$clog2(X_RES/BLOCK_SIZE)-1:0] block     ;
	logic [      $clog2(BLOCK_SIZE)-1:0] block_line;
	logic [    $clog2(BLOCK_SIZE/N)-1:0] block_elem;

	logic buf_empty ;
	logic buf_full  ;
	logic buf_select;

	logic next_is_sof;

	/*------------------------------------------------------------------------------
	--  INPUT BUFFERS
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk) begin
		buf1_o <= buf1[rd_cntr];
		if(buf1_wr_en) begin
			buf1[wr_cntr] <= {hdmi_data_cb, hdmi_data_cr, hdmi_data_y};
		end
	end

	always_ff @(posedge clk) begin
		buf2_o <= buf2[rd_cntr];
		if(buf2_wr_en) begin
			buf2[wr_cntr] <= {hdmi_data_cb, hdmi_data_cr, hdmi_data_y};
		end
	end


	/*------------------------------------------------------------------------------
	--  READ & WRITE COUNTERS
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk or negedge rst_n) begin : proc_wr_cntr
		if(~rst_n) begin
			wr_cntr <= '0;
			buf_full <= 0;
		end else if(wr_cntr_en) begin
			if(wr_cntr < BUF_DEPTH) begin 
				wr_cntr <= wr_cntr + 1;
				buf_full <= (wr_cntr == BUF_DEPTH-2);
			end else begin 
				wr_cntr <= '0;
			end
		end
	end	

	always_ff @(posedge clk or negedge rst_n) begin 
	 	if(~rst_n) begin
	 		block <= '0;
	 		block_line <= '0;
	 		block_elem <= '0;
	 		buf_empty <= 0;
	 	end else if(rd_cntr_en)begin
	 		buf_empty <= 0;
	 		if(block_elem == BLOCK_SIZE/N-1) begin // end of block line
	 			block_elem <= '0;
		 		if(block_line == BLOCK_SIZE-1) begin // end of block
		 			block_line <= '0;
		 			block <= block + 1;
		 			if(block == X_RES/BLOCK_SIZE-1) begin // end of buffer
			 			block <= '0;
		 				buf_empty <= 1;
		 			end else begin 
		 			 	buf_empty <= 0;
		 			end
	 			// if not end of block
		 		end else block_line <= block_line + 1;
		 	// if not end of block line
	 		end else block_elem <= block_elem + 1;
	 	end
	end

	assign rd_cntr = block_elem + block_line*X_RES/N + block*BLOCK_SIZE/N;

	/*------------------------------------------------------------------------------
	--  Control logic
	------------------------------------------------------------------------------*/

	// Remember start of frame
	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			next_is_sof <= 0;
		end else begin
			if(hdmi_v_sync) next_is_sof <= 1;
			else if(blk_sof) next_is_sof <= 0;
		end
	end

	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			buf_select <= 0;
		end else if(buf_full) begin
			buf_select <= !buf_select;
		end
	end

	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			rd_cntr_en <= 0;
			rd_cntr_en_del <= 0;
		end else begin
			if(buf_full) begin 
				rd_cntr_en <= 1;
			end else if(buf_empty) begin
				rd_cntr_en <= 0;
			end
			rd_cntr_en_del <= rd_cntr_en;
		end
	end

	assign wr_cntr_en = buf1_wr_en || buf2_wr_en;
	assign buf1_wr_en = !buf_select && hdmi_data_valid;
	assign buf2_wr_en =  buf_select && hdmi_data_valid;

	/*------------------------------------------------------------------------------
	--  Output pipeline
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			blk_data_y  <= '0;
			blk_data_cr <= '0;
			blk_data_cb <= '0;
			blk_valid <= 0;
			blk_eob <= 0;
			blk_sob <= 0;
			blk_sof <= 0;
		end else begin
			blk_data_y  <= (!buf_select) ? buf2_o[8*N-1   : 0]     : buf1_o[8*N-1   : 0]    ;
			blk_data_cr <= (!buf_select) ? buf2_o[8*N*2-1 : 8*N]   : buf1_o[8*N*2-1 : 8*N]  ;
			blk_data_cb <= (!buf_select) ? buf2_o[8*N*3-1 : 8*N*2] : buf1_o[8*N*3-1 : 8*N*2];
			blk_valid <= rd_cntr_en_del; 
			blk_eob <= (block_elem == BLOCK_SIZE/N-1) && (block_line == BLOCK_SIZE-1);
			blk_sob <= (block_elem == 0) && (block_line == 0);
			blk_sof <= (block_elem == 0) && (block_line == 0) && next_is_sof;
		end
	end

endmodule