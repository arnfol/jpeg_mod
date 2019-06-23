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

	logic [8*3*N-1:0] buf1, buf2 [BUF_DEPTH];
	logic                         buf1_en, buf2_en;
	logic                         buf1_wr_en, buf2_wr_en;
	logic [$clog2(BUF_DEPTH)-1:0] buf1_rd_addr, buf2_rd_addr;
	logic [            8*3*N-1:0] buf1_o, buf2_o;

	logic [$clog2(BUF_DEPTH)-1:0] wr_cntr;
	logic wr_cntr_clr;
	logic wr_cntr_en;

	logic [$clog2(BUF_DEPTH)-1:0] rd_cntr;
	logic rd_cntr_clr;
	logic rd_cntr_en;


	/*------------------------------------------------------------------------------
	--  INPUT BUFFERS
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk) begin
		if(buf1_en) begin
			buf1_o <= buf1[buf1_rd_addr];
			if(buf1_wr_en) buf1[wr_cntr] <= {hdmi_data_cb, hdmi_data_cr, hdmi_data_y};
		end
	end

	always_ff @(posedge clk) begin
		if(buf2_en) begin
			buf2_o <= buf2[buf2_rd_addr];
			if(buf2_wr_en) buf2[wr_cntr] <= {hdmi_data_cb, hdmi_data_cr, hdmi_data_y};
		end
	end


	/*------------------------------------------------------------------------------
	--  READ & WRITE COUNTERS
	------------------------------------------------------------------------------*/
	always_ff @(posedge clk or negedge rst_n) begin : proc_wr_cntr
		if(~rst_n) begin
			wr_cntr <= '0;
		end else if(wr_cntr_clr) begin
			wr_cntr <= '0;
		end else if(wr_cntr_en) begin
			wr_cntr <= wr_cntr + 1;
		end
	end	

	integer block;
	integer block_line;
	integer block_elem;
	always_ff @(posedge clk or negedge rst_n) begin 
	 	if(~rst_n) begin
	 		block <= '0;
	 		block_line <= '0;
	 		block_elem <= '0;
	 	end else if(rd_cntr_clr) begin
			block <= '0;
	 		block_line <= '0;
	 		block_elem <= '0;
		end else if(rd_cntr_en)begin
	 		if(block_elem == BLOCK_SIZE/N-1) begin // end of block line
		 		block_elem <= 0;
		 		if(block_line == BLOCK_SIZE-1) begin // end of block
		 			block_line <= 0;
		 			block <= block + 1;
		 			if(block == X_RES/BLOCK_SIZE-1) begin // end of buffer
		 				
		 			end
	 			// if not end of block
		 		end else block_line <= block_line + 1;
		 	// if not end of block line
	 		end else block_elem <= block_elem + 1;
	 	end
	end

	assign rd_cntr = block_elem + block_line*X_RES/N + block*BLOCK_SIZE/N;

	/*------------------------------------------------------------------------------
	--  FSM
	------------------------------------------------------------------------------*/
	assign blk_eob = (block_elem == BLOCK_SIZE/N-1) && (block_line == BLOCK_SIZE-1);
	assign blk_sob = (block_elem == 0) && (block_line == 0);

	// TODO: make a FSM
	assign rd_cntr_clr = 0;
	assign rd_cntr_en  = 1;
	assign wr_cntr_clr = 0;
	assign wr_cntr_en = 1;
	assign buf1_en = 1;
	assign buf2_en = 1;

	

	// TODO: add pipeline here
	assign blk_data_y  = (1) ? buf2_o[8*N-1   : 0]     : buf1_o[8*N-1   : 0]    ;
	assign blk_data_cr = (1) ? buf2_o[8*N*2-1 : 8*N]   : buf1_o[8*N*2-1 : 8*N]  ;
	assign blk_data_cb = (1) ? buf2_o[8*N*3-1 : 8*N*2] : buf1_o[8*N*3-1 : 8*N*2];

endmodule