############################################################
## Do not source this entire file as a script. 
## Instead, copy individual commands into the command-line.
## Debugging will be a lot easier.
############################################################

## User inputs
set rtl_sverilog_files {decoder_final.sv}
set top_module_name "decoder"


## Read in verilog files and elaborate design.
analyze -format sverilog -lib WORK ${rtl_sverilog_files}
elaborate ${top_module_name} -library WORK
uniquify

## Uncomment if you want to see the gtech netlist
#write_file -format verilog -output ${top_module_name}.gtech.v

## Basic electrical and timing contraints
source decoder.sdc


## Compile and output gate-level netlist
compile
write_file -format verilog -output ${top_module_name}.netlist.v

## When you're done
#exit

