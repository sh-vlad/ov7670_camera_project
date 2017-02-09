## Generated SDC file "cam_proj.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Fri Apr 22 16:53:24 2016"

##
## DEVICE  "EP2C20F484C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk50}]
create_clock -name {PCLK_cam} -period 41.600 -waveform { 0.000 20.800 } [get_ports {PCLK_cam}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pll_for_sdram_0|altpll_component|pll|clk[0]} -source [get_pins {pll_for_sdram_0|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {clk50} [get_pins {pll_for_sdram_0|altpll_component|pll|clk[0]}] 
create_generated_clock -name {pll_for_sdram_0|altpll_component|pll|clk[1]} -source [get_pins {pll_for_sdram_0|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -phase 72.000 -master_clock {clk50} [get_pins {pll_for_sdram_0|altpll_component|pll|clk[1]}] 
create_generated_clock -name {pll_for_sdram_0|altpll_component|pll|clk[2]} -source [get_pins {pll_for_sdram_0|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 2 -master_clock {clk50} [get_pins {pll_for_sdram_0|altpll_component|pll|clk[2]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_qe9:dffpipe17|dffe18a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_pe9:dffpipe15|dffe16a*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

