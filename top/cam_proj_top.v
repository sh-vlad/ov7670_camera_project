//author: shvlad
//email: shvladspb@gmail.com
// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on
//`default_nettype none
module cam_proj_top
//   #(	
		//parameter test = 1
//	)  	
(
//clocks & reset
	input wire  				clk50,             
	input wire 					rst,
	input wire					clk24,
//OV7670
	input wire		[7:0]		data_cam,
	input wire					VSYNC_cam,
	input wire					HREF_cam,
	input wire					PCLK_cam,	
	output wire					XCLK_cam,
	output reg					res_cam	,
	output reg					on_off_cam,	
	output wire					sioc,
	output wire					siod,
//VGA	
	output wire					vsync,
	output wire					hsync,	
	output wire		[ 3: 0]		r,	 
	output wire     [ 3: 0]		g,
	output wire     [ 3: 0]		b,		
//SDRAM
	output wire					cs_n,
	output wire					ras_n,
	output wire					cas_n,
	output wire					we_n,
	output wire		[ 1: 0]		dqm,
	output wire		[11: 0]		sd_addr,
	output wire		[ 1: 0]		ba,
	output wire					Cke,
	inout wire		[15: 0]		sd_data,	
	output wire					sdram_clk	

);

wire					rst_n;
wire					clk25;
wire					clk100;
wire		[9:0]		input_wrusedw;
wire		[9:0]		output_rdusedw;		
wire					wr_strobe;
wire					rd_strobe;
wire					wr_input_fifo;
wire					rd_input_fifo;
wire					wr_output_fifo;
wire					rd_output_fifo;
wire					valid_data;
wire		[15:0]		input_fifo_to_sdram;
wire					rd_ena;
wire					sd_ready;
wire					p_VSYNC_cam;
wire					conf_done;
assign rst_n = rst;

//клоки
pll_for_sdram pll_for_sdram_0
(
	.inclk0			( clk50		),
	.c0             ( clk100	),
	.c1             ( sdram_clk	),
	.c2				( clk25		)
);

//Обработка данных с камеры
cam_wrp cam_wrp_0
(
	.rst_n				( rst_n					),
	.data_cam           ( data_cam				),
	.VSYNC_cam          ( VSYNC_cam				),
	.HREF_cam           ( HREF_cam				),
	.PCLK_cam           ( PCLK_cam				),
	.clk_sdram          ( clk100				),
	.output_rdusedw		( input_wrusedw			),
	.wr_fifo			( wr_input_fifo			),
	.rd_fifo			( rd_ena				),
	.input_fifo_to_sdram( input_fifo_to_sdram	)	
);

//VGA			
hvsync hvsync_0
(
	.pixel_clock		( clk25				),
	.rst_n         		( rst_n			 	),	
	.hsync_out          ( hsync				),
	.vsync_out          ( vsync				),
	.r                  ( r					),
	.g                  ( g					),
	.b                  ( b					),
	.clk_sdram			( clk100			),
	.wr_fifo			( valid_data		),
	.output_rdusedw		( output_rdusedw	),
	.sdram_data			( sd_data			),
	.wait_scrn			( conf_done			)
);	
assign 	XCLK_cam = clk24;

//контроллер SDRAM
sdram_cntr sdram_cntr_0
(
	.clk			( clk100				),
	.rst_n          ( rst_n					),
	.wr             ( wr_strobe				),
	.rd	            ( rd_strobe				),
	.valid_data		( valid_data			),
	.data           ( input_fifo_to_sdram	),
	.cs_n           ( cs_n					),
	.ras_n          ( ras_n					),
	.cas_n          ( cas_n					),
	.we_n           ( we_n					),
	.dqm            ( dqm					),
	.sd_addr        ( sd_addr				),
	.ba             ( ba					),
	.Cke            ( Cke					),
	.sd_data        ( sd_data				),
	.rd_ena			( rd_ena				),
	.sd_ready		( sd_ready				),
	.p_VSYNC_cam	( p_VSYNC_cam			),
	.vsync			( vsync					)
);

//"главный" автомат
fsm_global fsm_global_0
(
	.clk					( clk100		),
	.rst_n               	( rst_n			),
	.clk_cam				( clk24			),
	.input_wrusedw       	( input_wrusedw	),
	.output_rdusedw      	( output_rdusedw),
	.VSYNC_cam           	( VSYNC_cam		),
	.HREF_cam	        	( HREF_cam		),
	.wr_strobe				( wr_strobe		),
	.rd_strobe              ( rd_strobe		),
	.wr_input_fifo			( wr_input_fifo ),
	.rd_input_fifo			( rd_input_fifo ),
	.valid_data				( valid_data	),
	.sd_ready				( sd_ready		),
	.p_VSYNC_cam			( p_VSYNC_cam	)
);

//запуск инициализации камеры
reg [2:0]	strt;		
always @( posedge clk25 or negedge rst_n )
	if ( !rst_n )
		strt	<= 3'h0;
	else
		if ( &strt )
			strt	<= strt;
		else
			strt	<= strt + 1'h1;	

//инициализация камеры
camera_configure 
#(	
    .CLK_FREQ 	(	25000000		 )
)
camera_configure_0
(
    .clk		( clk25				),	
    .start      ( ( strt == 3'h6 )	),
    .sioc       ( sioc				),
    .siod       ( siod				),
    .done       ( conf_done			)
);

//сброс камеры общим сбросом с кнопки
assign res_cam		= rst_n;
assign on_off_cam   = !rst_n;
endmodule





