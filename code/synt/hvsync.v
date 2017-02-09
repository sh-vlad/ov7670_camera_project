//author: http://marsohod.org/
//modified: shvlad ( shvladspb@gmail.com )
///////////////////////////////////////////////////////////////
//module which generates video sync impulses
///////////////////////////////////////////////////////////////

module hvsync (
	// inputs:
	input wire pixel_clock,

	// outputs:
	output wire hsync_out,
	output wire vsync_out,

	//high-color test video signal
	output reg [3:0]r,
	output reg [3:0]g,
	output reg [3:0]b,
//
	input wire					rst_n,
	input wire					clk_sdram,
	input wire					wr_fifo,	
	output wire		[9:0]		output_rdusedw,
	input wire		[15:0]		sdram_data,
	input wire					wait_scrn
	);
	
	// video signal parameters, default 1440x900 60Hz
	parameter horz_front_porch = 16;
	parameter horz_sync = 96;
	parameter horz_back_porch = 48;
	parameter horz_addr_time = 640;
	
	parameter vert_front_porch = 10;
	parameter vert_sync = 2;
	parameter vert_back_porch = 33;
	parameter vert_addr_time = 480;
	
	//variables
	reg hsync;	
	reg vsync;	
	reg [11:0]pixel_count = 0;
	reg [11:0]line_count = 0;

reg hvisible = 1'b0;
reg vvisible = 1'b0;

//synchronous process
always @(posedge pixel_clock)
begin
	hsync <= (pixel_count < horz_sync);
	hvisible <= (pixel_count >= (horz_sync+horz_back_porch)) && 
		(pixel_count < (horz_sync+horz_back_porch+horz_addr_time));
	
	if(pixel_count < (horz_sync+horz_back_porch+horz_addr_time+horz_front_porch) )
		pixel_count <= pixel_count + 1'b1;
	else
		pixel_count <= 0;
end

always @(posedge hsync)
begin
	vsync <= (line_count < vert_sync);
	vvisible <= (line_count >= (vert_sync+vert_back_porch)) && 
		(line_count < (vert_sync+vert_back_porch+vert_addr_time));
	
	if(line_count < (vert_sync+vert_back_porch+vert_addr_time+vert_front_porch) )
		line_count <= line_count + 1'b1;
	else
		line_count <= 0;
end

wire visible; assign visible = hvisible & vvisible & wait_scrn;

	
wire	[15:0]	q;
fifo_1024x16 input_fifo 
(
	.aclr				( !rst_n			),
	.data				( sdram_data		),
	.rdclk              ( pixel_clock		),
	.rdreq              ( visible			),
	.wrclk              ( clk_sdram			),
	.wrreq              ( wr_fifo			),
	.q                  ( q					),
	.rdempty            ( 					),
	.rdusedw            ( output_rdusedw	),
	.wrfull             ( 					),
	.wrusedw            ( 					)
);

	always @( posedge pixel_clock or negedge rst_n )
		if ( !rst_n )
			begin
				r	<= 4'h0;
				g	<= 4'h0;
				b	<= 4'h0;
			end
		else
			if ( visible )
				begin
					r	<= q[11: 8];
					g	<= q[ 7: 4];
					b	<= q[ 3: 0];
				end
			else
				begin
					r	<= 4'h0;
					g	<= 4'h0;
					b	<= 4'h0;
				end
		
delay_rg
#(
   .W  (2),         
   .D  (2)
)
delay_rg_0
(
	.reset_b	( rst_n					),
    .clk        ( pixel_clock			),
	.data_in    ( {hsync,vsync}			), 
    .data_out   ( {hsync_out,vsync_out}	)
);   
		
		
endmodule

