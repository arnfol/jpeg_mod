module blocks_buf #(
	N    = 2       , // bus width
	SIZE = 1080*240  // fifo depth
) (
	input                            clk        ,
	input                            rst_n      ,
	output logic                     overflow   , // 1 then overflow of fifo occurs
	// input interface
	input                            in_valid   ,
	input        signed [N-1:0][7:0] in_data_y  ,
	input        signed [N-1:0][7:0] in_data_cr ,
	input        signed [N-1:0][7:0] in_data_cb ,
	input                            in_eob     , // end of block
	input                            in_sob     , // start of block
	input                            in_sof     , // start of frame
	// output interface
	output logic                     out_valid  ,
	input							 out_ready  ,
	output logic signed [N-1:0][7:0] out_data_y ,
	output logic signed [N-1:0][7:0] out_data_cr,
	output logic signed [N-1:0][7:0] out_data_cb,
	output logic                     out_eob    , // end of block
	output logic                     out_sob    , // start of block
	output logic                     out_sof      // start of frame
);

	logic fifo_empty;
	logic fifo_full;

	assign out_valid = !fifo_empty;
	assign overflow = in_valid && fifo_full;
	
	scfifo scfifo_component (
		.aclr        (!rst_n                                                           ),
		.clock       (clk                                                              ),
		.data        ({in_data_y, in_data_cb, in_data_cr, in_eob, in_sob, in_sof}      ),
		.rdreq       (out_ready                                                        ),
		.wrreq       (in_valid                                                         ),
		.empty       (fifo_empty                                                       ),
		.full        (fifo_full                                                        ),
		.q           ({out_data_y, out_data_cb, out_data_cr, out_eob, out_sob, out_sof}),
		.usedw       (                                                                 ),
		.almost_empty(                                                                 ),
		.almost_full (                                                                 ),
		.eccstatus   (                                                                 ),
		.sclr        (                                                                 )
	);
	defparam
		scfifo_component.add_ram_output_register = "ON",
		scfifo_component.intended_device_family = "Arria V",
		scfifo_component.lpm_numwords = SIZE,
		scfifo_component.lpm_showahead = "ON",
		scfifo_component.lpm_type = "scfifo",
		scfifo_component.lpm_width = N*8*3+3,
		scfifo_component.lpm_widthu = 17,
		scfifo_component.overflow_checking = "OFF",
		scfifo_component.underflow_checking = "ON",
		scfifo_component.use_eab = "ON";


endmodule