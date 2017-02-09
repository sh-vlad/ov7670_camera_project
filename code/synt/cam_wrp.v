//author: shvlad
//email: shvladspb@gmail.com
// synopsys translate_off
`timescale 1 ns / 100 ps
// synopsys translate_on
//`default_nettype none
module cam_wrp
//   #(	
		//parameter test = 1
//	)  	
(         
	input wire 					rst_n,
//
	input wire		[7:0]		data_cam,
	input wire					VSYNC_cam,
	input wire					HREF_cam,
	input wire					PCLK_cam,	
//
	input wire					clk_sdram,
	output wire		[ 9: 0]		output_rdusedw,
	output reg					wr_fifo,
	input wire					rd_fifo,
	output wire		[15: 0]		input_fifo_to_sdram
);
	reg		[15: 0]		data2fifo;	
	reg					sh_HREF_cam;
	
	always @( posedge PCLK_cam or negedge rst_n )
		if  ( ! rst_n )
			begin
				sh_HREF_cam	<= 1'h0;
			end			
		else
			begin
				sh_HREF_cam		<= HREF_cam;			
			end	

	always @( posedge PCLK_cam or negedge rst_n )
		if ( !rst_n )
			data2fifo	<= 16'h0;
		else
			if ( wr_fifo )
				data2fifo[7:0]	<= data_cam;
			else
				data2fifo[15:8]	<= data_cam;					

	always @( posedge PCLK_cam or negedge rst_n )
		if ( !rst_n )
			wr_fifo		<= 1'h0;
		else
			if ( HREF_cam )
				wr_fifo	<= !wr_fifo;
			else
				wr_fifo	<= 1'h0;
				
fifo_1024x16 input_fifo 
(	
	.aclr				( !rst_n				),
	.data				( data2fifo				),
	.rdclk              ( clk_sdram				),
	.rdreq              ( rd_fifo				),
	.wrclk              ( PCLK_cam				),
	.wrreq              ( !wr_fifo & sh_HREF_cam),
	.q                  ( input_fifo_to_sdram	),
	.rdempty            (						),
	.rdusedw            ( output_rdusedw		),
	.wrfull             ( 						),
	.wrusedw            ( 						)
);
				
endmodule


